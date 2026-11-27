SELECT
    ticket_volume,
    week_start,
    lower(category) as category
FROM {{ source('jara_raw', 'ticket_weekly_volume_category') }}