select
	week_start,
	category,
    sum(ticket_volume) as ticket_volume
from {{ ref('stg_ticket_weekly_volume_category') }}
group by 
week_start,
category