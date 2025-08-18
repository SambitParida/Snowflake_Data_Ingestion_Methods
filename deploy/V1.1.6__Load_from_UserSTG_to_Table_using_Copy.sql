/* This script contains beelow
1. Create table Statements
2. Create file format
3. Copy statement to copy file data to table 
Put command is present in execute_statements.sql*/

-- use sysadmin role to create objects --
use role sysadmin;
-- use virtual warehouse -- 
use warehouse data_ingestion_wh;

-- use database --
use database ttips;
-- use schema --
use schema ch02;


create or replace transient table customer_csv_01 (
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

create or replace transient table customer_tsv_01 (
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

create or replace transient table customer_psv_01 (
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

-- Create CSV File format -- 
create or replace file format customer_csv_ff 
    type = 'csv' 
    compression = None
    field_delimiter = ',' 
    record_delimiter = '\n' 
    date_format = 'AUTO'
    timestamp_format = 'AUTO'
    skip_header = 1 
    field_optionally_enclosed_by = '"' 
    null_if = ('\\n', '\\N', '','<null>','null');

-- Create TSV File format -- 
create or replace file format customer_tsv_ff 
    type = 'csv' 
    compression = None
    field_delimiter = '\t' 
    record_delimiter = '\n' 
    skip_header = 1 
    field_optionally_enclosed_by = '"' 
    null_if = ('\\n', '\\N', '');

-- Create PSV File format -- 
create or replace file format customer_psv_ff 
    type = 'csv' 
    compression = None
    field_delimiter = '|' 
    record_delimiter = '\n' 
    skip_header = 1 
    field_optionally_enclosed_by = '"' 
    null_if = ('\\n', '\\N', '');

copy into ch02.customer_csv_01 (
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
        from @~/customer/csv/uncompressed/customer_data_with_100_records.csv t
    ) file_format = (format_name = 'ttips.ch02.customer_csv_ff') on_error = continue;



copy into ch02.customer_tsv_01 (
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
        from @~/customer/tsv/uncompressed/customer_data_with_100_records.tsv t
    ) file_format = (format_name = 'ttips.ch02.customer_tsv_ff') on_error = continue;

copy into ch02.customer_psv_01 (
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
        from @~/customer/psv/uncompressed/customer_data_with_100_records.psv t
    ) file_format = (format_name = 'ttips.ch02.customer_psv_ff') on_error = continue;