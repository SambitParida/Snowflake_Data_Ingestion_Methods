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
use schema ch10;

-- Creating table user to store duplicate data from file --
create or replace transient table bookings (
    booking_id number,
    booking_dt date,
    booking_time time,
    booking_dt_time datetime,
    booking_timestamp timestamp,
    stg_file_name string,
    stg_file_load_ts timestamp_ntz,
    stg_file_md5 string,
    copy_data_ts timestamp_ntz default current_timestamp
);

create or replace transient table customer_f3 (
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
	registration_time timestamp_ltz(9),
	stg_file_name string,
    stg_file_load_ts timestamp_ntz,
    stg_file_md5 string,
    copy_data_ts timestamp_ntz default current_timestamp
);

/* Scenario : 1 : All records following proper date and time format */
create or replace file format csv_ff
    type = 'csv' 
    compression = 'none' 
    field_delimiter = ',' 
    record_delimiter = '\n' 
    skip_header = 1 
    field_optionally_enclosed_by = '"';

PUT file:///Users/sambitparida/Desktop/Sambit/Learning/SnowflakePractice/data/DataIngestion/ch10/01-bookings-std.csv
    @~/ch10/csv
    auto_compress=false
    parallel = 10;

list @~/ch10/csv

copy into ch10.bookings (
    booking_id ,
    booking_dt ,
    booking_time ,
    booking_dt_time ,
    booking_timestamp ,
    stg_file_name ,
    stg_file_load_ts ,
    stg_file_md5 ,
    copy_data_ts 
)
from (
        select t.$1::number as booking_id,
            t.$2::date as booking_dt,
            t.$3::time as booking_time,
            t.$4::datetime as booking_dt_time,
            t.$5::timestamp as booking_timestamp,
            metadata$filename as stg_file_name,
            metadata$file_last_modified as stg_file_load_ts,
            metadata$file_content_key as stg_file_md5,
            current_timestamp as copy_data_ts
        from @~/ch10/csv/01-bookings-std.csv t
    ) file_format = (format_name = 'ttips.ch10.csv_ff') on_error = continue;

list @~/ch10/csv

/*Scenario 2:  This new file have five faulty records which are out of range*/
PUT file:///Users/sambitparida/Desktop/Sambit/Learning/SnowflakePractice/data/DataIngestion/ch10/02-bookings-year-range.csv
    @~/ch10/csv
    auto_compress=false
    parallel = 10;


truncate bookings;

copy into ch10.bookings (
    booking_id ,
    booking_dt ,
    booking_time ,
    booking_dt_time ,
    booking_timestamp ,
    stg_file_name ,
    stg_file_load_ts ,
    stg_file_md5 ,
    copy_data_ts 
)
from (
        select t.$1::number as booking_id,
            t.$2::date as booking_dt,
            t.$3::time as booking_time,
            t.$4::datetime as booking_dt_time,
            t.$5::timestamp as booking_timestamp,
            metadata$filename as stg_file_name,
            metadata$file_last_modified as stg_file_load_ts,
            metadata$file_content_key as stg_file_md5,
            current_timestamp as copy_data_ts
        from @~/ch10/csv/02-bookings-year-range.csv t
    ) file_format = (format_name = 'ttips.ch10.csv_ff') on_error = continue;

/* Copy the query id and run below query to find errorneour records along with reason. You can find that 3 records */
select * from table(validate(bookings, job_id => '01bf675b-0000-3695-0068-868b0002a1b6'));


/* Scenario 3:  This new file have one record with wrong date format */
PUT file:///Users/sambitparida/Desktop/Sambit/Learning/SnowflakePractice/data/DataIngestion/ch10/04-bookings-mixed-date-formats.csv
    @~/ch10/csv
    auto_compress=false
    parallel = 10;


truncate bookings;

copy into ch10.bookings (
    booking_id ,
    booking_dt ,
    booking_time ,
    booking_dt_time ,
    booking_timestamp ,
    stg_file_name ,
    stg_file_load_ts ,
    stg_file_md5 ,
    copy_data_ts 
)
from (
        select t.$1::number as booking_id,
            t.$2::date as booking_dt,
            t.$3::time as booking_time,
            t.$4::datetime as booking_dt_time,
            t.$5::timestamp as booking_timestamp,
            metadata$filename as stg_file_name,
            metadata$file_last_modified as stg_file_load_ts,
            metadata$file_content_key as stg_file_md5,
            current_timestamp as copy_data_ts
        from @~/ch10/csv/04-bookings-mixed-date-formats.csv t
    ) file_format = (format_name = 'ttips.ch10.csv_ff') on_error = continue;

