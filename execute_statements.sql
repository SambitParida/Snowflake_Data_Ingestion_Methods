use role sysadmin;
use warehouse data_ingestion_wh;
use database ttips;
use schema ch01;

-- Load csv data from local directory to snowflake internal named stage and verify --
PUT file:///Users/sambitparida/Desktop/Sambit/Learning/SnowflakePractice/data/DataIngestion/ch01/customer_10k_good_data.csv @csv_stg;

list @csv_stg;
select t.$1::text as orderid -- t.$2::text as customerid,
    -- t.$3::text as restaurantid,
    -- t.$4::text as orderdate,
    -- t.$5::text as totalamount,
    -- t.$6::text as status,
    -- t.$7::text as paymentmethod,
    -- t.$8::text as createddate,
    -- t.$9::text as modifieddate,
    -- metadata $filename as stg_file_name,
    -- metadata $file_last_modified as stg_file_load_ts,
    -- metadata $file_content_key as stg_file_md5,
    -- current_timestamp as copy_data_ts
from @ttips.ch01.csv_stg t (FILE_FORMAT => 'ttips.ch01.customer_csv_ff');

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



-- Load psv data from local directory to snowflake internal named stage and verify --
PUT file:///Users/sambitparida/Desktop/Sambit/Learning/SnowflakePractice/data/DataIngestion/ch01/customer_10k_good_data.psv @psv_stg;
list @psv_stg;