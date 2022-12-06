#!/bin/bash
PSQL="psql --username=freecodecamp --dbname=number_guess -t --no-align -c"
# Get random number
RAND_NUM=$((1 + $RANDOM % 10))


# Ask for username
echo "Enter your username:"
read USERNAME
USER_EXISTS=$($PSQL "SELECT username FROM users WHERE username='$USERNAME'")
# if user does not exist
if [[ -z $USER_EXISTS ]]
then
  # New user prompt
  echo "Welcome, $USERNAME! It looks like this is your first time here."
  # Create new user
  INSERT_USER=$($PSQL "INSERT INTO users(username) VALUES('$USERNAME')")
else 
  # Returning user prompt
  GAMES_PLAYED=$($PSQL "SELECT games_played FROM users WHERE username='$USERNAME'")
  BEST_GAME=$($PSQL "SELECT best_game FROM users WHERE username='$USERNAME'")
  echo "Welcome back, $USERNAME! You have played $GAMES_PLAYED games, and your best game took $BEST_GAME guesses."
fi


# Give game info and play game
echo "Guess the secret number between 1 and 1000:"
read GUESS
i=1
while (( $GUESS != $RAND_NUM ))
do
  # count of guesses
  let i+=1
  # If guess is not a number, guess again
  if ! [[ $GUESS =~ ^[0-9]+$ ]]
  then
    echo "That is not an integer, guess again:"
    read GUESS
  # If number lower than guess, guess again
  elif (( $GUESS > $RAND_NUM ))
  then
    echo "It's lower than that, guess again:"
    read GUESS
  # If number higher than guess, guess again
  elif (( $GUESS < $RAND_NUM ))
  then
    echo "It's higher than that, guess again:"
    read GUESS
  fi
done


# Store game info
INSERT_GAME=$($PSQL "INSERT INTO games(username,guesses) VALUES('$USERNAME','$i')")
# Update user table with game info
GAMES_PLAYED=$($PSQL "SELECT COUNT(*) FROM games WHERE username='$USERNAME'")
INSERT_GAMES_PLAYED=$($PSQL "UPDATE users SET games_played=$GAMES_PLAYED WHERE username='$USERNAME'")
BEST_GAME=$($PSQL "SELECT MIN(guesses) FROM games WHERE username='$USERNAME'")
INSERT_BEST_GAME=$($PSQL "UPDATE users SET best_game=$BEST_GAME WHERE username='$USERNAME'")


# Output number of tries and secret number
echo "You guessed it in $i tries. The secret number was $RAND_NUM. Nice job!"