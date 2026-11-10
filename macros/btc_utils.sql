{% macro convert_to_usd(btc_amount, btc_price) %}

    ({{ btc_amount }} * {{ btc_price }})

{% endmacro %}