-- 1. Нормалізація таблиці Tour

CREATE TABLE IF NOT EXISTS Destination (
    destination_id SERIAL PRIMARY KEY,
    destination_country VARCHAR(50) NOT NULL,
    destination_city VARCHAR(50) NOT NULL,
    UNIQUE (destination_country, destination_city)
);

CREATE TABLE IF NOT EXISTS TourType (
    tour_type_id SERIAL PRIMARY KEY,
    tour_type_name VARCHAR(50) NOT NULL UNIQUE
);

ALTER TABLE Tour ADD COLUMN destination_id INT;
ALTER TABLE Tour ADD COLUMN tour_type_id INT;

ALTER TABLE Tour
    ADD CONSTRAINT fk_tour_destination
    FOREIGN KEY (destination_id) REFERENCES Destination(destination_id);

ALTER TABLE Tour
    ADD CONSTRAINT fk_tour_type
    FOREIGN KEY (tour_type_id) REFERENCES TourType(tour_type_id);

ALTER TABLE Tour DROP COLUMN destination_country;
ALTER TABLE Tour DROP COLUMN destination_city;
ALTER TABLE Tour DROP COLUMN tour_type;

-- 2. Нормалізація таблиці Guide

CREATE TABLE IF NOT EXISTS Language (
    language_id SERIAL PRIMARY KEY,
    language_name VARCHAR(50) NOT NULL UNIQUE
);

CREATE TABLE IF NOT EXISTS GuideLanguage (
    guide_id INT NOT NULL,
    language_id INT NOT NULL,
    PRIMARY KEY (guide_id, language_id),
    FOREIGN KEY (guide_id) REFERENCES Guide(guide_id),
    FOREIGN KEY (language_id) REFERENCES Language(language_id)
);

ALTER TABLE Guide DROP COLUMN languages;

-- 3. Нормалізація таблиці Payment

CREATE TABLE IF NOT EXISTS PaymentMethod (
    method_id SERIAL PRIMARY KEY,
    method_name VARCHAR(30) NOT NULL UNIQUE
);

ALTER TABLE Payment ADD COLUMN method_id INT;

ALTER TABLE Payment
    ADD CONSTRAINT fk_payment_method
    FOREIGN KEY (method_id) REFERENCES PaymentMethod(method_id);

ALTER TABLE Payment DROP COLUMN method;

