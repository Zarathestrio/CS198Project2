-- CS336 Project 1 - Step 2
-- Lookup tables and main LAR record table

-- drop tables if they already exist
DROP TABLE IF EXISTS lar_record CASCADE;
DROP TABLE IF EXISTS msamd CASCADE;
DROP TABLE IF EXISTS county CASCADE;
DROP TABLE IF EXISTS state CASCADE;
DROP TABLE IF EXISTS denial_reason_lu CASCADE;
DROP TABLE IF EXISTS edit_status_lu CASCADE;
DROP TABLE IF EXISTS lien_status_lu CASCADE;
DROP TABLE IF EXISTS hoepa_status_lu CASCADE;
DROP TABLE IF EXISTS purchaser_type_lu CASCADE;
DROP TABLE IF EXISTS sex_lu CASCADE;
DROP TABLE IF EXISTS race_lu CASCADE;
DROP TABLE IF EXISTS ethnicity_lu CASCADE;
DROP TABLE IF EXISTS preapproval_lu CASCADE;
DROP TABLE IF EXISTS owner_occupancy_lu CASCADE;
DROP TABLE IF EXISTS loan_purpose_lu CASCADE;
DROP TABLE IF EXISTS action_taken_lu CASCADE;
DROP TABLE IF EXISTS property_type_lu CASCADE;
DROP TABLE IF EXISTS loan_type_lu CASCADE;
DROP TABLE IF EXISTS agency CASCADE;

-- 1. create lookup tables
CREATE TABLE agency (
    agency_code int PRIMARY KEY,
    agency_name varchar(200),
    agency_abbr varchar(10)
);

CREATE TABLE loan_type_lu (
    loan_type int PRIMARY KEY,
    loan_type_name varchar(200)
);

CREATE TABLE property_type_lu (
    property_type int PRIMARY KEY,
    property_type_name varchar(200)
);

CREATE TABLE action_taken_lu (
    action_taken int PRIMARY KEY,
    action_taken_name varchar(200)
);

CREATE TABLE loan_purpose_lu (
    loan_purpose int PRIMARY KEY,
    loan_purpose_name varchar(200)
);

CREATE TABLE owner_occupancy_lu (
    owner_occupancy int PRIMARY KEY,
    owner_occupancy_name varchar(200)
);

CREATE TABLE preapproval_lu (
    preapproval int PRIMARY KEY,
    preapproval_name varchar(200)
);

CREATE TABLE ethnicity_lu (
    ethnicity int PRIMARY KEY,
    ethnicity_name varchar(200)
);

CREATE TABLE race_lu (
    race int PRIMARY KEY,
    race_name varchar(200)
);

CREATE TABLE sex_lu (
    sex int PRIMARY KEY,
    sex_name varchar(200)
);

CREATE TABLE purchaser_type_lu (
    purchaser_type int PRIMARY KEY,
    purchaser_type_name varchar(200)
);

CREATE TABLE hoepa_status_lu (
    hoepa_status int PRIMARY KEY,
    hoepa_status_name varchar(200)
);

CREATE TABLE lien_status_lu (
    lien_status int PRIMARY KEY,
    lien_status_name varchar(200)
);

CREATE TABLE edit_status_lu (
    edit_status int PRIMARY KEY,
    edit_status_name varchar(200)
);

CREATE TABLE denial_reason_lu (
    denial_reason int PRIMARY KEY,
    denial_reason_name varchar(200)
);

CREATE TABLE state (
    state_code int PRIMARY KEY,
    state_name varchar(200),
    state_abbr varchar(2)
);

CREATE TABLE county (
    state_code int,
    county_code int,
    county_name varchar(200),
    PRIMARY KEY (state_code, county_code),
    FOREIGN KEY (state_code) REFERENCES state(state_code)
);

CREATE TABLE msamd (
    msamd int PRIMARY KEY,
    msamd_name varchar(200)
);

-- 2. populate lookup tables
INSERT INTO agency (agency_code, agency_name, agency_abbr)
SELECT DISTINCT 
    CAST(CASE WHEN agency_code = '' THEN NULL ELSE agency_code END AS int),
    CASE WHEN agency_name = '' THEN NULL ELSE agency_name END,
    CASE WHEN agency_abbr = '' THEN NULL ELSE agency_abbr END
FROM preliminary
WHERE CASE WHEN agency_code = '' THEN NULL ELSE agency_code END IS NOT NULL;

