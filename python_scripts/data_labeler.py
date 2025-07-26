#===========================================================================================================================
# The purpose of this script is to label the merge and label the data for the data warehouse
#===========================================================================================================================

import pandas as pd
import os

# Creating direcory for storing labelled and stored data
#============================================================================================================================
project_dir = "C:/Users/daniel/Desktop/Serious Projects/data warehouse projects/premier_league_2016_to_2024_datawarehouse"
os.makedirs(project_dir + "/warehouse_dataset",exist_ok=True)
warehouse_data_dir = project_dir + "/warehouse_dataset"
original_data_dir = f"{project_dir}/datasets"
#============================================================================================================================


# Labelling the player information
# ==========================================================================================================================
#-----------------------------------------------------------------------------------------------------------------------------
# Create the varaible to hold the player information in a dataframe
player_information = pd.read_csv(f"{original_data_dir}/premier_player_info.csv")


print(f"{warehouse_data_dir}/player_info.csv")
player_information.to_csv(f"{warehouse_data_dir}/player_info.csv", index=False)
print("stored new player info")



#player information does not require adding any labels so we move on
# ----------------------------------------------------------------------------------------------------------------------------
#==============================================================================================================================


# Labelling player_stats dataframe
#==============================================================================================================================
# ----------------------------------------------------------------------------------------------------------------------------
# Creating the data frame to hold the player stats

player_stats_2024 = pd.read_csv(f"{original_data_dir}/player_stats_2024_2025_season.csv")

# add the season lablel to the dataset
player_stats_2024["season"] = 2024
print("labeled player stats")

# store new player stats in directory
player_stats_2024.to_csv(f"{warehouse_data_dir}/player_stats.csv", index=False)
print("stored player stats")
# ----------------------------------------------------------------------------------------------------------------------------
#==============================================================================================================================



# Labelling league_table dataframe
#==============================================================================================================================
# ----------------------------------------------------------------------------------------------------------------------------
# Creating the variable to hold the league table path
league_table_dir = original_data_dir + "/league_table"

# Create a variable to hold the table version (home, away, combine)
league_table_version = ["home", "away", "home_and_away"]

# Create an empty dataframe that holds the league table information
league_table = pd.DataFrame(columns=["position", "badge_url", "name", "games_played", "games_won", "games_drawn", "games_lost", "goals_for", "goals_against", "goal_difference", "points", "season", "gameweek"])
#start iterating over each version
for version in league_table_version:

    # start iterating over all the avaialable seasons
    for season in range(2016, 2025, 1):

        # Start iterating over each gameweek
        for gameweek in range(1, 39, 1):

            # load the csv, add the season and the gameweek label, and save add it to the overall table
            current_season_gameweek = ""
            if version == "home" or version == "away":
                current_season_gameweek = f"{league_table_dir}/{version}/{version}_gameweek_{season}/{season}_{version}_gameweek_{gameweek}.csv"
            else:
                current_season_gameweek = f"{league_table_dir}/{version}/gameweek_{season}/{season}_gameweek_{gameweek}.csv"

            # Create a datafromae for the season and gameweek
            current_season_gameweek_df = pd.read_csv(current_season_gameweek)

            # Add season label
            current_season_gameweek_df["season"] = season

            # Add gameweek label
            current_season_gameweek_df["gameweek"] = gameweek
            print(f"labelled data for gameweek {gameweek} in {season} season")

            # join the current season gameweek with the original data
            league_table = pd.concat([league_table, current_season_gameweek_df], axis=0) 
            print(f"added data for gameweek {gameweek} in {season} season to league table")

# Now save the league table as a csv
league_table.to_csv(f"{warehouse_data_dir}/league_table.csv", index=False)

print("finished labelling league tables")
# ----------------------------------------------------------------------------------------------------------------------------
#==============================================================================================================================



# Labelling club stats data
#==============================================================================================================================
# ----------------------------------------------------------------------------------------------------------------------------

# Creating a variable to hold the club stats data
club_stats_dir = original_data_dir + "/club_stats"

# Create empty dataframe to hold new club stats
club_stats = pd.DataFrame(columns = list(pd.read_csv(club_stats_dir+"/2024_season_club_stats.csv").columns) + ["year"])

# start iterating over all seasons
for season in range (2016, 2025, 1):
    current_club_stats = pd.read_csv(f"{club_stats_dir}/{season}_season_club_stats.csv")
    current_club_stats["year"] = season

    # add the new season to the overall club stats 
    club_stats = pd.concat([club_stats, current_club_stats], axis=0)
    print(f"added club stats for {season} to club stats dataframe")

# Now save the club stats as a csv
club_stats.to_csv(f"{warehouse_data_dir}/club_stats.csv", index=False)

print("Finished labeling data  everything")



# ----------------------------------------------------------------------------------------------------------------------------
#==============================================================================================================================