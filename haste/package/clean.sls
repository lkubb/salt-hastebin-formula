# vim: ft=sls

{#-
    Removes the haste, memcached, redis containers
    and the corresponding user account and service units.
    Has a depency on `haste.config.clean`_.
    If ``remove_all_data_for_sure`` was set, also removes all data.
#}

{%- set tplroot = tpldir.split("/")[0] %}
{%- set sls_config_clean = tplroot ~ ".config.clean" %}
{%- from tplroot ~ "/map.jinja" import mapdata as haste with context %}

include:
  - {{ sls_config_clean }}

{%- if haste.install.autoupdate_service %}

Podman autoupdate service is disabled for Haste:
{%-   if haste.install.rootless %}
  compose.systemd_service_disabled:
    - user: {{ haste.lookup.user.name }}
{%-   else %}
  service.disabled:
{%-   endif %}
    - name: podman-auto-update.timer
{%- endif %}

Haste is absent:
  compose.removed:
    - name: {{ haste.lookup.paths.compose }}
    - volumes: {{ haste.install.remove_all_data_for_sure }}
{%- for param in ["project_name", "container_prefix", "pod_prefix", "separator"] %}
{%-   if haste.lookup.compose.get(param) is not none %}
    - {{ param }}: {{ haste.lookup.compose[param] }}
{%-   endif %}
{%- endfor %}
{%- if haste.install.rootless %}
    - user: {{ haste.lookup.user.name }}
{%- endif %}
    - require:
      - sls: {{ sls_config_clean }}

Haste compose file/repo is absent:
  file.absent:
    - names:
      - {{ haste.lookup.paths.compose }}
      - {{ haste.lookup.paths.src }}
    - require:
      - Haste is absent

{%- if haste.install.podman_api %}

Haste podman API is unavailable:
  compose.systemd_service_dead:
    - name: podman
    - user: {{ haste.lookup.user.name }}
    - onlyif:
      - fun: user.info
        name: {{ haste.lookup.user.name }}

Haste podman API is disabled:
  compose.systemd_service_disabled:
    - name: podman
    - user: {{ haste.lookup.user.name }}
    - onlyif:
      - fun: user.info
        name: {{ haste.lookup.user.name }}
{%- endif %}

Haste user session is not initialized at boot:
  compose.lingering_managed:
    - name: {{ haste.lookup.user.name }}
    - enable: false
    - onlyif:
      - fun: user.info
        name: {{ haste.lookup.user.name }}

Haste user account is absent:
  user.absent:
    - name: {{ haste.lookup.user.name }}
    - purge: {{ haste.install.remove_all_data_for_sure }}
    - require:
      - Haste is absent
    - retry:
        attempts: 5
        interval: 2

{%- if haste.install.remove_all_data_for_sure %}

Haste paths are absent:
  file.absent:
    - names:
      - {{ haste.lookup.paths.base }}
    - require:
      - Haste is absent
{%- endif %}
