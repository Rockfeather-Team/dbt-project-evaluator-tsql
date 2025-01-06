with all_resources as (
    select * from {{ ref('int_all_graph_resources') }}
    where is_excluded = 0

),

final as (

    select
        resource_name,
        model_type

    from all_resources
    where is_described = 0 and resource_type = 'model'

)

select * from final

{{ filter_exceptions() }}