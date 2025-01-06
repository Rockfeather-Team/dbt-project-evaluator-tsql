{%- macro convert_boolean_value(value) -%}
    {%- set value = value | trim -%}  {# Trim spaces and hidden characters #}
    {%- set result = value -%}  {# Initialize result to the trimmed value #}

    {%- if adapter.type == 'sqlserver' -%}
        {%- if value == True -%} 
            {%- set result = 1 -%}
        {%- elif value == False -%} 
            {%- set result = 0 -%}
        {%- elif value == "True" -%}
            {%- set result = 1 -%}
        {%- elif value == "False" -%}
            {%- set result = 0 -%}
        {%- elif value == 'True' -%}
            {%- set result = 1 -%}
        {%- elif value == 'False' -%}
            {%- set result = 0 -%}
        {%- else -%}
            {%- set result = value -%}
        {%- endif -%}
    {%- else -%}
        {%- if value == True -%} 
            {%- set result = 1 -%}
        {%- elif value == False -%} 
            {%- set result = 0 -%}
        {%- elif value == "True" -%} 
            {%- set result = 1 -%}
        {%- elif value == "False" -%}
            {%- set result = 0 -%}
        {%- elif value == 'True' -%}
            {%- set result = 1 -%}
        {%- elif value == 'False' -%}
            {%- set result = 0 -%}
        {%- else -%}
            {%- set result = value -%}
        {%- endif -%}
    {%- endif -%}

    {{ return(result) }}  {# Return the converted result #}
{%- endmacro -%}
