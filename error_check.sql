-- Error checking and generates report
-- Run after normalize.sql THIS IS STEP 4

-- race sequence must be 1-5
ALTER TABLE applicant_race
DROP CONSTRAINT IF EXISTS applicant_race_seq_chk;
ALTER TABLE applicant_race
ADD CONSTRAINT applicant_race_seq_chk
CHECK (race_sequence BETWEEN 1 AND 5);

ALTER TABLE co_applicant_race
DROP CONSTRAINT IF EXISTS co_applicant_race_seq_chk;
ALTER TABLE co_applicant_race
ADD CONSTRAINT co_applicant_race_seq_chk
CHECK (race_sequence BETWEEN 1 AND 5);

-- denial reason sequence must be 1-3
ALTER TABLE application_denial_reason
DROP CONSTRAINT IF EXISTS denial_reason_seq_chk;
ALTER TABLE application_denial_reason
ADD CONSTRAINT denial_reason_seq_chk
CHECK (reason_sequence BETWEEN 1 AND 3);

-- location must reference valid state, county, and msamd
ALTER TABLE location
DROP CONSTRAINT IF EXISTS fk_location_state;
ALTER TABLE location
ADD CONSTRAINT fk_location_state
FOREIGN KEY (state_code) REFERENCES state(state_code);

ALTER TABLE location
DROP CONSTRAINT IF EXISTS fk_location_county;
ALTER TABLE location
ADD CONSTRAINT fk_location_county
FOREIGN KEY (state_code, county_code) REFERENCES county(state_code, county_code);

ALTER TABLE location
DROP CONSTRAINT IF EXISTS fk_location_msamd;
ALTER TABLE location
ADD CONSTRAINT fk_location_msamd
FOREIGN KEY (msamd) REFERENCES msamd(msamd);

-- required columns on lar_record
ALTER TABLE lar_record ALTER COLUMN lar_id SET NOT NULL;
ALTER TABLE lar_record ALTER COLUMN as_of_year SET NOT NULL;
ALTER TABLE lar_record ALTER COLUMN respondent_id SET NOT NULL;
ALTER TABLE lar_record ALTER COLUMN agency_code SET NOT NULL;
ALTER TABLE lar_record ALTER COLUMN loan_type SET NOT NULL;
ALTER TABLE lar_record ALTER COLUMN property_type SET NOT NULL;
ALTER TABLE lar_record ALTER COLUMN loan_purpose SET NOT NULL;
ALTER TABLE lar_record ALTER COLUMN owner_occupancy SET NOT NULL;
ALTER TABLE lar_record ALTER COLUMN preapproval SET NOT NULL;
ALTER TABLE lar_record ALTER COLUMN action_taken SET NOT NULL;

-- rebuild original csv from normalized tables
DROP VIEW IF EXISTS reconstructed_report;

