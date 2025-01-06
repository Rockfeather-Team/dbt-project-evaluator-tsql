-- this model finds cases where a model references more than one source
with direct_source_relationships as (
    select distinct
        child,
        parent
    from {{ ref('int_all_dag_relationships') }}
    where distance = 1
    and parent_resource_type = 'source'
    and parent_is_excluded = 0
    and child_is_excluded = 0
),

multiple_sources_joined as (
    select
        child,
        STRING_AGG(parent, ', ') WITHIN GROUP (ORDER BY parent) AS source_parents
    from direct_source_relationships
    group by child
    having count(*) > 1
)

select * from multiple_sources_joined

{{ filter_exceptions() }}