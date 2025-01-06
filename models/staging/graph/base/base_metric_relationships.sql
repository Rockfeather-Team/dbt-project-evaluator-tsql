{{
    config(
        materialized='table',
        post_hook="{{ insert_resources_from_graph(this, resource_type='metrics', relationships=True) }}",
        alias="base_metric_relationships"
    )
}}

{% if execute %}
    {{ check_model_is_table(model) }}
{% endif %}

with dummy_cte as (
    select 1 as foo
) 

select 
    cast(null as {{ dbt_project_evaluator.type_string_dpe()}}) as resource_id,
    cast(null as {{ dbt_project_evaluator.type_string_dpe()}}) as direct_parent_id,
    cast(1 as {{ dbt.type_boolean() }}) as is_primary_relationship

from dummy_cte
where 1=0
