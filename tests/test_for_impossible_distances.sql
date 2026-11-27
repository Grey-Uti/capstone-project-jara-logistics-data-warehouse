Select 
  delivery_id,
  created_at,
  month,
  monthyear,
  customer_id,
  rider_id,
  pickup_city,
  fleet,
  status,
  distance_km,
  delivery_fee
from {{ ref('stg_deliveries') }}
where distance_km > 41 --impossible distances