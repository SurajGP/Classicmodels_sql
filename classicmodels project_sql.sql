-- Database source -
-- https://raw.githubusercontent.com/harsha547/ClassicModels-Database-Queries/master/database.sql

-- List the customers in the United States with a credit limit higher than $1000

select customername,creditlimit from customers where creditlimit > 1000 and country = "usa"
order by creditlimit;

-- List the employee codes for sales representatives of customers in Spain, France and Italy. Make another query to list the names and email addresses of those employees.

select distinct salesRepEmployeeNumber from customers
where country  = "spain" or country = "france" or country = "italy" ; 

create view t1 as (select distinct salesRepEmployeeNumber from customers
where country  = "spain" or country = "france" or country = "italy");
select concat(firstname," ",lastname) as employee_name from employees join t1 on 
salesRepEmployeeNumber = employeeNumber; 


-- Change the job title "Sales Rep" to "Sales Representative"

update  employees
set jobTitle = "Sales Representative" where jobtitle = "sales rep";
select * from employees;

-- Delete the entries for Sales Representatives working in London.
SET foreign_key_checks=0;
delete  from employees where jobtitle = "sales representative" and officecode in
(select officecode from offices where city = "london");

-- Show a list of employees who are not sales representatives

select * from employees where jobtitle !="sales representative";

-- Show a list of customers with "Toys" in their name

select * from customers where customername like "%toys%";

-- List the 5 most expensive products from the "Planes" product line

select productname,buyprice from products where productline = "planes"
order by buyprice desc
limit 5;

-- Identify the products that are about to run out of stock (quantity in stock < 100)

select productname,quantityInStock from products 
where quantityInStock <100;

-- List 10 products in the "Motorcycles" category with the lowest buy price and more than 1000 units in stock

select productname,buyPrice,quantityInStock from products where quantityinstock > 1000 and productline = "motorcycles"
order by buyprice asc
limit 10;

-- Report the total number of payments received before October 28, 2004.

select count(*) from payments 
where paymentdate < "2004-10-28";

-- Report the number of customer who have made payments before October 28, 2004.

select count( distinct customernumber) from payments
where paymentDate< "2004-10-28";

-- Retrieve the list of customer numbers for customer who have made a payment before October 28, 2004.

select  distinct customernumber from payments
where paymentDate< "2004-10-28"
order by customernumber;

-- Retrieve the details all customers who have made a payment before October 28, 2004.

select * from customers where customernumber in (
select  distinct customernumber from payments
where paymentDate< "2004-10-28"
order by customernumber) ;

-- Retrieve details of all the customers in the United States who have made payments between April 1st 2003 and March 31st 2004.

select * from customers where customernumber in (
select  distinct customernumber from payments
where paymentDate> "2003-04-01" and paymentDate< "2004-03-31" and country = "usa"
order by customernumber);

--  Find the total number of payments made by  each customer before October 28, 2004.

select customernumber,count(*) as "Totalpayments" from payments
where paymentDate> "2004-10-028"
group by customernumber;

-- Find the total amount paid by each customer payment before October 28, 2004.

select customernumber, round(sum(amount),0) as "Totalpayments" from payments
where paymentDate> "2004-10-028"
group by customernumber;

-- Determine the total number of units sold for each product.

select productName, sum(quantityOrdered) as total_orders  from products
join orderdetails on orderdetails.productcode = products.productcode
group by productName
order by total_orders;

-- Find the total no. of payments and total payment amount for each customer for payments made before October 28, 2004.

select customername,round(sum(amount),1) as total_amount,count(amount) as no_payments from payments
join customers
on customers.customerNumber = payments.customernumber 
where paymentdate < "2004-10-28"
group by customername
order by no_payments desc;

-- Modify the above query to also show the minimum, maximum and average payment value for each customer.

select customername,
count(amount) as no_payments,
round(sum(amount),1) as total_amount,
round(max(amount),1) as max_amount,
round(min(amount),1) as min_amount,
round(avg(amount),1) as avg_amount from payments
join customers
on customers.customerNumber = payments.customernumber 
where paymentdate < "2004-10-28"
group by customername
order by no_payments desc;

-- Retrieve the customer number for 10 customers who made the highest total payment in 2004.

select customernumber,round(sum(amount),1) as total_payment from payments
group by customernumber
order by total_payment desc
limit 10;

-- Retrieve the next 10 customer numbers

select customernumber,round(sum(amount),1) as total_payment from payments
group by customernumber
order by total_payment desc
limit 10
offset 10;

-- Display the full name of point of contact each customer in the United States in upper case, along with their phone number, sorted by alphabetical order of customer name.

select distinct concat(upper(contactfirstname)," ",upper(contactlastname)) as contact_persons,phone from customers where country = "usa";

-- Display a paginated list of customers (sorted by customer name), with a country code column. The country is simply the first 3 letters in the country name, in lower case.

select customername,substr(country,1,3) from customers
order by customername;

-- Display the list of the 5 most expensive products in the "Motorcycles" product line with their price (MSRP) rounded to dollars.

select productname as "Product name",round(msrp,0) as MSRP_price from products where productline ="motorcycles"
order by msrp desc
limit 5;

-- Display the product code, product name, buy price, sale price and profit margin percentage ((MSRP - buyPrice)*100/buyPrice) for the 10 products with the highest profit margin. Round the profit margin to 2 decimals.

select productcode,productname,buyprice, msrp, 
round((((msrp-buyprice)*100)/buyprice),2) as profit_margin
from products
order by profit_margin  desc
limit 10;

-- List the largest single payment done by every customer in the year 2004, ordered by the transaction value (highest to lowest).

select customernumber, round(max(amount)) as max_transaction_value from payments
where year(paymentdate) = 2004
group by customernumber
order by max_transaction_value desc;

-- Show the total payments received month by month for every year.

select year(paymentdate) as "year", month(paymentdate) as "month",monthname(paymentdate) as "month_name", round(sum(amount)) as total_payments
from payments
group by year, month
order by year, month;

-- For the above query, format the amount properly with a dollar symbol and comma separation (e.g $26,267.62), and also show the month as a string.

select year(paymentdate) as "year", month(paymentdate) as "month",
concat("$"," ",format((round(sum(amount))),0)) as total_payments
from payments
group by year, month
order by year, month;

-- Retrieve the detials of customers wh have never purchased anything at classicmodels. 
select  customername,customers.customernumber,paymentdate from payments
right join customers on payments.customernumber = customers.customernumber
where paymentdate is null ;



