# vim: ft=sls

{#-
    *Meta-state*.

    This installs the haste, memcached, redis containers,
    manages their configuration and starts their services.
#}

include:
  - .package
  - .config
  - .service
