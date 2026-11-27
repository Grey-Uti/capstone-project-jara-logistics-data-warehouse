select
    rider_id,
    trim(rider_name)        as rider_name,
	trim(vehicle_type)      as vehicle_type,
	trim(fleet)             as fleet,
    trim(lower(base_city))  as base_city,
    joined_date
from {{ source('jara_raw', 'riders') }}