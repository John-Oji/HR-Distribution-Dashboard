CREATE TABLE hr (
    id VARCHAR(20) PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    birthdate DATE,
    gender VARCHAR(10),
    race VARCHAR(50),
    department VARCHAR(50),
    jobtitle VARCHAR(50),
    work_location VARCHAR(50),
    hire_date DATE,
    termdate DATE,
    location_city VARCHAR(50),
    location_state VARCHAR(50)
);


SELECT * from hr limit 100;


-----(DATA CLEANING WAS DONE USING EXCEL & POSTGRESQL)

--      EXCEL CLEANING
-- Step 1. Birthdate and hire_date column were formated in excel from DD-MM-YY to YY-MM-DD

-----   POSTGRESQL CLEANING

-- Step 1: Column header was changed from id to employee_id in the hr table
ALTER TABLE hr RENAME COLUMN id TO employee_id;

-- Step 2: ADD_AGE_COLUMN
ALTER TABLE hr ADD COLUMN age integer;

-- Step 3: Update the age column with the calculated age

UPDATE hr
SET age = DATE_PART('year', AGE(birthdate));

-------


SELECT MAX(age) As highest_age,
	   MIN(age) As minimum_age
FROM hr;



SELECT *
FROM hr
WHERE termdate IS NOT NULL;


---           QUESTIONS
--1a. How many employees are currently working at the company?

SELECT COUNT(*) AS current_no_of_employees
 FROM hr
  WHERE termdate IS NULL 
   OR termdate > CURRENT_DATE;
   


--1b. WHAT IS THE GENDER BREAKDOWN OF ALL THE CURRENT EMPLOYEES IN THE COMPANY?

SELECT gender, COUNT(*) AS count
FROM hr
WHERE termdate IS NULL 
   OR termdate > CURRENT_DATE
GROUP BY gender
ORDER BY count DESC;

--1c. WHAT IS THE GENDER BREAKDOWN OF ALL EMPLOYEES WHO HAVE WORKED IN THE COMPANY?(past and preseent)

SELECT gender, COUNT(*) AS count
FROM hr
GROUP BY gender
ORDER BY count DESC;

--1d. WHAT IS THE GENDER BREAKDOWN OF ALL THE EMPLOYEES WITHOUT A TERM DATE?

SELECT gender, COUNT(*) AS count
FROM hr
WHERE termdate IS NULL 
GROUP BY gender
ORDER BY count DESC;


--2. WHAT IS THE RACE/ETHNICITY BREAKDOWN OF CURRENT EMPLOYEES IN THE COMPANY?

SELECT race, COUNT(*) AS count
FROM hr
WHERE termdate IS NULL 
   OR termdate > CURRENT_DATE
GROUP BY race
ORDER BY count DESC;

--2b WHAT IS THE RACE/ETHNICITY BREAKDOWN OF ALL THE EMPLOYEES(PAST AND PRESENT) IN THE COMPANY?

SELECT race, COUNT(*) AS count
 FROM hr
 GROUP BY race
 ORDER BY count DESC;


---3. WHAT IS THE AGE DISTRUBUTION OF THE CURRENT EMPLOYEES IN THE COMPANY?

SELECT 
    CASE 
        WHEN age BETWEEN 21 AND 30 THEN '21-30'
        WHEN age BETWEEN 31 AND 40 THEN '31-40'
        WHEN age BETWEEN 41 AND 50 THEN '41-50'
        WHEN age BETWEEN 51 AND 58 THEN '51-58'
        ELSE 'Other'
    END AS age_group,
    COUNT(*) AS count
FROM hr
WHERE termdate IS NULL 
   OR termdate > CURRENT_DATE
GROUP BY age_group
ORDER BY age_group;


---3b. WHAT IS THE AGE DISTRUBUTION OF THE CURRENT EMPLOYEES IN THE COMPANY BY GENDER?

SELECT 
    CASE 
        WHEN age BETWEEN 21 AND 30 THEN '21-30'
        WHEN age BETWEEN 31 AND 40 THEN '31-40'
        WHEN age BETWEEN 41 AND 50 THEN '41-50'
        WHEN age BETWEEN 51 AND 58 THEN '51-58'
        ELSE 'Other'
    END AS age_group, gender,
    COUNT(*) AS count
FROM hr
WHERE termdate IS NULL 
   OR termdate > CURRENT_DATE
GROUP BY age_group, gender
ORDER BY age_group, gender;



---3C. WHAT IS THE AGE DISTRUBUTION OF THE EMPLOYEES IN THE COMPANY?(PAST & PRESENT)

SELECT 
    CASE 
        WHEN age BETWEEN 21 AND 30 THEN '21-30'
        WHEN age BETWEEN 31 AND 40 THEN '31-40'
        WHEN age BETWEEN 41 AND 50 THEN '41-50'
        WHEN age BETWEEN 51 AND 58 THEN '51-58'
        ELSE 'Other'
    END AS age_group,
    COUNT(*) AS count