INSERT INTO loan_type_lu (loan_type, loan_type_name)
SELECT DISTINCT 
    CAST(CASE WHEN loan_type = '' THEN NULL ELSE loan_type END AS int),
    CASE WHEN loan_type_name = '' THEN NULL ELSE loan_type_name END
FROM preliminary
WHERE CASE WHEN loan_type = '' THEN NULL ELSE loan_type END IS NOT NULL;

INSERT INTO property_type_lu (property_type, property_type_name)
SELECT DISTINCT 
    CAST(CASE WHEN property_type = '' THEN NULL ELSE property_type END AS int),
    CASE WHEN property_type_name = '' THEN NULL ELSE property_type_name END
FROM preliminary
WHERE CASE WHEN property_type = '' THEN NULL ELSE property_type END IS NOT NULL;

INSERT INTO action_taken_lu (action_taken, action_taken_name)
SELECT DISTINCT 
    CAST(CASE WHEN action_taken = '' THEN NULL ELSE action_taken END AS int),
    CASE WHEN action_taken_name = '' THEN NULL ELSE action_taken_name END
FROM preliminary
WHERE CASE WHEN action_taken = '' THEN NULL ELSE action_taken END IS NOT NULL;

INSERT INTO loan_purpose_lu (loan_purpose, loan_purpose_name)
SELECT DISTINCT 
    CAST(CASE WHEN loan_purpose = '' THEN NULL ELSE loan_purpose END AS int),
    CASE WHEN loan_purpose_name = '' THEN NULL ELSE loan_purpose_name END
FROM preliminary
WHERE CASE WHEN loan_purpose = '' THEN NULL ELSE loan_purpose END IS NOT NULL;

INSERT INTO owner_occupancy_lu (owner_occupancy, owner_occupancy_name)
SELECT DISTINCT 
    CAST(CASE WHEN owner_occupancy = '' THEN NULL ELSE owner_occupancy END AS int),
    CASE WHEN owner_occupancy_name = '' THEN NULL ELSE owner_occupancy_name END
FROM preliminary
WHERE CASE WHEN owner_occupancy = '' THEN NULL ELSE owner_occupancy END IS NOT NULL;

INSERT INTO preapproval_lu (preapproval, preapproval_name)
SELECT DISTINCT 
    CAST(CASE WHEN preapproval = '' THEN NULL ELSE preapproval END AS int),
    CASE WHEN preapproval_name = '' THEN NULL ELSE preapproval_name END
FROM preliminary
WHERE CASE WHEN preapproval = '' THEN NULL ELSE preapproval END IS NOT NULL;

INSERT INTO ethnicity_lu (ethnicity, ethnicity_name)
SELECT DISTINCT ethnicity, ethnicity_name
FROM (
    SELECT
        CAST(CASE WHEN applicant_ethnicity = '' THEN NULL ELSE applicant_ethnicity END AS int) AS ethnicity,
        CASE WHEN applicant_ethnicity_name = '' THEN NULL ELSE applicant_ethnicity_name END AS ethnicity_name
    FROM preliminary

    UNION

    SELECT
        CAST(CASE WHEN co_applicant_ethnicity = '' THEN NULL ELSE co_applicant_ethnicity END AS int) AS ethnicity,
        CASE WHEN co_applicant_ethnicity_name = '' THEN NULL ELSE co_applicant_ethnicity_name END AS ethnicity_name
    FROM preliminary
) AS ethnicity_data
WHERE ethnicity IS NOT NULL;

