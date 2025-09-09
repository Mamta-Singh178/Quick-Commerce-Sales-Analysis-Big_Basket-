# SQL:Customer & Transactions_Analysis

**Project Overview**

This project focuses on analyzing a customer–transactions dataset using SQL to derive business insights such as revenue growth, customer segmentation, churn analysis, and spending behavior.

-----------------------------------------------------------------------------------------------------
**Datataset Details**

1.Customers Table :
[CustomerID, FirstName, LastName, Region, Status, JoinDate, Email]

2.Transactions Table :
[TransactionID, CustomerID, Amount, TransactionDate, TransactionType]

3.Subscriptions Table :
[SubscriptionID, CustomerID, PlanType, StartDate, EndDate]

4.Churn Table :
[CustomerID, Reason]

-----------------------------------------------------------------------------------------------------
**Business Questions Solved**

**--Basic Analysis**

1.Total number of customers & transactions

2.Total revenue & average transaction value

3.Customers from specific regions (e.g., North America, Europe)

4.Active vs. Inactive customers

5.Customers joined in a specific year

**--Intermediate Analysis (Customer & Revenue Insights)**

6.Top 5 customers by spending

7.Customers with repeat purchases vs. one-time buyers

8.Active customers with annual subscription plans

9.Number of churned customers by reason & region

10.Transactions above $100

**--Advanced Analysis (Strategic Growth Focus)**

11.Pareto analysis (Which 20% of customers drive 80% of revenue)

12.Revenue distribution by transaction quartiles

13.Monthly revenue trend & average transaction values

14.Customer segmentation (VIP, Regular, Low Spenders)

15.Outlier analysis (High-value spenders)

16.Churned customers who made transactions before leaving

17.Customers making purchases after subscription expiry

18.Churn rate (%) per plan type

19.Customer Lifetime Value (CLV) estimation

20.Top 10% customers’ contribution to total revenue

----------------------------------------------------------------------------------------------------

**Business Impact**

1.Helps marketing teams identify high-value customers (VIPs) for loyalty programs.

2.Provides product managers insights into churn reasons → reduces customer attrition.

3.Assists finance teams in forecasting monthly revenue and planning budgets.

4.Guides strategy teams in applying Pareto principle to maximize ROI from top customers.
