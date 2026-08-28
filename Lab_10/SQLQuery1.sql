use Company_SD;


---------------------------------------

--1.	Create a cursor for Employee table that increases Employee salary by 10% if Salary <3000 and increases it by 20% if Salary >=3000. Use company DB


Declare c cursor
for select Salary
	from Employee
for update 
declare @sal int
open c
fetch c into @sal
while @@FETCH_STATUS=0
		begin
			if @sal >=3000
			update Employee
			set Salary = Salary*1.20
			where current of c
		else	
			update Employee
			set Salary = Salary*1.10
			where current of c
			fetch c into @sal
		end
close c
deallocate c;


----------------------------------------------------------------------

--2.	Display Department name with its manager name using cursor. Use ITI DB


use ITI;


declare c cursor 
for select i.Ins_Name, d.Dept_Name
from Department d inner join Instructor i
on i.Ins_Id=d.Dept_Manager
for read only
declare @inst varchar(20), @dept varchar(20)
open c
fetch c into @inst, @dept
while @@fetch_status=0
	begin 
		select @inst, @dept
		fetch c into @inst, @dept
	end
close c
deallocate c;



-------------------------------------------------------------------------------

--3.	Try to display all students first name in one cell separated by comma. Using Cursor 

declare c cursor
for select St_Fname
	from Student
	where St_Fname is not null
for read only 
declare @name varchar(20), @allnames varchar(300)
open c
fetch c into @name
while @@FETCH_STATUS = 0
	begin
		set @allnames = concat(@allnames, ',', @name)
		fetch c into @name
	end
	select @allnames
close c
deallocate c;

--------------------------------------------------------------------------------------------------

--4.	Create full, differential Backup for iti DB.

backup database iti 
to disk = 'D:\Course\GitHub\ITI-SQL-ENG.Ramy\Lab_10\iti_full_backup.bak'
With FORMAT, Name = 'Full Backup of iti database';

backup database iti 
to disk = 'D:\Course\GitHub\ITI-SQL-ENG.Ramy\Lab_10\iti_differential.bak'
with differential, name = 'Differential Backup of iti database';