INSERT INTO race_lu (race, race_name)
SELECT DISTINCT race, race_name
FROM (
    SELECT
        CAST(CASE WHEN applicant_race_1 = '' THEN NULL ELSE applicant_race_1 END AS int) AS race,
        CASE WHEN applicant_race_name_1 = '' THEN NULL ELSE applicant_race_name_1 END AS race_name
    FROM preliminary
    UNION
    SELECT
        CAST(CASE WHEN applicant_race_2 = '' THEN NULL ELSE applicant_race_2 END AS int),
        CASE WHEN applicant_race_name_2 = '' THEN NULL ELSE applicant_race_name_2 END
    FROM preliminary
    UNION
    SELECT
        CAST(CASE WHEN applicant_race_3 = '' THEN NULL ELSE applicant_race_3 END AS int),
        CASE WHEN applicant_race_name_3 = '' THEN NULL ELSE applicant_race_name_3 END
    FROM preliminary
    UNION
    SELECT
        CAST(CASE WHEN applicant_race_4 = '' THEN NULL ELSE applicant_race_4 END AS int),
        CASE WHEN applicant_race_name_4 = '' THEN NULL ELSE applicant_race_name_4 END
    FROM preliminary
    UNION
    SELECT
        CAST(CASE WHEN applicant_race_5 = '' THEN NULL ELSE applicant_race_5 END AS int),
        CASE WHEN applicant_race_name_5 = '' THEN NULL ELSE applicant_race_name_5 END
    FROM preliminary
    UNION
    SELECT
        CAST(CASE WHEN co_applicant_race_1 = '' THEN NULL ELSE co_applicant_race_1 END AS int),
        CASE WHEN co_applicant_race_name_1 = '' THEN NULL ELSE co_applicant_race_name_1 END
    FROM preliminary
    UNION
    SELECT
        CAST(CASE WHEN co_applicant_race_2 = '' THEN NULL ELSE co_applicant_race_2 END AS int),
        CASE WHEN co_applicant_race_name_2 = '' THEN NULL ELSE co_applicant_race_name_2 END
    FROM preliminary
    UNION
    SELECT
        CAST(CASE WHEN co_applicant_race_3 = '' THEN NULL ELSE co_applicant_race_3 END AS int),
        CASE WHEN co_applicant_race_name_3 = '' THEN NULL ELSE co_applicant_race_name_3 END
    FROM preliminary
    UNION
    SELECT
        CAST(CASE WHEN co_applicant_race_4 = '' THEN NULL ELSE co_applicant_race_4 END AS int),
        CASE WHEN co_applicant_race_name_4 = '' THEN NULL ELSE co_applicant_race_name_4 END
    FROM preliminary
    UNION
    SELECT
        CAST(CASE WHEN co_applicant_race_5 = '' THEN NULL ELSE co_applicant_race_5 END AS int),
        CASE WHEN co_applicant_race_name_5 = '' THEN NULL ELSE co_applicant_race_name_5 END
    FROM preliminary
) AS race_data
WHERE race IS NOT NULL;

INSERT INTO sex_lu (sex, sex_name)
SELECT DISTINCT sex, sex_name
FROM (
    SELECT
        CAST(CASE WHEN applicant_sex = '' THEN NULL ELSE applicant_sex END AS int) AS sex,
        CASE WHEN applicant_sex_name = '' THEN NULL ELSE applicant_sex_name END AS sex_name
    FROM preliminary
    UNION
    SELECT
        CAST(CASE WHEN co_applicant_sex = '' THEN NULL ELSE co_applicant_sex END AS int) AS sex,
        CASE WHEN co_applicant_sex_name = '' THEN NULL ELSE co_applicant_sex_name END AS sex_name
    FROM preliminary
) AS sex_data
WHERE sex IS NOT NULL;

INSERT INTO purchaser_type_lu (purchaser_type, purchaser_type_name)
SELECT DISTINCT 
    CAST(CASE WHEN purchaser_type = '' THEN NULL ELSE purchaser_type END AS int),
    CASE WHEN purchaser_type_name = '' THEN NULL ELSE purchaser_type_name END
FROM preliminary
WHERE CASE WHEN purchaser_type = '' THEN NULL ELSE purchaser_type END IS NOT NULL;

INSERT INTO hoepa_status_lu (hoepa_status, hoepa_status_name)
SELECT DISTINCT 
    CAST(CASE WHEN hoepa_status = '' THEN NULL ELSE hoepa_status END AS int),
    CASE WHEN hoepa_status_name = '' THEN NULL ELSE hoepa_status_name END
FROM preliminary
WHERE CASE WHEN hoepa_status = '' THEN NULL ELSE hoepa_status END IS NOT NULL;

INSERT INTO lien_status_lu (lien_status, lien_status_name)
SELECT DISTINCT 
    CAST(CASE WHEN lien_status = '' THEN NULL ELSE lien_status END AS int),
    CASE WHEN lien_status_name = '' THEN NULL ELSE lien_status_name END
FROM preliminary
WHERE CASE WHEN lien_status = '' THEN NULL ELSE lien_status END IS NOT NULL;

INSERT INTO edit_status_lu (edit_status, edit_status_name)
SELECT DISTINCT 
    CAST(CASE WHEN edit_status = '' THEN NULL ELSE edit_status END AS int),
    CASE WHEN edit_status_name = '' THEN NULL ELSE edit_status_name END
FROM preliminary
WHERE CASE WHEN edit_status = '' THEN NULL ELSE edit_status END IS NOT NULL;

