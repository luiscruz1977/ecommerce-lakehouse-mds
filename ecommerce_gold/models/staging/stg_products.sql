with source as (

    select * from {{ source('silver', 'products')}}

)

select
    product_id,
    product_category_name_english as product_category,
    product_weight_g,
    product_length_cm,
    product_height_cm,
    product_width_cm

from source