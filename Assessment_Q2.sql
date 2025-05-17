-- Q2: Transaction Frequency Analysis
-- Analyze monthly transaction activity to categorize customer frequency

WITH monthly_transactions AS (
    -- Count number of transactions per customer per month
    SELECT
        s.owner_id,
        YEAR(s.transaction_date) AS year,
        MONTH(s.transaction_date) AS month,
        COUNT(*) AS transactions_in_month
    FROM 
        savings_savingsaccount s
    GROUP BY 
        s.owner_id, YEAR(s.transaction_date), MONTH(s.transaction_date)
),
avg_transactions_per_customer AS (
    -- Calculate average monthly transaction count per user
    SELECT
        owner_id,
        AVG(transactions_in_month) AS avg_transactions_per_month
    FROM 
        monthly_transactions
    GROUP BY 
        owner_id
),
categorized_customers AS (
    -- Assigning frequency category based on average transaction volume
    SELECT
        owner_id,
        avg_transactions_per_month,
        CASE
            WHEN avg_transactions_per_month >= 10 THEN 'High Frequency'
            WHEN avg_transactions_per_month BETWEEN 3 AND 9 THEN 'Medium Frequency'
            ELSE 'Low Frequency'
        END AS frequency_category
    FROM 
        avg_transactions_per_customer
)
-- Aggregating the number of customers per frequency group
SELECT
    frequency_category,
    COUNT(*) AS customer_count,
    ROUND(AVG(avg_transactions_per_month), 1) AS avg_transactions_per_month
FROM 
    categorized_customers
GROUP BY 
    frequency_category
ORDER BY avg_transactions_per_month DESC;