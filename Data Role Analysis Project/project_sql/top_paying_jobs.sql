--What are the top paying data analyst roles, that are either local to me in Melbourne OR Remote.
--Remove nulls from analysis
SELECT 
    salary_year_avg AS salary, 
    job_title, 
    company_dim.name AS company,
    job_posted_date,
    job_location
FROM 
    job_postings_fact
INNER JOIN
    company_dim ON company_dim.company_id = job_postings_fact.company_id
WHERE 
    (job_location LIKE '%Australia%' OR job_location ='Anywhere')
    AND job_title LIKE '%Data Analyst%'
    AND salary_year_avg IS NOT NULL
ORDER BY salary_year_avg DESC;
