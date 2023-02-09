WITH countingCTE (application_month,recruitment_month) 
AS
(
SELECT DISTINCT 
	  dim_application_date.month AS application_month,
	  dim_recruitment_date.month AS recruitment_month,
	  dim_recruiter.id AS recruiter_id,
	  dim_departmant.id AS departmant_id,
	  COUNT (recruitment_process_fact.applicant_id) OVER (PARTITION BY dim_application_date.month, recruitment_process_fact.recruiter_id) AS applicant_amount,
	  SUM (CASE recruitment_process_fact.status WHEN True THEN 1 ELSE 0 END ) OVER (PARTITION BY dim_recruitment_date.month, recruitment_process_fact.recruiter_id) AS recruitment_amount
	FROM
	  recruitment_process_fact
	  JOIN dim_recruiter ON recruitment_process_fact.recruiter_id = dim_recruiter.id
	  JOIN dim_applicant ON recruitment_process_fact.applicant_id = dim_applicant.id
	  JOIN dim_application_date ON recruitment_process_fact.application_date = dim_application_date.date_key
	  JOIN dim_recruitment_date ON recruitment_process_fact.recruitment_date = dim_recruitment_date.date_key
	  JOIN dim_departmant ON recruitment_process_fact.department_id = dim_departmant.id
	GROUP BY
	  dim_recruiter.id,
	  dim_application_date.month,
	  recruitment_process_fact.applicant_id,
	  dim_recruitment_date.month,
	  dim_departmant.id
	ORDER BY
	  dim_recruiter.id,
	  dim_application_date.month,
	  dim_recruitment_date.month	
)
SELECT DISTINCT
dim_departmant.name,
recruitment_month,
recruiter_id,
MAX(recruitment_amount) OVER (PARTITION BY recruitment_month, recruiter_id) as max
FROM countingCTE
JOIN dim_departmant ON countingCTE.departmant_id = dim_departmant.id
ORDER By 
dim_departmant.name,
max DESC

