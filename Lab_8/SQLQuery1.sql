
--PART 1:

Use ITI;

-------------------------------------------------------------
--1.	 Create a view that displays student full name, course name if the student has a grade more than 50. 

create view vstudent 
	as
		select concat(s.St_Fname,' ',s.St_Lname) as fullname, c.Crs_Name
		from stud.Student s inner join Stud_Course sc
		on sc.St_Id = s.St_Id
		inner join course c 
		on c.Crs_Id = sc.Crs_Id
		where sc.Grade > 50;


select * from vstudent;

-------------------------------------------------------------------------------------

--2.	 Create an Encrypted view that displays manager names and the topics they teach. 

create view mnames
with encryption
	as
		select i.Ins_Name, c.Crs_Name
		from Instructor i inner join Department d
		on d.Dept_Manager = i.Ins_Id
		inner join Ins_Course ic
		on ic.Ins_Id = i.Ins_Id
		inner join Course c
		on c.Crs_Id = ic.Crs_Id;



select * from mnames;

----------------------------------------------------------------------------------------

--3.	Create a view that will display Instructor Name, Department Name for the ‘SD’ or ‘Java’ Department 

create view iname
	as
		select i.Ins_Name, d.Dept_Name
		from Instructor i inner join Department d
		on d.Dept_Id = i.Dept_Id
		where d.Dept_Name in ('SD', 'Java');


select * from iname;

----------------------------------------------------------------------------------------


--Create a view “V1” that displays student data for student who lives in Alex or Cairo. 
	--Note: Prevent the users to run the following query 
	--Update V1 set st_address=’tanta’
	--Where st_address=’alex’;


create view V1 
	as
		select *
		from stud.Student
		where St_Address in ('cairo', 'alex')
	with check option;



select * from V1;


---------------------------------------------------------------------------------------


--5.	Create a view that will display the project name and the number of employees work on it. “Use Company DB”

Use Company;

create view VC
	as 
		select p.Pname, count(wf.ESSn) as num_of_emp
		from project p inner join Works_for wf
		on p.Pnumber = wf.Pno
		group by p.Pname;


select * from VC;


----------------------------------------------------------------------------------------


--6.	Create index on column (Hiredate) that allow u to cluster the data in table Department. What will happen?

use ITI;

create clustered index idxc
on iti.dbo.department (Manager_hiredate);


--the code will not run because there is a clustered index on the primary key 'dept_id' already, and we can not create 2 clustered indexes in the same table.

---------------------------------------------------------------------------------------------


--7.	Create index that allow u to enter unique ages in student table. What will happen? 

create unique nonclustered index uniqeidx
on stud.student (st_age);


--the code will not run because the column 'age' contain repeated data so i can not change it to unique data.

-------------------------------------------------------------------------------------------


--8.	Using Merge statement between the following two tables [User ID, Transaction Amount]

create database bank;

use bank;

create table Daily_Transaction
(
UserID int primary key,
Trans_Amount int
);

create table Last_Transaction
(
UserID int primary key,
Trans_Amount int
);

insert into Daily_Transaction(UserID,Trans_Amount)
values (1,1000),(2,2000),(3,1000);

insert into Last_Transaction(UserID,Trans_Amount)
values (1,4000),(4,2000),(2,10000);

merge into last_transaction as t
using daily_transaction as s
on t.userid =s.userid
	when matched then
		update
			set t.trans_amount = s.trans_amount
	when not matched then
		insert
			values(s.UserID, s.Trans_Amount);


-------------------------------------------------------------------------------------------

--PART 2:


use SD;


--1)	Create view named   “v_clerk” that will display employee#,project#, the date of hiring of all the jobs of the type 'Clerk'.


create view vclerk 
as 
	select EmpNo, ProjectNo, Enter_Date
	from Works_on
	where Job = 'clerk';


-- to use the view: 
select * from vclerk;


-------------------------------------------------------------------------

--2)	 Create view named  “v_without_budget” that will display all the projects data without budget


create view v_without_budget
as
	select ProjectNo, ProjectName
	from Company.Project
	where Budget is null;


-- to use the view:
select * from v_without_budget;


-----------------------------------------------------------------------

--3)	Create view named  “v_count “ that will display the project name and the # of jobs in it

create view v_count
as 
	select p.ProjectName, count(w.job) as number_of_jobs
	from Company.Project p inner join Works_on w
	on w.ProjectNo = p.ProjectNo
	group by p.ProjectName;


select * from v_count;


------------------------------------------------------------------------------------------


--4)	 Create view named ” v_project_p2” that will display the emp# s for the project# ‘p2’ use the previously created view  “v_clerk”


create view v_project_p2
as 
	select EmpNo
	from vclerk
	where ProjectNo like 'p2';


-- to use the view:
select * from v_project_p2;



-------------------------------------------------------------------------------------------

--5)	modifey the view named  “v_without_budget”  to display all DATA in project p1 and p2 

alter view v_without_budget
as 
	select *
	from Company.Project
	where ProjectNo in ('p1','p2');


--to use the view:
select * from v_without_budget;



---------------------------------------------------------------------------------------------

--6)	Delete the views  “v_ clerk” and “v_count”

DROP VIEW vclerk, v_count;


----------------------------------------------------------------------------------------------


--7)	Create view that will display the emp# and emp lastname who works on dept# is ‘d2’

create view empv
as 
	select EmpNo, Emp_Lname
	from hr.Employee
	where DeptNo = 'd2';


--to use the view:
select *from empv;

-----------------------------------------------------------------------------------

--8)	Display the employee  lastname that contains letter “J” Use the previous view created in Q#7

select Emp_Lname
from empv
where Emp_Lname like '%J%';


-----------------------------------------------------------------------------------

--9)	Create view named “v_dept” that will display the department# and department name

create view v_dept
as
	select DeptNO, DeptName
	from Company.Department;



--to use the view:
select * from v_dept;


-----------------------------------------------------------------------------------


--10)	using the previous view try enter new department data where dept# is ’d4’ and dept name is ‘Development’


insert into v_dept (DeptNO, DeptName)
values ('d4', 'Development');

---------------------------------------------------------------------------------

--11)	Create view name “v_2006_check” that will display employee#, the project #where he works and the date of joining the project which must be from the first of January and the last of December 2006.
	--	this view will be used to insert data so make sure that the coming new data must match the condition



create view v_2006_check
as
	select EmpNo, ProjectNo, Enter_Date
	from Works_on
	where Enter_Date between '1-1-2006' and '12-31-2006'
	with check option;


-- to use the view:
select * from v_2006_check;

---------------------------------------------------------------------------------------------


