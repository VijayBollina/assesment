/* Using POSTGRESQL to query data from the designed datawarehouse model*/
  
/* What are the top 5 brands by receipts scanned for most recent month? */
select name, count(*) as total_scans 
from receipts r
join brands b
on r.barcode = b.code
where date_scanned between (current_date - INTERVAL '1 months') and current_date
group by name
order by total_scans desc
limit 5;

/* How does the ranking of the top 5 brands by receipts scanned for the recent month compare to the ranking for the previous month? */
with cte1 as (select date_scanned, name, count(*) as total_scans 
from receipts r
join brands b
on r.barcode = b.barcode
where date_scanned between (current_date - INTERVAL '2 months') and current_date
group by date_scanned, name),
cte2 as (select date_scanned, name, total_scans,
dense_rank() over(partiton by date_scanned, name order by total_scans desc) as rank
from cte1)
select * from cte2 where rank <=5;

/* When considering average spend from receipts with 'rewardsReceiptStatus’ of ‘Accepted’ or ‘Rejected’, which is greater? */
select r.rewards_receipt_status, avg(f.total_spent) as avg_spent 
from fact_table f
left join receipts r
on f.receipt_id = r.id
group by rewards_receipt_status;

/* the above SQL statement will return the average spend of each receipt status level,
which then used to compare the average spend between each levels.

From the given data, the rewards_receipt_status has following levels: 
'FINISHED', 'FLAGGED', 'PENDING', 'REJECTED', 'SUBMITTED' and thier average spend is
80.85, 180.45,  28.03,  23.33, Null respectively

Assuming, Finished level as accepted, the average spend of Finished is greater than rejected*/


/*When considering total number of items purchased from receipts with 'rewardsReceiptStatus’ of ‘Accepted’ or ‘Rejected’, which is greater? */
select r.rewards_receipt_status, sum(f.purchasedItemCount) as total_purchases
from fact_table f
left join receipts r
on f.receipt_id = r.id
group by rewards_receipt_status

/*The total purchases at each receipt status as below:
FINISHED    8184.00
FLAGGED     1014.00
PENDING        0.00
REJECTED     173.00
SUBMITTED      0.00

Assuming, Finished level as accepted, the total purchase of Finished is greater than rejected*/

/* Which brand has the most spend among users who were created within the past 6 months? */
select name, sum(total_spend) as total_spend
from fact_table f
left join users u
on f.user_id = u.id
left join brands b
on f.barcode = b.barcode
where u.created_date between (current_date - INTERVAL '6 months')  and current_date
group by name
order by total_spend desc;

/* Which brand has the most transactions among users who were created within the past 6 months? */
select name, count(*) as total_transcations
from fact_table f
left join users u
on f.user_id = u.id
left join brands b
on f.barcode = b.barcode
where u.created_date between (current_date - INTERVAL '6 months')  and current_date
group by name
order by total_transcations desc;