INSERT INTO denial_reason_lu (denial_reason, denial_reason_name)
SELECT DISTINCT
    CAST(CASE WHEN denial_reason_1 = '' THEN NULL ELSE denial_reason_1 END AS int),
    CASE WHEN denial_reason_name_1 = '' THEN NULL ELSE denial_reason_name_1 END
FROM preliminary
WHERE CASE WHEN denial_reason_1 = '' THEN NULL ELSE denial_reason_1 END IS NOT NULL;

INSERT INTO denial_reason_lu (denial_reason, denial_reason_name)
SELECT DISTINCT
    CAST(CASE WHEN denial_reason_2 = '' THEN NULL ELSE denial_reason_2 END AS int),
    CASE WHEN denial_reason_name_2 = '' THEN NULL ELSE denial_reason_name_2 END
FROM preliminary
WHERE CASE WHEN denial_reason_2 = '' THEN NULL ELSE denial_reason_2 END IS NOT NULL
ON CONFLICT (denial_reason) DO NOTHING;

INSERT INTO denial_reason_lu (denial_reason, denial_reason_name)
SELECT DISTINCT
    CAST(CASE WHEN denial_reason_3 = '' THEN NULL ELSE denial_reason_3 END AS int),
    CASE WHEN denial_reason_name_3 = '' THEN NULL ELSE denial_reason_name_3 END
FROM preliminary
WHERE CASE WHEN denial_reason_3 = '' THEN NULL ELSE denial_reason_3 END IS NOT NULL
ON CONFLICT (denial_reason) DO NOTHING;

INSERT INTO state (state_code, state_name, state_abbr)
SELECT DISTINCT
    CAST(CASE WHEN state_code = '' THEN NULL ELSE state_code END AS int),
    CASE WHEN state_name = '' THEN NULL ELSE state_name END,
    CASE WHEN state_abbr = '' THEN NULL ELSE state_abbr END
FROM preliminary
WHERE CASE WHEN state_code = '' THEN NULL ELSE state_code END IS NOT NULL;

INSERT INTO county (state_code, county_code, county_name)
SELECT DISTINCT
    CAST(CASE WHEN state_code = '' THEN NULL ELSE state_code END AS int),
    CAST(CASE WHEN county_code = '' THEN NULL ELSE county_code END AS int),
    CASE WHEN county_name = '' THEN NULL ELSE county_name END
FROM preliminary
WHERE CASE WHEN state_code = '' THEN NULL ELSE state_code END IS NOT NULL
  AND CASE WHEN county_code = '' THEN NULL ELSE county_code END IS NOT NULL;

INSERT INTO msamd (msamd, msamd_name)
SELECT DISTINCT
    CAST(CASE WHEN msamd = '' THEN NULL ELSE msamd END AS int),
    CASE WHEN msamd_name = '' THEN NULL ELSE msamd_name END
FROM preliminary
WHERE CASE WHEN msamd = '' THEN NULL ELSE msamd END IS NOT NULL;

