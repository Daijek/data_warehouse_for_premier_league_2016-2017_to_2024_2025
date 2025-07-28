
/*=========================================================================================================================*/
/* Cleaning the player info table in preparation for the silver layer*/
/*=========================================================================================================================*/
/* Check for null values in the name column*/

USE PremierLeagueDataWarehouse

/*-------------------------------------------------------------------------------------------------------------------------*/
/* Cleaning the player_name column*/
/*-------------------------------------------------------------------------------------------------------------------------*/

/* 
Checking the name colum for null values 
Expectation: No result
*/
SELECT 
	player_name
FROM bronze.player_info
WHERE player_name IS NULL OR player_name = ''
/* nothing comes up, so thats great */



/* 
Checking for duplicate names in the name column
Expectation: no results
*/
SELECT
	player_name,
	COUNT(player_name) as player_counts
FROM bronze.player_info
GROUP BY player_name
HAVING COUNT(player_name) > 1
/* Nothing comes up, so thats great*/

/* 
Checking for unwanted spaces by the left and right in the player name column
Expectation: No results
*/
SELECT
	player_name
FROM bronze.player_info
WHERE TRIM(player_name) != player_name
/* Nothing comes up, so thats great*/


/*-------------------------------------------------------------------------------------------------------------------------*/
/* Cleaning the player_img_url column*/
/*-------------------------------------------------------------------------------------------------------------------------*/

/* 
Checking the player_image_url colum for null values 
Expectation: No result
*/
SELECT 
	player_image_url
FROM bronze.player_info
WHERE player_image_url IS NULL OR player_image_url = ''
/* nothing comes up, so thats great */



/* 
Checking for duplicate player_image_url in the name column
Expectation: Only place holder image url should repeat, because it is used when we dont have a player image
*/
SELECT
	player_image_url,
	COUNT(player_image_url) as player_image_counts
FROM bronze.player_info
GROUP BY player_image_url
HAVING COUNT(player_image_url) > 1
/* Only player image url comes up*/

/* 
Checking for unwanted spaces by the left and right in the player name column
Expectation: No results
*/
SELECT
	player_image_url
FROM bronze.player_info
WHERE TRIM(player_image_url) != player_image_url
/* Nothing comes up, so thats great*/


/*-------------------------------------------------------------------------------------------------------------------------*/
/* Cleaning the player_country column*/
/*-------------------------------------------------------------------------------------------------------------------------*/

/* 
Checking the player_country colum for null values 
Expectation: No result
*/
SELECT 
	player_country
FROM bronze.player_info
WHERE player_country IS NULL OR player_country = ''
/* nothing comes up, so thats great */


/* 
Checking for unwanted spaces by the left and right in the player player_country column
Expectation: No results
*/
SELECT
	player_country
FROM bronze.player_info
WHERE TRIM(player_country) != player_country
/* Nothing comes up, so thats great*/

/* 
Checking for unique values of the player country column to see if there are issues
*/
SELECT DISTINCT player_country FROM bronze.player_info

/* Identify countries that dont match the normal alphabet*/
SELECT 
	player_country 
FROM (SELECT DISTINCT player_country FROM bronze.player_info)t
WHERE player_country COLLATE Latin1_General_BIN  LIKE '%[^A-Za-z ]%'  -- Allows only letters (no spaces/numbers)

/*The only country with that might cause an issue in ENGLISH is Cote dÔÇÖIvoire, so we simply replace it using the case when in the load script*/




/*-------------------------------------------------------------------------------------------------------------------------*/
/* Cleaning the player_club column*/
/*-------------------------------------------------------------------------------------------------------------------------*/

/* 
Checking the name colum for null values 
Expectation: No result
*/
SELECT 
	player_club
FROM bronze.player_info
WHERE player_club IS NULL OR player_club = ''
/* nothing comes up, so thats great */

/* 
Checking for unwanted spaces by the left and right in the player name column
Expectation: No results
*/
SELECT
	player_club
FROM bronze.player_info
WHERE TRIM(player_club) != player_club
/* Nothing comes up, so thats great*/

/* 
Checking for unique values of the player country column to see if there are issues
*/
SELECT DISTINCT player_club FROM bronze.player_info
/* Identify countries that dont match the normal alphabet*/
SELECT 
	player_club 
FROM (SELECT DISTINCT player_club FROM bronze.player_info)t
WHERE player_club COLLATE Latin1_General_BIN  LIKE '%[^A-Za-z ]%'  -- Allows only letters (no spaces/numbers)
/* They all match, so no issues here */


/*-------------------------------------------------------------------------------------------------------------------------*/
/* Cleaning the player_position column*/
/*-------------------------------------------------------------------------------------------------------------------------*/

/* 
Checking the player_position colum for null values 
Expectation: No result
*/
SELECT 
	player_position
FROM bronze.player_info
WHERE player_position IS NULL OR player_position = ''
/* nothing comes up, so thats great */

/* 
Checking for duplicate player_position in the name column
Expectation: no results
*/
SELECT
	player_position,
	COUNT(player_position) as player_position_counts
FROM bronze.player_info
GROUP BY player_position
HAVING COUNT(player_position) > 1
/* Nothing comes up, so thats great*/

/* 
Checking for unwanted spaces by the left and right in the player_position column
Expectation: No results
*/
SELECT
	player_position
FROM bronze.player_info
WHERE TRIM(player_position) != player_position
/* Nothing comes up, so thats great*/






/*-------------------------------------------------------------------------------------------------------------------------*/
/* Cleaning the player_stats_url column*/
/*-------------------------------------------------------------------------------------------------------------------------*/
/* 
Checking the player_image_url colum for null values 
Expectation: No result
*/
SELECT 
	player_stats_url
FROM bronze.player_info
WHERE player_stats_url IS NULL OR player_stats_url = ''
/* nothing comes up, so thats great */



/* 
Checking for duplicate player_image_url in the name column
Expectation: Only place holder image url should repeat, because it is used when we dont have a player image
*/
SELECT
	player_stats_url,
	COUNT(player_image_url) as player_image_counts
FROM bronze.player_info
GROUP BY player_stats_url
HAVING COUNT(player_stats_url) > 1
/* Only player image url comes up*/

/* 
Checking for unwanted spaces by the left and right in the player name column
Expectation: No results
*/
SELECT
	player_image_url
FROM bronze.player_info
WHERE TRIM(player_stats_url) != player_stats_url
/* Nothing comes up, so thats great*/