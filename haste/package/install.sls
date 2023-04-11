# vim: ft=sls

{%- set tplroot = tpldir.split("/")[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as haste with context %}
{%- from tplroot ~ "/libtofs.jinja" import files_switch with context %}

Haste user account is present:
  user.present:
{%- for param, val in haste.lookup.user.items() %}
{%-   if val is not none and param != "groups" %}
    - {{ param }}: {{ val }}
{%-   endif %}
{%- endfor %}
    - usergroup: true
    - createhome: true
    - groups: {{ haste.lookup.user.groups | json }}
    # (on Debian 11) subuid/subgid are only added automatically for non-system users
    - system: false

Haste user session is initialized at boot:
  compose.lingering_managed:
    - name: {{ haste.lookup.user.name }}
    - enable: {{ haste.install.rootless }}
    - require:
      - user: {{ haste.lookup.user.name }}

Haste paths are present:
  file.directory:
    - names:
      - {{ haste.lookup.paths.base }}
    - user: {{ haste.lookup.user.name }}
    - group: {{ haste.lookup.user.name }}
    - makedirs: true
    - require:
      - user: {{ haste.lookup.user.name }}

{%- if haste.install.podman_api %}

Haste podman API is enabled:
  compose.systemd_service_enabled:
    - name: podman.socket
    - user: {{ haste.lookup.user.name }}
    - require:
      - Haste user session is initialized at boot

Haste podman API is available:
  compose.systemd_service_running:
    - name: podman.socket
    - user: {{ haste.lookup.user.name }}
    - require:
      - Haste user session is initialized at boot
{%- endif %}

Haste repo is present:
  git.latest:
    - name: {{ haste.lookup.repo }}
    - target: {{ haste.lookup.paths.src }}
    - user: {{ haste.lookup.user.name }}

Haste compose file is managed:
  file.managed:
    - name: {{ haste.lookup.paths.compose }}
    - source: {{ files_switch(["docker-compose.yml", "docker-compose.yml.j2"],
                              lookup="Haste compose file is present"
                 )
              }}
    - mode: '0644'
    - user: root
    - group: {{ haste.lookup.rootgroup }}
    - makedirs: True
    - template: jinja
    - makedirs: true
    - context:
        haste: {{ haste | json }}

Haste is installed:
  compose.installed:
    - name: {{ haste.lookup.paths.compose }}
{%- for param, val in haste.lookup.compose.items() %}
{%-   if val is not none and param != "service" %}
    - {{ param }}: {{ val }}
{%-   endif %}
{%- endfor %}
{%- for param, val in haste.lookup.compose.service.items() %}
{%-   if val is not none %}
    - {{ param }}: {{ val }}
{%-   endif %}
{%- endfor %}
    - watch:
      - file: {{ haste.lookup.paths.compose }}
      - git: {{ haste.lookup.repo }}
{%- if haste.install.rootless %}
    - user: {{ haste.lookup.user.name }}
    - require:
      - user: {{ haste.lookup.user.name }}
{%- endif %}

{%- if haste.install.autoupdate_service is not none %}

Podman autoupdate service is managed for Haste:
{%-   if haste.install.rootless %}
  compose.systemd_service_{{ "enabled" if haste.install.autoupdate_service else "disabled" }}:
    - user: {{ haste.lookup.user.name }}
{%-   else %}
  service.{{ "enabled" if haste.install.autoupdate_service else "disabled" }}:
{%-   endif %}
    - name: podman-auto-update.timer
{%- endif %}