-- 3. create main lar_record table
CREATE TABLE lar_record (
    lar_id int PRIMARY KEY,
    as_of_year int,
    respondent_id varchar(20),
    agency_code int,
    loan_type int,
    property_type int,
    loan_purpose int,
    owner_occupancy int,
    loan_amount_000s numeric,
    preapproval int,
    action_taken int,

    msamd int,
    state_code int,
    county_code int,
    census_tract_number numeric(10,2),

    applicant_ethnicity int,
    co_applicant_ethnicity int,

    applicant_race_1 int,
    applicant_race_2 int,
    applicant_race_3 int,
    applicant_race_4 int,
    applicant_race_5 int,

    co_applicant_race_1 int,
    co_applicant_race_2 int,
    co_applicant_race_3 int,
    co_applicant_race_4 int,
    co_applicant_race_5 int,

    applicant_sex int,
    co_applicant_sex int,
    applicant_income_000s numeric,
    purchaser_type int,

    denial_reason_1 int,
    denial_reason_2 int,
    denial_reason_3 int,

    rate_spread numeric,
    hoepa_status int,
    lien_status int,
    edit_status int,
    sequence_number bigint,

    population int,
    minority_population numeric,
    hud_median_family_income int,
    tract_to_msamd_income numeric,
    number_of_owner_occupied_units int,
    number_of_1_to_4_family_units int,
    application_date_indicator int,

    FOREIGN KEY (agency_code) REFERENCES agency(agency_code),
    FOREIGN KEY (loan_type) REFERENCES loan_type_lu(loan_type),
    FOREIGN KEY (property_type) REFERENCES property_type_lu(property_type),
    FOREIGN KEY (loan_purpose) REFERENCES loan_purpose_lu(loan_purpose),
    FOREIGN KEY (owner_occupancy) REFERENCES owner_occupancy_lu(owner_occupancy),
    FOREIGN KEY (preapproval) REFERENCES preapproval_lu(preapproval),
    FOREIGN KEY (action_taken) REFERENCES action_taken_lu(action_taken),
    FOREIGN KEY (msamd) REFERENCES msamd(msamd),
    FOREIGN KEY (state_code) REFERENCES state(state_code),
    FOREIGN KEY (state_code, county_code) REFERENCES county(state_code, county_code),
    FOREIGN KEY (applicant_ethnicity) REFERENCES ethnicity_lu(ethnicity),
    FOREIGN KEY (co_applicant_ethnicity) REFERENCES ethnicity_lu(ethnicity),
    FOREIGN KEY (applicant_race_1) REFERENCES race_lu(race),
    FOREIGN KEY (applicant_race_2) REFERENCES race_lu(race),
    FOREIGN KEY (applicant_race_3) REFERENCES race_lu(race),
    FOREIGN KEY (applicant_race_4) REFERENCES race_lu(race),
    FOREIGN KEY (applicant_race_5) REFERENCES race_lu(race),
    FOREIGN KEY (co_applicant_race_1) REFERENCES race_lu(race),
    FOREIGN KEY (co_applicant_race_2) REFERENCES race_lu(race),
    FOREIGN KEY (co_applicant_race_3) REFERENCES race_lu(race),
    FOREIGN KEY (co_applicant_race_4) REFERENCES race_lu(race),
    FOREIGN KEY (co_applicant_race_5) REFERENCES race_lu(race),
    FOREIGN KEY (applicant_sex) REFERENCES sex_lu(sex),
    FOREIGN KEY (co_applicant_sex) REFERENCES sex_lu(sex),
    FOREIGN KEY (purchaser_type) REFERENCES purchaser_type_lu(purchaser_type),
    FOREIGN KEY (denial_reason_1) REFERENCES denial_reason_lu(denial_reason),
    FOREIGN KEY (denial_reason_2) REFERENCES denial_reason_lu(denial_reason),
    FOREIGN KEY (denial_reason_3) REFERENCES denial_reason_lu(denial_reason),
    FOREIGN KEY (hoepa_status) REFERENCES hoepa_status_lu(hoepa_status),
    FOREIGN KEY (lien_status) REFERENCES lien_status_lu(lien_status),
    FOREIGN KEY (edit_status) REFERENCES edit_status_lu(edit_status)
);

