use pubs

select * from publishers
select * from authors
select * from titles
select * from sales
select * from titleauthor

sp_help authors
sp_help publishers
sp_help sales
sp_help titles
--1
create proc proc_author(@fname varchar(20),@lname varchar(20))
as
begin
select title_id from sales where title_id in
(select title_id from titleauthor where au_id in
(select au_id from authors where au_fname=@fname and au_lname=@lname))
end

exec proc_author 'Charlene','Locksley'

--2
select pub_name,au_fname,au_lname,price from authors,titles,publishers join titleauthor on 
titleauthor.title_id = title_id

--3
declare @pname varchar(20),@titles varchar(80),@au_name varchar(20),@qty smallint,@date datetime
declare cur_pub cursor for
select pub_name,au_lname,title,qty,ord_date from authors,titles,publishers join sales on
sales.title_id = title_id

open cur_pub

fetch next from cur_pub
into @pname,@titles,@au_name,@qty,@date

print 'data:'

while @@FETCH_STATUS = 0
begin
print  'Publisher name: ' + cast(@pname as varchar(20))
print  'aurthor name: ' + cast(@au_name as varchar(20))
print  'Title name: ' + cast(@titles as varchar(80))

end

close cur_pub
deallocate cur_pub

--4
create table account
(account_number varchar(20) primary key,
account_name varchar(20),
balance float,
status varchar(20) default 'open')

create table transactions(tran_id int primary key,
from_acc int,
to_acc int,
amount float,
remarks varchar(20),
account_number varchar(20) references account(account_number))

--4a
insert into account values('9182735','surya',1600,'open')
insert into account values('9182736','prakash',1100,'open')
insert into account values('9182737','reddy',2000,'blocked')

begin transaction
if((select balance from account)<1500)
rollback
else
commit

select * from account

--4b
begin transaction
if((select status from account)='blocked')
rollback
else
commit

select amount from transactions

--5
create trigger trg_calculate
on transactions
after insert
as begin
declare
@total float
set @total = ((select (balance-amount) from insetred) join tranasactions on where tranansactions.tran_id=tran_id)
print('Amount deducted')
end