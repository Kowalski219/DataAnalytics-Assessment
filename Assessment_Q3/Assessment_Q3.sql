-- question 3 Account Inactivity Alert
WITH active_acc AS (

-- first CTE to get the plan_id, owner id & transaction date
SELECT
	p.id,
    
    s.owner_id,
    
    -- case statement to group INVESTMENT & SAVINGS in one column, TYPE
    
    CASE WHEN
		p.is_a_fund = 1 THEN "Investment"
	WHEN
		p.is_regular_savings = 1 THEN "Savings"
        ELSE "Unknown plan" 
	END AS type,
    
    s.transaction_reference,
    
    MAX(s.transaction_date) AS last_transaction_date
    
FROM plans_plan p

INNER JOIN 
	savings_savingsaccount s  -- inner joining the plan & savings table on id & plan_id

ON 
	p.id = s.plan_id

WHERE
	(p.is_a_fund = 1   -- filtering for active profiles & where the data is investments or savings. active profiles were inferred
   OR
    p.is_regular_savings = 1)
    AND
        p.is_deleted = 0
    AND p.is_archived = 0
    AND p.locked = 0
    AND p.status_id = 1

GROUP BY
	p.id,s.owner_id,s.transaction_reference)

SELECT
	id AS plan_id,
    owner_id,
    type,
    last_transaction_date,
	DATEDIFF(CURRENT_DATE, last_transaction_date) AS inactive_days


FROM active_acc

WHERE 
	DATEDIFF(CURRENT_DATE, last_transaction_date) > 365 -- filtering for active profiles 
GROUP BY
	plan_id,owner_id,last_transaction_date
;

    