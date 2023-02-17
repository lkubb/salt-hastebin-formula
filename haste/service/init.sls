# vim: ft=sls

{#-
    Starts the haste, memcached, redis container services
    and enables them at boot time.
    Has a dependency on `haste.config`_.
#}

include:
  - .running
