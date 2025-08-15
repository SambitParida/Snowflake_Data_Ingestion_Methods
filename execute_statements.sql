
use role sysadmin;
use warehouse data_ingestion_wh;
use database ttips;
use schema ch01;

PUT file:///Users/sambitparida/Desktop/Sambit/Learning/SnowflakePractice/Swiggy_Order_Data/01-location-csv/01.01-initial-load/location-5rows.csv @CSV_STG/initial/location;