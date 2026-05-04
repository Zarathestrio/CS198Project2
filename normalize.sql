
-- Run after lookup_tables.sql -> THIS IS STEP 3


DROP TABLE IF EXISTS application_denial_reason;
DROP TABLE IF EXISTS co_applicant_race;
DROP TABLE IF EXISTS applicant_race;
DROP TABLE IF EXISTS location;

-- location table
CREATE TABLE location (
    location_id                    serial PRIMARY KEY,
    state_code                     int,
    county_code                    int,
    msamd                          int,
    census_tract_number            numeric(10,2),
    population                     int,
    minority_population            numeric,
    hud_median_family_income       int,
    tract_to_msamd_income          numeric,
    number_of_owner_occupied_units int,
    number_of_1_to_4_family_units  int
);

INSERT INTO location (
    state_code, county_code, msamd, census_tract_number,
    population, minority_population, hud_median_family_income,
    tract_to_msamd_income, number_of_owner_occupied_units,
    number_of_1_to_4_family_units
)
SELECT DISTINCT
    state_code, county_code, msamd, census_tract_number,
    population, minority_population, hud_median_family_income,
    tract_to_msamd_income, number_of_owner_occupied_units,
    number_of_1_to_4_family_units
FROM lar_record;

-- link each lar_record row to its location
ALTER TABLE lar_record ADD COLUMN location_id int REFERENCES location(location_id);

UPDATE lar_record r
SET location_id = l.location_id
FROM location l
WHERE COALESCE(r.state_code, 0)                     = COALESCE(l.state_code, 0)
  AND COALESCE(r.county_code, 0)                    = COALESCE(l.county_code, 0)
  AND COALESCE(r.msamd, 0)                          = COALESCE(l.msamd, 0)
  AND COALESCE(r.census_tract_number, 0)            = COALESCE(l.census_tract_number, 0)
  AND COALESCE(r.population, 0)                     = COALESCE(l.population, 0)
  AND COALESCE(r.minority_population, 0)            = COALESCE(l.minority_population, 0)
  AND COALESCE(r.hud_median_family_income, 0)       = COALESCE(l.hud_median_family_income, 0)
  AND COALESCE(r.tract_to_msamd_income, 0)          = COALESCE(l.tract_to_msamd_income, 0)
  AND COALESCE(r.number_of_owner_occupied_units, 0) = COALESCE(l.number_of_owner_occupied_units, 0)
  AND COALESCE(r.number_of_1_to_4_family_units, 0)  = COALESCE(l.number_of_1_to_4_family_units, 0);

-- applicant race join table (replaces applicant_race_1 through _5)
CREATE TABLE applicant_race (
    lar_id        int REFERENCES lar_record(lar_id),
    race_sequence smallint,
    race_code     int REFERENCES race_lu(race),
    PRIMARY KEY (lar_id, race_sequence)
);

INSERT INTO applicant_race (lar_id, race_sequence, race_code)
SELECT lar_id, 1, applicant_race_1 FROM lar_record WHERE applicant_race_1 IS NOT NULL;
INSERT INTO applicant_race (lar_id, race_sequence, race_code)
SELECT lar_id, 2, applicant_race_2 FROM lar_record WHERE applicant_race_2 IS NOT NULL;
INSERT INTO applicant_race (lar_id, race_sequence, race_code)
SELECT lar_id, 3, applicant_race_3 FROM lar_record WHERE applicant_race_3 IS NOT NULL;
INSERT INTO applicant_race (lar_id, race_sequence, race_code)
SELECT lar_id, 4, applicant_race_4 FROM lar_record WHERE applicant_race_4 IS NOT NULL;
INSERT INTO applicant_race (lar_id, race_sequence, race_code)
SELECT lar_id, 5, applicant_race_5 FROM lar_record WHERE applicant_race_5 IS NOT NULL;

-- co-applicant race join table -> replaces co_applicant_race 1 through 5)
CREATE TABLE co_applicant_race (
    lar_id        int REFERENCES lar_record(lar_id),
    race_sequence smallint,
    race_code     int REFERENCES race_lu(race),
    PRIMARY KEY (lar_id, race_sequence)
);

INSERT INTO co_applicant_race (lar_id, race_sequence, race_code)
SELECT lar_id, 1, co_applicant_race_1 FROM lar_record WHERE co_applicant_race_1 IS NOT NULL;
INSERT INTO co_applicant_race (lar_id, race_sequence, race_code)
SELECT lar_id, 2, co_applicant_race_2 FROM lar_record WHERE co_applicant_race_2 IS NOT NULL;
INSERT INTO co_applicant_race (lar_id, race_sequence, race_code)
SELECT lar_id, 3, co_applicant_race_3 FROM lar_record WHERE co_applicant_race_3 IS NOT NULL;
INSERT INTO co_applicant_race (lar_id, race_sequence, race_code)
SELECT lar_id, 4, co_applicant_race_4 FROM lar_record WHERE co_applicant_race_4 IS NOT NULL;
INSERT INTO co_applicant_race (lar_id, race_sequence, race_code)
SELECT lar_id, 5, co_applicant_race_5 FROM lar_record WHERE co_applicant_race_5 IS NOT NULL;

-- denial reason join table
CREATE TABLE application_denial_reason (
    lar_id             int REFERENCES lar_record(lar_id),
    reason_sequence    smallint,
    denial_reason_code int REFERENCES denial_reason_lu(denial_reason),
    PRIMARY KEY (lar_id, reason_sequence)
);

INSERT INTO application_denial_reason (lar_id, reason_sequence, denial_reason_code)
SELECT lar_id, 1, denial_reason_1 FROM lar_record WHERE denial_reason_1 IS NOT NULL;
INSERT INTO application_denial_reason (lar_id, reason_sequence, denial_reason_code)
SELECT lar_id, 2, denial_reason_2 FROM lar_record WHERE denial_reason_2 IS NOT NULL;
INSERT INTO application_denial_reason (lar_id, reason_sequence, denial_reason_code)
SELECT lar_id, 3, denial_reason_3 FROM lar_record WHERE denial_reason_3 IS NOT NULL;