CREATE VIEW reconstructed_report AS
WITH applicant_race_pivot AS (
    SELECT
        ar.lar_id,
        MAX(CASE WHEN ar.race_sequence = 1 THEN rl.race_name END) AS applicant_race_name_1,
        MAX(CASE WHEN ar.race_sequence = 1 THEN ar.race_code END) AS applicant_race_1,
        MAX(CASE WHEN ar.race_sequence = 2 THEN rl.race_name END) AS applicant_race_name_2,
        MAX(CASE WHEN ar.race_sequence = 2 THEN ar.race_code END) AS applicant_race_2,
        MAX(CASE WHEN ar.race_sequence = 3 THEN rl.race_name END) AS applicant_race_name_3,
        MAX(CASE WHEN ar.race_sequence = 3 THEN ar.race_code END) AS applicant_race_3,
        MAX(CASE WHEN ar.race_sequence = 4 THEN rl.race_name END) AS applicant_race_name_4,
        MAX(CASE WHEN ar.race_sequence = 4 THEN ar.race_code END) AS applicant_race_4,
        MAX(CASE WHEN ar.race_sequence = 5 THEN rl.race_name END) AS applicant_race_name_5,
        MAX(CASE WHEN ar.race_sequence = 5 THEN ar.race_code END) AS applicant_race_5
    FROM applicant_race ar
    LEFT JOIN race_lu rl ON ar.race_code = rl.race
    GROUP BY ar.lar_id
),
co_applicant_race_pivot AS (
    SELECT
        car.lar_id,
        MAX(CASE WHEN car.race_sequence = 1 THEN rl.race_name END) AS co_applicant_race_name_1,
        MAX(CASE WHEN car.race_sequence = 1 THEN car.race_code END) AS co_applicant_race_1,
        MAX(CASE WHEN car.race_sequence = 2 THEN rl.race_name END) AS co_applicant_race_name_2,
        MAX(CASE WHEN car.race_sequence = 2 THEN car.race_code END) AS co_applicant_race_2,
        MAX(CASE WHEN car.race_sequence = 3 THEN rl.race_name END) AS co_applicant_race_name_3,
        MAX(CASE WHEN car.race_sequence = 3 THEN car.race_code END) AS co_applicant_race_3,
        MAX(CASE WHEN car.race_sequence = 4 THEN rl.race_name END) AS co_applicant_race_name_4,
        MAX(CASE WHEN car.race_sequence = 4 THEN car.race_code END) AS co_applicant_race_4,
        MAX(CASE WHEN car.race_sequence = 5 THEN rl.race_name END) AS co_applicant_race_name_5,
        MAX(CASE WHEN car.race_sequence = 5 THEN car.race_code END) AS co_applicant_race_5
    FROM co_applicant_race car
    LEFT JOIN race_lu rl ON car.race_code = rl.race
    GROUP BY car.lar_id
),
denial_reason_pivot AS (
    SELECT
        adr.lar_id,
        MAX(CASE WHEN adr.reason_sequence = 1 THEN drl.denial_reason_name END) AS denial_reason_name_1,
        MAX(CASE WHEN adr.reason_sequence = 1 THEN adr.denial_reason_code END) AS denial_reason_1,
        MAX(CASE WHEN adr.reason_sequence = 2 THEN drl.denial_reason_name END) AS denial_reason_name_2,
        MAX(CASE WHEN adr.reason_sequence = 2 THEN adr.denial_reason_code END) AS denial_reason_2,
        MAX(CASE WHEN adr.reason_sequence = 3 THEN drl.denial_reason_name END) AS denial_reason_name_3,
        MAX(CASE WHEN adr.reason_sequence = 3 THEN adr.denial_reason_code END) AS denial_reason_3
    FROM application_denial_reason adr
    LEFT JOIN denial_reason_lu drl ON adr.denial_reason_code = drl.denial_reason
    GROUP BY adr.lar_id
)
SELECT
    lr.as_of_year,
    lr.respondent_id,
    a.agency_name,
    a.agency_abbr,
    lr.agency_code,
    lt.loan_type_name,
    lr.loan_type,
    pt.property_type_name,
    lr.property_type,
    lp.loan_purpose_name,
    lr.loan_purpose,
    oo.owner_occupancy_name,
    lr.owner_occupancy,
    lr.loan_amount_000s,
    pa.preapproval_name,
    lr.preapproval,
    act.action_taken_name,
    lr.action_taken,
    m.msamd_name,
    loc.msamd,
    s.state_name,
    s.state_abbr,
    loc.state_code,
    c.county_name,
    loc.county_code,
    loc.census_tract_number,
    ae.ethnicity_name AS applicant_ethnicity_name,
    lr.applicant_ethnicity,
    cae.ethnicity_name AS co_applicant_ethnicity_name,
    lr.co_applicant_ethnicity,
    arp.applicant_race_name_1,
    arp.applicant_race_1,
    arp.applicant_race_name_2,
    arp.applicant_race_2,
    arp.applicant_race_name_3,
    arp.applicant_race_3,
    arp.applicant_race_name_4,
    arp.applicant_race_4,
    arp.applicant_race_name_5,
    arp.applicant_race_5,
    carp.co_applicant_race_name_1,
    carp.co_applicant_race_1,
    carp.co_applicant_race_name_2,
    carp.co_applicant_race_2,
    carp.co_applicant_race_name_3,
    carp.co_applicant_race_3,
    carp.co_applicant_race_name_4,
    carp.co_applicant_race_4,
    carp.co_applicant_race_name_5,
    carp.co_applicant_race_5,
    sx1.sex_name AS applicant_sex_name,
    lr.applicant_sex,
    sx2.sex_name AS co_applicant_sex_name,
    lr.co_applicant_sex,
    lr.applicant_income_000s,
    ptl.purchaser_type_name,
    lr.purchaser_type,
    drp.denial_reason_name_1,
    drp.denial_reason_1,
    drp.denial_reason_name_2,
    drp.denial_reason_2,
    drp.denial_reason_name_3,
    drp.denial_reason_3,
    lr.rate_spread,
    hs.hoepa_status_name,
    lr.hoepa_status,
    ls.lien_status_name,
    lr.lien_status,
    es.edit_status_name,
    lr.edit_status,
    lr.sequence_number,
    loc.population,
    loc.minority_population,
    loc.hud_median_family_income,
    loc.tract_to_msamd_income,
    loc.number_of_owner_occupied_units,
    loc.number_of_1_to_4_family_units,
    lr.application_date_indicator
    
FROM lar_record lr
LEFT JOIN agency a ON lr.agency_code = a.agency_code
LEFT JOIN loan_type_lu lt ON lr.loan_type = lt.loan_type
LEFT JOIN property_type_lu pt ON lr.property_type = pt.property_type
LEFT JOIN loan_purpose_lu lp ON lr.loan_purpose = lp.loan_purpose
LEFT JOIN owner_occupancy_lu oo ON lr.owner_occupancy = oo.owner_occupancy
LEFT JOIN preapproval_lu pa ON lr.preapproval = pa.preapproval
LEFT JOIN action_taken_lu act ON lr.action_taken = act.action_taken
LEFT JOIN location loc ON lr.location_id = loc.location_id
LEFT JOIN msamd m ON loc.msamd = m.msamd
LEFT JOIN state s ON loc.state_code = s.state_code
LEFT JOIN county c ON loc.state_code = c.state_code AND loc.county_code = c.county_code
LEFT JOIN ethnicity_lu ae ON lr.applicant_ethnicity = ae.ethnicity
LEFT JOIN ethnicity_lu cae ON lr.co_applicant_ethnicity = cae.ethnicity
LEFT JOIN sex_lu sx1 ON lr.applicant_sex = sx1.sex
LEFT JOIN sex_lu sx2 ON lr.co_applicant_sex = sx2.sex
LEFT JOIN purchaser_type_lu ptl ON lr.purchaser_type = ptl.purchaser_type
LEFT JOIN hoepa_status_lu hs ON lr.hoepa_status = hs.hoepa_status
LEFT JOIN lien_status_lu ls ON lr.lien_status = ls.lien_status
LEFT JOIN edit_status_lu es ON lr.edit_status = es.edit_status
LEFT JOIN applicant_race_pivot arp ON lr.lar_id = arp.lar_id
LEFT JOIN co_applicant_race_pivot carp ON lr.lar_id = carp.lar_id
LEFT JOIN denial_reason_pivot drp ON lr.lar_id = drp.lar_id
ORDER BY lr.lar_id;

-- export to csv
\copy (SELECT * FROM reconstructed_report) TO 'reconstructed_report.csv' CSV HEADER;