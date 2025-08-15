-- use sysadmin role to create objects --
use role sysadmin;
-- use virtual warehouse -- 
use warehouse data_ingestion_wh;
-- use database --
use database ttips;
-- use schema --
use schema ch01;
-- Create CSV File format -- 
create or replace file format customer_csv_ff 
    type = 'csv' 
    compression = 'auto' 
    field_delimiter = ',' 
    record_delimiter = '\n' 
    date_format = 'AUTO'
    timestamp_format = 'AUTO'
    skip_header = 1 
    field_optionally_enclosed_by = '"' 
    null_if = ('\\n', '\\N', '');

-- Create TSV File format -- 
create or replace file format customer_tsv_ff 
    type = 'csv' 
    compression = 'auto' 
    field_delimiter = '\t' 
    record_delimiter = '\n' 
    skip_header = 1 
    field_optionally_enclosed_by = '"' 
    null_if = ('\\n', '\\N', '');

-- Create PSV File format -- 
create or replace file format customer_psv_ff 
    type = 'csv' 
    compression = 'auto' 
    field_delimiter = '|' 
    record_delimiter = '\n' 
    skip_header = 1 
    field_optionally_enclosed_by = '"' 
    null_if = ('\\n', '\\N', '');