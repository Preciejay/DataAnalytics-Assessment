- Q4: Customer Lifetime Value (CLV) Estimation
-- Estimate customer lifetime value using transaction history and tenure

SELECT
    u.id AS customer_id,
    CONCAT(u.first_name, ' ', u.last_name) AS name,
    -- Calculate how long the customer has been with the company (in months)
    TIMESTAMPDIFF(MONTH, u.date_joined, CURRENT_DATE) AS tenure_months,
    -- Count total savings transactions
    COUNT(s.id) AS total_transactions,
    -- Estimate CLV: 
    -- Formula given: (total_transactions / tenure) * 12 months * average profit per transaction (0.1% of average confirmed amount)
    ROUND(
        (
            COUNT(s.id) / NULLIF(TIMESTAMPDIFF(MONTH, u.date_joined, CURRENT_DATE), 0)
        ) * 12 * (AVG(s.confirmed_amount) * 0.001), 2
    ) AS estimated_clv
FROM 
    users_customuser u
-- Join savings transactions
LEFT JOIN 
    savings_savingsaccount s ON u.id = s.owner_id
GROUP BY 
    u.id, name, tenure_months
-- Show customers with highest CLV first
ORDER BY 
    estimated_clv DESC;
