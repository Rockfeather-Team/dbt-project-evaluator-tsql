with all_dag_relationships as (
    select  
        *
    from {{ ref('int_all_dag_relationships') }}
    where parent_is_excluded = 0
    and child_is_excluded = 0
),

-- find all models without children
models_without_children as (
    select
        parent
    from all_dag_relationships
    where parent_resource_type = 'model'
    group by parent
    having max(distance) = 0
),

-- all parents with more direct children than the threshold for fanout (determined by variable models_fanout_threshold, default 3)
    -- Note: only counts "leaf children" - direct chilren that are models AND are child-less (are at the right-most-point in the DAG)
model_fanout as (
    select 
        all_dag_relationships.parent,
        all_dag_relationships.parent_model_type,
        all_dag_relationships.child
    from all_dag_relationships
    inner join models_without_children
        on all_dag_relationships.child = models_without_children.parent
    where all_dag_relationships.distance = 1 and all_dag_relationships.child_resource_type = 'model'
    group by 
        all_dag_relationships.parent,
        all_dag_relationships.parent_model_type,
        all_dag_relationships.child
),

model_fanout_agg as (
    select
        parent,
        parent_model_type,
        STRING_AGG(child, ', ') WITHIN GROUP (ORDER BY child) AS leaf_children
    from model_fanout
    group by 
        parent,
        parent_model_type
    having count(*) >= {{ var('models_fanout_threshold') }}
)

select * from model_fanout_agg

{{ filter_exceptions() }}