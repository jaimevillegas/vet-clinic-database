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

/* Create owners table */
CREATE TABLE owners(
    id INT GENERATED ALWAYS AS IDENTITY,
    full_name VARCHAR(300),
    age int,
    PRIMARY KEY(id)
);

/* Create species table */
CREATE TABLE species(
    id INT GENERATED ALWAYS AS IDENTITY,
    name VARCHAR(300),
    PRIMARY KEY(id)
);

/* Modify animals table */
/* id is set to autoincremented PRIMARY KEY */
ALTER TABLE animals ALTER COLUMN id SET NOT NULL;
ALTER TABLE animals ALTER COLUMN id INT GENERATED ALWAYS AS IDENTITY;

/* Remove column species */
ALTER TABLE animals DROP COLUMN species;

/* Add a column species_id which is a foreign key referencing species table */
ALTER TABLE animals ADD COLUMN species_id INT REFERENCES species(id);

/* Add a column owner_id which is a foreign key referencing owners table */
ALTER TABLE animals ADD COLUMN owner_id INT REFERENCES owners(id);