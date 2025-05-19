/* Create a CTE that calculates the tenure months, number of transactions,
total profit and total transacation value
*/
WITH CustomerStats AS (
    SELECT 
        u.id AS customer_id,
        CONCAT(u.first_name, ' ', u.last_name) AS Name,
        TIMESTAMPDIFF(MONTH, u.created_on, CURRENT_DATE()) AS tenure_months,
        COUNT(s.id) AS total_transactions,
        SUM(s.confirmed_amount) AS total_transaction_value,
        SUM(s.confirmed_amount) * 0.001 AS total_profit  -- 0.1% profit per transaction
    FROM 
        adashi_staging.users_customuser u
    LEFT JOIN 
        adashi_staging.savings_savingsaccount s ON u.id = s.owner_id
    GROUP BY 
        u.id, u.first_name, u.last_name, u.created_on
)

SELECT 
    customer_id,
    Name,
    tenure_months,
    total_transactions,
    CASE 
        WHEN tenure_months > 0 
        THEN (total_transactions / tenure_months) * 12 * (total_profit / total_transactions)
        ELSE 0
    END AS estimated_clv
FROM 
    CustomerStats
ORDER BY 
    estimated_clv DESC;

