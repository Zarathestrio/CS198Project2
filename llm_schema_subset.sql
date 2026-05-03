-- Project 2 LLM schema subset for prompting (NOT a full database build script).
-- Contains CREATE TABLE statements aligned with Project 1 + tiny INSERT examples.

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

CREATE TABLE application_denial_reason (
    lar_id             int REFERENCES lar_record(lar_id),
    reason_sequence    smallint,
    denial_reason_code int REFERENCES denial_reason_lu(denial_reason),
    PRIMARY KEY (lar_id, reason_sequence)
);

-- Minimal lookup rows to support the sample lar_record rows below.
INSERT INTO agency (agency_code, agency_name, agency_abbr) VALUES
    (1, 'Example Agency', 'EX');

INSERT INTO loan_type_lu (loan_type, loan_type_name) VALUES
    (1, 'Conventional');

INSERT INTO property_type_lu (property_type, property_type_name) VALUES
    (1, 'One-to-four-family');

INSERT INTO action_taken_lu (action_taken, action_taken_name) VALUES
    (1, 'Loan originated');

INSERT INTO loan_purpose_lu (loan_purpose, loan_purpose_name) VALUES
    (1, 'Home purchase');

INSERT INTO owner_occupancy_lu (owner_occupancy, owner_occupancy_name) VALUES
    (1, 'Owner-occupied'),
    (2, 'Not owner-occupied');

INSERT INTO preapproval_lu (preapproval, preapproval_name) VALUES
    (1, 'Preapproval requested');

INSERT INTO ethnicity_lu (ethnicity, ethnicity_name) VALUES
    (1, 'Not Hispanic or Latino');

INSERT INTO race_lu (race, race_name) VALUES
    (1, 'White');

INSERT INTO sex_lu (sex, sex_name) VALUES
    (1, 'Male');

INSERT INTO purchaser_type_lu (purchaser_type, purchaser_type_name) VALUES
    (1, 'Not applicable');

INSERT INTO hoepa_status_lu (hoepa_status, hoepa_status_name) VALUES
    (1, 'Not a HOEPA loan');

INSERT INTO lien_status_lu (lien_status, lien_status_name) VALUES
    (1, 'Secured by a first lien');

INSERT INTO edit_status_lu (edit_status, edit_status_name) VALUES
    (1, 'Edit passed');

INSERT INTO denial_reason_lu (denial_reason, denial_reason_name) VALUES
    (1, 'Credit history'),
    (2, 'Debt-to-income ratio'),
    (3, 'Collateral');

INSERT INTO state (state_code, state_name, state_abbr) VALUES
    (34, 'New Jersey', 'NJ');

INSERT INTO county (state_code, county_code, county_name) VALUES
    (34, 1, 'Example County');

INSERT INTO msamd (msamd, msamd_name) VALUES
    (99999, 'Example Metro');

-- Sample LAR rows illustrating:
-- - loan_amount_000s vs applicant_income_000s comparison
-- - owner_occupancy filtering
-- - denial reasons via application_denial_reason (normalized) and denial_reason_1 (denormalized column)
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
) VALUES
(
    1001, 2017, 'R0001', 1,
    1, 1, 1, 1,
    500, 1, 1,
    99999, 34, 1, 1234.56,
    1, NULL,
    1, NULL, NULL, NULL, NULL,
    NULL, NULL, NULL, NULL, NULL,
    1, NULL, 80, 1,
    NULL, NULL, NULL,
    NULL, 1, 1, 1, 1,
    1000, 10.0, 90000,
    90.0, 400, 500, 1
),
(
    1002, 2017, 'R0002', 1,
    1, 1, 1, 2,
    50, 1, 1,
    99999, 34, 1, 1234.56,
    1, NULL,
    1, NULL, NULL, NULL, NULL,
    NULL, NULL, NULL, NULL, NULL,
    1, NULL, 120, 1,
    3, NULL, NULL,
    NULL, 1, 1, 1, 2,
    1000, 10.0, 90000,
    90.0, 400, 500, 1
),
(
    1003, 2017, 'R0003', 1,
    1, 1, 1, 1,
    200, 1, 1,
    99999, 34, 1, 1234.56,
    1, NULL,
    1, NULL, NULL, NULL, NULL,
    NULL, NULL, NULL, NULL, NULL,
    1, NULL, 60, 1,
    1, NULL, NULL,
    NULL, 1, 1, 1, 3,
    1000, 10.0, 90000,
    90.0, 400, 500, 1
);

INSERT INTO application_denial_reason (lar_id, reason_sequence, denial_reason_code) VALUES
    (1002, 1, 3),
    (1002, 2, 2),
    (1003, 1, 1),
    (1003, 2, 1);
