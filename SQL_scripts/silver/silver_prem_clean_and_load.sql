/*
===============================================================================================
Stored Procedure: Load Bronze Layer (Source -> Bronze)
===============================================================================================
Script Purpose:
	This stored procedure cleans and loads data into the "silver" schema the bronze layer.
	It performs the following actions:
	-Truncates the silver tables before loading data.
	-Uses the `INSERT INTO` command to clean and laod data from bronze layer  to silver layer.

	Parameters:
			None.
		This stored procedure does not accept any parameters or return any values.

	Usage Example:
		EXEC silver.load_silver;
==============================================================================================
*/


USE PremierLeagueDataWarehouse
GO
/*==============================================================================================================================*/


CREATE OR ALTER PROCEDURE silver.load_silver AS
BEGIN
	BEGIN TRY
		DECLARE 
			@start_time DATETIME, 
			@end_time DATETIME,
			@overall_start_time DATETIME, 
			@overall_end_time DATETIME;
		PRINT '>> Truncating table: silver.player_info'
		TRUNCATE TABLE PremierLeagueDataWarehouse.silver.player_info
		PRINT '>> Inserting Data Into: silver.player_info'
		
		SET @overall_start_time = GETDATE()
		SET @start_time = GETDATE()
		INSERT INTO silver.player_info (
			player_id,
			player_name,
			player_club,
			player_position,
			player_country,
			player_image_url,
			player_stats_url
		)
		/*------------------------------------------------------------------------------------------------------------------------------*/
		/*Cleaning and loading the player information table into the silver layer*/
		/*------------------------------------------------------------------------------------------------------------------------------*/
		SELECT 
			/* First we have to give each player and ID*/
			ROW_NUMBER() OVER (ORDER BY player_name) AS player_id,

			/* Then obviously, we have to select the player name*/
			player_name,

			/* No quality issues with the player club, so we add it as is*/
			player_club,
			player_position,

			/* Select the country names, but we replace the ones with special characters with normal characters*/
			CASE
				WHEN player_country = 'Cote dÔÇÖIvoire' THEN 'Ivory Coast'
				WHEN player_country = 'Bosnia & Herzegovina' THEN 'Bosnia and Herzegovina'
				WHEN player_country = 'Guinea-Bissau' THEN 'Guinea Bissau'
				ELSE player_country
			END player_country,

			/* Then now we select the url to the players url (would be important for visualization)*/
			player_image_url,

			/*No quality issues wiht the stats url, so we load it up*/
			player_stats_url


		FROM bronze.player_info


		SET @end_time = GETDATE();
		PRINT 'load time: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds' 
		PRINT '====================================================================='
		PRINT ''
		PRINT ''
		/*==============================================================================================================================*/


		/*==============================================================================================================================*/

		/*------------------------------------------------------------------------------------------------------------------------------*/
		/*Cleaning and loading the player information table into the silver layer*/
		/*------------------------------------------------------------------------------------------------------------------------------*/
		PRINT '>> Truncating table: silver.player_stats'
		TRUNCATE TABLE PremierLeagueDataWarehouse.silver.player_stats
		PRINT '>> Inserting Data Into: silver.player_stats'
		SET @start_time = GETDATE()
		INSERT INTO silver.player_stats (
			player_name,
			player_nationality,
			player_preferred_foot,
			player_date_of_birth,
			player_appearances,
			player_sub_appearances,
			player_xa,
			player_passes,
			player_pass_accuracy,
			player_long_passes,
			player_long_pass_accuracy,
			player_minutes_played,
			player_duels_won,
			player_total_tackles,
			player_interceptions,
			player_blocks,
			player_red_cards,
			player_yellow_cards,
			player_xg,
			player_touches_in_opposition_box,
			player_aerial_duels_won,
			player_assists,
			player_shots_on_target_inside_the_box,
			player_cross_attempts,
			player_cross_accuracy,
			player_dribble_attempts,
			player_dribble_accuracy,
			player_fouls,
			player_goals,
			hit_woodwork,
			player_offsides,
			player_shots_on_target_outside_the_box,
			player_corners_taken,
			player_freekick_attempts,
			player_freekicks_scored,
			player_own_goals,
			player_penalty_attempts,
			player_goals_conceded,
			player_clean_sheets,
			player_saves_made,
			player_penalties_faced,
			player_penalties_scored,
			player_penalties_saved,
			player_penalty_save_precentage,
			player_season
		)
		SELECT
			player_name,
			CASE
				WHEN player_nationality = 'Cote dÔÇÖIvoire' THEN 'Ivory Coast'
				WHEN player_nationality = 'Bosnia & Herzegovina' THEN 'Bosnia and Herzegovina'
				WHEN player_nationality = 'Guinea-Bissau' THEN 'Guinea-Bissau'
				ELSE player_nationality
			END player_nationality,

			-- replacing the null preferred foot data with null temporarily
			ISNULL(player_preferred_foot, 'na') AS player_preferred_foot,

			-- Using CASE to fill in the missing date of births for players
	
			CASE
				-- Adding the missing date of birth for freddie symonds
				WHEN player_name = 'Freddie Symonds' THEN CAST(CONVERT(DATE, '09/03/2008', 103) AS DATE)
				-- Adding the missing date of birth for Tom Taylor
				WHEN player_name = 'Tom Taylor' THEN CAST(CONVERT(DATE, '10/02/1985', 103) AS DATE)
				WHEN player_date_of_birth IS NULL THEN NULL
				ELSE CAST(CONVERT(DATE, player_date_of_birth, 103) AS DATE)
			END player_date_of_birth,

			-- merging the player appearances together (using them to complement each other)
			CASE
				WHEN player_appearances_ = 0 AND player_appearances != 0 THEN player_appearances
				WHEN player_appearances = 0 AND player_appearances_ != 0 THEN player_appearances_
				ELSE player_appearances
			END player_appearances,

			player_sub_appearances,
			player_xa,
			CASE
				WHEN player_passes_attempts = 0 AND player_passes != 0 THEN player_passes
				WHEN player_passes_attempts != 0 AND player_passes = 0 THEN player_passes_attempts
				ELSE player_passes_attempts
			END player_passes,

			player_pass_accuracy,
			player_long_pass_attempts AS long_passes,
			player_long_pass_accuracy,
			player_minutes_played,
			player_duels_won,
			player_total_tackles,
			player_interceptions,
			player_blocks,
			player_red_cards,
			player_yellow_cards,
			player_xg,
			player_touches_in_opposition_box,
			player_aerial_duels_won,
			player_assists,
			player_shots_on_target_inside_the_box,
			player_cross_attempts,
			player_cross_accuracy,
			player_dribble_attempts,
			player_dribble_accuracy,
			player_fouls,
			player_goals,
			hit_woodwork,
			player_offsides,
			player_shots_on_target_outside_the_box,
			player_corners_taken,
			player_freekick_attempts,
			player_freekicks_scored,
			player_own_goals,

			CASE
				WHEN player_penalties_taken != 0 AND player_penalty_attempts = 0 THEN player_penalties_taken
				WHEN player_penalties_taken = 0 AND player_penalty_attempts != 0 THEN player_penalty_attempts
				ELSE player_penalty_attempts
			END player_penalty_attempts,

			player_goals_conceded,
			player_clean_sheets,
			player_saves_made,
			player_penalties_faced,
			player_penalties_scored,
			player_penalties_saved,
			player_penalty_save_precentage,
			player_season

	
		FROM bronze.player_stats


		SET @end_time = GETDATE();
		PRINT 'load time: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds' 
		PRINT '====================================================================='
		PRINT ''
		PRINT ''
		/*==============================================================================================================================*/




		/*==============================================================================================================================*/
		/*------------------------------------------------------------------------------------------------------------------------------*/

		/*Cleaning and loading the league_table into the silver layer*/
		/*------------------------------------------------------------------------------------------------------------------------------*/
		PRINT '>> Truncating table: silver.league_table'
		TRUNCATE TABLE PremierLeagueDataWarehouse.silver.league_table
		PRINT '>> Inserting Data Into: silver.league_table'
		SET @start_time = GETDATE()
		INSERT INTO silver.league_table (
			league_table_position,
			league_table_badge_URL,
			league_table_club_name,
			league_table_games_played,
			league_table_games_won,
			league_table_games_drawn,
			league_table_games_lost,
			league_table_goals_for,
			league_table_goals_against,
			league_table_goal_difference,
			league_table_points,
			league_table_season,
			league_table_gameweek
		)

		SELECT
			league_table_position,
			league_table_badge_URL,
			league_table_club_name,
			league_table_games_played,
			league_table_games_won,
			league_table_games_drawn,
			league_table_games_lost,
			league_table_goals_for,
			league_table_goals_against,
			league_table_goal_difference,
			league_table_points,
			league_table_season,
			league_table_gameweek

		FROM bronze.league_table

		SET @end_time = GETDATE();
		PRINT 'load time: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds' 
		PRINT '====================================================================='
		PRINT ''
		PRINT ''
		/*==============================================================================================================================*/



		/*==============================================================================================================================*/
		/*------------------------------------------------------------------------------------------------------------------------------*/

		/*Cleaning and loading the club_stats into the silver layer*/
		/*------------------------------------------------------------------------------------------------------------------------------*/
		/*Cleaning and loading the club_stats into the silver layer*/
		/*------------------------------------------------------------------------------------------------------------------------------*/
		PRINT '>> Truncating table: silver.club_stats'
		TRUNCATE TABLE PremierLeagueDataWarehouse.silver.club_stats
		PRINT '>> Inserting Data Into: silver.club_stats'
		SET @start_time = GETDATE()
		INSERT INTO silver.club_stats (
			club_stats_club_name,
			club_stats_club_url,
			club_stats_season,
			club_stats_games_layed,
			club_stats_goals,
			club_stats_goals_conceded,
			club_stats_xg,
			club_stats_shots,
			club_stats_shots_on_target,
			club_stats_shots_on_target_inside_the_box,
			club_stats_shots_on_target_outside_the_box,
			club_stats_touches_in_opposition_box,
			club_stats_penalties_taken,
			club_stats_penalties_scored,
			club_stats_free_kicks_taken,
			club_stats_hitwoodwork,
			club_stats_cross_attempts,
			club_stats_cross_accuracy,
			club_stats_interceptions,
			club_stats_blocks,
			club_stats_clearances,
			club_stats_passes,
			club_stats_long_pass_attempts,
			club_stats_long_pass_accuracy,
			club_stats_corners_taken,
			club_stats_dribble_attempts,
			club_stats_dribble_accuracy,
			club_stats_duels_won,
			club_stats_aerial_duals_won,
			club_stats_red_cards,
			club_stats_yellow_cards,
			club_stats_fouls,
			club_stats_offsides,
			club_stats_own_goals,
			club_stats_penalties_saved,
			club_stats_penalty_save_percentage,
			club_stats_free_kicks_scored,
			club_stats_year
		)


		SELECT
			club_stats_club_name,
			club_stats_club_url,
			club_stats_season,
			club_stats_games_layed,
			club_stats_goals,
			club_stats_goals_conceded,
			club_stats_xg,
			club_stats_shots,
			club_stats_shots_on_target,
			club_stats_shots_on_target_inside_the_box,
			club_stats_shots_on_target_outside_the_box,
			club_stats_touches_in_opposition_box,
			CASE 
				WHEN club_stats_penalties_ IS NULL or club_stats_penalties_ = 0 THEN club_stats_penaties_taken
				WHEN club_stats_penaties_taken IS NULL or club_stats_penaties_taken = 0 THEN club_stats_penalties_
				ELSE club_stats_penalties_
			END club_stats_penalties_taken,
			club_stats_penalties_scored,
			CASE
				WHEN club_stats_free_kicks IS NULL OR club_stats_free_kicks = 0 THEN club_stats_free_kicks_taken
				WHEN club_stats_free_kicks_taken IS NULL OR club_stats_free_kicks_taken = 0 THEN club_stats_free_kicks
				ELSE club_stats_free_kicks_taken
			END club_stats_free_kicks_taken,
			club_stats_hitwoodwork,
			club_stats_cross_attempts,
			club_stats_cross_accuracy,
			club_stats_interceptions,
			club_stats_blocks,
			club_stats_clearances,
			club_stats_passes,
			club_stats_long_pass_attempts,
			club_stats_long_pass_accuracy,
			club_stats_corners_taken,
			club_stats_dribble_attempts,
			club_stats_dribble_accuracy,
			club_stats_duels_won,
			club_stats_aerial_duals_won,
			club_stats_red_cards,
			club_stats_yellow_cards,
			club_stats_fouls,
			club_stats_offsides,
			club_stats_own_goals,
			club_stats_penalties_saved,
			club_stats_penalty_save_percentage,
			club_stats_free_kicks_scored,
			club_stats_year

		FROM bronze.club_stats 

		SET @end_time = GETDATE();
		PRINT 'load time: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds' 
		PRINT '====================================================================='
		PRINT ''
		PRINT ''
		/*==============================================================================================================================*/


		SET @overall_end_time = GETDATE()
		PRINT 'overall load time: ' + CAST(DATEDIFF(second, @overall_start_time, @overall_end_time) AS NVARCHAR) + ' seconds' 
		PRINT '====================================================================='

	END TRY
	BEGIN CATCH
		PRINT '========================================='
		PRINT 'Error Message: ' + ERROR_MESSAGE();
		PRINT 'Error Number: ' + CAST (ERROR_NUMBER() AS NVARCHAR); 
		PRINT 'Error Number: ' + CAST (ERROR_STATE() AS NVARCHAR);
		PRINT '========================================='
	END CATCH
END