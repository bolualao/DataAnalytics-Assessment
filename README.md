# DataAnalytics-Assessment

## ASSESSMENT Q1
### Explanation:
1.	Joins: I joined the three tables to connect users with their savings and plans.
2.	Filtering: I only include records with positive confirmed amounts (s.Confirmed_amount > 0).
3.	Counting:
        	COUNT(DISTINCT CASE WHEN p.is_regular_savings = 1 THEN s.Plan_ID END) counts distinct savings plans
          COUNT(DISTINCT CASE WHEN p.is_a_fund = 1 THEN s.Plan_ID END) counts distinct investment plans
4.	Aggregation: I sum all confirmed amounts for each user.
5.	HAVING clause: Ensures I only include users with at least one of each plan type.
6.	Sorting: Results are ordered by total deposits in descending order.

## ASSESSMENT Q2
### Explanation:
1.	MonthlyTransactions CTE:
          Calculates transaction counts per customer per month
          Groups by Owner_ID and year-month combination
2.	CustomerAverages CTE:
          Computes the average monthly transactions for each customer
          Averages the monthly counts from the first CTE
3.	FrequencyCategories CTE:
          Categorizes customers based on their average transaction frequency
          Uses CASE statements to apply the business rules
4.	Final SELECT:
          Counts customers in each category
          Calculates the average transactions per month for each category
          Orders results logically (High → Medium → Low)

## ASSESSMENT Q3
### Explanation:
1.	LatestTransactions CTE:
          Joins the Savings and Plan tables
          Filters for actual inflows (confirmed_amount > 0)
          For each plan, calculates: The last transaction date, Days since last transaction, Total transaction count
2.	Main Query:
          Selects only accounts with no activity for over 365 days
          Identifies account type (savings/investment)
          Returns the requested columns
          Orders by days inactive (most inactive first)
3.	Key Features:
          Only considers accounts with positive confirmed amounts (real transactions)
          Explicitly checks for savings (is_regular_savings=1) or investment (is_a_fund=1) accounts
          Provides clear account type classification
          Shows exact days of inactivity

## ASSESSMENT Q4
### Explanation:
1.	CustomerStats CTE:
          Joins User and Savings tables
          Calculates: Account tenure in months using TIMESTAMPDIFF, Total transaction count, Total transaction value, Total profit (0.1% of transaction value)
2.	Main Query:
          Calculates CLV using the formula: (total_transactions / tenure) * 12 * avg_profit_per_transaction
          Handles division by zero for new accounts (tenure = 0 months)
          Orders results by estimated CLV (highest first)
