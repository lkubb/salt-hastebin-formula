# -*- coding: utf-8 -*-
# vim: ft=sls

{%- set tplroot = tpldir.split('/')[0] %}
{%- set sls_config_file = tplroot ~ '.config.file' %}
{%- from tplroot ~ "/map.jinja" import mapdata as haste with context %}

include:
  - {{ sls_config_file }}

Haste service is enabled:
  compose.enabled:
    - name: {{ haste.lookup.paths.compose }}
{%- for param in ["project_name", "container_prefix", "pod_prefix", "separator"] %}
{%-   if haste.lookup.compose.get(param) is not none %}
    - {{ param }}: {{ haste.lookup.compose[param] }}
{%-   endif %}
{%- endfor %}
    - require:
      - Haste is installed
{%- if haste.install.rootless %}
    - user: {{ haste.lookup.user.name }}
{%- endif %}

Haste service is running:
  compose.running:
    - name: {{ haste.lookup.paths.compose }}
{%- for param in ["project_name", "container_prefix", "pod_prefix", "separator"] %}
{%-   if haste.lookup.compose.get(param) is not none %}
    - {{ param }}: {{ haste.lookup.compose[param] }}
{%-   endif %}
{%- endfor %}
{%- if haste.install.rootless %}
    - user: {{ haste.lookup.user.name }}
{%- endif %}
    - watch:
      - Haste is installed
