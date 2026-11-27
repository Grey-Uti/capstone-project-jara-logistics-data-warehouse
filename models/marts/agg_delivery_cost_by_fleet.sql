Select 
  month,
  monthyear,
  fleet,
  count(distinct delivery_id) as delivery_count,
  sum(cost)                   as total_delivery_cost
from {{ ref('fct_deliveries') }}
where status = 'delivered'
group by all