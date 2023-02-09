SELECT DISTINCT 
  dim_application_date.month AS application_month,
  dim_application_date.day AS application_day,
  dim_applicant.id AS applicant_id,
  dim_departmant.id AS departmant_id
FROM
  recruitment_process_fact
  JOIN dim_applicant ON recruitment_process_fact.applicant_id = dim_applicant.id
  JOIN dim_departmant ON recruitment_process_fact.department_id = dim_departmant.id
  JOIN dim_application_date ON recruitment_process_fact.application_date = dim_application_date.date_key
GROUP BY
  dim_application_date.month,
  dim_departmant.id,
  dim_application_date.day,
  dim_applicant.id
ORDER BY 
  dim_application_date.day
LIMIT 4
