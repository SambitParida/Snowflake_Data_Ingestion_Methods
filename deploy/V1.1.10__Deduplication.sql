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
create or replace transient table user(
    id number,
    first_name varchar(100),
    last_name varchar(100),
    email varchar(100),
    gender varchar(1),
    about_me varchar(500),
    stg_file_name string,
    stg_file_load_ts timestamp_ntz,
    stg_file_md5 string,
    copy_data_ts timestamp_ntz default current_timestamp
);

-- create a file format
-- double quote as field_optionally_enclosed_by parameter
 create or replace file format allow_duplicate_ff 
        type = 'csv' 
        compression = 'none' 
        field_delimiter = ',' 
        record_delimiter = '\n' 
        skip_header = 1 
        field_optionally_enclosed_by = '\042' 
        escape = '\134';

-- Below copy statement will load all duplicate entries to the table --
copy into ch07.user(
    id ,
    first_name,
    last_name,
    email,
    gender,
    about_me,
    stg_file_name,
    stg_file_load_ts,
    stg_file_md5,
    copy_data_ts
)
from (
        select distinct t.$1::text as id,
            t.$2::text as first_name,
            t.$3::text as last_name,
            t.$4::text as email,
            t.$5::text as gender,
            t.$6::text as about_me,
            metadata$filename as stg_file_name,
            metadata$file_last_modified as stg_file_load_ts,
            metadata$file_content_key as stg_file_md5,
            current_timestamp as copy_data_ts
        from @~/cho7/csv/dedup/01_user_data.csv t
    ) file_format = (format_name = 'ttips.ch07.allow_duplicate_ff') 
    on_error = 'CONTINUE'
    ;

-- Below copy statement will load distinct entries in the table. Will remove the duplicates --

copy into ch07.user(
    id ,
    first_name,
    last_name,
    email,
    gender,
    about_me,
    stg_file_name,
    stg_file_load_ts,
    stg_file_md5,
    copy_data_ts
)
from (
        select distinct t.$1::text as id,
            t.$2::text as first_name,
            t.$3::text as last_name,
            t.$4::text as email,
            t.$5::text as gender,
            t.$6::text as about_me,
            metadata$filename as stg_file_name,
            metadata$file_last_modified as stg_file_load_ts,
            metadata$file_content_key as stg_file_md5,
            current_timestamp as copy_data_ts
        from @~/cho7/csv/dedup/01_user_data.csv t
    ) file_format = (format_name = 'ttips.ch07.allow_duplicate_ff') 
    on_error = 'CONTINUE'
    ;


/* If duplicate data is present in separate files which are to be loaded to target table  */


create or replace transient table user_mult_dedup(
    id number,
    first_name varchar(100),
    last_name varchar(100),
    email varchar(100),
    gender varchar(1),
    about_me varchar(500)
);
copy into ch07.user_mult_dedup(
    id ,
    first_name,
    last_name,
    email,
    gender,
    about_me
)
from (
        select distinct t.$1::number as id,
            t.$2::text as first_name,
            t.$3::text as last_name,
            t.$4::text as email,
            t.$5::text as gender,
            t.$6::text as about_me
        from @~/cho7/csv/dedup/multfiles/ t 
    ) file_format = (format_name = 'ttips.ch07.allow_duplicate_ff') 
    on_error = 'CONTINUE'
    pattern = '.*[.]csv'
    force = true
    ;


/* Retrieve unique data from 20k records */

create or replace transient table user_20k_unique(
    id number,
    first_name varchar(100),
    last_name varchar(100),
    email varchar(100),
    gender varchar(1),
    about_me varchar(500)
);

copy into ch07.user_20k_unique(
    id ,
    first_name,
    last_name,
    email,
    gender,
    about_me
)
from (
        select distinct t.$1::number as id,
            t.$2::text as first_name,
            t.$3::text as last_name,
            t.$4::text as email,
            t.$5::text as gender,
            t.$6::text as about_me
        from @~/cho7/csv/dedup/04_user_20k.csv t 
    ) file_format = (format_name = 'ttips.ch07.allow_duplicate_ff') 
    on_error = 'CONTINUE'
    force = true
    ;