FROM hr
GROUP BY age_group
ORDER BY age_group;

---4. HOW MANY EMPLOYEES WORK AT HEADQUARTERS VERSUS REMOTE LOCATIONS?

SELECT work_location, COUNT(*) AS count
 FROM hr
 WHERE termdate IS NULL 
   OR termdate > CURRENT_DATE
 GROUP BY work_location;


--5.WHAT IS THE AVERAGE LENGTH OF EMPLOYMENT FOR EMPLOYEES WHO HAVE BEEN TERMINATED?

SELECT ROUND(AVG(EXTRACT(YEAR FROM AGE(termdate, hire_date))),0) AS average_length_of_employment
FROM HR
WHERE termdate IS NOT NULL AND termdate <= CURRENT_DATE;


 
---6a. HOW DOES THE GENDER DISTRIBUTION OF CURRENT EMPLOYEES VARY ACROSS DIFFERENT DEPARTMENT AND JOB TITLES?
 
SELECT department, jobtitle, gender, COUNT(*) AS count
 FROM hr
  WHERE termdate IS NULL 
    OR termdate > CURRENT_DATE
  GROUP BY department, jobtitle, gender
  ORDER BY department;


---6b. WHAT IS THE GENDER DISTRIBUTION OF CURRENT EMPLOYEES IN EACH DEPARTMENT?

SELECT department, gender, COUNT (*) AS count
 FROM hr
  WHERE termdate IS NULL 
    OR termdate > CURRENT_DATE
   GROUP BY department, gender
    ORDER BY department;
 
 ---7. WHAT IS THE DISTRIBUTION OF JOB TITLES ACROSS THE COMPANY?
 
SELECT jobtitle, COUNT (*) AS count
 FROM hr
  WHERE termdate IS NULL 
    OR termdate > CURRENT_DATE
   GROUP BY jobtitle
    ORDER BY jobtitle DESC;
	
	

------### This code helps identify the most common job titles or roles within an organization, ignoring variations due to seniority level/Roman numerals.
SELECT 
    REGEXP_REPLACE(jobtitle, ' [IVX]+$', '') AS jobtitle_group, 
    COUNT(*) AS count
FROM hr
WHERE termdate IS NULL 
   OR termdate > CURRENT_DATE
GROUP BY jobtitle_group
ORDER BY count DESC;

----##


---- What are the departments with the most active employees, ignoring department name variations due to team or subgroup identifiers.
SELECT 
    REGEXP_REPLACE(department, ' [IVX]+$', '') AS department_group,
    COUNT(*) AS employee_count
FROM hr
WHERE termdate IS NULL 
   OR termdate > CURRENT_DATE
GROUP BY department_group
ORDER BY employee_count DESC;



--What are the departments with the most employees (active and non active employees), along with their average employee tenure, ignoring department name variations due to team or subgroup identifiers
SELECT 
    REGEXP_REPLACE(department, ' [IVX]+$', '') AS department_group,
    COUNT(*) AS employee_count,
    ROUND(AVG(EXTRACT(YEAR FROM AGE(COALESCE(termdate, CURRENT_DATE), hire_date))), 1) AS average_tenure_years
FROM hr
WHERE hire_date IS NOT NULL
GROUP BY department_group
ORDER BY employee_count DESC;






----# top 5 jobtitle with the highest number of employees.
SELECT 
    REGEXP_REPLACE(jobtitle, ' [IVX]+$', '') AS jobtitle_group, 
    COUNT(*) AS count
FROM hr
WHERE termdate IS NULL 
   OR termdate > CURRENT_DATE
GROUP BY jobtitle_group
ORDER BY count DESC
LIMIT 5;

----# Top 5 jobtitle with the lowest number of employees
SELECT 
    REGEXP_REPLACE(jobtitle, ' [IVX]+$', '') AS jobtitle_group, 
    COUNT(*) AS count
FROM hr
WHERE termdate IS NULL 
   OR termdate > CURRENT_DATE
GROUP BY jobtitle_group
ORDER BY count ASC
LIMIT 5;
	
--8. WHICH DEPARTMENT HAS THE HIGHEST TURNOVER RATE?
--- 
SELECT department,
       COUNT(*) AS total_count,
       COUNT(CASE WHEN termdate IS NOT NULL AND termdate <= CURRENT_DATE THEN 1 END) AS termination_count,
       ROUND((COUNT(CASE WHEN termdate IS NOT NULL AND termdate <= CURRENT_DATE THEN 1 END) * 100.0 / COUNT(*)), 2) AS turnover_rate
