
-- use sysadmin role to create objects --
use role sysadmin;
-- use database --
use database ttips;
-- use schema --
use schema ch01;
-- create transient t

create stage if not exists ch01.csv_stg directory = (enable = true) comment = 'this is a snowflake internal stage';