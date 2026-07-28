
Use iti;

------------------------------------------

--1.	Create a scalar function that takes date and returns Month name of that date.

create function getmonth (@date date)
returns nvarchar(20)
	begin
		declare @month nvarchar(20)
		select @month = datename(month, @date)
		return @month
	end;

--to run the function:
select dbo.getmonth ('10-10-2004') ;


----------------------------------------------------


--2.	 Create a multi-statements table-valued function that takes 2 integers and returns the values between them.

create function getvaluesbetween (@start int, @end int)
returns @between table
						(
						values_between int
						)
as 
	begin
		while @start < @end
			begin
				set @start += 1
				if @start = @end
				break
				insert into @between
				values (@start)
			end
		return
	end;

--to run the function:
select * from dbo.getvaluesbetween (1, 7);


---------------------------------------------------

--3.	 Create inline function that takes Student No and returns Department Name with Student full name.

create function get_deptn_and_sn (@stud_n int)
	returns table
	as return
		(
			select d.Dept_Name, s.St_Fname + ' '+s.St_Lname as student_full_name
			from Department d inner join stud.Student s
			on s.Dept_Id = d.Dept_Id
			where @stud_n = s.St_Id
		);

-- to run the function:
select * from dbo.get_deptn_and_sn (3);


----------------------------------------------

--4.	Create a scalar function that takes Student ID and returns a message to user :
	--a.	If first name and Last name are null then display 'First name & last name are null'
	--b.	If First name is null then display 'first name is null'
	--c.	If Last name is null then display 'last name is null'
	--d.	Else display 'First name & last name are not null'


create function know_name (@stud_id int)
returns varchar(40)
	begin
		declare @message varchar(40)
			select @message =
				case 
					when st_fname is null and st_lname is null then 'First name & last name are null'
					when st_fname is null then 'first name is null'
					when st_lname is null then 'last name is null'
					else 'First name & last name are not null'
				end 
			 from stud.Student 
			 where @stud_id = stud.Student.St_Id
		return @message
	end;

--to run the function :
select dbo.know_name (5);

---------------------------------------------------



--5.	Create inline function that takes integer which represents manager ID and displays department name, Manager Name and hiring date 

create function get_manager (@mid int)
returns table
as return
		(
			select d.Dept_Name, i.Ins_Name, d.Manager_hiredate
			from Department d inner join Instructor i
			on i.Ins_Id = d.Dept_Manager
			where @mid = d.Dept_Manager
		);


--to run the function :
select * from dbo.get_manager(5);


-------------------------------------------------------------------

--6.	Create multi-statements table-valued function that takes a string
	--If string='first name' returns student first name
	--If string='last name' returns student last name 
	--If string='full name' returns Full Name from student table 
	--Note: Use “ISNULL” function


create function gt_studname  (@format varchar(20))
returns @studname table
	(stud_name varchar(30))
as
	begin
		if @format = 'first name'
			insert into @studname
			select isnull(St_Fname,' ')
			from stud.Student
		else if @format = 'last name'
			insert into @studname
			select isnull(St_Lname,' ')
			from stud.Student
		else if @format = 'full name'
			insert into @studname
			select isnull(St_Fname,' ')+ ' '+ isnull(St_Lname,' ') as full_name 
			from stud.Student
	return
end;


--to run the function:
select * from dbo.gt_studname ('full name');


-----------------------------------------------------------------------------


--7.	Write a query that returns the Student No and Student first name without the last char

select St_Id, substring(st_fname,1,len(St_Fname)-1)
from stud.Student;


----------------------------------------------------------------------------


--8.	Wirte query to delete all grades for the students Located in SD Department 

update sc
set sc.Grade = null
from Stud_Course sc inner join stud.Student s
on s.St_Id = sc.St_Id
inner join Department d
on d.Dept_Id = s.Dept_Id
where d.Dept_Name = 'SD'
