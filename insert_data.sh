#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.

echo $($PSQL "TRUNCATE games, teams")
# Script to insert data from games.csv into games database
cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
  #WINNER
  if [[ $WINNER != "winner" ]] 
  then
    # get winner_id
    WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
    # if not found
      if [[ -z $WINNER_ID ]]
      then
        # insert winner
        INSERT_WINNER_RESULT=$($PSQL "INSERT INTO teams(name) VALUES('$WINNER')")
        # get new winner_id
        WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
      fi
  fi
   #OPPONENT
  if [[ $OPPONENT != "opponent" ]] 
  then
    # get opponent id
    OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")
    # if not found
      if [[ -z $OPPONENT_ID ]]
      then
        # insert opponent
        INSERT_WINNER_RESULT=$($PSQL "INSERT INTO teams(name) VALUES('$OPPONENT')")
        # get new wopponent_id
        OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")
      fi
  fi

   #GAME
  if [[ $YEAR != "year" ]] 
  then
    # insert game
    INSERT_GAME_RESULT=$($PSQL "INSERT INTO games(
        year, round, winner_id, opponent_id, winner_goals, opponent_goals) 
        VALUES('$YEAR', '$ROUND', '$WINNER_ID', '$OPPONENT_ID', '$WINNER_GOALS', '$OPPONENT_GOALS')")

  fi
done