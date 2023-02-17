# vim: ft=sls


{#-
    Stops the haste, memcached, redis container services
    and disables them at boot time.
#}

{%- set tplroot = tpldir.split("/")[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as haste with context %}

haste service is dead:
  compose.dead:
    - name: {{ haste.lookup.paths.compose }}
{%- for param in ["project_name", "container_prefix", "pod_prefix", "separator"] %}
{%-   if haste.lookup.compose.get(param) is not none %}
    - {{ param }}: {{ haste.lookup.compose[param] }}
{%-   endif %}
{%- endfor %}
{%- if haste.install.rootless %}
    - user: {{ haste.lookup.user.name }}
{%- endif %}

haste service is disabled:
  compose.disabled:
    - name: {{ haste.lookup.paths.compose }}
{%- for param in ["project_name", "container_prefix", "pod_prefix", "separator"] %}
{%-   if haste.lookup.compose.get(param) is not none %}
    - {{ param }}: {{ haste.lookup.compose[param] }}
{%-   endif %}
{%- endfor %}
{%- if haste.install.rootless %}
    - user: {{ haste.lookup.user.name }}
{%- endif %}
