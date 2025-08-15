-- use sysadmin role to create objects --
use role sysadmin;
-- use virtual warehouse -- 
use warehouse data_ingestion_wh;

-- use database --
use database ttips;
-- use schema --
use schema ch01;
-- create transient t
copy into ch01.customer_csv (
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
        from @ttips.ch01.csv_stg t
    ) file_format = (format_name = 'ttips.ch01.customer_csv_ff') on_error = continue;
