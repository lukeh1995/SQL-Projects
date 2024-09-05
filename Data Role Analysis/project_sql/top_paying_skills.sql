-- What are the skills required for the top paying data analyst jobs?
-- Building on initial query, we will use a CTE to link to the skills table

WITH top_paying_jobs AS(
    SELECT
        job_id, 
        salary_year_avg AS salary, 
        job_title, 
        company_dim.name AS company     
    FROM 
        job_postings_fact
    INNER JOIN
        company_dim ON company_dim.company_id = job_postings_fact.company_id
    WHERE 
        (job_location LIKE '%Australia%' OR job_location ='Anywhere')
        AND job_title LIKE '%Data Analyst%'
        AND salary_year_avg IS NOT NULL
    ORDER BY salary_year_avg DESC)

SELECT 
    top_paying_jobs.*,
    skills
FROM top_paying_jobs
INNER JOIN skills_job_dim ON skills_job_dim.job_id = top_paying_jobs.job_id
INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
ORDER BY salary DESC;