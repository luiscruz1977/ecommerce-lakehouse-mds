with order_items as (

    select * from {{ ref('stg_order_items') }}
),

products as (

    select * FROM {{ ref('stg_products') }}

),

orders as (

    select * from {{ ref('stg_orders') }}

),

joined as (

    select  
        oi.order_id,
        oi.price,
        oi.freight_value,
        coalesce(p.product_category, 'unknown') as product_category,
        o.order_status


    from order_items as oi
    left join products as p on oi.product_id = p.product_id
    left join orders as o on oi.order_id = o.order_id
),

aggregated as (

    select
        product_category,
        -- Gross total
        count(distinct order_id) as total_orders_gross,
        sum(price) as gross_revenue,
        -- Net total
        count(distinct case when order_status = 'delivered' then order_id end) as total_orders_delivered,
        sum(case when order_status = 'delivered' then price else 0 end) as net_revenue

    from joined
    group by product_category
)

select
    *,
    round(gross_revenue - net_revenue, 2) as revenue_at_risk

from aggregated
order by gross_revenue desc