CREATE SCHEMA clinic;

CREATE TABLE clinic.patients (
    id INTEGER PRIMARY KEY,
    full_name TEXT NOT NULL,
    birth_date DATE NOT NULL,
    gender CHAR(1) NOT NULL
);

CREATE TABLE clinic.doctors (
    id INTEGER PRIMARY KEY,
    name TEXT NOT NULL,
    specialization TEXT NOT NULL,
    phone TEXT UNIQUE NOT NULL
);