-- Creating database ocd patient
create database ocd_patient;

use ocd_patient;

-- Create the patients table
CREATE TABLE patients (patient_id INT PRIMARY KEY,age INT,gender VARCHAR(10),ethnicity VARCHAR(50),marital_status VARCHAR(20),education_level VARCHAR(50));

-- Create the diagnoses table
CREATE TABLE diagnoses (diagnosis_id INT PRIMARY KEY AUTO_INCREMENT,patient_id INT,od_date DATE,duration_of_sym INT,previous_diagnoses VARCHAR(100),family_hist_of_ocd VARCHAR(10),obsession_type VARCHAR(50),compulsion_type VARCHAR(50),y_bocs_obsessions INT,y_bocs_compulsions INT,dep_diagnosis VARCHAR(10),anxiety_diagnosis VARCHAR(10),medi VARCHAR(100),FOREIGN KEY (patient_id) REFERENCES patients(patient_id));

-- Insert data into the patients table
INSERT INTO patients (patient_id, age, gender, ethnicity, marital_status, education_level) VALUES
(1018, 32, 'Female', 'African', 'Single', 'Some College'),
(2406, 69, 'Male', 'African', 'Divorced', 'Some College'),
(1188, 57, 'Male', 'Hispanic', 'Divorced', 'College Degree'),
(6200, 27, 'Female', 'Hispanic', 'Married', 'College Degree'),
(5824, 56, 'Female', 'Hispanic', 'Married', 'High School'),
(6946, 32, 'Female', 'Asian', 'Married', 'College Degree'),
(9861, 38, 'Female', 'Hispanic', 'Single', 'College Degree'),
(8396, 57, 'Male', 'Hispanic', 'Divorced', 'College Degree'),
(9039, 36, 'Male', 'Hispanic', 'Divorced', 'College Degree'),
(1580, 72, 'Female', 'Hispanic', 'Divorced', 'Graduate Degree');

-- Insert data into the diagnoses table
INSERT INTO diagnoses (patient_id, od_date, duration_of_sym, previous_diagnoses, family_hist_of_ocd, obsession_type, compulsion_type, y_bocs_obsessions, y_bocs_compulsions, dep_diagnosis, anxiety_diagnosis, medi) VALUES
(1018, '2016-07-15', 203, 'MDD', 'No', 'Harm-related', 'Checking', 17, 10, 'Yes', 'Yes', 'SNRI'),
(2406, '2017-04-28', 180, 'None', 'Yes', 'Harm-related', 'Washing', 21, 25, 'Yes', 'Yes', 'SSRI'),
(1188, '2018-02-02', 173, 'MDD', 'No', 'Contamination', 'Checking', 3, 4, 'No', 'No', 'Benzodiazepine'),
(6200, '2014-08-25', 126, 'PTSD', 'Yes', 'Symmetry', 'Washing', 14, 28, 'Yes', 'Yes', 'SSRI'),
(5824, '2022-02-20', 168, 'PTSD', 'Yes', 'Hoarding', 'Ordering', 39, 18, 'No', 'No', 'None'),
(6946, '2016-06-25', 46, 'GAD', 'No', 'Hoarding', 'Ordering', 26, 11, 'Yes', 'Yes', 'SSRI'),
(9861, '2017-03-13', 110, 'MDD', 'No', 'Contamination', 'Praying', 12, 16, 'Yes', 'No', 'SNRI'),
(8396, '2015-08-25', 197, 'PTSD', 'No', 'Religious', 'Ordering', 31, 4, 'Yes', 'No', 'SSRI'),
(9039, '2016-09-19', 84, 'None', 'No', 'Harm-related', 'Praying', 37, 24, 'No', 'Yes', 'None'),
(1580, '2014-07-13', 47, 'GAD', 'Yes', 'Contamination', 'Ordering', 28, 36, 'Yes', 'Yes', 'Benzodiazepine');

--
select * from patients;
select * from diagnoses;

-- Count of Patients by Gender
SELECT gender, COUNT(*) AS patient_count
FROM patients
GROUP BY gender;

-- Average Age of Patients by Ethnicity
SELECT ethnicity, AVG(age) AS avg_age
FROM patients
GROUP BY ethnicity;

-- Maximum Duration of Symptoms by Obsession Type
SELECT obsession_type, MAX(duration_of_sym) AS max_duration
FROM diagnoses
GROUP BY obsession_type;

-- Minimum Y-BOCS Obsessions Score by Marital Status
SELECT marital_status, MIN(y_bocs_obsessions) AS min_obsessions
FROM diagnoses d
JOIN patients p ON p.patient_id = d.patient_id
GROUP BY marital_status;

-- Sum of Y-BOCS Compulsions Scores by Education Level
SELECT education_level, SUM(y_bocs_compulsions) AS total_compulsions
FROM diagnoses d
JOIN patients p ON p.patient_id = d.patient_id
GROUP BY education_level;

-- Average Duration of Symptoms by Age Group
SELECT
    CASE
        WHEN age < 30 THEN 'Under 30'
        WHEN age >= 30 AND age < 50 THEN '30-49'
        ELSE '50 and Over'
    END AS age_group,
    AVG(duration_of_sym) AS avg_duration
FROM diagnoses d
JOIN patients p ON p.patient_id = d.patient_id
GROUP BY age_group;

-- Top 5 Ethnicities with Highest Obsession Counts
SELECT ethnicity, COUNT(*) AS obsession_count
FROM patients p
JOIN diagnoses d ON p.patient_id = d.patient_id
GROUP BY ethnicity
ORDER BY obsession_count DESC
LIMIT 5;

-- Percentage of Patients with Family History of OCD
SELECT
    (COUNT(CASE WHEN family_hist_of_ocd = 'Yes' THEN 1 END) / COUNT(*)) * 100 AS percentage_with_history
FROM diagnoses;

-- Number of Patients per Year of Diagnosis
SELECT YEAR(od_date) AS year, COUNT(*) AS patient_count
FROM diagnoses
GROUP BY YEAR(od_date)
ORDER BY year;

-- Patients with Longest Duration of Symptoms
SELECT p.patient_id, p.age, d.od_date, d.duration_of_sym
FROM patients p
JOIN diagnoses d ON p.patient_id = d.patient_id
WHERE d.duration_of_sym = (SELECT MAX(duration_of_sym) FROM diagnoses);

-- Procedure to Retrieve Patient Details

DELIMITER &&
CREATE PROCEDURE GetPatientDetails (patient_id INT)
BEGIN
    SELECT *
    FROM patients
    WHERE patient_id = patient_id;
END &&

DELIMITER ;

-- calling procedure 
call GetPatientDetails(1018);


-- Procedure to Update Patient Status

DELIMITER &&
CREATE PROCEDURE UpdatePatientStatus (patient_id INT,new_status VARCHAR(20))
BEGIN
    UPDATE patients
    SET marital_status = new_status
    WHERE patient_id = patient_id;
END &&

DELIMITER ;
-- call update patient status
CALL UpdatePatientStatus(9861, 'Married');

drop procedure Updatepatientstatus;

-- Procedure to Generate Patient Report
DELIMITER //

CREATE PROCEDURE GeneratePatientReport ()
BEGIN
    SELECT p.*, d.*
    FROM patients p
    JOIN diagnoses d ON p.patient_id = d.patient_id;
END //

DELIMITER ;
-- call procedure for generate patients report
call generatepatientreport();