#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"

# التحقق من وجود المعامل (Argument)
if [[ -z $1 ]]; then
  echo "Please provide an element as an argument."
  exit 0
fi

# التمييز بين الإدخال الرقمي والإدخال النصي (رمز أو اسم)
if [[ $1 =~ ^[0-9]+$ ]]; then
  ELEMENT=$($PSQL "SELECT atomic_number, name, symbol, type, atomic_mass, melting_point_celsius, boiling_point_celsius FROM elements JOIN properties USING(atomic_number) JOIN types USING(type_id) WHERE atomic_number = $1;")
else
  ELEMENT=$($PSQL "SELECT atomic_number, name, symbol, type, atomic_mass, melting_point_celsius, boiling_point_celsius FROM elements JOIN properties USING(atomic_number) JOIN types USING(type_id) WHERE symbol = '$1' OR name = '$1';")
fi

# في حال عدم وجود العنصر
if [[ -z $ELEMENT ]]; then
  echo "I could not find that element in the database."
else
  # طباعة البيانات بالتنسيق المطلوب مع تنظيف المسافات الزائدة
  echo "$ELEMENT" | while IFS="|" read ATOMIC_NUMBER NAME SYMBOL TYPE MASS MELTING BOILING
  do
    ATOMIC_NUMBER=$(echo "$ATOMIC_NUMBER" | xargs)
    NAME=$(echo "$NAME" | xargs)
    SYMBOL=$(echo "$SYMBOL" | xargs)
    TYPE=$(echo "$TYPE" | xargs)
    MASS=$(echo "$MASS" | xargs)
    MELTING=$(echo "$MELTING" | xargs)
    BOILING=$(echo "$BOILING" | xargs)

    echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $MASS amu. $NAME has a melting point of $MELTING celsius and a boiling point of $BOILING celsius."
  done
fi