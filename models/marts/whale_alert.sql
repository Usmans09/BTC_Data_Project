
WITH WHALES AS (

    SELECT
        output_address,
        SUM(output_value) AS total_sent,
        COUNT(*) AS tx_count

    FROM {{ ref('stg_btc_transactions') }}

    WHERE output_value > 10

    GROUP BY output_address

),

LATEST_PRICE AS (

    SELECT
        CLOSE_PRICE_USD AS PRICE

    FROM {{ ref('btc_usd_max') }}

    WHERE TO_DATE(REPLACE(EVENT_DATE, ' UTC', '')) = CURRENT_DATE()

)

SELECT
    w.output_address,
    w.total_sent,
    w.tx_count,
    {{ convert_to_usd('w.total_sent', 'p.PRICE') }} AS total_sent_usd

FROM WHALES w
CROSS JOIN LATEST_PRICE p

ORDER BY total_sent_usd DESC