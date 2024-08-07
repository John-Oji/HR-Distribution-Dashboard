# HR-Dashboard-PostgreSQL-Power BI
![hr distribution dashboard](https://github.com/user-attachments/assets/1909cf64-dc87-4679-bdd4-2b7284244b7c)


### DATA USED
Data Used
Data Used - HR Data with over 22414 rows from the year 2000 to 2020.

Data Cleaning & Analysis - Excel and PostgreSQL

Data Visualization - PowerBI

### Exploratory Data Analysis.
EDA involved exploring the HR data to answer key questions, such as:

1. What is the gender breakdown of employees in the company?

2. What is the race/ethnicity breakdown of employees in the company?

3. What is the age distribution of employees in the company?

4. What is the distribution of employees between headquarters and remote locations?
 
5. What is the average length of employment for employees who have been terminated?
  
6. How does the gender distribution vary across departments and job titles?
   
7. What is the distribution of job titles across the company?

8. Which department has the highest turnover rate?
   
9. What is the distribution of employees across locations by state?
 
10. How has the company's employee count changed over time based on hire and term dates?
  
11. What is the tenure distribution for each department?

12. Which year has the highest attrition rate?

### Data Analysis
Some code used in the project.

What is the race breakdown of current employees in the company?
``` PostgreSQL
SELECT race, COUNT(*) AS count
FROM hr
WHERE termdate IS NULL 
   OR termdate > CURRENT_DATE
GROUP BY race
ORDER BY count DESC;
```
Which city and state have the highest number of employees?
```PostgreSQL
SELECT location_city, location_state, COUNT(*) AS count
FROM hr
WHERE termdate IS NULL 
   OR termdate > CURRENT_DATE
GROUP BY location_city, location_state
ORDER BY count DESC
LIMIT 1;
```


### Summary of Findings
- There are more male employees than the female employees.

- White race is the most dominant while Native Hawaiian and American Indian are the least dominant.
  
- The youngest employee is 21 years old while the oldest is 58 years old. 4 age groups were created (21-30, 31-40, 41-50, 51-58). A large number of employees were between 31-40 followed by 41-50 while the smallest group was 51-58.
  
- A large number of employees work at the headquarters (14,756 employees) compared to employees that work remotely (4,901 employees).
  
- The average length of employment for terminated employees is around 7 years.
  
- The gender distribution across departments is fairly balanced but there are generally more male than female employees.
  
- Research Assistant has the highest number of employees (1,214) followed by Human Resources Analyst (900) while Assistant Professor, Associate Professor, Executive Secretary, marketing manager and VP of training & development are the jobtitles with the lowest number of employees(1 staff respectively) 
  
- The department with the highest turnover rate is Auditing while the department with the least turnover rate is Marketing.

- The year 2010 has the highest attrition rate.

- A large number of employees(15,923) come from the state of Ohio while the least number of employees come from wisconsin (338)
  
- The net change in employees has increased over the years.

- The average tenure for each department is about 12 years with Auditing and Legal having the highest while Marketing and Business Develpoment have the lowest.


### Limitation
- There were missing termination dates which can impact turnover analysis and lead to incorrect attrition rates.
  
- Job titles are not standardized, leading to difficulties in grouping and comparing similar roles. Variations in job titles made it hard to analyze job-specific trends.
  
- The data lacks contextual information such as performance metrics, job satisfaction scores, or reasons for termination, which can provide deeper insights into HR trends and issues.


###  Recommendation

- With an overall attrition of 2,553 employees, we should consider enhancing retention programs. This could include improving employee engagement through regular feedback, recognition programs, and professional development opportunities to keep employees motivated and committed to the organization.

- The turnover rate is particularly high in departments like Auditing (17.31%), Legal (13.50%), and Training (12.23%). Investigate the reasons behind high attrition in these departments and implement retention strategies, such as career development opportunities, better work-life balance, and competitive compensation packages.

- The race distribution shows a significant number of employees identifying as White (5.6K), but there are notable populations of Two or More Races, Black or African American, Asian, and Hispanic or Latino employees. Strengthen diversity and inclusion programs to ensure equitable opportunities for all groups. Initiatives could include diversity training, mentorship programs, and targeted recruitment efforts.

- The average age of employees is 40, and a significant number fall within the 41-50 (5.2K) and 51-58 (4.1K) age groups. Develop programs that support an aging workforce, such as wellness programs, retirement planning services, and phased retirement options to retain valuable experience and knowledge.

  
  
