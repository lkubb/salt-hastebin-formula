# -*- coding: utf-8 -*-
# vim: ft=yaml
---
haste:
  lookup:
    master: template-master
    # Just for testing purposes
    winner: lookup
    added_in_lookup: lookup_value
    compose:
      create_pod: null
      pod_args: null
      project_name: haste
      remove_orphans: true
      service:
        container_prefix: null
        ephemeral: true
        pod_prefix: null
        restart_policy: on-failure
        separator: null
        stop_timeout: null
    paths:
      base: /opt/containers/haste
      compose: docker-compose.yml
      config_haste: haste.env
      config_memcached: memcached.env
      config_redis: redis.env
      data: data
      src: src
    user:
      groups: []
      home: null
      name: haste
      shell: /usr/sbin/nologin
      uid: null
    containers:
      haste: {}
      memcached:
        image: docker.io/library/memcached:latest
        port: 11211
      redis:
        image: docker.io/library/redis:alpine
        port: 6379
    repo: https://github.com/toptal/haste-server
  install:
    rootless: true
    remove_all_data_for_sure: false
  config:
    documents:
      - about=./about.md
    host: 0.0.0.0
    key_length: 10
    keygenerator_keyspace: null
    keygenerator_type: phonetic
    logging:
      colorize: true
      level: verbose
      type: Console
    max_length: 400000
    port: 7777
    ratelimits:
      blacklist: []
      blacklist_every_seconds: null
      blacklist_total_requests: null
      normal_every_milliseconds: 60000
      normal_total_requests: 500
      whitelist: []
      whitelist_every_seconds: null
      whitelist_total_requests: null
    recompress_static_assets: true
    static_max_age: 86400
    storage:
      database_url: null
      db: 2
      expire_seconds: 2592000
      filepath: null
      host: memcached
      password: null
      port: null
      type: memcached
      username: null

  tofs:
    # The files_switch key serves as a selector for alternative
    # directories under the formula files directory. See TOFS pattern
    # doc for more info.
    # Note: Any value not evaluated by `config.get` will be used literally.
    # This can be used to set custom paths, as many levels deep as required.
    files_switch:
      - any/path/can/be/used/here
      - id
      - roles
      - osfinger
      - os
      - os_family
    # All aspects of path/file resolution are customisable using the options below.
    # This is unnecessary in most cases; there are sensible defaults.
    # Default path: salt://< path_prefix >/< dirs.files >/< dirs.default >
    #         I.e.: salt://haste/files/default
    # path_prefix: template_alt
    # dirs:
    #   files: files_alt
    #   default: default_alt
    # The entries under `source_files` are prepended to the default source files
    # given for the state
    # source_files:
    #   haste-config-file-file-managed:
    #     - 'example_alt.tmpl'
    #     - 'example_alt.tmpl.jinja'

    # For testing purposes
    source_files:
      Haste environment file is managed:
      - haste.env.j2

  # Just for testing purposes
  winner: pillar
  added_in_pillar: pillar_value
