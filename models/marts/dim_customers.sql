select
    customer_id,
    full_name,
    city,
	tier,
    signup_date
From {{ ref('stg_customers') }}