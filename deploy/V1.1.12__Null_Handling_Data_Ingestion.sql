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
use schema ch09;

-- Creating table user to store duplicate data from file --
create or replace transient table user (
    id number,
    first_name varchar(100),
    middle_name varchar(100),
    last_name varchar(100),
    email varchar(100),
    dob varchar(10)
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
    null_if = ('\\n', '\\N', '','<null>','null','Null','NULL')
    empty_field_as_null = true;


-- Run below statement to copy data from stg to table --

copy into ch09.user 
     from @~/ch09/csv/01_user_sample_with_nulls.csv
     file_format = (format_name = 'ttips.ch09.csv_ff') on_error = continue;


