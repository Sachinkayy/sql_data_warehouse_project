/*
=============================================================
Create Database and Schemas
=============================================================
Script Purpose:
    This script creates a 3 new databases named as Bronze, Silver, Gold after checking if it already exists. 
    If the database exists, it is dropped and recreated. 
    Note: In Mysql, we dont have a concept of schema and schema is just another name for a DATABASE
	
WARNING:
    Running this script will drop the entire 'Database' if it exists. 
    All data in the database will be permanently deleted. Proceed with caution 
    and ensure you have proper backups before running this script.
*/




-- In MySql we dont have a schema, schema aka database --

-- >> creating databases << --
DROP DATABASE if exists BRONZE;
CREATE DATABASE  BRONZE ;

DROP DATABASE if exists SILVER;
CREATE DATABASE SILVER;

DROP DATABASE if exists GOLD ;
CREATE SCHEMA GOLD;





