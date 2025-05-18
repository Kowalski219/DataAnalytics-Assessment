-- question 4 

-- CTE to get customer_id, name, tenure_months, total transactions & estimated

WITH clv AS (

SELECT
	u.id AS customer_id,
    CONCAT(first_name, ' ', last_name) AS name, -- joining first name and last name to get the name
    u.date_joined AS signup_date,
	COUNT(s.id) AS total_transactions,
	SUM(s.amount) AS total_transaction_value
FROM users_customuser u
LEFT JOIN 
	savings_savingsaccount s ON u.id = s.owner_id -- left join user & customer table on id & owner id
GROUP BY 
	customer_id, name, signup_date)
SELECT
	customer_id,
    name,
    TIMESTAMPDIFF(MONTH, signup_date, CURRENT_DATE()) AS tenure_months, -- using timestamp to extract the tenure in months instead of dateddiff to avoid dividing by 30
    
    total_transactions,
    
    ROUND(
    (total_transactions/TIMESTAMPDIFF(MONTH, signup_date, CURRENT_DATE())) * 12 * -- estimating clv and rounding to 1 dp for better readability
    (0.1* total_transaction_value)
    ) AS estimated_clv
FROM clv

WHERE 
(total_transactions/TIMESTAMPDIFF(MONTH, signup_date, CURRENT_DATE())) * 12 *
    (0.1* total_transaction_value)

IS NOT NULL

ORDER BY 
	estimated_clv DESC
    ;