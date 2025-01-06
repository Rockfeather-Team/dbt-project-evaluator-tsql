-- this model finds cases where a source has no children

with source_relationships as (
    select  
        *
    from {{ ref('int_all_dag_relationships') }}
    where parent_resource_type = 'source'
    and parent_is_excluded = 0
    and child_is_excluded = 0
),

final as (
    select
        parent
    from source_relationships
    group by parent
    having max(distance) = 0
)

select * from final

{{ filter_exceptions() }}