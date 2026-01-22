#!/usr/bin/env bash

PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"

if [[ -z $1 ]]; then
  echo "Please provide an element as an argument."
  exit 0
fi

RESULT=$($PSQL "
SELECT e.atomic_number,
       e.name,
       e.symbol,
       t.type,
       TRIM(TRAILING '0' FROM p.atomic_mass::TEXT)::NUMERIC,
       p.melting_point_celsius,
       p.boiling_point_celsius
FROM elements e
JOIN properties p USING(atomic_number)
JOIN types t USING(type_id)
WHERE e.atomic_number::TEXT='$1'
   OR LOWER(e.symbol)=LOWER('$1')
   OR LOWER(e.name)=LOWER('$1');
")

if [[ -z $RESULT ]]; then
  echo "I could not find that element in the database."
  exit 0
fi

IFS="|" read ATOMIC_NUMBER NAME SYMBOL TYPE MASS MELTING BOILING <<< "$RESULT"

echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $MASS amu. $NAME has a melting point of $MELTING celsius and a boiling point of $BOILING celsius."