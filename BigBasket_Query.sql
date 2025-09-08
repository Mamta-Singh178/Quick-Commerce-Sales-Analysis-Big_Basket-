use big_basket;
select * from customers;
select * from transactions;
select * from churn;
select * from subscriptions;

##1. Total how many customers we have?
select * from customers;

##2. Show the first name, last name & the status of all the customers
select FirstName, LastName, Status from customers;

##3. Retrieve the details of all the customers from "North America" region

select count(*) as total_customers from customers  
where region = "North America";

##4. Find out those customers with Active Status
select count(*) as total_active_customers from customers 
where status = "Active";

##5. How many customers are there who joined after January 1, 2001
select count(*) from customers where JoinDate > "01-01-2001";

##6. List down the active customer from Europe
select count(*) from customers
where region = "Europe" and status = "Active";

SET SQL_SAFE_UPDATES=0;

UPDATE customers
SET JoinDate = STR_TO_DATE(JoinDate, '%d-%m-%Y')
WHERE JoinDate LIKE '%-%-%';

UPDATE transactions
SET TransactionDate = STR_TO_DATE(TransactionDate, '%d-%m-%Y')
WHERE TransactionDate LIKE '%-%-%';

##7. Find out how many customer have joined the platform in the year 2021
select count(*) as customers_joined_in_2021 from customers 
where Year(JoinDate) = 2021;

select count(*) from customers 
where JoinDate between '2021-01-01' and '2021-12-31';

##8. Count of customers whoe are having an email id containing 'example'

##9. Retrieve the number of customer who are having an annual subscription plan.

##10. Retrieve all the transaction where the amount is greater than $100.

##11. Calculate the average amount of all transactions
select avg(amount) from transactions;

##12. Retrieve all the transactions along with the first name,last name, transaction id, transaction amount
select FirstName, LastName, TransactionID, Amount 
from customers c 
join transactions T
on c.customerID = T.customerID;

##13. Find out the 5 most recent transactions
select * from Transactions
order by TransactionDate desc
limit 5;

##14. Retrieve all the reasons for churn
select distinct reason from churn;

##15. List the churn reasons and customer left from each of the reasons
select count(*), reason 
from churn
group by reason; 

##16. Retrieve customerID, Full Name,Email, Plan type
select c.customerID, concat(c.FirstName," ",c.LastName) as FUll_Name, c.email, s.PlanType
from customers c
join subscriptions s
on c.customerID = s.customerID;

##17. Retrieve active customers who have an annual subscription
select count(*) as total_annual_active_customers
from customers  c
join subscriptions  s
where c.status= 'Active' and s.PLanType = 'Annual';

##18. List down the churn reasons & the how many north american customers has left from each reason?
select ch.reason, count(*) as churn_customer
from customers c
join churn ch
on c.customerID = ch.customerID
where c.region = 'North America'
group by ch.reason;

##19. How many customers who have chruned & have made transaction.
select count(*) as churned_customers_with_transactions
from churn c
join transactions t
on c.customerID = t.customerID;

##20. Retrieve all the customer who have not made any transaction with us.
select count(*) as customers_without_any_transaction
from customers c
left join transactions t
on c.customerID = t.customerID
where t.transactionID is null;

## 21. Find out the customers who have more than one subscription

with cte as (
select count(c.customerid) from customers c
join subscriptions s
on c.CustomerID = s.CustomerID
group by c.CustomerID
having count(s.PlanType) > 1)
select count(*) as count_of_customers from cte;

