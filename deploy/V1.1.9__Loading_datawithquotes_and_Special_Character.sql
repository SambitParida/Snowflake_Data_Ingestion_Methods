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


-- use schema --
--create schema ch06 --
use schema ch06;

create or replace transient table user_email(
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

create or replace transient table user_email_single_quote(
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

create or replace transient table user_email_double_quote(
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
create or replace file format csv_double_q_ff 
    type = 'csv' 
    compression = 'none' 
    field_delimiter = ',' 
    record_delimiter = '\n' 
    skip_header = 1 
    field_optionally_enclosed_by = '\042' 
    trim_space = false 
    error_on_column_count_mismatch = true;

-- another file format where field_optionally_enclosed_by parameter
-- will take single quote (\047)

create or replace file format csv_single_q_ff 
    type = 'csv' 
    compression = 'none' 
    field_delimiter = ',' 
    record_delimiter = '\n' 
    skip_header = 1 
    field_optionally_enclosed_by = '\047' 
    trim_space = false 
    error_on_column_count_mismatch = true;

copy into ch06.user_email (
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
        select t.$1::text as id,
            t.$2::text as first_name,
            t.$3::text as last_name,
            t.$4::text as email,
            t.$5::text as gender,
            t.$6::text as about_me,
            metadata$filename as stg_file_name,
            metadata$file_last_modified as stg_file_load_ts,
            metadata$file_content_key as stg_file_md5,
            current_timestamp as copy_data_ts
        from @~/cho6/csv/uncompressed/01_sample_user_email.csv t
    ) file_format = (format_name = 'ttips.ch06.csv_double_q_ff') 
    on_error = 'CONTINUE'
    ;


copy into ch06.user_email_double_quote (
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
        select t.$1::text as id,
            t.$2::text as first_name,
            t.$3::text as last_name,
            t.$4::text as email,
            t.$5::text as gender,
            t.$6::text as about_me,
            metadata$filename as stg_file_name,
            metadata$file_last_modified as stg_file_load_ts,
            metadata$file_content_key as stg_file_md5,
            current_timestamp as copy_data_ts
        from @~/cho6/csv/uncompressed/02_sample_email_double_quotes.csv t
    ) file_format = (format_name = 'ttips.ch06.csv_double_q_ff') 
    on_error = 'CONTINUE'
    ;

copy into ch06.user_email_single_quote (
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
        select t.$1::text as id,
            t.$2::text as first_name,
            t.$3::text as last_name,
            t.$4::text as email,
            t.$5::text as gender,
            t.$6::text as about_me,
            metadata$filename as stg_file_name,
            metadata$file_last_modified as stg_file_load_ts,
            metadata$file_content_key as stg_file_md5,
            current_timestamp as copy_data_ts
        from @~/cho6/csv/uncompressed/03_sample_email_single_quote.csv t
    ) file_format = (format_name = 'ttips.ch06.csv_single_q_ff') 
    on_error = 'CONTINUE'
    ;

/*if one field contains new line character. It Loads without any issue */

create or replace transient table user_email_new_line(
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

copy into ch06.user_email_new_line (
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
        select t.$1::text as id,
            t.$2::text as first_name,
            t.$3::text as last_name,
            t.$4::text as email,
            t.$5::text as gender,
            t.$6::text as about_me,
            metadata$filename as stg_file_name,
            metadata$file_last_modified as stg_file_load_ts,
            metadata$file_content_key as stg_file_md5,
            current_timestamp as copy_data_ts
        from @~/cho6/csv/uncompressed/05_sample_email_new_line.csv t
    ) file_format = (format_name = 'ttips.ch06.csv_double_q_ff') 
    on_error = 'CONTINUE'
    ;



/*if one field contains both single and double characters.*/

create or replace transient table user_email_with_reg_expr(
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


create or replace file format csv_double_q_reg_exp_ff 
    type = 'csv' 
    compression = 'none' 
    field_delimiter = ',' 
    record_delimiter = '\n' 
    skip_header = 1 
    field_optionally_enclosed_by = '\042' 
    escape = '\134'
    skip_blank_lines = true
    trim_space = true
    error_on_column_count_mismatch = true;


copy into ch06.user_email_with_reg_expr (
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
        select t.$1::text as id,
            t.$2::text as first_name,
            t.$3::text as last_name,
            t.$4::text as email,
            t.$5::text as gender,
            regexp_replace($6,'\\"|\'','') AS about_me,
            metadata$filename as stg_file_name,
            metadata$file_last_modified as stg_file_load_ts,
            metadata$file_content_key as stg_file_md5,
            current_timestamp as copy_data_ts
        from @~/cho6/csv/uncompressed/06_sample_email_regex.csv t
    ) file_format = (format_name = 'ttips.ch06.csv_double_q_reg_exp_ff') 
     on_error = 'CONTINUE'
     force = true
    ;

