select
    rider_id,
    rider_name,
	vehicle_type,
	fleet,
    base_city,
    joined_date
From {{ ref('stg_riders')}}