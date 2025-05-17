-- Q1: High-Value Customers with Multiple Products
-- Find customers who have at least one funded savings plan and one funded investment plan,
-- Then calculate the total deposits (confirmed_amount), grouped and ordered by total_deposits.

SELECT 
    u.id AS owner_id,
    COALESCE(u.name, CONCAT(u.first_name, ' ', u.last_name)) AS name,
    -- Count distinct savings accounts where plan is a regular savings
    COUNT(DISTINCT CASE WHEN pp.is_regular_savings = 1 THEN ssa.id END) AS savings_count,
    -- Count distinct investment accounts where plan is a fixed investment
    COUNT(DISTINCT CASE WHEN pp.is_fixed_investment = 1 THEN ssa.id END) AS investment_count,
    -- Sum all confirmed deposits
    SUM(ssa.confirmed_amount) AS total_deposits
FROM 
    users_customuser u
-- Join savings account to user
JOIN 
    savings_savingsaccount ssa ON ssa.owner_id = u.id
-- Join plan details to savings account
JOIN 
    plans_plan pp ON ssa.plan_id = pp.id
-- Group by user identity
GROUP BY 
    u.id, u.name, u.first_name, u.last_name
-- Ensuring that both savings and investment exist
HAVING 
    savings_count > 0 AND investment_count > 0
-- Show highest depositors first
ORDER BY 
    total_deposits DESC;