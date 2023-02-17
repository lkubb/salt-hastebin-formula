# vim: ft=sls

{#-
    *Meta-state*.

    Undoes everything performed in the ``haste`` meta-state
    in reverse order, i.e. stops the haste, memcached, redis services,
    removes their configuration and then removes their containers.
#}

include:
  - .service.clean
  - .config.clean
  - .package.clean
