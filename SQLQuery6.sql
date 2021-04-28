--scalar function 
create function fun(@Basic float,@Hra float,@Da float,@deductions float)
returns float
as begin
declare
@netsal float
set @netsal = @Basic+@Hra+@Da-@deductions
return @netsal
end

select Basics,Hra,Da,deductions,dbo.fun(Basics,Hra,Da,deductions) 'net total' from Salaries


--tvf function
create function Funs(@empid int)
returns @salTable Table
(ename varchar(15),
TotalSal float,
tax float)
as begin 
declare
@total float,
@tax float,
@taxpayable float,
@Ename varchar(15)
set @total = (select sum(Basics+hra+da-deductions) as total_salary from Employe join Salaries on Employe.salary_id = sal_id where Employe.emp_id=@empid)
if(@total>1000)
set @tax = 0
else if(1000 > @total and @total > 2000)
set @tax =5
else
set @tax =10
set @taxpayable = @total*@tax/100
set @Ename = (select Name from Employee1 where emp_id = emp_id)
insert into @salTable values(@Ename,@taxpayable,@total)
return
end

select * from dbo.Funs(100)

select * from Employe

create table EmployeeNetSal
(transaction_id int,
netSal float)

create table dtbldummy
(f1 int,
f2 varchar(20))

create trigger trgInsert
on dtbldummy
after insert
as begin
select 'hello there!!!'
end

select * from dtbldummy

insert into dtbldummy values(2,'ramu')
insert into dtbldummy values(3,'ammu')

drop trigger trgInsert

drop trigger  trigInsert

create trigger trgInsertDummy
on dtbldummy
after insert
as begin
select concat('hello there!!!',f2) from inserted
end

select * from dtbldummy

insert into dtbldummy values(1,'surya');
update dtbldummy set f1 = 1 where f2 = 'ramu';
delete from dtbldummy where f2 = 'surya'


select * from EmployeeNetSal
select * from Salaries
select * from Employe

create trigger trg_insertNetSal
on Employe
after insert 
as begin
declare
@totalSal float
set @totalSal = (select dbo.Fun(Basics,Hra,Da,deductions) from Salaries where emp_id = 
(select salary_id from inserted))
insert into EmployeeNetSal values((select transaction_id from inserted),@totalSal)
end

insert into EmployeeNetSal values('ae567',104,201,'2011-03-28')


create function fon(@gender varchar(20))
returns varchar(20)
as begin
return @gender
end

select gender,dbo.fon(gender) from Employee1

create trigger trg_names
on Employee1
after insert
as begin
if((select gender from inserted) != 'Male')
select concat('Miss.',name,'Welcome') from inserted
else
select concat('Mr.',name,'Welcome') from inserted
end

insert into Employee1 values('surya',20,'9182735902','Male')

select * from Employee1
select * from Employe
--transaction
begin transaction 
insert into Employee1 values('Reddy','30','9182735902','Male')
insert into Employe values('fe300',104,201,'2018-09-19')
if((select max(emp_id) from Employe)=111)
commit
else
rollback

--cuesor
declare @eid int,@ename varchar(20)
declare cur_employee cursor for
select emp_id,name from Employee1

open cur_employee

fetch next from cur_employee
into @eid,@ename

print 'Employee Data'

while @@FETCH_STATUS =0
begin
print 'Employee id: '+cast(@eid as varchar(10))
print 'Employee name:'+@ename
print '-----------------------'
fetch next from cur_employee
into @eid,@ename
end

close cur_employee
deallocate cur_employee

--curesor2
declare @eid int,@ename varchar(20)
declare cur_employee cursor for
select emp_id,name from Employee1

open cur_employee

fetch next from cur_employee
into @eid,@ename

print 'Employee Data'

while @@FETCH_STATUS =0
begin
print 'Employee id: '+cast(@eid as varchar(10))
print 'Employee name:'+@ename
print '-----------------------'
--declare @basic float,@Hra float,@Da float,@deductions float
declare @sid int,@date date,@total float
declare cur_empsal cursor for
select salary_id,dates from Employe where emp_id = @eid

open cur_empsal

fetch next from cur_empsal into @sid,@date
print '####################'
print 'salay details'
while @@FETCH_STATUS = 0
begin
set @total=(select (Basics+Hra+Da-deductions) from Salaries where sal_id = @sid)
print 'date: ' + cast(@date as varchar(20))
print 'net salary:' +cast(@sid as varchar(20))
fetch next from cur_empsal into @sid,@date
end
print '#############'
close cur_empsal
deallocate cur_sal
fetch next from cur_employee
into @eid,@ename
end

close cur_employee
deallocate cur_employee
