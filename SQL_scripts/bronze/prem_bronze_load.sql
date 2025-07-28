/*
===============================================================================================
Stored Procedure: Load Bronze Layer (Source -> Bronze)
===============================================================================================
Script Purpose:
	This stored procedure loads data into the "bronze" schema from external CSV files.
	It performs the following actions:
	-Truncates the bronze tables before loading data.
	-Uses the `BULK INSERT` command to laod data from CSV files to bronze tables.

	Parameters:
			None.
		This stored procedure does not accept any parameters or return any values.

	Usage Example:
		EXEC bronze.load_bronze;
==============================================================================================
*/

USE PremierLeagueDataWarehouse;
GO
CREATE OR ALTER PROCEDURE bronze.load_bronze AS
BEGIN
	DECLARE @bronze_start_time DATETIME, @bronze_end_time DATETIME;
	DECLARE @start_time DATETIME, @end_time DATETIME;

	SET @bronze_start_time = GETDATE();
	BEGIN TRY
		PRINT '============================================================';
		PRINT 'Loading Bronze Layer'
		PRINT '============================================================';

		PRINT '------------------------------------------------------------';
		PRINT 'Loading club_stats Table';
		PRINT '------------------------------------------------------------';

		SET @start_time = GETDATE();
		PRINT '>> Truncating Table: club_stats';
		TRUNCATE TABLE bronze.club_stats;


		PRINT '>> Inserting Data Into: club_stats';
		BULK INSERT bronze.club_stats
		FROM 'C:\Users\daniel\Desktop\Serious Projects\data warehouse projects\premier_league_2016_to_2024_datawarehouse\warehouse_dataset\club_stats.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		SET @end_time = GETDATE();
		PRINT '>> Load duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';
		PRINT '>> ---------------------------'



		PRINT '------------------------------------------------------------';
		PRINT 'Loading league_table Table';
		PRINT '------------------------------------------------------------';

		SET @start_time = GETDATE();
		PRINT '>> Truncating Table: league_table';
		TRUNCATE TABLE bronze.league_table;

		PRINT '>> Inserting Data Into Table: league_table';
		BULK INSERT bronze.league_table
		FROM 'C:\Users\daniel\Desktop\Serious Projects\data warehouse projects\premier_league_2016_to_2024_datawarehouse\warehouse_dataset\league_table.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		SET @end_time = GETDATE();
		PRINT '>> Load duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';
		PRINT '>> ---------------------------'




		PRINT '------------------------------------------------------------';
		PRINT 'Loading player_info Table';
		PRINT '------------------------------------------------------------';
		SET @start_time = GETDATE();
		PRINT '>> Truncating Table: player_info';
		TRUNCATE TABLE bronze.player_info;

		PRINT '>> Inserting Data Into Table: player_info';
		BULK INSERT bronze.player_info
		FROM 'C:\Users\daniel\Desktop\Serious Projects\data warehouse projects\premier_league_2016_to_2024_datawarehouse\warehouse_dataset\player_info.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);

		SET @end_time = GETDATE();
		PRINT '>> Load duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';
		PRINT '>> ---------------------------'




		PRINT '------------------------------------------------------------';
		PRINT 'Loading player_stats Table';
		PRINT '------------------------------------------------------------';
		
		SET @start_time = GETDATE();
		PRINT '>> Truncating Table: player_stats';
		TRUNCATE TABLE bronze.player_stats;

		PRINT '>> Inserting Data Into Table: player_stats';
		BULK INSERT bronze.player_stats
		FROM 'C:\Users\daniel\Desktop\Serious Projects\data warehouse projects\premier_league_2016_to_2024_datawarehouse\warehouse_dataset\player_stats.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);

		SET @end_time = GETDATE();
		PRINT '>> Load duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';
		PRINT '>> ---------------------------'

		

	END TRY
	BEGIN CATCH
		PRINT '========================================='
		PRINT 'Error Message: ' + ERROR_MESSAGE();
		PRINT 'Error Number: ' + CAST (ERROR_NUMBER() AS NVARCHAR); 
		PRINT 'Error Number: ' + CAST (ERROR_STATE() AS NVARCHAR);
		PRINT '========================================='
	END CATCH

	SET @bronze_end_time = GETDATE();
	PRINT '======================================================================';
	PRINT 'Total Load Duration:' + CAST(DATEDIFF(second, @bronze_start_time, @bronze_end_time) AS NVARCHAR) + ' seconds';
	PRINT '======================================================================';
END