FROM hr
GROUP BY department
ORDER BY turnover_rate DESC;

 
 ---9a. Which state currently has the highest number of active employees in the company?
 
SELECT location_state, COUNT (*) AS count
  FROM hr
   WHERE termdate IS NULL 
    OR termdate > CURRENT_DATE
   GROUP BY location_state
   ORDER BY count DESC;
 
 
 ---9b. WHAT IS THE DISTRIBUTION OF EMPLOYEES ACROSS LOCATIONS BY CITY AND STATE.
 
 SELECT work_location,location_city, location_state, COUNT (*) AS count
 FROM hr
 WHERE termdate IS NULL 
    OR termdate > CURRENT_DATE
	GROUP BY work_location,location_city, location_state
	ORDER BY work_location;
	

----## The city and state with the highest number of employees

SELECT location_city, location_state, COUNT(*) AS count
FROM hr
WHERE termdate IS NULL 
   OR termdate > CURRENT_DATE
GROUP BY location_city, location_state
ORDER BY count DESC
LIMIT 1;

----# The city and state with the lowest number of employees.

SELECT location_city, location_state, COUNT(*) AS count
FROM hr
WHERE termdate IS NULL 
   OR termdate > CURRENT_DATE
GROUP BY location_city, location_state
ORDER BY count ASC
LIMIT 1;


	
 
 ---10. HOW HAS THE COMPANY'S EMPLOYEE COUNT CHANGED OVER TIME BASED ON HIRE AND TERMDATE


SELECT
    EXTRACT(YEAR FROM COALESCE(hire_date, termdate)) AS year,
    COUNT(*) FILTER (WHERE hire_date IS NOT NULL) AS hires,
    COUNT(*) FILTER (WHERE termdate IS NOT NULL AND termdate <= CURRENT_DATE) AS terminations,
    COUNT(*) FILTER (WHERE hire_date IS NOT NULL) - COUNT(*) FILTER (WHERE termdate IS NOT NULL AND termdate <= CURRENT_DATE) AS net_change,
    ROUND(
        (COUNT(*) FILTER (WHERE hire_date IS NOT NULL) - COUNT(*) FILTER (WHERE termdate IS NOT NULL AND termdate <= CURRENT_DATE)) * 100.0 /
        NULLIF(COUNT(*) FILTER (WHERE hire_date IS NOT NULL) + COUNT(*) FILTER (WHERE termdate IS NOT NULL AND termdate <= CURRENT_DATE), 0), 2
    ) AS net_change_percent
FROM hr
GROUP BY year
ORDER BY year;

 
 ---11.  WHAT IS THE TENURE DISTRIBUTION OF EMPLOYEE (IN YEARS) IN EACH DEPARTMENT.
 ---(THIS CODE IS MORE DETAILED THAN THE CODE BELOW)

 SELECT 
    department,
    EXTRACT(YEAR FROM AGE(COALESCE(termdate, CURRENT_DATE), hire_date)) AS tenure_years,
    COUNT(*) AS employee_count
FROM hr
WHERE hire_date IS NOT NULL
GROUP BY department, tenure_years
ORDER BY department, tenure_years;
 
 
 
---11a. WHAT IS THE TENURE DISTRIBUTION(LENGTH OF SERVICE) OF EMPLOYEES IN EACH DEPARTMENT?
  
 SELECT
    department,
    CASE
        WHEN EXTRACT(YEAR FROM AGE(COALESCE(termdate, CURRENT_DATE), hire_date)) < 1 THEN 'Less than 1 year'
        WHEN EXTRACT(YEAR FROM AGE(COALESCE(termdate, CURRENT_DATE), hire_date)) BETWEEN 1 AND 3 THEN '1-3 years'
        WHEN EXTRACT(YEAR FROM AGE(COALESCE(termdate, CURRENT_DATE), hire_date)) BETWEEN 4 AND 6 THEN '4-6 years'
        WHEN EXTRACT(YEAR FROM AGE(COALESCE(termdate, CURRENT_DATE), hire_date)) BETWEEN 7 AND 10 THEN '7-10 years'
        ELSE 'More than 10 years'
    END AS tenure_range,
    COUNT(*) AS employee_count
FROM hr
WHERE hire_date IS NOT NULL
GROUP BY department, tenure_range
ORDER BY department, tenure_range;

 
 
---11b.WHAT IS THE AVERAGE TENURE OF EMPLOYEES IN EACH DEPARTMENT,AND WHICH DEPARTMENT HAS THE HIGHEST AVERAGE TENURE?
SELECT 
    department,
    ROUND(AVG(EXTRACT(YEAR FROM AGE(COALESCE(termdate, CURRENT_DATE), hire_date))), 0) AS avg_tenure_years
FROM hr
WHERE hire_date IS NOT NULL
GROUP BY department
ORDER BY avg_tenure_years DESC;



  
