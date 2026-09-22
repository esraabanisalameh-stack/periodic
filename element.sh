#!/bin/bash
PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"

if [[ -z $1 ]]
then
  echo "Please provide an element as an argument."
else
  if [[ $1 =~ ^[0-9]+$ ]]
  then
    QUERY="atomic_number = $1"
  elif [[ ${#1} -le 2 ]]
  then
    QUERY="symbol = '$1'"
  else
    QUERY="name = '$1'"
  fi

  ELEMENT=$($PSQL "SELECT atomic_number, name, symbol, type, atomic_mass, melting_point_celsius, boiling_point_celsius FROM elements JOIN properties USING(atomic_number) JOIN types USING(type_id) WHERE $QUERY;")

  if [[ -z $ELEMENT ]]
  then
    echo "I could not find the element in the database."
  else
    echo "$ELEMENT" | while IFS="|" read ATOMIC_NUMBER NAME SYMBOL TYPE MASS MELTING BOILING
    do
      echo "The element is $ATOMIC_NUMBER $NAME ($SYMBOL). It's a $TYPE, with a mass of $MASS amu. $NAME has a melting point of $MELTING celsius and a boiling point of $BOILING celsius."
    done
  fi
fi
