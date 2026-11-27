


select 
month, 
monthyear, 
fleet, 
SUM(delivery_count) as total_delivery_count,
SUM(total_delivery_cost)  AS total_delivery_cost
 from {{ ref('agg_delivery_cost_by_fleet') }} 
 where fleet = 'partner'
 group by all
 order by month
