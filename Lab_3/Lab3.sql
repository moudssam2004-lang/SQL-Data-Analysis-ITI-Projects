USE Company;


-- Insert your personal data to the employee table as a new employee in department number 30, SSN = 102672, Superssn = 112233, salary=3000.
INSERT INTO Employee (Fname, Lname, SSN, Sex, Superssn, Dno) 
VALUES ('Mahmoud', 'Essam', 102672, 'M', 112233, 30);
UPDATE Employee SET Salary = 1000 WHERE Fname = 'Mahmoud' AND Lname = 'Essam';


-- Insert another employee with personal data your friend as new employee in department number 30, SSN = 102660, but dont enter any value for salary or manager number to him.
INSERT INTO Employee (Fname,Lname,SSN, Sex, Dno) 
VALUES ('Yousef','Salah', 102660 ,'M', 30);


-- Upgrade your salary by 20 % of its last value.
UPDATE Employee 
SET Salary = Salary*1.20 
WHERE Fname = 'Mahmoud' AND Lname = 'Essam';


-- Display the Department id, name and id and the name of its manager.
SELECT dname, dnum, MGRSSN, CONCAT(fname, ' ', lname) AS fullname 
FROM Departments INNER JOIN employee 
ON employee.ssn = Departments.MGRSSN;


-- Display the name of the departments and the name of the projects under its control.
SELECT Dname, Pname 
FROM Departments d INNER JOIN Project p 
ON p.Dnum = d.Dnum;


-- Display the full data about all the dependence associated with the name of the employee they depend on him/her.
SELECT d.* , e.Fname+' '+ lname AS emp_name 
FROM Dependent d INNER JOIN Employee e 
ON e.SSN = d.ESSN;


-- Display the Id, name and location of the projects in Cairo or Alex city.
SELECT * 
FROM Project 
WHERE city LIKE 'cairo' OR city = 'alex';


-- Display the Projects full data of the projects with a name starts with "a" letter.
SELECT * 
FROM Project 
WHERE pname LIKE 'A%';


-- display all the employees in department 30 whose salary from 1000 to 2000 LE monthly.
SELECT *
FROM dbo.Employee
WHERE Dno = 30 AND Salary BETWEEN 1000 AND 2000;


-- Retrieve the names of all employees in department 10 who works more than or equal10 hours per week on "AL Rabwah" project.
SELECT e.*, w.Hours, p.Pname
FROM Employee e 
JOIN Works_for w 
ON e.SSN = w.ESSn
JOIN Project p
ON p.Pnumber = w.Pno 
WHERE dno = 30 AND Pnumber = 200 AND w.Hours >= 10;

