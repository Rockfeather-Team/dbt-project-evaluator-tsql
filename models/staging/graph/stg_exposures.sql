{{
    config(
        materialized='table',
        post_hook="{{ insert_resources_from_graph(this, resource_type='exposures') }}",
        alias="stg_exposures"
    )
}}

{% if execute %}
    {{ check_model_is_table(model) }}
{% endif %}

with dummy_cte as (
    select 1 as foo
)

select 

    cast(null as {{ dbt_project_evaluator.type_string_dpe() }} ) as unique_id,
    cast(null as {{ dbt_project_evaluator.type_string_dpe() }} ) as name,
    cast(null as {{ dbt_project_evaluator.type_string_dpe() }} ) as resource_type,
    cast(null as {{ dbt_project_evaluator.type_string_dpe() }} ) as file_path,
    cast(1 as {{ dbt.type_boolean() }}) as is_described,
    cast(null as {{ dbt_project_evaluator.type_string_dpe() }} ) as exposure_type,
    cast(null as {{ dbt_project_evaluator.type_string_dpe() }} ) as maturity,
    cast(null as {{ dbt_project_evaluator.type_string_dpe() }} ) as package_name,
    cast(null as {{ dbt_project_evaluator.type_string_dpe() }} ) as url,
    cast(null as {{ dbt_project_evaluator.type_string_dpe() }} ) as owner_name,
    cast(null as {{ dbt_project_evaluator.type_string_dpe() }} ) as owner_email,
    cast(null as {{ dbt_project_evaluator.type_string_dpe() }} ) as meta

from dummy_cte
where 1=0 