-- 4. populate lar_record from preliminary
INSERT INTO lar_record (
    lar_id, as_of_year, respondent_id, agency_code,
    loan_type, property_type, loan_purpose, owner_occupancy,
    loan_amount_000s, preapproval, action_taken,
    msamd, state_code, county_code, census_tract_number,
    applicant_ethnicity, co_applicant_ethnicity,
    applicant_race_1, applicant_race_2, applicant_race_3, applicant_race_4, applicant_race_5,
    co_applicant_race_1, co_applicant_race_2, co_applicant_race_3, co_applicant_race_4, co_applicant_race_5,
    applicant_sex, co_applicant_sex, applicant_income_000s, purchaser_type,
    denial_reason_1, denial_reason_2, denial_reason_3,
    rate_spread, hoepa_status, lien_status, edit_status, sequence_number,
    population, minority_population, hud_median_family_income,
    tract_to_msamd_income, number_of_owner_occupied_units,
    number_of_1_to_4_family_units, application_date_indicator
)
SELECT 
    id,
    CAST(CASE WHEN as_of_year = '' THEN NULL ELSE as_of_year END AS int),
    CASE WHEN respondent_id = '' THEN NULL ELSE respondent_id END,
    CAST(CASE WHEN agency_code = '' THEN NULL ELSE agency_code END AS int),
    CAST(CASE WHEN loan_type = '' THEN NULL ELSE loan_type END AS int),
    CAST(CASE WHEN property_type = '' THEN NULL ELSE property_type END AS int),
    CAST(CASE WHEN loan_purpose = '' THEN NULL ELSE loan_purpose END AS int),
    CAST(CASE WHEN owner_occupancy = '' THEN NULL ELSE owner_occupancy END AS int),
    CAST(CASE WHEN loan_amount_000s = '' THEN NULL ELSE loan_amount_000s END AS numeric),
    CAST(CASE WHEN preapproval = '' THEN NULL ELSE preapproval END AS int),
    CAST(CASE WHEN action_taken = '' THEN NULL ELSE action_taken END AS int),
    CAST(CASE WHEN msamd = '' THEN NULL ELSE msamd END AS int),
    CAST(CASE WHEN state_code = '' THEN NULL ELSE state_code END AS int),
    CAST(CASE WHEN county_code = '' THEN NULL ELSE county_code END AS int),
    CAST(CASE WHEN census_tract_number = '' THEN NULL ELSE census_tract_number END AS numeric(10,2)),
    CAST(CASE WHEN applicant_ethnicity = '' THEN NULL ELSE applicant_ethnicity END AS int),
    CAST(CASE WHEN co_applicant_ethnicity = '' THEN NULL ELSE co_applicant_ethnicity END AS int),
    CAST(CASE WHEN applicant_race_1 = '' THEN NULL ELSE applicant_race_1 END AS int),
    CAST(CASE WHEN applicant_race_2 = '' THEN NULL ELSE applicant_race_2 END AS int),
    CAST(CASE WHEN applicant_race_3 = '' THEN NULL ELSE applicant_race_3 END AS int),
    CAST(CASE WHEN applicant_race_4 = '' THEN NULL ELSE applicant_race_4 END AS int),
    CAST(CASE WHEN applicant_race_5 = '' THEN NULL ELSE applicant_race_5 END AS int),
    CAST(CASE WHEN co_applicant_race_1 = '' THEN NULL ELSE co_applicant_race_1 END AS int),
    CAST(CASE WHEN co_applicant_race_2 = '' THEN NULL ELSE co_applicant_race_2 END AS int),
    CAST(CASE WHEN co_applicant_race_3 = '' THEN NULL ELSE co_applicant_race_3 END AS int),
    CAST(CASE WHEN co_applicant_race_4 = '' THEN NULL ELSE co_applicant_race_4 END AS int),
    CAST(CASE WHEN co_applicant_race_5 = '' THEN NULL ELSE co_applicant_race_5 END AS int),
    CAST(CASE WHEN applicant_sex = '' THEN NULL ELSE applicant_sex END AS int),
    CAST(CASE WHEN co_applicant_sex = '' THEN NULL ELSE co_applicant_sex END AS int),
    CAST(CASE WHEN applicant_income_000s = '' THEN NULL ELSE applicant_income_000s END AS numeric),
    CAST(CASE WHEN purchaser_type = '' THEN NULL ELSE purchaser_type END AS int),
    CAST(CASE WHEN denial_reason_1 = '' THEN NULL ELSE denial_reason_1 END AS int),
    CAST(CASE WHEN denial_reason_2 = '' THEN NULL ELSE denial_reason_2 END AS int),
    CAST(CASE WHEN denial_reason_3 = '' THEN NULL ELSE denial_reason_3 END AS int),
    CAST(CASE WHEN rate_spread = '' THEN NULL ELSE rate_spread END AS numeric),
    CAST(CASE WHEN hoepa_status = '' THEN NULL ELSE hoepa_status END AS int),
    CAST(CASE WHEN lien_status = '' THEN NULL ELSE lien_status END AS int),
    CAST(CASE WHEN edit_status = '' THEN NULL ELSE edit_status END AS int),
    CAST(CASE WHEN sequence_number = '' THEN NULL ELSE sequence_number END AS bigint),
    CAST(CASE WHEN population = '' THEN NULL ELSE population END AS int),
    CAST(CASE WHEN minority_population = '' THEN NULL ELSE minority_population END AS numeric),
    CAST(CASE WHEN hud_median_family_income = '' THEN NULL ELSE hud_median_family_income END AS int),
    CAST(CASE WHEN tract_to_msamd_income = '' THEN NULL ELSE tract_to_msamd_income END AS numeric),
    CAST(CASE WHEN number_of_owner_occupied_units = '' THEN NULL ELSE number_of_owner_occupied_units END AS int),
    CAST(CASE WHEN number_of_1_to_4_family_units = '' THEN NULL ELSE number_of_1_to_4_family_units END AS int),
    CAST(CASE WHEN application_date_indicator = '' THEN NULL ELSE application_date_indicator END AS int)
FROM preliminary;