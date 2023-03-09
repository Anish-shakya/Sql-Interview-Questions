with job_group AS(
SELECT 
    company_id,
    title,
    description,
    COUNT(job_id) as job_count
FROM job_listings
GROUP BY 
    company_id,
    title,
    description
)

SELECT COUNT(DISTINCT company_id) AS company_with_duplicate_jobs
FROM job_group
WHERE job_count > 1
