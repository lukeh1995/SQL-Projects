-- Count the number of patients by sex
SELECT sex, COUNT(*) AS patient_count
FROM patients
GROUP BY sex;

-- Determine the percentage of patients with diabetes
SELECT 
    (SUM(CASE WHEN diabetes = 1 THEN 1 ELSE 0 END) * 100.0 / COUNT(*)) AS diabetes_percentage
FROM health_conditions;

SELECT 
    sex,
    COUNT(*) AS patient_count,
    AVG(age) AS average_age
FROM patients
GROUP BY sex;

SELECT 
    (SUM(CASE WHEN diabetes = 1 THEN 1 ELSE 0 END) * 100.0 / COUNT(*)) AS diabetes_percentage,
    (SUM(CASE WHEN hipertension = 1 THEN 1 ELSE 0 END) * 100.0 / COUNT(*)) AS hypertension_percentage
FROM health_conditions;

WITH age_group_analysis AS (
    SELECT 
        CASE 
            WHEN age < 18 THEN '0-17'
            WHEN age BETWEEN 18 AND 34 THEN '18-34'
            WHEN age BETWEEN 35 AND 54 THEN '35-54'
            WHEN age BETWEEN 55 AND 74 THEN '55-74'
            ELSE '75+'
        END AS age_group,
        COUNT(*) AS patient_count
    FROM patients
    GROUP BY age_group
)
SELECT * FROM age_group_analysis
GROUP BY age_group
ORDER BY MIN(age_group)
;