/* Check player name quality*/
/*Cleaning the player_name column*/
-- Check the name for duplicates

SELECT player_name, COUNT(player_name) FROM bronze.player_stats GROUP BY player_name HAVING COUNT(player_name) > 1

-- Check for null values in player name column
SELECT player_name FROM bronze.player_stats WHERE player_name IS NULL OR player_name = ''

-- Check for unwanted spaces in player name
SELECT player_name FROM bronze.player_stats WHERE TRIM(player_name) != player_name





/* Check player nationality quality*/
/*Cleaning the player_nationality column*/

-- Check the player_nationality for duplicates
SELECT player_nationality, COUNT(player_nationality) FROM bronze.player_stats GROUP BY player_nationality HAVING COUNT(player_nationality) > 1

-- Check for null values in player_nationality column
SELECT player_nationality FROM bronze.player_stats WHERE player_nationality IS NULL OR player_nationality = ''

-- Check for unwanted spaces in player name
SELECT player_nationality FROM bronze.player_stats WHERE TRIM(player_nationality) != player_nationality




/* Check player_preferred_foot*/
/*Cleaning the player_preferred_foot column*/

-- Check the player_preferred_foot for duplicates
SELECT player_preferred_foot, COUNT(player_preferred_foot) FROM bronze.player_stats GROUP BY player_preferred_foot HAVING COUNT(player_preferred_foot) > 1

-- Check for null values in player_nationality column
SELECT player_preferred_foot FROM bronze.player_stats WHERE player_preferred_foot IS NULL OR player_preferred_foot = ''

-- Check for unwanted spaces in player name
SELECT player_preferred_foot FROM bronze.player_stats WHERE TRIM(player_preferred_foot) != player_preferred_foot

-- Check null preferred foot to gain more insight 
SELECT player_name, player_preferred_foot FROM bronze.player_stats WHERE player_preferred_foot IS NULL




/* Check date_of_birth*/
/*Cleaning the date_of_birth column*/

-- Check the date_of_birth for duplicates
SELECT player_name, player_date_of_birth, COUNT(player_date_of_birth) FROM bronze.player_stats GROUP BY player_name, player_date_of_birth HAVING player_date_of_birth IS NULL
--lets look for the date of birth of these players and add them

-- Check for null values in player_nationality column
SELECT player_date_of_birth FROM bronze.player_stats WHERE player_date_of_birth IS NULL OR player_date_of_birth = ''

-- Check for unwanted spaces in player name
SELECT player_date_of_birth FROM bronze.player_stats WHERE TRIM(player_date_of_birth) != player_date_of_birth


SELECT player_name, player_date_of_birth FROM bronze.player_stats WHERE player_date_of_birth IS NULL

SELECT player_name, player_date_of_birth FROM bronze.player_stats
WHERE player_date_of_birth NOT LIKE '[0-3][0-9]/[0-1][0-9]/[0-9][0-9][0-9][0-9]'

/*check appearances (because it apprears twice)*/

-- 
SELECT 
	player_name,
	player_appearances_,
	player_appearances,
	player_sub_appearances
FROM bronze.player_stats
WHERE (player_appearances = 0 AND player_appearances_ > 0)
-- From what we have seen, players that have never had a sub appearance are stored under player_appearances, while players that have had subs are stored under player_appearances_
-- We have to define a logic to check the player appearances to fill the appearances when the appearances is 0


SELECT 
	player_name,
	player_passes_attempts,
	player_passes,
	player_pass_accuracy
FROM bronze.player_stats
WHERE (player_passes_attempts = 0 AND player_passes > 0)


SELECT 
    player_name, 
    player_date_of_birth AS problematic_string
FROM bronze.player_stats
WHERE 
    player_date_of_birth IS NOT NULL
    AND TRY_CAST(player_date_of_birth AS DATE) IS NULL
    -- Exclude your manual overrides (if needed)
    AND player_name NOT IN ('Freddie Symonds', 'Tom Taylor');
