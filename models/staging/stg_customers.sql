select
    customer_id,
    trim(full_name)    as full_name,
    trim(lower(city))  as city,
	trim(lower(tier))  as tier,
    signup_date
from {{ source('jara_raw', 'customers') }}