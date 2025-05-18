-- question one High-Value Customers with Multiple Products
WITH si AS( 
/* this query counts total savings and investment plans*/

SELECT 
	u.id AS owner_id,
   CONCAT(u.first_name, ' ',u.last_name) AS name, -- full customer name
   
   SUM(CASE WHEN p.is_regular_savings = 1 THEN 1 ELSE 0 END) AS savings, -- count of savings account funded
   
    SUM(CASE WHEN p.is_a_fund = 1 THEN 1 ELSE 0 END) AS investment, -- count of investment account funded
    
    SUM(s.confirmed_amount) AS total_deposits -- total deposits
FROM users_customuser u

INNER JOIN plans_plan p -- joining the user_customuser table to the plans_plan table on id & plan_id
ON 
	U.id = p.owner_id
INNER JOIN savings_savingsaccount s -- joining the plans_plan table with the savings_savingsaccount table
ON
	p.id = s.plan_id

GROUP BY owner_id,name)
SELECT
	owner_id,
    name,
    savings AS savings_count,
    investment AS investment_count,
    total_deposits
FROM si
WHERE 
	savings >= 1 -- filtering for customers with at least one savings plan
    
AND investment >= 1 -- filtering for customers with at least one investment plan
GROUP BY 
	owner_id,name
ORDER BY
	total_deposits DESC -- sorting the table by total_deposits in descending order
    ;


