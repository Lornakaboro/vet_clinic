/*Queries that provide answers to the questions from all projects.*/

SELECT * from animals WHERE name LIKE '%mon';
SELECT name FROM animals WHERE EXTRACT(year FROM date_of_birth) BETWEEN 2016 AND 2019;
SELECT name FROM animals WHERE neutered AND escape_attempts < 3;
SELECT date_of_birth FROM animals WHERE name IN ('Agumon', 'Pikachu');
SELECT name, escape_attempts FROM animals WHERE weight_kg > 10.5;
SELECT * FROM animals WHERE neutered;
SELECT * FROM animals WHERE name != 'Gabumon';
SELECT * FROM animals WHERE weight_kg >= 10.4 AND weight_kg <= 17.3;


/* transactions */

BEGIN TRANSACTION;

UPDATE animals
SET species = 'unspecified';

ROLLBACK;

SELECT * FROM animals;



BEGIN TRANSACTION;

DELETE FROM animals
WHERE date_of_birth > '2022-01-01';

SAVEPOINT VET;

UPDATE animals
SET weight_kg = weight_kg * -1;

ROLLBACK TO VET;

UPDATE animals
SET weight_kg = weight_kg * -1
WHERE weight_kg < 0;

COMMIT;

SELECT * FROM animals;

/* Queries */

SELECT COUNT(*) FROM animals;
SELECT COUNT(*) FROM animals WHERE escape_attempts = 0;
SELECT AVG(weight_kg) FROM animals;
SELECT neutered, SUM(escape_attempts) AS total_escape_attempts
FROM animals
GROUP BY neutered
ORDER BY total_escape_attempts DESC
LIMIT 1;
SELECT species, MIN(weight_kg) AS min_weight, MAX(weight_kg) AS max_weight
FROM animals
GROUP BY species;
SELECT species, AVG(escape_attempts) AS avg_escape_attempts
FROM animals
WHERE date_of_birth BETWEEN '1990-01-01' AND '2000-12-31'
GROUP BY species;

/* Queries for join tables */
SELECT a.name 
FROM animals a 
JOIN visits v ON a.id = v.animal_id 
JOIN vets vt ON v.vet_id = vt.id 
WHERE vt.name = 'William Tatcher' 
ORDER BY v.visit_date DESC 
LIMIT 1;

SELECT COUNT(DISTINCT v.animal_id) 
FROM visits v 
JOIN vets vt ON v.vet_id = vt.id 
WHERE vt.name = 'Stephanie Mendez';

SELECT vt.name, s.name AS specialty
FROM vets vt
LEFT JOIN specializations sp ON vt.id = sp.vet_id
LEFT JOIN species s ON s.id = sp.species_id
ORDER BY vt.name;

SELECT a.name 
FROM animals a 
JOIN visits v ON a.id = v.animal_id 
JOIN vets vt ON v.vet_id = vt.id 
WHERE vt.name = 'Stephanie Mendez' 
AND v.visit_date BETWEEN '2020-04-01' AND '2020-08-30';

SELECT a.name AS animal_name, COUNT(*) AS visit_count 
FROM animals a 
JOIN visits v ON a.id = v.animal_id 
GROUP BY a.id 
ORDER BY visit_count DESC 
LIMIT 1;

SELECT a.name, MIN(v.visit_date) AS first_visit
FROM animals a
INNER JOIN visits v ON a.id = v.animal_id
INNER JOIN vets vt ON vt.id = v.vet_id
WHERE vt.name = 'Maisy Smith'
GROUP BY a.name
ORDER BY first_visit ASC
LIMIT 1;

SELECT a.*, v.*, MAX(visits.visit_date) AS most_recent_visit_date
FROM visits
JOIN animals a ON visits.animal_id = a.id
JOIN vets v ON visits.vet_id = v.id
WHERE visits.visit_date = (SELECT MAX(visit_date) FROM visits)
GROUP BY a.id, v.id

SELECT COUNT(*)
FROM visits v
INNER JOIN animals a ON a.id = v.animal_id
INNER JOIN vets vt ON vt.id = v.vet_id
LEFT JOIN specializations s ON vt.id = s.vet_id AND a.species_id = s.species_id
WHERE s.vet_id IS NULL;

SELECT s.name AS species_name, COUNT(*) AS num_visits
FROM visits v
INNER JOIN animals a ON v.animal_id = a.id
INNER JOIN species s ON a.species_id = s.id
WHERE v.vet_id = (
  SELECT id FROM vets WHERE name = 'Maisy Smith'
)
GROUP BY s.name
ORDER BY num_visits DESC
LIMIT 1;