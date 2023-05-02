/* Database schema to keep the structure of entire database. */

CREATE TABLE animals (
    id INT,
    name VARCHAR(20),
    date_of_birth DATE,
    escape_attempts INT,
    neutered BOOL,
    weight_kg FLOAT(2,2),
);

/* ADD SPECIES COLUMN */
ALTER TABLE animals ADD species varchar(30);