/* This script contains beelow
1. Create table Statements
2. Create file format
3. Copy statement to copy file data to table 
4. Note : gzip file
Put command is present in execute_statements.sql*/

-- use sysadmin role to create objects --
use role sysadmin;
-- use virtual warehouse -- 
use warehouse data_ingestion_wh;

-- use database --
use database ttips;

-- Use Schema --
use schema ch07;

-- Creating table user to store duplicate data from file --
create or replace transient table customer_validate (
	customer_pk number(38,0),
	salutation varchar(10),
	first_name varchar(20),
	last_name varchar(30),
	gender varchar(1),
	marital_status varchar(1),
	day_of_birth date,
	birth_country varchar(60),
	email_address varchar(50),
	city_name varchar(60),
	zip_code varchar(10),
	country_name varchar(20),
	gmt_timezone_offset number(10,2),
	preferred_cust_flag boolean,
	registration_time timestamp_ltz(9)
);

create or replace file format csv_ff
    type = 'csv' 
    compression = 'auto' 
    field_delimiter = ',' 
    record_delimiter = '\n' 
    date_format = 'AUTO'
    timestamp_format = 'AUTO'
    skip_header = 1 
    field_optionally_enclosed_by = '"' 
    null_if = ('\\n', '\\N', '','<null>','null');


-- Run below validate statements to check the errors in the file --


copy into ch07.customer_validate 
     from @~/cho8/csv/validate/customer_01_one_error.csv 
     file_format =  'ttips.ch07.csv_ff'
     validation_mode = return_errors
         ; 

copy into ch07.customer_validate 
     from @~/cho8/csv/validate/customer_02_three_errors.csv 
     file_format =  'ttips.ch07.csv_ff'
     validation_mode = return_errors
         ; 
copy into ch07.customer_validate 
     from @~/cho8/csv/validate/customer_03_one_line_many_error.csv
     file_format =  'ttips.ch07.csv_ff'
     validation_mode = return_errors
         ; 



-- To display all errors in all files --


copy into ch07.customer_validate 
     from @~/cho8/csv/validate/ -- location of the files--
     file_format =  'ttips.ch07.csv_ff'
     validation_mode = return_all_errors
         ; 


-- Load the three files to the table --

copy into ch07.customer_validate 
     from @~/cho8/csv/validate/
     file_format =  'ttips.ch07.csv_ff'
     on_error = continue 
     force = true ;

-- Same result can be got by executing below query --
-- job_id = query id of the load copy statement. not with the validation mode--
select * from table(validate(customer_validate,job_id => '01beaa08-0000-2e19-003c-f30b00064146'))


