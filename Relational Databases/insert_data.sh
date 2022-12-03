#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.

# Remove old data
echo $($PSQL "TRUNCATE games, teams")

# Add csv data to teams table
cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
  #Populating teams table
    # Adding winners to teams
    if [[ $WINNER != "winner" ]]
    then
      # get team_id
      TEAM_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
      # if not found
      if [[ -z $TEAM_ID ]]
      then
        # insert winner into teams
        INSERT_TEAM_RESULT=$($PSQL "INSERT INTO teams(name) VALUES('$WINNER')")
        if [[ $INSERT_TEAM_RESULT == "INSERT 0 1" ]]
        then
          echo Inserted into teams, $WINNER
        fi
      fi
    fi

    # Adding opponents to teams
    if [[ $OPPONENT != "opponent" ]]
    then
      # get team_id
      TEAM_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")
      # if not found
      if [[ -z $TEAM_ID ]]
      then
        # insert opponent into teams
        INSERT_TEAM_RESULT=$($PSQL "INSERT INTO teams(name) VALUES('$OPPONENT')")
        if [[ $INSERT_TEAM_RESULT == "INSERT 0 1" ]]
        then
          echo Inserted into teams, $OPPONENT
        fi
      fi
    fi

  #Populating games table
    # Adding games to games
    if [[ $WINNER != "winner" ]]
    then
      # get winner_id
      WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
      # get opponent_id
      OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")
      # insert games into games
      INSERT_TEAM_RESULT=$($PSQL "INSERT INTO games(year, round, winner_id, opponent_id, winner_goals, opponent_goals)
       VALUES('$YEAR','$ROUND','$WINNER_ID','$OPPONENT_ID','$WINNER_GOALS','$OPPONENT_GOALS')")
        if [[ $INSERT_TEAM_RESULT == "INSERT 0 1" ]]
        then
          #check insertion into games
          GAME_ID=$($PSQL "SELECT game_id FROM games WHERE year='$YEAR' AND round='$ROUND' AND winner_id='$WINNER_ID'
           AND opponent_id='$OPPONENT_ID'")
          echo Inserted into games - year: $YEAR, round: $ROUND, winner: $WINNER, opponent: $OPPONENT, winner_goals: $WINNER_GOALS, opponent_goals: $OPPONENT_GOALS
        fi
    fi
done
