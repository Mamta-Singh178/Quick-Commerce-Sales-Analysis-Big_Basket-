--Q1. Total number of customers

select COUNT(*) as Total_Customers
from Customers;


--Q2.Total number of transactions

select COUNT(*) as Total_Transactions
from Transactions;


--Q3.Total revenue generated

select sum(Amount) as Total_Revenue
from Transactions;


--Q4.Average transaction value

select round(avg(Amount),2) as Avg_Transaction_Value
from Transactions;

--Customer Insights (Engagement & Growth)

--Q5. Number of unique customers who made purchases

select count(distinct CustomerID) as Unique_Customers
from Transactions;


--Q6. Customers who made more than 1 transaction (repeat customers)

select CustomerID, count(*) as Transaction_Count
from Transactions
group by CustomerID
having count(*) > 1;


--Q7.Top 5 customers by total spend

select CustomerID, sum(Amount) as Total_Spent
from Transactions
group by CustomerID
order by Total_Spent desc
limit 5;


--Q8. Categorize customers as VIP / Regular / Low Spenders

select CustomerID,sum(Amount) as Total_Spent,
       case 
           when sum(Amount) >= 150 then 'VIP'
           when sum(Amount) between 80 and 149 then 'Regular'
           else 'Low_Spender'
       end as Customer_Category
from Transactions
group by CustomerID
order by Total_Spent desc;

--Revenue Insights (Pareto & Quartiles)

--Q9. Which 20% of customers contribute 80% of revenue (Pareto principle)

with Customer_Revenue as (
    select CustomerID, sum(Amount) as Total_Spent
    from Transactions
    group by CustomerID
),
Ranked as (
    select CustomerID, Total_Spent,
           sum(Total_Spent) over (order by Total_Spent desc) as Running_Total,
           sum(Total_Spent) over () as Total_Revenue
    from Customer_Revenue
)
select CustomerID, Total_Spent,
       (Running_Total / Total_Revenue) * 100 as Cumulative_Percent
from Ranked
order by Total_Spent desc;

--Q10. Revenue contribution by transaction quartiles (low vs. high spenders)

with Quartiles as (
    select TransactionID, CustomerID, Amount,
           ntile(4) over (order by Amount) as Quartile
    from Transactions
)
select Quartile, count(*) as Num_Transactions,
       sum(Amount) as Revenue
from Quartiles
group by Quartile
order by Quartile;

--Risk & Churn Indicators

--Q11. One-time vs Repeat customers revenue contribution

select 
    case when cnt = 1 then 'One-time Customer' else 'Repeat Customer' end as Customer_Type,
    count(CustomerID) as Num_Customers,
    sum(Total_Spent) as Revenue
from (
    select CustomerID, count(*) as cnt, sum(Amount) as Total_Spent
    from Transactions
    group by CustomerID
) t
group by Customer_Type;


--Q12. Outlier customers (spending 2+ standard deviations above average)

select CustomerID, sum(Amount) as Total_Spent
from Transactions
group by CustomerID
having sum(Amount) > (
    select avg(Total_Spent) + 2 * stddev(Total_Spent)
    from (
        select CustomerID, sum(Amount) as Total_Spent
        from Transactions
        group by CustomerID
    ) sub
);

--Trends & Growth

--Q13. Monthly revenue trend

select date_format(TransactionDate, '%Y-%m') as Month,
       sum(Amount) as Monthly_Revenue
from Transactions
group by Month
order by Month;


--Q14. Average transaction size over time

select date_format(TransactionDate, '%Y-%m') as Month,
       avg(Amount) as Avg_Transaction_Value
from Transactions
group by Month
order by Month;

--Advanced Business Value

--Q15. Customer Lifetime Value (CLV) approximation

select CustomerID, sum(Amount) as Customer_Lifetime_Value
from Transactions
group by CustomerID
order by Customer_Lifetime_Value desc;


--Q16. Top 3 customers in each quartile by spending (ranking insight)

with Ranked as (
    select CustomerID, sum(Amount) as Total_Spent,
           ntile(4) over (order by sum(Amount)) as Quartile
    from Transactions
    group by CustomerID
)
select *
from (
    select CustomerID, Total_Spent, Quartile,
           row_number() over (partition by Quartile order by Total_Spent desc) as rn
    from Ranked
) t
where rn <= 3;


--Q17. Average revenue per customer segment (VIP vs Regular vs Low Spender)

with Segments as (
    select CustomerID, sum(Amount) as Total_Spent,
           case 
               when sum(Amount) >= 150 then 'VIP'
               when sum(Amount) between 80 and 149 then 'Regular'
               else 'Low Spender'
           end as Customer_Category
    from Transactions
    group by CustomerID
)
select Customer_Category, count(*) as Num_Customers, avg(Total_Spent) as Avg_Revenue
from Segments
group by Customer_Category;


--Q18. Contribution of top 10% customers to total revenue

with Ranked as (
    select CustomerID, sum(Amount) as Total_Spent,
           rank() over (order by sum(Amount) desc) as Rank_By_Spend,
           count(distinct CustomerID) over () as Total_Customers
	from Transactions
    group by CustomerID
)
select sum(TotalSpent) as Top10_Percent_Revenue,
       (sum(TotalSpent) / (select sum(Amount) from Transactions)) * 100 as Revenue_Share
from Ranked
where Rank_By_Spend <= TotalCustomers * 0.1;


--Q19. Median transaction value

select avg(Amount) as Median_Transaction_Value
from (
    select Amount
    from Transactions
    order by Amount
    limit 2 - (select count(*) from Transactions) % 2    -- if odd count, pick middle
    offset (select (count(*) - 1) / 2 from Transactions)
) as sub;


--Q20. Customer churn proxy (customers with no transactions in last 6 months)

select c.CustomerID, c.FirstName, c.LastName
from Customers c
left join Transactions t
on c.CustomerID = t.CustomerID
where t.TransactionDate < date_sub(curdate(), interval 6 month)
   or t.TransactionID is null;
