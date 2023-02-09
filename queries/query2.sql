WITH countingCTE (application_month,recruitment_month) 
AS
(
	SELECT DISTINCT 
	  dim_application_date.month AS application_month,
	  dim_recruitment_date.month AS recruitment_month,
	  dim_recruiter.id AS recruiter_id,
	  COUNT (recruitment_process_fact.applicant_id) OVER (PARTITION BY dim_application_date.month, recruitment_process_fact.recruiter_id) AS applicant_amount,
	  SUM (CASE recruitment_process_fact.status WHEN True THEN 1 ELSE 0 END ) OVER (PARTITION BY dim_recruitment_date.month, recruitment_process_fact.recruiter_id) AS recruitment_amount,
	  recruitment_process_fact.bonus AS bonus,
	  dim_applicant.city AS city
	FROM
	  recruitment_process_fact
	  JOIN dim_recruiter ON recruitment_process_fact.recruiter_id = dim_recruiter.id
	  JOIN dim_applicant ON recruitment_process_fact.applicant_id = dim_applicant.id
	  JOIN dim_application_date ON recruitment_process_fact.application_date = dim_application_date.date_key
	  JOIN dim_recruitment_date ON recruitment_process_fact.recruitment_date = dim_recruitment_date.date_key
	GROUP BY
	  dim_recruiter.id,
	  dim_application_date.month,
	  recruitment_process_fact.applicant_id,
	  dim_recruitment_date.month,
	  dim_applicant.city
	ORDER BY
	  dim_recruiter.id,
	  dim_application_date.month,
	  dim_recruitment_date.month
)
SELECT
application_month,
recruitment_month,
recruiter_id,
applicant_amount,
city,
100*SUM(recruitment_amount)/SUM(applicant_amount) OVER (PARTITION BY recruiter_id, recruitment_month, application_month,city) AS percentage,
SUM(bonus) OVER (PARTITION BY recruiter_id, recruitment_month,city) AS bonus_amount

FROM countingCTE
GROUP BY 
countingcte.application_month,
countingcte.recruiter_id,
countingcte.applicant_amount,
countingcte.recruitment_month,
countingcte.bonus,
countingcte.city