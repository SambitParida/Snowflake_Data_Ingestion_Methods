
-- use sysadmin role to create objects --
use role sysadmin;
-- use database --
use database ttips;
-- use schema --
use schema ch01;
-- create transient t

create stage if not exists ch01.csv_stg directory = (enable = true) comment = 'this is a snowflake internal stage';
create stage if not exists ch01.psv_stg directory = (enable = true) comment = 'this is a snowflake internal stage to store data from pipe separated file';
create stage if not exists ch01.tsv_stg directory = (enable = true) comment = 'this is a snowflake internal stage to store data from tab separated file';