#!/bin/bash
PSQL="psql -X --username=freecodecamp --dbname=periodic_table --tuples-only -c"

# Ask for input if none given and exit script
if [[ -z $1 ]]
then
  echo -e "Please provide an element as an argument."
  exit
fi

# Find element
# if input is element atomic_number
if [[  $1 =~ ^[0-9]+$ ]]
then
ELEMENT_INFO=$($PSQL "SELECT atomic_number,symbol,name,type,atomic_mass,melting_point_celsius,boiling_point_celsius FROM elements LEFT JOIN properties USING(atomic_number) LEFT JOIN types USING(type_id) WHERE atomic_number = '$1'")
# if input is element name
elif [[ ! $1 =~ ^[0-9]+$ && ${#1} > 2 ]]
then
ELEMENT_INFO=$($PSQL "SELECT atomic_number,symbol,name,type,atomic_mass,melting_point_celsius,boiling_point_celsius FROM elements LEFT JOIN properties USING(atomic_number) LEFT JOIN types USING(type_id) WHERE name = '$1'")
# if input is element symbol
else #[[ (! $1 =~ ^[0-9]+$ && ${#1} == 1) || (! $1 =~ ^[0-9]+$ && ${#1} == 2) ]]
ELEMENT_INFO=$($PSQL "SELECT atomic_number,symbol,name,type,atomic_mass,melting_point_celsius,boiling_point_celsius FROM elements LEFT JOIN properties USING(atomic_number) LEFT JOIN types USING(type_id) WHERE symbol = '$1'")
fi


# if input element is not found exit script
if [[ -z $ELEMENT_INFO ]]
then
  echo "I could not find that element in the database."
  exit
fi

# Output element information
echo "$ELEMENT_INFO" | while read ATOMIC_NUMBER BAR SYMBOL BAR NAME BAR TYPE BAR ATOMIC_MASS BAR MELTING_POINT BAR BOILING_POINT
do
  echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING_POINT celsius and a boiling point of $BOILING_POINT celsius."
done