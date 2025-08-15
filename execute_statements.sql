
use role sysadmin;
use warehouse data_ingestion_wh;
use database ttips;
use schema ch01;

PUT file:///Users/sambitparida/Desktop/Sambit/Learning/SnowflakePractice/data/DataIngestion/ch01/customer_10k_good_data.csv @csv_stg;

list @csv_stg;