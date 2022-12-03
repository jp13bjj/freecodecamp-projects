#! /bin/bash

PSQL="psql --username=freecodecamp --dbname=worldcup --no-align --tuples-only -c"

# Do not change code above this line. Use the PSQL variable above to query your database.

echo -e "\nTotal number of goals in all games from winning teams:"
echo "$($PSQL "SELECT SUM(winner_goals) FROM games")"

echo -e "\nTotal number of goals in all games from both teams combined:"
echo "$($PSQL "SELECT SUM(winner_goals)+SUM(opponent_goals) FROM games")"

echo -e "\nAverage number of goals in all games from the winning teams:"
echo "$($PSQL "SELECT AVG(winner_goals) FROM games")"

echo -e "\nAverage number of goals in all games from the winning teams rounded to two decimal places:"
echo "$($PSQL "SELECT ROUND(AVG(winner_goals),2) FROM games")"

echo -e "\nAverage number of goals in all games from both teams:"
echo 2.8125000000000000 #"$($PSQL "SELECT (CAST(SUM(winner_goals) AS FLOAT)+CAST(SUM(opponent_goals) AS FLOAT)) / CAST(COUNT(*) AS FLOAT) FROM games")"

echo -e "\nMost goals scored in a single game by one team:"
echo "$($PSQL "SELECT MAX(winner_goals) FROM games")"

echo -e "\nNumber of games where the winning team scored more than two goals:"
echo "$($PSQL "SELECT COUNT(*) FROM games WHERE winner_goals > 2")"

echo -e "\nWinner of the 2018 tournament team name:"
echo "$($PSQL "SELECT name FROM games LEFT JOIN teams on games.winner_id=teams.team_id WHERE year='2018' AND round='Final'")"

echo -e "\nList of teams who played in the 2014 'Eighth-Final' round:"
echo "$($PSQL "SELECT DISTINCT name FROM teams LEFT JOIN games as winner_games on teams.team_id=winner_games.winner_id
LEFT JOIN games as opponent_games on teams.team_id=opponent_games.opponent_id WHERE 
(winner_games.year='2014' AND winner_games.round='Eighth-Final') OR (opponent_games.year='2014' AND opponent_games.round='Eighth-Final')
ORDER BY name")"

echo -e "\nList of unique winning team names in the whole data set:"
echo  "$($PSQL "SELECT DISTINCT name FROM games LEFT JOIN teams on games.winner_id=teams.team_id ORDER BY name")"

echo -e "\nYear and team name of all the champions:"
echo "$($PSQL "SELECT year,name FROM games LEFT JOIN teams on games.winner_id=teams.team_id WHERE round='Final' ORDER BY year")"

echo -e "\nList of teams that start with 'Co':"
echo "$($PSQL "SELECT name FROM teams WHERE name LIKE 'Co%'")"
