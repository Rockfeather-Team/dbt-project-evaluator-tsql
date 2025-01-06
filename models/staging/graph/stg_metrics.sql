{{
    config(
        materialized='table',
        post_hook="{{ insert_resources_from_graph(this, resource_type='metrics') }}",
        alias="stg_metrics"
    )
}}

{% if execute %}
    {{ check_model_is_table(model) }}
{% endif %}

with dummy_cte as (
    select 1 as foo
)

select 

    cast(null as {{ dbt_project_evaluator.type_string_dpe() }}) as unique_id,
    cast(null as {{ dbt_project_evaluator.type_string_dpe() }}) as name,
    cast(null as {{ dbt_project_evaluator.type_string_dpe() }}) as resource_type,
    cast(null as {{ dbt_project_evaluator.type_string_dpe() }}) as file_path,
    cast(1 as {{ dbt.type_boolean() }}) as is_described,
    cast(null as {{ dbt_project_evaluator.type_string_dpe() }}) as metric_type,
    cast(null as {{ dbt_project_evaluator.type_string_dpe() }}) as label,
    cast(null as {{ dbt_project_evaluator.type_string_dpe() }}) as package_name,
    cast(null as {{ dbt_project_evaluator.type_string_dpe() }}) as metric_filter,
    cast(null as {{ dbt_project_evaluator.type_string_dpe() }}) as metric_measure,
    cast(null as {{ dbt_project_evaluator.type_string_dpe() }}) as metric_measure_alias,
    cast(null as {{ dbt_project_evaluator.type_string_dpe() }}) as numerator,
    cast(null as {{ dbt_project_evaluator.type_string_dpe() }}) as denominator,
    cast(null as {{ dbt_project_evaluator.type_string_dpe() }}) as expr,
    cast(null as {{ dbt_project_evaluator.type_string_dpe() }}) as metric_window,
    cast(null as {{ dbt_project_evaluator.type_string_dpe() }}) as grain_to_date,
    cast(null as {{ dbt_project_evaluator.type_string_dpe() }}) as meta

from dummy_cte
where 1=0 
