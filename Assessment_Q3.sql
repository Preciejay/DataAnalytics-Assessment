-- Q3: Account Inactivity Alert
-- Identify active savings or investment plans with no transactions in the last 365 days

SELECT
    p.id AS plan_id,
    p.owner_id,
    -- Classifying the plan type
    CASE 
        WHEN p.is_fixed_investment = 1 THEN 'Investment' 
        ELSE 'Savings' 
    END AS type,
    -- Get most recent transaction date
    DATE(MAX(s.transaction_date)) AS last_transaction_date,
    -- Calculate days since last transaction
    DATEDIFF(CURRENT_DATE, DATE(MAX(s.transaction_date))) AS inactivity_days
FROM 
    plans_plan p
-- Include savings transactions tied to plan and owner
LEFT JOIN 
    savings_savingsaccount s 
    ON p.id = s.plan_id AND p.owner_id = s.owner_id
-- Group per plan
GROUP BY 
    p.id, p.owner_id, p.is_fixed_investment
-- Only show plans with no recent activity
HAVING 
    (MAX(s.transaction_date) IS NULL 
     OR MAX(s.transaction_date) <= DATE_SUB(CURRENT_DATE, INTERVAL 365 DAY))
-- Prioritize longest inactive plans
ORDER BY 
    inactivity_days DESC;