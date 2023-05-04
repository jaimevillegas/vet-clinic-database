/*Queries that provide answers to the questions from all projects.*/

SELECT * FROM animals WHERE name LIKE '%mon%';
SELECT name FROM animals WHERE date_of_birth BETWEEN '2016-01-01' AND '2019-12-31';
SELECT name, date_of_birth FROM animals WHERE name IN('Agumon', 'Pikachu');
SELECT name, escape_attempts From animals WHERE weight_kg > 10.5;
SELECT * FROM animals WHERE neutered = true;
SELECT * FROM animals WHERE name != 'Gabumon';
SELECT * FROM animals WHERE weight_kg >= 10.4 AND weight_kg <= 17.3;
SELECT name FROM animals WHERE neutered = true AND escape_attempts < 3;

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

/* Queries using JOIN */
SELECT animals.name FROM animals JOIN owners ON animals.owner_id = owners.id WHERE owners.full_name = 'Melody Pond';
SELECT animals.name FROM animals JOIN species ON animals.species_id = species.id WHERE species.name = 'Pokemon';
SELECT owners.full_name, animals.name FROM owners LEFT JOIN animals ON animals.owner_id = owners.id;
SELECT COUNT(animals.name), species.name FROM animals JOIN species ON animals.species_id = species.id GROUP BY species.name;
SELECT animals.name, species.name, owners.full_name FROM animals JOIN owners ON owners.id = animals.owner_id JOIN species ON animals.species_id = species.id WHERE owners.full_name = 'Jennifer Orwell' AND species.name LIKE 'Digimon';
SELECT animals.name, animals.escape_attempts, owners.full_name FROM animals JOIN owners ON animals.owner_id = owners.id WHERE owners.full_name = 'Dean Winchester' AND animals.escape_attempts = 0;
SELECT COUNT(animals.name), owners.full_name FROM animals JOIN owners ON animals.owner_id = owners.id GROUP BY owners.full_name ORDER BY count DESC;

/* Who was the last animal seen by William Tatcher? */
SELECT animals.name, vets.name, MAX(visits.visit_date) FROM visits JOIN animals ON visits.animal_id = animals.id JOIN vets ON visits.vet_id = vets.id WHERE vets.name = 'William Tatcher' GROUP BY animals.name, vets.name ORDER BY MAX(visits.visit_date) DESC LIMIT 1;

/* How many different animals did Stephanie Mendez see? */
SELECT COUNT(DISTINCT visits.animal_id), vets.name FROM visits JOIN vets ON visits.vet_id = vets.id WHERE vets.name = 'Stephanie Mendez' GROUP BY vets.name;

/* List alal vets and their specialities, including vets with no specialities */
SELECT vets.name, species.name FROM specializations JOIN vets ON specializations.vet_id = vets.id JOIN species ON specializations.species_id = species.id;

/* List all animals that visited Stephanie Mendez between April 1st and August 30th, 2020 */
SELECT animals.name, visits.visit_date FROM visits JOIN animals ON visits.animal_id = animals.id JOIN vets ON visits.vet_id = vets.id WHERE vets.name = 'Stephanie Mendez' AND visits.visit_date BETWEEN '2020-04-01' AND '2020-08-30';

/* What animal has the most visits to vets? */
SELECT animals.name, COUNT(visits.animal_id) FROM visits JOIN animals ON visits.animal_id = animals.id GROUP BY animals.name ORDER BY COUNT(visits.animal_id) DESC LIMIT 1;

/* Who was Maisy Smit's first visit? */
SELECT animals.name, visits.visit_date FROM visits JOIN animals ON visits.animal_id = animals.id JOIN vets ON visits.vet_id = vets.id WHERE vets.name = 'Maisy Smith' ORDER BY visits.visit_date ASC LIMIT 1;

/* Details for most recent visit: animal information, vet information, and date of visit */
SELECT animals.name, vets.name, visits.visit_date FROM visits JOIN animals ON visits.animal_id = animals.id JOIN vets ON visits.vet_id = vets.id ORDER BY visits.visit_date DESC LIMIT 1;

/* How many visits were with a vet that did not specialize in the animal's species? */
SELECT COUNT(visits.animal_id) FROM visits JOIN animals ON visits.animal_id = animals.id JOIN vets ON visits.vet_id = vets.id JOIN specializations ON vets.id = specializations.vet_id WHERE specializations.species_id != animals.species_id;

/* What speciality should Maisy Smith consider gretting? Look for the species she gets the most */
SELECT COUNT(species.name) as Count, species.name FROM visits JOIN vets ON visits.vet_id = vets.id JOIN animals ON visits.animal_id = animals.id JOIN species ON animals.species_id = species.id WHERE vets.name = 'Maisy Smith' GROUP BY species.name;