# -*- coding: utf-8 -*-
# vim: ft=sls

{%- set tplroot = tpldir.split('/')[0] %}
{%- set sls_package_install = tplroot ~ '.package.install' %}
{%- from tplroot ~ "/map.jinja" import mapdata as haste with context %}
{%- from tplroot ~ "/libtofs.jinja" import files_switch with context %}

include:
  - {{ sls_package_install }}

Haste environment files are managed:
  file.managed:
    - names:
      - {{ haste.lookup.paths.config_haste }}:
        - source: {{ files_switch(['haste.env', 'haste.env.j2'],
                                  lookup='haste environment file is managed',
                                  indent_width=10,
                     )
                  }}
{%- if "memcached" == haste.config.storage.type %}
      - {{ haste.lookup.paths.config_memcached }}:
        - source: {{ files_switch(['memcached.env', 'memcached.env.j2'],
                                  lookup='memcached environment file is managed',
                                  indent_width=10,
                     )
                  }}
{%- elif "redis" == haste.config.storage.type %}
      - {{ haste.lookup.paths.config_redis }}:
        - source: {{ files_switch(['redis.env', 'redis.env.j2'],
                                  lookup='redis environment file is managed',
                                  indent_width=10,
                     )
                  }}
{%- endif %}
    - mode: '0640'
    - user: root
    - group: {{ haste.lookup.user.name }}
    - makedirs: True
    - template: jinja
    - require:
      - user: {{ haste.lookup.user.name }}
    - watch_in:
      - Haste is installed
    - context:
        haste: {{ haste | json }}
