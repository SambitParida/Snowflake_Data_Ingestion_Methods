/*Many important scripts are present including 
1. Multiple file upload from local to snowflake user stage
2. parallel upload etc */

use role sysadmin;
use warehouse data_ingestion_wh;
use database ttips;
use schema ch01;

-- Load csv data from local directory to snowflake internal named stage and verify --
PUT file:///Users/sambitparida/Desktop/Sambit/Learning/SnowflakePractice/data/DataIngestion/ch01/customer_10k_good_data.csv @csv_stg;

list @csv_stg;
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
from @ttips.ch01.csv_stg (file_format => 'ttips.ch01.customer_csv_ff') t;

-- Load tsv data from local directory to snowflake internal named stage and verify --
PUT file:///Users/sambitparida/Desktop/Sambit/Learning/SnowflakePractice/data/DataIngestion/ch01/customer_10k_good_data.tsv @tsv_stg;
list @tsv_stg;

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
from @ttips.ch01.tsv_stg (file_format => 'ttips.ch01.customer_tsv_ff') t;

-- Load psv data from local directory to snowflake internal named stage and verify --
PUT file:///Users/sambitparida/Desktop/Sambit/Learning/SnowflakePractice/data/DataIngestion/ch01/customer_10k_good_data.psv @psv_stg;
list @psv_stg;

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
from @ttips.ch01.psv_stg (file_format => 'ttips.ch01.customer_psv_ff') t;


-- Check Load History for status --
select * from information_schema.load_history;

-- Load csv data from local directory to snowflake internal named stage and verify : ERRORNEOUS FILE with wrong boolean data --
PUT file:///Users/sambitparida/Desktop/Sambit/Learning/SnowflakePractice/data/DataIngestion/ch01/data-file-with-2-issues.csv @csv_stg;

list @csv_stg;
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
from @ttips.ch01.csv_stg/data-file-with-2-issues.csv (file_format => 'ttips.ch01.customer_csv_ff') t;


-- Load csv data from local directory to snowflake internal named stage and verify : ERRORNEOUS FILE with wrong data length --

PUT file:///Users/sambitparida/Desktop/Sambit/Learning/SnowflakePractice/data/DataIngestion/ch01/data-file-with-datatype-issue.csv @csv_stg;

list @csv_stg;
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
from @ttips.ch01.csv_stg/data-file-with-datatype-issue.csv (file_format => 'ttips.ch01.customer_csv_ff') t;


-- Load csv data from local directory to snowflake internal user stage and verify --
PUT file:///Users/sambitparida/Desktop/Sambit/Learning/SnowflakePractice/data/DataIngestion/ch01/customer_data_with_100_records.csv 
    @~/customer/csv/uncompressed
    auto_compress=false;

list @~/customer/csv/uncompressed;

-- Load tsv data from local directory to snowflake internal user stage and verify --
PUT file:///Users/sambitparida/Desktop/Sambit/Learning/SnowflakePractice/data/DataIngestion/ch01/customer_data_with_100_records.tsv 
    @~/customer/tsv/uncompressed
    auto_compress=false;

list @~/customer/tsv/uncompressed;

-- Load psv data from local directory to snowflake internal user stage and verify --
PUT file:///Users/sambitparida/Desktop/Sambit/Learning/SnowflakePractice/data/DataIngestion/ch01/customer_data_with_100_records.psv 
    @~/customer/psv/uncompressed
    auto_compress=false;

list @~/customer/psv/uncompressed;

-- Viewing all internal user stages ---

list @~;

----Purge User Stage---
use schema ch07;
REMOVE @~/cho7/csv/dedup/03_08pm_user_data.csv;

-- Load multiple csv data from local directory to snowflake internal user stage and verify --
PUT file:///Users/sambitparida/Desktop/Sambit/Learning/SnowflakePractice/data/DataIngestion/ch01/multiple_files/*
    @~/customer/csv/uncompressed
    auto_compress=false;

list @~/customer/csv/uncompressed;

-- Load multiple csv data from local directory to snowflake internal user stage and verify --
PUT file:///Users/sambitparida/Desktop/Sambit/Learning/SnowflakePractice/data/DataIngestion/ch01/multiple_files/*
    @~/customer/csv/uncompressed
    auto_compress=false;

list @~/customer/csv/uncompressed;

-- Load large file csv data from local directory to snowflake internal user stage and verify --
PUT file:///Users/sambitparida/Desktop/Sambit/Learning/SnowflakePractice/data/DataIngestion/ch01/06_01_customer_500k_rows.csv.gz
    @~/customer/csv/compressed
    auto_compress=true
    parallel = 20;

list @~/customer/csv/compressed;

-- Load multiple csv data from local directory to snowflake internal user stage. Files contain special characters --
PUT file:///Users/sambitparida/Desktop/Sambit/Learning/SnowflakePractice/data/DataIngestion/ch06/*
    @~/cho6/csv/uncompressed
    auto_compress=false
    parallel = 10;

list @~/cho6/csv/uncompressed;


   select t.$1::text as id,
            t.$2::text as first_name,
            t.$3::text as last_name,
            t.$4::text as email,
            t.$5::text as gender,
            REGEXP_REPLACE($6::STRING, '["'']', '') AS about_me,
            metadata$filename as stg_file_name,
            metadata$file_last_modified as stg_file_load_ts,
            metadata$file_content_key as stg_file_md5,
            current_timestamp as copy_data_ts
        from @~/cho6/csv/uncompressed/06_sample_email_regex.csv 
        (file_format => 'ttips.ch06.csv_double_q_reg_exp_ff') t

-- ch07 : Data load for deduplication during copy poc ---

PUT file:///Users/sambitparida/Desktop/Sambit/Learning/SnowflakePractice/data/DataIngestion/ch07/04_user_20k.csv 
    @~/cho7/csv/dedup
    auto_compress=false
    parallel = 10;

PUT file:///Users/sambitparida/Desktop/Sambit/Learning/SnowflakePractice/data/DataIngestion/ch07/multfiles/*
    @~/cho7/csv/dedup/multfiles
    auto_compress=false
    parallel = 10;


list @~/cho7/csv/dedup;

select * from ch07.user;


select distinct t.$1::number as id,
            t.$2::text as first_name,
            t.$3::text as last_name,
            t.$4::text as email,
            t.$5::text as gender,
            t.$6::text as about_me
        from @~/cho7/csv/dedup/multfiles/ 
     (file_format =>'ttips.ch07.allow_duplicate_ff') t order by id


--------
--Loading data to stage for validate ---

PUT file:///Users/sambitparida/Desktop/Sambit/Learning/SnowflakePractice/data/DataIngestion/ch08/* 
    @~/cho8/csv/validate
    auto_compress=false
    parallel = 10;

-- Same result can be got by executing below query --
-- job_id = query id of the load copy statement. not with the validation mode--
select * from table(validate(customer_validate,job_id => '01beaa2f-0000-2e31-003c-f30b0006e282'))

--Loading data to stage for null handling example ---

PUT file:///Users/sambitparida/Desktop/Sambit/Learning/SnowflakePractice/data/DataIngestion/ch09/01_user_sample_with_nulls.csv 
    @~/ch09/csv
    auto_compress=false
    parallel = 10;

list @~/ch09/csv
-- Same result can be got by executing below query --
-- job_id = query id of the load copy statement. not with the validation mode--
select * from table(validate(customer_validate,job_id => '01beaa2f-0000-2e31-003c-f30b0006e282'))