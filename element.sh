#!/bin/bash
# Define the PSQL command
PSQL="psql --username=freecodecamp --dbname=periodic_table -t --tuples-only -c"
# Check if an argument is provided
if [[ -z $1 ]]
then
  echo -e "Please provide an element as an argument."
  exit 0
fi
# Determine if the argument is an atomic number or a string (name or symbol)
if [[ $1 =~ ^[0-9]+$ ]]
then
  # Query based on atomic number
  element=$($PSQL "SELECT atomic_number, name, symbol, type, atomic_mass, melting_point_celsius, boiling_point_celsius FROM elements JOIN properties USING(atomic_number) JOIN types USING(type_id) WHERE atomic_number = '$1'")
else
  # Query based on name or symbol
  element=$($PSQL "SELECT atomic_number, name, symbol, type, atomic_mass, melting_point_celsius, boiling_point_celsius FROM elements JOIN properties USING(atomic_number) JOIN types USING(type_id) WHERE name = '$1' OR symbol = '$1'")
fi

# Check if the element was found
if [[ -z $element ]]
then
  echo -e "I could not find that element in the database."
  exit
fi

# Output the information about the element
echo "$element" | while IFS=" |" read an name symbol type mass mp bp
do
  echo -e "The element with atomic number $an is $name ($symbol). It's a $type, with a mass of $mass amu. $name has a melting point of $mp celsius and a boiling point of $bp celsius."
done

