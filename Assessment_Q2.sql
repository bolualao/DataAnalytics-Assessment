/* Used three CTEs; Monthly Transactions for the year-month
of each transaction, Customer Averages to get the average
transactions per month of each customer, and Frequency categories 
to categories the average transactions using a CASE statement
*/

WITH MonthlyTransactions AS (
    SELECT 
        s.owner_id,
        DATE_FORMAT(s.transaction_date, '%Y-%m') AS Month,
        COUNT(*) AS Transactions
    FROM 
        adashi_staging.savings_savingsaccount s
    GROUP BY 
        s.owner_id, 
        DATE_FORMAT(s.transaction_date, '%Y-%m')
),

CustomerAverages AS (
    SELECT 
        owner_id,
        AVG(Transactions) AS AvgTransactionsPerMonth
    FROM 
        MonthlyTransactions
    GROUP BY 
        owner_id
),

FrequencyCategories AS (
    SELECT 
        CASE 
            WHEN AvgTransactionsPerMonth >= 10 THEN 'High Frequency'
            WHEN AvgTransactionsPerMonth BETWEEN 3 AND 9 THEN 'Medium Frequency'
            ELSE 'Low Frequency'
        END AS frequency_category,
        owner_id,
        AvgTransactionsPerMonth
    FROM 
        CustomerAverages
)

SELECT 
    frequency_category,
    COUNT(owner_id) AS customer_count,
    ROUND(AVG(AvgTransactionsPerMonth), 1) AS avg_transactions_per_month
FROM 
    FrequencyCategories
GROUP BY 
    frequency_category
ORDER BY 
    CASE frequency_category
        WHEN 'High Frequency' THEN 1
        WHEN 'Medium Frequency' THEN 2
        ELSE 3
    END;