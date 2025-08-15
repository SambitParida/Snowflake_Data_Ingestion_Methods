-- use sysadmin role to create objects --
use role sysadmin;
-- use database --
use database ttips;
-- use schema --
use schema ch01;
-- create transient table --
create or replace file format customer_csv_ff type = 'csv' compression = 'auto' field_delimiter = ',' record_delimiter = '\n' skip_header = 1 field_optionally_enclosed_by = '"' null_if = ('\\n','\\N','');