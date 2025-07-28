USE PremierLeagueDataWarehouse
GO

/* 

Creating the tables for the silver layer 

The purpose of this script is to create Data Definition Language for all the soucrse.


This means that we would have to create 4 DDL Tables here.


In these project, we use the data names as 1 to 1, which means that they would have the same
names with what we have in the bronze layer (and remove any duplicate columns).
*/


/* First Use TSQL logic to make sure the table does not exist*/

/*Creating the data definision language for the silver player info*/
IF OBJECT_ID ('silver.player_info', 'u') IS NOT NULL
	DROP TABLE silver.player_info;
CREATE TABLE silver.player_info (
	player_id INT,
	player_name NVARCHAR(50),
	player_club NVARCHAR(50),
	player_country NVARCHAR(50),
	player_position NVARCHAR(50),
	player_image_url NVARCHAR(MAX),
	player_stats_url NVARCHAR(MAX),
	dwh_create_date DATETIME DEFAULT GETDATE()
);


/*Creating the data definision language for the silver player stats*/
IF OBJECT_ID ('silver.player_stats', 'u') IS NOT NULL
	DROP TABLE silver.player_stats;
CREATE TABLE silver.player_stats (
	player_name NVARCHAR(50),
	player_nationality NVARCHAR(50),
	player_preferred_foot NVARCHAR(50),
	player_date_of_birth DATE,
	player_appearances INT,
	player_sub_appearances INT,
	player_xa FLOAT,
	player_passes INT,
	player_pass_accuracy FLOAT,
	player_long_passes INT,
	player_long_pass_accuracy INT,
	player_minutes_played INT,
	player_duels_won INT,
	player_total_tackles INT,
	player_interceptions INT,
	player_blocks INT,
	player_red_cards INT,
	player_yellow_cards INT,
	player_xg FLOAT,
	player_touches_in_opposition_box INT,
	player_aerial_duels_won INT,
	player_assists INT,
	player_shots_on_target_inside_the_box INT,
	player_cross_attempts INT,
	player_cross_accuracy FLOAT,
	player_dribble_attempts INT,
	player_dribble_accuracy FLOAT,
	player_fouls INT,
	player_goals INT,
	hit_woodwork INT,
	player_offsides INT,
	player_shots_on_target_outside_the_box INT,
	player_corners_taken INT,
	player_freekick_attempts INT,
	player_freekicks_scored INT,
	player_own_goals INT,
	player_penalty_attempts INT,
	player_goals_conceded INT,
	player_clean_sheets INT,
	player_saves_made INT,
	player_penalties_faced INT,
	player_penalties_scored INT,
	player_penalties_saved INT,
	player_penalty_save_precentage FLOAT,
	player_season INT,
	dwh_create_date DATETIME DEFAULT GETDATE()
);

/*Creating the data definision language for the  silverleague table*/
IF OBJECT_ID ('silver.league_table', 'u') IS NOT NULL
	DROP TABLE silver.league_table;
CREATE TABLE silver.league_table (
	league_table_position INT,
	league_table_badge_URL NVARCHAR(MAX),
	league_table_club_name NVARCHAR(50),
	league_table_games_played INT,
	league_table_games_won INT,
	league_table_games_drawn INT,
	league_table_games_lost INT,
	league_table_goals_for INT,
	league_table_goals_against INT,
	league_table_goal_difference INT,
	league_table_points INT,
	league_table_season INT,
	league_table_gameweek INT,
	dwh_create_date DATETIME DEFAULT GETDATE()
);


/*Creating the data definision language for the silver club stats*/
IF OBJECT_ID ('silver.club_stats', 'u') IS NOT NULL
	DROP TABLE silver.club_stats;
CREATE TABLE silver.club_stats (
	club_stats_club_name NVARCHAR(50),
	club_stats_club_url NVARCHAR(MAX),
	club_stats_season NVARCHAR(50),
	club_stats_games_layed INT,
	club_stats_goals INT,
	club_stats_goals_conceded INT,
	club_stats_xg FLOAT,
	club_stats_shots INT,
	club_stats_shots_on_target INT,
	club_stats_shots_on_target_inside_the_box INT,
	club_stats_shots_on_target_outside_the_box INT,
	club_stats_touches_in_opposition_box INT,
	club_stats_penalties_taken INT,
	club_stats_penalties_scored INT,
	club_stats_free_kicks_taken INT,
	club_stats_hitwoodwork INT,
	club_stats_cross_attempts INT,
	club_stats_cross_accuracy FLOAT,
	club_stats_interceptions INT,
	club_stats_blocks INT,
	club_stats_clearances INT,
	club_stats_passes INT,
	club_stats_long_pass_attempts INT,
	club_stats_long_pass_accuracy FLOAT,
	club_stats_corners_taken INT,
	club_stats_dribble_attempts INT,
	club_stats_dribble_accuracy FLOAT,
	club_stats_duels_won INT,
	club_stats_aerial_duals_won INT,
	club_stats_red_cards INT,
	club_stats_yellow_cards INT,
	club_stats_fouls INT,
	club_stats_offsides INT,
	club_stats_own_goals INT,
	club_stats_penalties_saved INT,
	club_stats_penalty_save_percentage FLOAT,
	club_stats_free_kicks_scored INT,
	club_stats_year INT,
	dwh_create_date DATETIME DEFAULT GETDATE()
);