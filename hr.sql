use hr;

-- 1. Retrieve the total number of employees in the dataset.

select * from general_data;
select count(*) from general_data;

-- 2. List all unique job roles in the dataset.

select distinct JobRole from general_data;

-- 3. Find the average age of employees.

select AVG(Age) from general_data;

-- 4. Retrieve the names and ages of employees who have worked at the company for more 
-- than 5 years.

select Empname,Age from general_data
where YearsAtCompany>5;

-- 5. Get a count of employees grouped by their department.

select Department,count(*) As employee_count from general_data group by Department;

-- 6. List employees who have 'High' Job Satisfaction.

select EmployeeID from employee_survey_data where JobSatisfaction=3;
SELECT en.Empname
FROM employee_survey_data es
JOIN general_data en ON es.EmployeeID = en.EmployeeID
WHERE es.JobSatisfaction = 3;


-- 7. Find the highest Monthly Income in the dataset.

select MonthlyIncome from general_data order by MonthlyIncome desc limit 1;


-- 8. List employees who have 'Travel_Rarely' as their BusinessTravel type.

select Empname from general_data where BusinessTravel='Travel_Rarely';


-- 9. Retrieve the distinct MaritalStatus categories in the dataset

select distinct MaritalStatus from general_data;


-- 10. Get a list of employees with more than 2 years of work experience but less than 4 years in 
-- their current role.

select Empname from general_data where YearsAtCompany>2 and YearsAtCompany<4;


-- 11. List employees who have changed their job roles within the company (JobLevel and 
-- JobRole differ from their previous job).

select * from general_data;
select JobLevel,JobRole from general_data;

-- 12. Find the average distance from home for employees in each department.

select Department,avg(DistanceFromHome) from general_data group by Department;


-- 13. Retrieve the top 5 employees with the highest MonthlyIncome.

select Empname,MonthlyIncome from general_data order by MonthlyIncome desc limit 5;


-- 14. Calculate the percentage of employees who have had a promotion in the last year.

select Empname,yearsSinceLastPromotion from general_data where yearsSinceLastPromotion=1;

SELECT 
  (emp_promotion / total_employees) * 100 AS percentage_promotion
FROM (
  SELECT 
    (SELECT COUNT(*) FROM general_data WHERE yearsSinceLastPromotion = 1) AS emp_promotion,
    (SELECT COUNT(*) FROM general_data) AS total_employees
) AS counts;


-- 15. List the employees with the highest and lowest EnvironmentSatisfaction.

select gd.EmployeeID,gd.Empname,esd.EnvironmentSatisfaction from general_data as gd
left join employee_survey_data as esd on gd.EmployeeID=esd.EmployeeID 
where EnvironmentSatisfaction=1 or EnvironmentSatisfaction=4 order by EnvironmentSatisfaction;


-- 16. Find the employees who have the same JobRole and MaritalStatus.

select JobRole, MaritalStatus, COUNT(*) AS employee_count
FROM general_data
GROUP BY JobRole, MaritalStatus
HAVING COUNT(*) > 1;


-- 17. List the employees with the highest TotalWorkingYears who also have a 
-- PerformanceRating of 4.

select gd.EmployeeID,gd.Empname,gd.TotalWorkingYears,msd.PerformanceRating from general_data as gd
left join manager_survey_data as msd on gd.EmployeeID=msd.EmployeeID 
where PerformanceRating=4 order by TotalWorkingYears desc limit 3;


-- 18. Calculate the average Age and JobSatisfaction for each BusinessTravel type.

SELECT AVG(gd.age) AS Average_age, AVG(esd.JobSatisfaction) AS average_jobsatisfaction, gd.BusinessTravel
FROM general_data AS gd
LEFT JOIN employee_survey_data AS esd ON gd.EmployeeID = esd.EmployeeID
GROUP BY gd.BusinessTravel;


-- 19. Retrieve the most common EducationField among employees.

select EducationField,count(*) from general_data group by EducationField limit 1;


-- 20. List the employees who have worked for the company the longest but haven't had a 
-- promotion

select Empname,YearsAtCompany,YearsSinceLastPromotion from general_data where YearsAtCompany=YearsSinceLastPromotion order by YearsAtCompany desc limit 3;