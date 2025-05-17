# DataAnalytics-Assessment


## Overview
This repository contains SQL solutions for the Data Analytics Assessment. Each query was written using MySQL and designed to solve a specific business or data problem. 
The solutions are divided into individual SQL files for clarity, each answering one question.


## Question Explanations

### Assessment_Q1.sql – High-Value Customers with Multiple Products

**What I did:**
I selected customers who have funded at least one savings plan and one investment plan. I counted how many of each product type (savings or investment) they had and summed up the confirmed deposit amounts.

**Why this logic works:**
By using `CASE WHEN` conditions inside `COUNT()`, I filtered only savings or investment plans. Then I used `HAVING` to return only those customers who had at least one of each type. 
Finally, I used `SUM()` to calculate total deposits.


### Assessment_Q2.sql – Transaction Frequency Analysis

**What I did:**
I first calculated the number of transactions each customer made every month using a `GROUP BY` on year and month. Then I calculated each customer's average monthly transactions. I categorized them as High (10+), Medium (3–9), or Low (below 3) frequency customers and counted how many fell into each group.

**Why this logic works:**
This approach helps understand customer engagement by transaction behavior over time. Grouping by month and averaging provides a fair view across different customer activity levels. Categorizing helps stakeholders easily identify target groups.


### Assessment_Q3.sql – Account Inactivity Alert

**What I did:**
I identified all savings and investment plans, then checked when each one had its last transaction. I filtered for those whose last transaction was over 365 days ago (or had no transaction at all).

**Why this logic works:**
Using `MAX(transaction_date)` helps me find the latest activity per plan. I then used `DATEDIFF()` to calculate how long it's been since that date. Using `HAVING` ensures I only return plans with over 1 year of inactivity — useful for triggering alerts.


### Assessment_Q4.sql – Customer Lifetime Value (CLV) Estimation

**What I did:**
I calculated how long each customer has been with the company (in months), counted all their transactions, and used a simplified formula given to estimate their CLV. The formula multiplies their monthly transaction rate by an assumed profit and annualizes it.

**Why this logic works:**
The CLV formula simulates a customer’s future value based on their past activity. Dividing transactions by tenure gives their monthly average, multiplying by 12 gives yearly activity, and the profit rate gives a financial estimate. It’s a useful KPI for marketing teams.


## Challenges Faced

### 1. Handling Conditional Logic and NULL Names in Q1:
I initially struggled with how to count only savings or investment plans when they were stored in the same table. I solved this by using `CASE WHEN` inside `COUNT()` to filter each type. 
Also, I noticed that some users had `NULL` in the `name` column, which made the output look incomplete. To fix this, I used the `COALESCE()` function to fall back to a combination of `first_name` and `last_name` when `name` was missing.

### 2. Dealing With Time-Based Grouping in Q2:
Grouping by year and month was tricky at first because I needed to track customer activity on a monthly basis. I resolved this by applying `YEAR()` and `MONTH()` functions in the `GROUP BY` clause to get distinct transaction counts per month.

### 3. Managing NULLs and Inactivity in Q3:
Some accounts had no transactions at all, which caused `MAX(transaction_date)` to return `NULL`. This was a challenge because I needed to find inactive plans. I handled it by checking for `NULL` explicitly and using `DATE_SUB()` to compare with a 365-day window.

### 4. Avoiding Division by Zero in Q4:
When calculating tenure in months, I found some customers had joined recently or had incomplete data, resulting in a tenure of zero. This caused division errors. To fix it, I wrapped the denominator with `NULLIF()` to safely avoid dividing by zero and ensure the formula didn’t break.


## Notes
- All queries were tested in a local MySQL environment.
- Each query is saved in a `.sql` file with appropriate comments and formatting.
- No sensitive data or database dump is included in this repository.