select * from table(validate(bookings, job_id => '01bf675b-0000-3695-0068-868b0002a1b6'));
/* Note : You can find one record with wrong date format being getting rejected. Snowflake follows yyyy-mm-dd by default. 
You have to manually define  date time format*/

create or replace file format csv_gzip_ff_v2
    type = 'csv' 
    compression = 'auto' 
    field_delimiter = ',' 
    record_delimiter = '\n' 
    date_format = 'DD-MM-YYYY'
    timestamp_format = 'DD-MM-YYYY HH24:MI:SS.FF3'
    skip_header = 1 
    field_optionally_enclosed_by = '"';


/* Scenario 4:  Loading nanosecond data in to a table */
PUT file:///Users/sambitparida/Desktop/Sambit/Learning/SnowflakePractice/data/DataIngestion/ch10/03_bookings_nano_seconds.csv
    @~/ch10/csv
    auto_compress=false
    parallel = 10;

list @~/ch10/csv

copy into ch10.bookings (
    booking_id ,
    booking_dt ,
    booking_time ,
    booking_dt_time ,
    booking_timestamp ,
    stg_file_name ,
    stg_file_load_ts ,
    stg_file_md5 ,
    copy_data_ts 
)
from (
        select t.$1::number as booking_id,
            t.$2::date as booking_dt,
            t.$3::time as booking_time,
            t.$4::datetime as booking_dt_time,
            t.$5::timestamp as booking_timestamp,
            metadata$filename as stg_file_name,
            metadata$file_last_modified as stg_file_load_ts,
            metadata$file_content_key as stg_file_md5,
            current_timestamp as copy_data_ts
        from @~/ch10/csv/03_bookings_nano_seconds.csv t
    ) file_format = (format_name = 'ttips.ch10.csv_ff') on_error = continue;


/* Note : Snowflake by default supports nano second data format without any special configuration. In order to see 9 digit nano second you have to set below environment 
*/

alter session set timestamp_ntz_output_format = 'YYYY-MM-DD HH24:MI:SS.FF9';
SELECT * FROM BOOKINGS;


/* LOADING A LARGE FILE DATA IN SNOWFLAKE */

create or replace file format csv_gzip_ff_v3
    type = 'csv' 
    compression = 'gzip' 
    field_delimiter = ',' 
    record_delimiter = '\n' 
    date_format = 'YYYY-MM-DD'
    timestamp_format = 'YYYY-MM-DDHH24:MI:SS.FF3'
    skip_header = 1 
    field_optionally_enclosed_by = '"';

    
    PUT file:///Users/sambitparida/Desktop/Sambit/Learning/SnowflakePractice/data/DataIngestion/ch01/06_01_customer_500k_rows.csv.gz
    @~/ch10/csv
    auto_compress=false
    parallel = 10;

    list @~/ch10/csv

    copy into ch10.customer_f3 (
    customer_pk,
    salutation,
    first_name,
    last_name,
    gender,
    marital_status,
    day_of_birth,
    birth_country,
    email_address,
    city_name,
    zip_code,
    country_name,
    gmt_timezone_offset,
    preferred_cust_flag,
    registration_time,
    stg_file_name,
    stg_file_load_ts,
    stg_file_md5,
    copy_data_ts
)
from (
        select t.$1::text as customer_pk,
            t.$2::text as salutation,
            t.$3::text as first_name,
            t.$4::text as last_name,
            t.$5::text as gender,
            t.$6::text as marital_status,
            t.$7::text as day_of_birth,
            t.$8::text as birth_country,
            t.$9::text as email_address,
            t.$10::text as city_name,
            t.$11::text as zip_code,
            t.$12::text as country_name,
            t.$13::text as gmt_timezone_offset,
            t.$14::text as preferred_cust_flag,
            t.$15::text as registration_time,
            metadata$filename as stg_file_name,
            metadata$file_last_modified as stg_file_load_ts,
            metadata$file_content_key as stg_file_md5,
            current_timestamp as copy_data_ts
        from @~/ch10/csv/06_01_customer_500k_rows.csv.gz t
    ) file_format = (format_name = 'ttips.ch10.csv_gzip_ff_v3') on_error = continue;

    select * from customer_f3;