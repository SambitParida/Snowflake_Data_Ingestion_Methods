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
use schema ch10;

-- Creating table user to store duplicate data from file --
create or replace transient table bookings (
    booking_id number,
    booking_dt date,
    booking_time time,
    booking_dt_time datetime,
    booking_timestamp timestamp
);

create or replace transient table customer_f3 (
	customer_pk number(38,0),
	salutation varchar(10),
	first_name varchar(20),
	last_name varchar(30),
	gender varchar(1),
	marital_status varchar(1),
	day_of_birth date,
	birth_country varchar(60),
	email_address varchar(50),
	city_name varchar(60),
	zip_code varchar(10),
	country_name varchar(20),
	gmt_timezone_offset number(10,2),
	preferred_cust_flag boolean,
	registration_time timestamp_ltz(9),
	stg_file_name string,
    stg_file_load_ts timestamp_ntz,
    stg_file_md5 string,
    copy_data_ts timestamp_ntz default current_timestamp
);

