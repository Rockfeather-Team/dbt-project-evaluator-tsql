-- these macros will read a user’s home environment and detect whether a computer’s operating system is Windows based or Mac/Linux, and display the right directory pattern.
{% macro is_os_mac_or_linux() %}
  {% for val in graph.nodes.values() %}
    {{ return("\\" not in val.get("original_file_path","")) }}
  {% endfor %}
  {{ return(true) }}
{% endmacro %}

{% macro get_directory_pattern() %}
  {% if execute %}
    {%- set on_mac_or_linux = dbt_project_evaluator.is_os_mac_or_linux() -%}
    {%- if on_mac_or_linux -%}
      {{ return("/") }}
    {% else %}
      {{ return("\\\\") }}
    {% endif %}
  {% endif %}
{% endmacro %}
 
{% macro get_regexp_directory_pattern() %}
  {% set regexp_escaped = get_directory_pattern() | replace("\\\\", "\\\\\\\\") %}
  {% do return(regexp_escaped) %}
{% endmacro %}
 
{% macro get_dbtreplace_directory_pattern() %}
  {% if execute %}
    {%- set is_sql_server = target.type == "sqlserver" -%}
    {%- set on_mac_or_linux = dbt_project_evaluator.is_os_mac_or_linux() -%}
     
    {%- if is_sql_server -%}
      -- Logic for SQL Server
      {{ dbt.replace("file_path", "RIGHT(file_path, CHARINDEX('\\', REVERSE(file_path)) - 1)", "''") }}
    {%- elif on_mac_or_linux -%}
      -- Logic for Mac or Linux
      {{ dbt.replace("file_path", "regexp_replace(file_path,'.*/','')", "''") }}
    {%- else -%}
      -- Logic for Windows
      {{ dbt.replace("file_path", "regexp_replace(file_path,'.*\\\\\\\\','')", "''") }}
    {%- endif -%}
  {% endif %}
{% endmacro %}