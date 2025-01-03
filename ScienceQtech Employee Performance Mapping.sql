Create Database Employee; -- 1. Creating of Database employee
Use employee;
SELECT * FROM emp_record_table;
SELECT EMP_ID, FIRST_NAME, LAST_NAME, GENDER, DEPT FROM emp_record_table; -- 3. query to fetch EMP_ID, FIRST_NAME, LAST_NAME, GENDER, and DEPARTMENT from the employee record table
-- 4.(i) Query to fetch EMP_ID, FIRST_NAME, LAST_NAME, GENDER, DEPARTMENT, and EMP_RATING if the EMP_RATING is less than 2
SELECT EMP_ID, FIRST_NAME, LAST_NAME, GENDER, DEPT, EMP_RATING FROM emp_record_table WHERE EMP_RATING<2; 
-- 4.(ii) Query to fetch EMP_ID, FIRST_NAME, LAST_NAME, GENDER, DEPARTMENT, and EMP_RATING if the EMP_RATING is greater than 4
SELECT EMP_ID, FIRST_NAME, LAST_NAME, GENDER, DEPT, EMP_RATING FROM emp_record_table WHERE EMP_RATING>4; 
-- 4.(iii) Query to fetch EMP_ID, FIRST_NAME, LAST_NAME, GENDER, DEPARTMENT, and EMP_RATING if the EMP_RATING is between 2 and 4
SELECT EMP_ID, FIRST_NAME, LAST_NAME, GENDER, DEPT, EMP_RATING FROM emp_record_table WHERE EMP_RATING>=2 AND EMP_RATING<=4;
-- 5. Query to concatenate the FIRST_NAME and the LAST_NAME of employees in the Finance department
SELECT CONCAT(FIRST_NAME, ' ', LAST_NAME) AS 'Name', Dept from emp_record_table WHERE Dept='Finance';
-- 6. Query to list only those employees who have someone reporting to them and the number of reporters
SELECT m.EMP_ID, m.FIRST_NAME, m.LAST_NAME, m.ROLE, m.EXP,COUNT(e.EMP_ID) as 'EMP_COUNT' FROM emp_record_table m INNER JOIN emp_record_table e ON m.EMP_ID = e.MANAGER_ID GROUP BY m.EMP_ID, m.FIRST_NAME, m.LAST_NAME, m.ROLE, m.EXP ORDER BY m.EMP_ID;
-- 7. Query to list down all the employees from the healthcare and finance departments using union
SELECT EMP_ID,FIRST_NAME,LAST_NAME,DEPT FROM emp_record_table WHERE DEPT = 'HEALTHCARE' UNION SELECT EMP_ID,FIRST_NAME,LAST_NAME,DEPT FROM emp_record_table WHERE DEPT = "FINANCE";
-- 8. Query to list down employee details such as EMP_ID, FIRST_NAME, LAST_NAME, ROLE, DEPARTMENT, and EMP_RATING grouped by dept and include the respective employee rating along with the max emp rating for the department
SELECT  m.EMP_ID,m.FIRST_NAME,m.LAST_NAME,m.ROLE,m.DEPT,m.EMP_RATING,max(m.EMP_RATING) OVER(PARTITION BY m.DEPT) AS "MAX_DEPT_RATING" FROM emp_record_table m ORDER BY DEPT;
-- 9. Query to calculate the minimum and the maximum salary of the employees in each role
SELECT ROLE, MAX(SALARY), MIN(SALARY) FROM emp_record_table
WHERE ROLE IN("PRESIDENT","LEAD DATA SCIENTIST","SENIOR DATA SCIENTIST","MANAGER","ASSOCIATE DATA SCIENTIST","JUNIOR DATA SCIENTIST") GROUP BY ROLE;
-- 10. Query to assign ranks to each employee based on their experience
SELECT EMP_ID,FIRST_NAME,LAST_NAME,EXP, RANK() OVER(ORDER BY EXP) EXP_RANK FROM emp_record_table;
-- 11. Query to create a view that displays employees in various countries whose salary is more than six thousand
CREATE VIEW employees_in_various_countries AS SELECT EMP_ID,FIRST_NAME,LAST_NAME,COUNTRY,SALARY FROM emp_record_table WHERE SALARY>6000;
SELECT *FROM employees_in_various_countries;
-- 12. Nested query to find employees with experience of more than ten years
SELECT EMP_ID,FIRST_NAME,LAST_NAME,EXP FROM emp_record_table WHERE EMP_ID IN(SELECT manager_id FROM emp_record_table);
-- 13. Query to create a stored procedure to retrieve the details of the employees whose experience is more than three years
DELIMITER &&
CREATE PROCEDURE get_experience_details()
BEGIN
SELECT EMP_ID,FIRST_NAME,LAST_NAME,EXP FROM emp_record_table WHERE EXP>3;
END &&
CALL get_experience_details();
-- 14. Query using stored functions in the project table to check whether the job profile assigned to each employee in the data science team matches the organization’s set standard
DELIMITER &&
CREATE FUNCTION Employee_ROLE(
EXP int
)
RETURNS VARCHAR(40)
DETERMINISTIC
BEGIN
DECLARE Employee_ROLE VARCHAR(40);
IF EXP>12 AND 16 THEN
SET Employee_ROLE="MANAGER";
ELSEIF EXP>10 AND 12 THEN
SET Employee_ROLE ="LEAD DATA SCIENTIST";
ELSEIF EXP>5 AND 10 THEN
SET Employee_ROLE ="SENIOR DATA SCIENTIST";
ELSEIF EXP>2 AND 5 THEN
SET Employee_ROLE ="ASSOCIATE DATA SCIENTIST";
ELSEIF EXP<=2 THEN
SET Employee_ROLE ="JUNIOR DATA SCIENTIST";
END IF;
RETURN (Employee_ROLE);
END &&

SELECT EXP,Employee_ROLE(EXP) FROM data_science_team;
-- 15. Index to improve the cost and performance of the query to find the employee whose FIRST_NAME is ‘Eric’ in the employee table after checking the execution plan. 
CREATE INDEX idx_first_name ON emp_record_table(FIRST_NAME(20));
SELECT * FROM emp_record_table WHERE FIRST_NAME='Eric';
-- 16. Query to calculate the bonus for all the employees, based on their ratings and salaries
UPDATE emp_record_table SET salary=(SELECT salary +(SELECT salary*.05*EMP_RATING))
SELECT *FROM emp_record_table;
-- 17. Query to calculate the average salary distribution based on the continent and country
SELECT EMP_ID, FIRST_NAME, LAST_NAME, SALARY, COUNTRY, CONTINENT, AVG(salary) OVER(PARTITION BY COUNTRY) AVG_salary_IN_COUNTRY,
AVG(salary) OVER(PARTITION BY CONTINENT) AVG_salary_IN_CONTINENT, 
COUNT(*) OVER(PARTITION BY COUNTRY) COUNT_IN_COUNTRY,
COUNT(*) OVER(PARTITION BY CONTINENT) COUNT_IN_CONTINENT
FROM emp_record_table;














