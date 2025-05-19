/* Created a CTE that returns the latest transaction date,
number of inactive days for each customer and using a CASE statement
for all active savings or investment accounts
*/

WITH LatestTransactions AS (
    SELECT 
        s.plan_id,
        s.owner_id,
        p.is_regular_savings,
        p.is_a_fund,
        MAX(s.transaction_date) AS last_transaction_date,
        DATEDIFF(CURRENT_DATE, MAX(s.transaction_date)) AS inactivity_days,
        COUNT(*) AS total_transactions
    FROM 
        adashi_staging.savings_savingsaccount s
    JOIN 
        adashi_staging.plans_plan p ON s.plan_id = p.id
    WHERE 
        s.confirmed_amount > 0
    GROUP BY 
        s.Plan_ID, s.Owner_ID, p.is_regular_savings, p.is_a_fund
)

SELECT 
    plan_id,
    owner_id,
    CASE 
        WHEN is_regular_savings = 1 THEN 'savings'
        WHEN is_a_fund = 1 THEN 'investment'
        ELSE 'other'
    END AS type,
    last_transaction_date,
    inactivity_days
FROM 
    LatestTransactions
WHERE 
    inactivity_days > 365
    AND (is_regular_savings = 1 OR is_a_fund = 1)  -- Only active savings or investment accounts
ORDER BY 
    inactivity_days DESC;