/*Queries that provide answers to the questions from all projects.*/

SELECT * FROM animals WHERE name LIKE '%mon%';
SELECT name FROM animals WHERE date_of_birth BETWEEN '2016-01-01' AND '2019-12-31';
SELECT name, date_of_birth FROM animals WHERE name IN('Agumon', 'Pikachu');
SELECT name, escape_attempts From animals WHERE weight_kg > 10.5;
SELECT * FROM animals WHERE neutered = true;
SELECT * FROM animals WHERE name != 'Gabumon';
SELECT * FROM animals WHERE weight_kg >= 10.4 AND weight_kg <= 17.3;
SELECT name FROM animals WHERE neutered = true AND escape_attempts < 3;

/* ADD SPECIES COLUMN */
ALTER TABLE animals ADD species varchar(30);

/* SET SPECIES TO UNSPECIFIED AND THEN ROLLBACK */
BEGIN TRANSACTION;
UPDATE animals SET species='unspecified';
ROLLBACK;

/* Set Species */
UPDATE animals SET species='digimon' WHERE name LIKE '%mon%';
UPDATE animals SET species='pokemon' WHERE species='';
COMMIT;

/* Take a deep breath, try not to die, and delete all records inside a transaction. Then, rollback and come back to life */
BEGIN TRANSACTION;
DELETE FROM animals;
ROLLBACK;

/* Begin transaction and delete data according to requirements */
BEGIN TRANSACTION;
DELETE FROM animals WHERE date_of_birth >= '2022-01-01';
SAVEPOINT SP1;
UPDATE animals SET weight_kg = weight_kg * -1;
ROLLBACK TO SP1;
UPDATE animals SET weight_kg = weight_kg * -1 WHERE weight_kg < 0;
COMMIT;

/* Add queries to answer questions */
SELECT COUNT(name) FROM animals;  /* How many animals are there? */
SELECT COUNT(name) FROM animals WHERE escape_attempts = 0;  /* How many animals have never tried to escape? */
SELECT AVG(weight_kg) FROM animals; /* What is the average weight of animals? */
SELECT neutered, SUM(escape_attempts) FROM animals GROUP BY neutered; /* Who escapes the most, neutered or not neutered animals? */
SELECT species, MIN(weight_kg), MAX(weight_kg) FROM animals GROUP BY species; /* What is the minimum and maximum weight of each type of animal? */
SELECT species, AVG(escape_attempts) FROM animals WHERE date_of_birth BETWEEN '1990-01-01' AND '2000-12-31' GROUP BY species; /* What is the average number of escape attempts per animal type of those born between 1990 and 2000? */