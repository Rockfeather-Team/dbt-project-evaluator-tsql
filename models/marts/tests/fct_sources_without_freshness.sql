with

all_resources as (
    select * from {{ ref('int_all_graph_resources') }}
    where is_excluded = 0

),

final as (

    select distinct
        resource_name

    from all_resources
    where is_freshness_enabled = 0 and resource_type = 'source'

)

select * from final

{{ filter_exceptions() }}