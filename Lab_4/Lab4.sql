--DQL 

USE Company;

-- Display (Using Union Function)
-- The name and the gender of the dependence that's gender is Female and depending on Female Employee.
-- And the male dependence that depends on Male Employee. 
SELECT Dependent_name, Dependent.sex 
FROM Dependent, Employee 
WHERE Dependent.ESSN = Employee.SSN AND Dependent.Sex = 'F' AND Employee.Sex = 'F' 
UNION 
SELECT Dependent_name, Dependent.sex 
FROM Dependent, Employee 
WHERE Dependent.ESSN = Employee.SSN AND Dependent.sex = 'M' AND Employee.Sex = 'M';


-- For each project, list the project name and the total hours per week (for all employees) spent on that project.
SELECT Pname, sum(Hours) 
FROM project p INNER JOIN Works_for w 
ON w.Pno = p.Pnumber 
GROUP BY p.Pname;


-- Display the data of the department which has the smallest employee ID over all employees' ID.
SELECT d.*, e.SSN 
FROM Departments d INNER JOIN Employee e
ON e.Dno = d.Dnum 
WHERE e.SSN = (
	SELECT MIN(ssn) FROM Employee
	);


-- For each department, retrieve the department name and the maximum, minimum and average salary of its employees.
SELECT Dname, MIN(Salary) AS min_s, MAX(salary) AS max_sal , AVG(salary) AS avg_sal 
FROM Departments d INNER JOIN Employee e 
ON e.Dno = d.Dnum 
GROUP BY Dname;


-- List the last name of all managers who have no dependents.
SELECT Lname
FROM Employee
WHERE SSN IN (SELECT MGRSSN FROM Departments) AND ssn NOT IN (SELECT ESSN FROM Dependent);


-- For each department-- if its average salary is less than the average salary of all employees-- display its number, name and number of its employees.
SELECT Dno ,dname ,count(e.ssn) AS number_of_emps
FROM Departments d INNER JOIN Employee e
ON e.Dno = d.Dnum
GROUP BY dno, Dname 
HAVING AVG(salary) < (SELECT AVG(salary) FROM employee);


-- Retrieve a list of employees and the projects they are working on ordered by department and within each department, ordered alphabetically by last name, first name.
SELECT DISTINCT fname, Lname, Pname, Dno 
FROM Employee INNER JOIN Works_for 
ON Works_for.ESSn = Employee.SSN 
INNER JOIN Project
ON Project.Pnumber = Works_for.Pno 
ORDER BY Dno, lname, fname;


-- Try to get the max 2 salaries using subquery
SELECT MAX(salary) FROM Employee 
UNION 
SELECT MAX(salary) FROM Employee 
WHERE salary < (SELECT MAX(salary) FROM Employee) 
ORDER BY max(salary) DESC;


-- Get the full name of employees that is similar to any dependent name
SELECT Fname, Lname 
FROM Employee 
WHERE Fname IN (SELECT Dependent_name FROM Dependent);

-- Display the employee number and name if at least one of them have dependents (use exists keyword) self-study.
SELECT e.ssn, e.fname, e.lname 
FROM Employee e
WHERE NOT EXISTS (SELECT d.essn FROM Dependent d WHERE d.ESSN = e.SSN);



--DML

-- In the department table insert new department called "DEPT IT" , with id 100, employee with SSN = 112233 as a manager for this department.
-- The start date for this manager is '1-11-2006' 
INSERT INTO Departments (Dname, Dnum, MGRSSN, [MGRStart Date])
VALUES ('dept_it', 100, 112233, '1-11-2006');


-- First try to update her record in the department table 
UPDATE Departments 
SET mgrssn = 968574
WHERE Dnum = 100;


-- Update your record to be department 20 manager.
UPDATE Departments
SET mgrssn = 102672
WHERE Dnum = 20;


-- Update the data of employee number=102660 to be in your teamwork (he will be supervised by you) (your SSN =102672) 
UPDATE Employee 
SET Superssn = 102672 
WHERE ssn = 102660;


-- Unfortunately the company ended the contract with Mr. Kamel Mohamed (SSN=223344) so try to delete his data from your database 
UPDATE Employee 
SET Superssn = 102672
WHERE Superssn = 223344;

UPDATE Departments 
SET MGRSSN = 102672
WHERE MGRSSN = 223344;

UPDATE Works_for
SET ESSn = 102672 WHERE ESSn = 223344;

DELETE FROM Dependent 
WHERE essn = 223344;

DELETE FROM Employee
WHERE ssn = 223344;


-- Try to update all salaries of employees who work in Project ‘Al Rabwah’ by 30% 
UPDATE Employee 
SET Salary = salary + salary * 0.3 
WHERE SSN IN (SELECT w.ESSn FROM Works_for w INNER JOIN Project p ON p.Pnumber = w.Pno WHERE p.Pname = 'Al Rabwah');


