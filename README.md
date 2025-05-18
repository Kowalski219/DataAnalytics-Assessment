**Question 1 – High-Value Customers with Multiple Products
**
For this question, I started by selecting all the fields I needed directly from the tables without needing to calculate or derive them with logic.I used CASE statements to count how many savings and investment plans each user has. Since I noticed the data I needed was spread across three tables (users_customuser, plans_plan, and savings_savingsaccount), I used INNER JOINs to bring the relevant data together. I used INNER JOIN because I only wanted users who had matching records in all tables. Once I had my complete table with savings, investments, and deposit totals, I filtered it to return only users who had at least one savings and one investment. Then I sorted the results by total deposits in descending order.

**Challenges**
The challenge I faced was figuring out how to get the savings and investment counts correctly but It became clear that both types of plans were stored in the same table but identified using different flags (is_regular_savings and is_a_fund) which was also given in the hint.

**Question 2 – Transaction Frequency Analysis**

For this question, I wanted to find out how frequently customers transact so they can be grouped into different categories (High, Medium, or Low frequency). i selected all fields that i didnt need to logically calculate for, like i usually do, then joined the users_customuser and savings_savingsaccount tables using an INNER JOIN on id and owner_id. In the first CTE, I grouped the transactions by customer and transaction month, then counted how many transactions each customer made per month.I noticed the table i got would not give me what i was looking for, so i linked another CTE. In the second CTE, I calculated the average number of monthly transactions per customer. I then created another CTE, In the third CTE, I used a CASE statement to group customers based on their average:

10 or more transactions = High Frequency

3 to 9 = Medium Frequency

2 or fewer = Low Frequency

Finally, I counted how many users fell into each category and also calculated the average transactions per category. I used FIELD() in the ORDER BY to sort the categories from High to Low.

**Challenges**
The challenge I had here was self-inflicted. I wasn’t sure which was the best way to write the logic for Medium Frequency and Low Frequency. At first, I wanted to use BETWEEN 3 AND 9, but I later settled for:

"WHEN avg_total_transactions_per_month >= 3 THEN "Medium Frequency" ELSE "Low Frequency"

**Question 3-Account Inactivity Alert**

I created a CTE agin for this question. the CTE joined the plans_plan and savings_savingsaccount tables using an INNER JOIN on id and plan_id. Then I used a CASE statement to label each plan as either "Investment" or "Savings", and pulled out the transaction_reference and the latest transaction_date using MAX().

Next, I filtered the plans to include only active profiles and grouped them by plan ID and owner. I assumed that an active profile was one that met all these conditions:

is_deleted = 0, 
is_archived = 0,
locked = 0,
status_id = 1

In the final query, I used DATEDIFF() to calculate the number of days since the last transaction, and filtered to show only those with more than 365 days of inactivity.

**Challenges**
I had a difficult time figuring out what counted as an "active profile." It wasn't clearly defined, so I settled for filtering plans based on the following conditions:

Not deleted (is_deleted = 0)

Not archived (is_archived = 0)

Not locked (locked = 0)

Status marked as active (status_id = 1)

**Question 4 – Customer Lifetime Value (CLV) Estimation**

I created a CTE that joined the users_customuser and savings_savingsaccount tables using a LEFT JOIN, to ensure all customers were included even if they had no transactions.
In the final query, I used TIMESTAMPDIFF to calculate tenure in months, rather than using DATEDIFF divided by 30, to be more precise.

**challenges**
I had a hard time understanding the logic behind calculating estimated CLV. I wasn’t fully sure how the formula should work, especially how the profit rate factored in. I applied the formula as best as I could based on the description even though i have my doubts about my interpretation of the clv


