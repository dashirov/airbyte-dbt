{% macro generate_database_name(custom_database_name, node) %}

    {% set default_database = target.database %}

    {% if custom_database_name is not none %}
        {{ return(custom_database_name | trim) }}
    {% else %}
        {{ return(default_database) }}
    {% endif %}

{% endmacro %}
