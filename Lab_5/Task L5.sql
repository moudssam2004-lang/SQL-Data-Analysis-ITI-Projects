--Part-1: Use ITI DB

use iti;

--1.	Retrieve number of students who have a value in their age. 
select count(St_Id) from Student
where st_age is not null;

--2.	Get all instructors Names without repetition
select distinct Ins_Name from Instructor;

--3.	Display student with the following Format (use isNull function)
--StudentID	Student Full Name	Department name
select St_Id, 
concat(isnull(St_Fname,' ' ) , ' ' ,isnull( St_Lname, ' ')) as st_full_name,
(isnull (Dept_Name, 'no_depatrtment')) as department_name
from student s inner join department d
on d.Dept_Id = s.Dept_Id;

--4.	Display instructor Name and Department Name 
--Note: display all the instructors if they are attached to a department or not
select Ins_Name, (isnull (Dept_Name, 'no_department'))
from Instructor i left join Department d
on d.Dept_Id = i.Dept_Id;

--5.	Display student full name and the name of the course he is taking
--For only courses which have a grade  
select CONCAT(St_Fname, ' ', St_Lname) as fullname, Crs_Name
from Student s 
inner join Stud_Course sc on sc.St_Id = s.St_Id
inner join Course c on c.Crs_Id = sc.Crs_Id
where Grade is not null;


--6.	Display number of courses for each topic name
select COUNT (c.top_id), t.Top_Name
from Course c inner join Topic t
on t.Top_Id = c.Top_Id
group by c.top_id , t.Top_Name;

--7.	Display max and min salary for instructors
select max(Salary), min(Salary)
from Instructor;

--8.	Display instructors who have salaries less than the average salary of all instructors.
select * 
from Instructor
where Salary <
	(
	select AVG(salary) from Instructor
	)

--9.	Display the Department name that contains the instructor who receives the minimum salary.
select Dept_Name 
from Department d inner join Instructor i
on i.Dept_Id = d.Dept_Id
where i.Salary in 
	(select min(salary) from Instructor);
	

--10.	 Select max two salaries in instructor table. 
select top(2) salary 
from Instructor
order by salary desc;


--11.	 Select instructor name and his salary but if there is no salary display instructor bonus. “use one of coalesce Function”
select Ins_Name, coalesce(Salary, 0) as income
from Instructor;
--here (0) is an alternate for the word bonus.

--12.	Select Average Salary for instructors 
select avg(salary) as avarage_salary
from Instructor;

--13.	Select Student first name and the data of his supervisor 
select stud.St_Fname as student_name, super.*
from Student stud  inner join student super
on stud.St_super = super.St_super;


--14.   Write a query to select the highest two salaries in each department for instructors who have salaries.
--"using one of ranking functions"
select * from 
	(
	select *, row_number() over (partition by dept_id order by salary desc) as sal_per_dept
	from Instructor
	where Salary is not null
	) as New_table
where sal_per_dept <= 2;

--15.	 Write a query to select a random  student from each department.  “using one of Ranking Functions”
select * from
	(
	select *, row_number() over (partition by dept_id order by newid()) as rn
	from Student
	) as Random_students
where rn =1;

------------------------------------------------------------
--Part-2: Use AdventureWorks DB

use AdventureWorks2012;

ALTER AUTHORIZATION ON DATABASE::AdventureWorks2012 TO sa; --To change the db owner to SA.

--1.	Display the SalesOrderiD, ShipDate of the SalesOrderHeader table (Sales schema) to designate SalesOrders 
--that occurred within the period ‘7/28/2002’ and ‘7/29/2014’

select SalesOrderID, ShipDate
from sales.salesorderheader
where OrderDate between '2002-07-28' and '2014-07-29';


--2.	Display only Products(Production schema) with a StandardCost below $110.00 (show ProductID, Name only)

select ProductID, Name
from Production.Product
where StandardCost < 110.00;


--3.	Display ProductID, Name if its weight is unknown

select ProductID, Name
from Production.Product
where Weight is null;


--4.	 Display all Products with a Silver, Black, or Red Color

select *
from Production.Product
where Color in ('silver','black','red');


--5.	 Display any Product with a Name starting with the letter B

select * 
from Production.Product
where name like 'B%';


--6.	Run the following Query:
UPDATE Production.ProductDescription
SET Description = 'Chromoly steel_High of defects'
WHERE ProductDescriptionID = 3
--Then write a query that displays any Product description with underscore value in its description.

select * 
from Production.ProductDescription
where Description like '%[_]%';



--7.	Calculate sum of TotalDue for each OrderDate in Sales.SalesOrderHeader table 
--for the period between  '7/1/2001' and '7/31/2014'

select OrderDate, sum(totaldue) as sum_total_due
from Sales.SalesOrderHeader
where OrderDate between '2001-07-01' and '2014-07-31'
group by OrderDate;


--8.	 Display the Employees HireDate (note no repeated values are allowed)

select distinct HireDate
from HumanResources.Employee;


--9.	 Calculate the average of the unique ListPrices in the Product table

select avg(distinct ListPrice) as avg_unique_price
from Production.Product;


--10.	Display the Product Name and its ListPrice within the values of 100 and 120 the list should has the following format:
--"The [product name] is only! [List price]" (the list will be sorted according to its ListPrice value)

select concat('The ', name, ' is only! ', ListPrice) as P_name_and_price
from Production.Product
where ListPrice between 100 and 120
order by ListPrice;


--11.	a)	 Transfer the rowguid ,Name, SalesPersonID, Demographics from Sales.Store table  in a newly created table named [store_Archive]
--Note: Check your database to see the new table and how many rows in it?
--b)	Try the previous query but without transferring the data? 

select rowguid, Name, SalesPersonID, Demographics into store_Archive
from Sales.Store;

select count(*) as number_of_rows
from store_Archive;

select rowguid, Name, SalesPersonID, Demographics into store_Archive_empty
from Sales.Store
where 0=1;


--12.	Using union statement, retrieve the today’s date in different styles

select cast(getdate() as varchar(20)) as date_styles --converting date dt to char dt to union them
union
select format(getdate(), ('dd-mm-yyyy'))
union
select format(getdate(), ('ddd-mmm-yy'))
union
select format(getdate(), ('dddd-mmmm-yyyy'))
union
select format(getdate(), ('mm-dd-yyyy'))

