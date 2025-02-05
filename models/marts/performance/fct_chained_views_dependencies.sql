with all_relationships as (
    select  
        *
    from {{ ref('int_all_dag_relationships') }}
    where distance <> 0
    and parent_is_excluded = 0
    and child_is_excluded = 0
),

final as (
    select
        parent,
        child, -- the model with potentially long run time / compilation time, improve performance by breaking the upstream chain of views
        distance,
        path
    from all_relationships
    where is_dependent_on_chain_of_views = 1
    and child_resource_type = 'model'
    and distance > {{ var('chained_views_threshold') }}
)

select * from final

{{ filter_exceptions() }}
