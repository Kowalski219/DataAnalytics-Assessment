-- question 2 Transaction Frequency Analysis

-- first cte, joins user and savings table, while also counting total transactions per month

WITH tfq AS (
SELECT
	u.id AS user_id,
    
	COUNT(s.transaction_reference) AS total_transactions,
    
    MONTH(s.transaction_date) AS transaction_month -- extracting only the month from the transaction date
    
FROM users_customuser u 

INNER JOIN
	savings_savingsaccount s  -- joining the user and savings table on id and owner_id
ON 
	u.id = s.owner_id
    
GROUP BY

	transaction_month, user_id),

-- second cte, to get the avg transaction per user

-- avg transaction per user 

avg_tr_u AS (
SELECT 
	user_id,
    AVG(total_transactions) AS avg_total_transactions_per_month
FROM tfq
GROUP BY 
	user_id),

-- final CTE 

-- putting the transactions into category (HF ,MF, LF)

trans_cat AS(
    SELECT 
    -- case statement to categorize 
		CASE WHEN avg_total_transactions_per_month >= 10 THEN "High Frequency" 
		WHEN avg_total_transactions_per_month >=3 THEN "Medium Frequency" 
		ELSE "Low Frequency"
		END AS frequency_category,
        
	user_id,
	
    avg_total_transactions_per_month
    
FROM avg_tr_u
GROUP BY 
	 user_id, avg_total_transactions_per_month)
     
SELECT
	frequency_category,
    COUNT(user_id) AS customer_count,
    ROUND(AVG(avg_total_transactions_per_month),1) AS avg_total_transactions_per_month -- taking the avg again to get the avg per category
    
FROM trans_cat

GROUP BY
	frequency_category
   
ORDER BY
	field(frequency_category, "High Frequency", "Medium Frequency", "Low Frequency") -- to sort the frequency from high to low 
    ;
	
