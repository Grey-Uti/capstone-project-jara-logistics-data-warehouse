with deduped as (

    select
        o.*,
        row_number() over (partition by o.delivery_id order by o.created_at) as rn
    from {{ source('jara_raw', 'deliveries') }} as o

),

cleaned as (

    select
        delivery_id,
        customer_id,
        rider_id,
		trim(lower(pickup_city)) as pickup_city,
		distance_km,
		delivery_fee,
		trim(fleet) as fleet,
		case when trim(lower(status)) = 'completed' then 'delivered' 
		else lower(trim(status)) end as status, 
        cast(created_at as date) as created_at
    from deduped
    where rn = 1

)

select
    d.created_at,
    MONTH(d.Created_at)              as month,
    TO_CHAR(d.Created_at, 'MM-YYYY') as monthyear,
    d.delivery_id,
    d.customer_id,
    d.rider_id,
    d.pickup_city,
    d.distance_km,
	d.delivery_fee,
	d.fleet,
    d.status,
    round((d.distance_km * 220.0), 2) as cost
from cleaned as d
left join {{ source('jara_raw', 'riders') }} as r
       on r.rider_id = d.rider_id
left join {{ source('jara_raw', 'customers') }} as c
       on d.customer_id = c.customer_id