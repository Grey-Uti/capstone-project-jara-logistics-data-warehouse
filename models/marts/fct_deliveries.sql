Select
 created_at,
 month,
 monthyear,
 delivery_id,
 customer_id,
 rider_id,
 status,
 fleet,
 distance_km,
 cost
from {{ ref('stg_deliveries') }}
Where distance_km is not null -- no empty distance values
and distance_km > 0    --exclude negative values, in case (proactiveness)
and distance_km < 41.0  --exclude impossible distances