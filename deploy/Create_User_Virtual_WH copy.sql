-- use sysadmin role to create objects --
use role sysadmin;
create or replace warehouse data_ingestion_wh with warehouse_size = 'large' warehouse_type = 'standard' auto_suspend = 60 auto_resume = true min_cluster_count = 1 max_cluster_count = 1 scaling_policy = 'standard';

create or replace database ttips;
use database ttips;
create or replace schema ch01;

use role useradmin;
create or replace user data_ingestion_user password = 'test@1234' comment = 'this user is created to ingest data in snowflake' default_role = sysadmin default_secondary_roles = ('all') must_change_password = false;

use role securityadmin;
grant role sysadmin to user data_ingestion_user;
grant usage on warehouse data_ingestion_wh to role sysadmin;


