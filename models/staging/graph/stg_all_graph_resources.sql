-- one row for each resource in the graph
with unioned as (

    {{ dbt_utils.union_relations([
        ref('base__nodes'),
        ref('base__exposures'),
        ref('base__metrics'),
        ref('base__sources')
    ])}}

),

final as (

    select
        unique_id as resource_id, 
        case 
            when resource_type = 'source' then source_name || '.' || name
            else name 
        end as resource_name, 
        resource_type, 
        file_path, 
        case 
            when resource_type in ('test', 'source', 'metric', 'exposure') then null
            when file_path like '%{{ var("staging_folder_name") }}%' 
                {%- for prefix in var("staging_prefixes") -%}
                or name like '%{{ prefix }}%'
                {% endfor %}
                then 'staging'
            when file_path like '%{{ var("intermediate_folder_name") }}%' 
                {%- for prefix in var("intermediate_prefixes") -%}
                or name like '%{{ prefix }}%'
                {% endfor %}
                then 'intermediate'
            when file_path like '%{{ var("marts_folder_name") }}%' 
                {%- for prefix in var("marts_prefixes") -%}
                or name like '%{{ prefix }}%'
                {% endfor %}
                then 'marts'
            else 'other' -- is this the catch-all that we want? what about the reports folder in our example DAG?
        end as model_type, 
        is_enabled, 
        materialized, 
        on_schema_change, 
        database, 
        schema, 
        package_name, 
        alias, 
        is_described, 
        exposure_type, 
        maturity, 
        url, 
        metric_type, 
        model, 
        label, 
        sql, 
        timestamp as timestamp,  
        source_name, -- NULL for non-source resources
        is_source_described, 
        loaded_at_field, 
        loader, 
        identifier

    from unioned
    where coalesce(is_enabled, True) = True
    and not(resource_type = 'model' and package_name = 'dbt_project_evaluator')

)

select * from final