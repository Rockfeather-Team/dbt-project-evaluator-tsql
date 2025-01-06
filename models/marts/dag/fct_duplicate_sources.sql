with sources as (
    select
        resource_name,
        CASE 
            WHEN database_name IS NULL THEN 
                schema_name + '.' + identifier
            ELSE 
                database_name + '.' + schema_name + '.' + identifier
        END AS source_db_location
    from {{ ref('int_all_graph_resources') }}
    where resource_type = 'source'
    and is_excluded = 0
),

source_duplicates as (
    select
        source_db_location,
        STRING_AGG(resource_name, ', ') WITHIN GROUP (ORDER BY resource_name) AS source_names
    from sources
    group by source_db_location
    having count(*) > 1
)

select * from source_duplicates

{{ filter_exceptions() }}
