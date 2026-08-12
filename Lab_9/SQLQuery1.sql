Use ITI;

-----------------------------------------------------------

--1.	Create a stored procedure without parameters to show the number of students per department name.[use ITI DB] 

create proc stud_num
as
	select count(s.St_Id), d.Dept_Name
	from stud.Student s inner join Department d
	on d.Dept_Id = s.Dept_Id
	group by Dept_Name;

--to call the procedure
exec stud_num;


------------------------------------------------------------------------------------

--2.	Create a stored procedure that will check for the # of employees in the project p100
	--if they are more than 3 print message to the user “'The number of employees in the project p100 is 3 or more'”
	--if they are less display a message to the user “'The following employees work for the project p100'”
		--in addition to the first name and last name of each one. [Company DB] 


Use Company;

create proc knowemp
as
	declare @x int
	select @x=count(w.ESSn)
	from Works_for w inner join Project p
	on p.Pnumber = w.Pno
	where p.Pnumber = 100
		if @x >=3
			begin
				print 'The number of employees in the project p100 is 3 or more'
			end
		else
			begin
				select 'The following employees work for the project p100', Fname, Lname
				from Employee e inner join Works_for w 
				on w.ESSn = e.SSN
				where w.Pno = 100
			end;

-- to call the procedure:
exec knowemp;

----------------------------------------------------------------------------------------

--3.	Create a stored procedure that will be used in case there is an old employee has left the project and a new one become instead of him.
	--The procedure should take 3 parameters (old Emp. number, new Emp. number and the project number) 
		--and it will be used to update works_on table. [Company DB]



create proc empchng @old_emp_no int, @new_emp_no int, @proj_cnt int
as
	update works_for
	set ESSn =  @new_emp_no
	where essn = @old_emp_no and Pno = @proj_cnt
	



--to use the procedure
exec empchng @old_emp_no = 3,@new_emp_no = 55,@proj_cnt =100;


--------------------------------------------------------------------------------------------------------------

-- 4 --

alter table project
add budget int;


create table Audit
(
Project_No int,
User_Name varchar(50),
Modified_Date date,
Budget_Old int,
Budget_New int
);

create trigger T1
on project 
after update
as 
	begin
		if update(budget)
			insert into Audit (Project_No, User_Name, Modified_Date, Budget_Old, Budget_New)
			select i.Pnumber, suser_name(), getdate(), d.budget, i.budget
			from deleted d inner join inserted i 
			on i.Pnumber = d.Pnumber
	end;	


--to use the trigger:
update project
set budget = 12000
where Pnumber = 100


select * from audit


--------------------------------------------------------------------------------------------------------------

--5.	Create a trigger to prevent anyone from inserting a new record in the Department table [ITI DB]
	--“Print a message for user to tell him that he can’t insert a new record in that table”


Use ITI;

create trigger T2
on department
instead of insert
as
	begin
		select 'You can not insert any data on this table'
	end;


--to use the trigger:

insert into Department(Dept_Id, Dept_Name)
values(99, 'manchester')

--------------------------------------------------------------------------------------------------------------

--6.	 Create a trigger that prevents the insertion Process for Employee table in March [Company DB].

use Company;

create trigger T3
on employee
after insert
as
	if format(getdate(), 'MMMM') = 'march'
		begin
			select 'You can not insert data on March'
			rollback transaction
		end;
	

--to use the trigger:
insert into Employee(SSN, Fname, Lname)
values (977, 'mahmoud','essam');


------------------------------------------------------------------------------------------

--7.	Create a trigger on student table after insert to add Row in Student Audit table (Server User Name , Date, Note)
	--where note will be “[username] Insert New Row with Key=[Key Value] in table [table name]”

use ITI;

create table Student_Audit_table
(
Server_user_name varchar(50),
Date date, 
note varchar(90)
);




create trigger T4
on stud.STUDENT
after insert
as 
	insert into student_Audit_table (Server_user_name, Date, note)
	select suser_name(), getdate(), suser_name()+' Insert New Row with Key = '+cast(i.St_Id as varchar(20)) + ' in table student'
	from inserted i;

--to use the trigger:

insert into stud.Student (St_Id)
values(44);

select * from student_Audit_table;


-----------------------------------------------------------------------------------------------------

--8. Create a trigger on student table instead of delete to add Row in Student Audit table (Server User Name, Date, Note)
	--where note will be“ try to delete Row with Key=[Key Value]”


create trigger T5
on stud.student
instead of delete
as
	insert into student_Audit_table (Server_user_name, Date, note)
	select suser_name(), getdate(), ' try to delete Row with Key = ' + cast(d.St_Id as varchar(20))
	from deleted d;

--to use the trigger:
delete s
from stud.Student s 
where s.St_Id = 4;

select * from stud.Student;
select * from Student_Audit_table;



----------------------------------------------------------------------------------------------

--9.	Display all the data from the Employee table (HumanResources Schema) 
	--As an XML document “Use XML Raw”. “Use Adventure works DB” 
	--A)	Elements
	--B)	Attributes


use AdventureWorks2012;

-->(A)
SELECT *
FROM HumanResources.Employee
FOR XML RAW('Employee'), ELEMENTS;

-->(B)
SELECT *
FROM HumanResources.Employee
FOR XML RAW('Employee');

--------------------------------------------------------------------------------------------------

--10.	Display Each Department Name with its instructors. “Use ITI DB”
	--A)	Use XML Auto
	--B)	Use XML Path

use	ITI;


-->(A):
SELECT d.Dept_Name,i.Ins_Name
FROM Department d inner join Instructor i 
ON d.Dept_Id = i.Dept_Id
FOR XML AUTO, ROOT('Departments');


-->(B):
select d.Dept_Name as "@name",
    (select i.Ins_Name AS "InstructorName"
     FROM Instructor i
     WHERE i.Dept_Id = d.Dept_Id
     FOR XML PATH('Instructor'), TYPE
	) AS "Instructors"
FROM Department d
FOR XML PATH('Department'), ROOT('Departments');


-------------------------------------------------------------------------

