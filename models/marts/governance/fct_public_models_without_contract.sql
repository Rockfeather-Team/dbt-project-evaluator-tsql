with 

all_resources as (
    select * from {{ ref('int_all_graph_resources') }}
    where is_excluded = 0
),

final as (

    select 
        resource_name,
        is_public,
        is_contract_enforced
        
    from all_resources
    where 
        is_public = 1
        and is_contract_enforced = 0
)

select * from final

{{ filter_exceptions() }}