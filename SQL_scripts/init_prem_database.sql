/*
Create Database and Schemas

Script Purpose:
	This script creates a new database named "PremierLeagueDataWarehouse" after checking if it already exists.
	if the database exists, it is dropped and recreated. Additionally the script sets up three schemas
	within the database: "bronze", "silver", and "gold".

	WARNING:
		Running this script will drop the entire "PremierLeagueDataWarehouse" database if it exists.
		All data in the database will be permanently deleted. Proceed with caution and
		ensure you have proper backups before running this script.
*/


USE master;
GO

-- Drop and recreate the "PremierLeagueDataWarehouse" database
IF EXISTS (SELECT 1 FROM sys.databases WHERE name = 'PremierLeagueDataWarehouse')
BEGIN
	ALTER DATABASE PremierLeagueDataWarehouse SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
	DROP DATABASE PremierLeagueDataWarehouse;
END;
GO

-- Create the 'PremierLeagueDataWarehouse' database
CREATE DATABASE PremierLeagueDataWarehouse;
GO

USE PremierLeagueDataWarehouse;
GO

-- Create Schemas
CREATE SCHEMA bronze;
GO

CREATE SCHEMA silver;
GO

CREATE SCHEMA gold;
GO