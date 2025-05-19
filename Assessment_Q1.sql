SELECT 
    u.id AS owner_id,
    CONCAT(u.First_name, ' ', u.Last_name) AS Name,
    COUNT(DISTINCT CASE WHEN p.is_regular_savings = 1 THEN s.Plan_ID END) AS savings_count,
    COUNT(DISTINCT CASE WHEN p.is_a_fund = 1 THEN s.Plan_ID END) AS investment_count,
    SUM(s.Confirmed_amount) AS total_deposit
FROM 
    adashi_staging.users_customuser u
JOIN 
    adashi_staging.savings_savingsaccount s ON u.id = s.owner_id
JOIN 
    adashi_staging.plans_plan p ON s.plan_id = p.id
WHERE 
    s.Confirmed_amount > 0
GROUP BY 
    u.id, u.first_name, u.last_name
HAVING 
    COUNT(DISTINCT CASE WHEN p.is_regular_savings = 1 THEN s.Plan_ID END) >= 1
    AND COUNT(DISTINCT CASE WHEN p.is_a_fund = 1 THEN s.Plan_ID END) >= 1
ORDER BY 
    total_deposit DESC;