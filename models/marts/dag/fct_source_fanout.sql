-- this model finds cases where a source is used in multiple direct downstream models
with direct_source_relationships as (
    select  
        *
    from {{ ref('int_all_dag_relationships') }}
    where distance = 1
    and parent_resource_type = 'source'
    and child_resource_type = 'model'
    and parent_is_excluded = 0
    and child_is_excluded = 0
),

source_fanout as (
    select
        parent,
        STRING_AGG(child, ', ') WITHIN GROUP (ORDER BY child) AS model_children
    from direct_source_relationships
    group by parent
    having count(*) > 1
)

select * from source_fanout

{{ filter_exceptions() }}