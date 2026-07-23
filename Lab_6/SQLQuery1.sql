use SD;


--Creating the DataType:
create type loc from nchar(2) not null;

--Creating 1st rule:
create rule r1
as 
@x in ('NY', 'DS', 'KW');

--Creating the 1ST table:
create table Department 
	(
	DeptNO varchar(10) primary key,
	DeptName varchar(20),
	Location loc Default 'NY',
	);

--Binding the rule with the location column:
sp_bindrule 'r1', 'department.Location';

select * from Department;

--Creating 2nd Table:
Create table Employee
	(
	EmpNo int,
	Emp_Fname varchar(20) not null,
	Emp_Lname varchar(20) not null,
	DeptNo varchar (10),
	Salary int,
	constraint c1 primary key (EmpNo),
	constraint c2 foreign key (DeptNo) references Department(DeptNo),
	constraint c3 unique (salary),
	);

-- Creating 2nd rule:
create rule r2 
as @x <6000;

--Binding 2nd rule:
sp_bindrule 'r2', 'Employee.Salary';

select* from works_on

--The Project and Works_on tables created by Wizard.

--Testing Referential Integrity:

--> 1-Add new employee with EmpNo =11111 In the works_on table [what will happen]
insert into Works_on (EmpNo)
Values (11111);
--nothing happened bacause the column ProjectNo does not allow null.

--> 2-Change the employee number 10102  to 11111  in the works on table [what will happen]
Update Works_on 
set EmpNo = 11111
where EmpNo = 10102;
--Nothing will happen because the column EmpNo is a foreign key.

--> 3-Modify the employee number 10102 in the employee table to 22222. [what will happen]
update Employee
set EmpNo = 22222
where EmpNo = 10102;
--Nothing will happen because the column EmpNo is a primary key and has a foreign key in the table Works_on.

--> 4-Delete the employee with id 10102
delete from Employee
where EmpNo = 10102;
--Nothing will happen because the column EmpNo is a primary key and has a foreign key in the table Works_on.


--Table modification:

--> 1-Add  TelephoneNumber column to the employee table[programmatically]
Alter table Employee
add TelephoneNumber int;


--> 2-drop this column[programmatically]
Alter table Employee
drop column TelephoneNumber;


--> 3-Bulid A diagram to show Relations between tables
						---->I have built the Diagram Named 'dbo.Diagram_0'




--2.	Create the following schema and transfer the following tables to it :
		--a.	Company Schema   i.	Department table (Programmatically)   ii.	Project table (using wizard)
		--b.	Human Resource Schema    i.	 Employee table (Programmatically)

create schema Company;

alter schema Company transfer dbo.Department;

create schema HR;

alter schema HR transfer dbo.Employee;



--3.	 Write query to display the constraints for the Employee table.
sp_helpconstraint 'HR.Employee';




--4.	Create Synonym for table Employee as Emp and then run the following queries and describe the results:
	--a.	Select * from Employee
	--b.	Select * from [Human Resource].Employee
	--c.	Select * from Emp
	--d.	Select * from [Human Resource].Emp


create synonym Emp
for SD.HR.Employee;

--> A:
Select * from Employee;
--Will not run because this table has a Schema name.

--> B:
Select * from [HR].Employee;
--it will run because the schema name was written.

--> C:
Select * from Emp;
--it will run because the synonym 'the shortcut' of the table written and it do not need schema name before it.

--> D:
Select * from [HR].Emp;
--it will not run because the synonym 'the shortcut' of the table written and it do not need schema name before it.





--5.	Increase the budget of the project where the manager number is 10102 by 10%.

update p
set Budget = budget * 1.1
from Company.Project p inner join Works_on w
on w.ProjectNo = p.ProjectNo
where W.Job = 'Manager' and W.EmpNo = 10102;



--6.	Change the name of the department for which the employee named James works.The new department name is Sales.

update d
set d.Deptname = 'Sales'
from Company.Department d inner join Emp e
on e.Deptno = d.Deptno
Where emp_fname = 'James';



--7.	Change the enter date for the projects for those employees who work in project p1 and belong to department ‘Sales’. The new date is 12.12.2007.

update w
set Enter_Date = '12-12-2007'
from Works_on w inner join Company.Project p
on p.ProjectNo = W.Projectno
inner join emp e
on e.empno = w.empno
inner join Company.Department d
on d.deptno = e.deptno
where p.projectno = 'p1' and d.deptname = 'Sales';




--8.	Delete the information in the works_on table for all employees who work for the department located in KW.

delete w 
from Works_on w
inner join emp e
on e.empno = w.empno
inner join company.department d
on d.deptno = e.deptno
where d.location = 'KW';



--9.	Try to Create Login Named(ITIStud) who can access Only student and Course tablesfrom ITI DB
--then allow him to select and insert data into tables and deny Delete and update.

use ITI;

create schema stud;

alter schema stud transfer course;

alter schema stud transfer student;
