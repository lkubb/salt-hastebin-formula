Available states
----------------

The following states are found in this formula:

.. contents::
   :local:


``haste``
^^^^^^^^^
*Meta-state*.

This installs the haste, memcached, redis containers,
manages their configuration and starts their services.


``haste.package``
^^^^^^^^^^^^^^^^^
Installs the haste, memcached, redis containers only.
This includes creating systemd service units.


``haste.config``
^^^^^^^^^^^^^^^^
Manages the configuration of the haste, memcached, redis containers.
Has a dependency on `haste.package`_.


``haste.service``
^^^^^^^^^^^^^^^^^
Starts the haste, memcached, redis container services
and enables them at boot time.
Has a dependency on `haste.config`_.


``haste.clean``
^^^^^^^^^^^^^^^
*Meta-state*.

Undoes everything performed in the ``haste`` meta-state
in reverse order, i.e. stops the haste, memcached, redis services,
removes their configuration and then removes their containers.


``haste.package.clean``
^^^^^^^^^^^^^^^^^^^^^^^
Removes the haste, memcached, redis containers
and the corresponding user account and service units.
Has a depency on `haste.config.clean`_.
If ``remove_all_data_for_sure`` was set, also removes all data.


``haste.config.clean``
^^^^^^^^^^^^^^^^^^^^^^
Removes the configuration of the haste, memcached, redis containers
and has a dependency on `haste.service.clean`_.

This does not lead to the containers/services being rebuilt
and thus differs from the usual behavior.


``haste.service.clean``
^^^^^^^^^^^^^^^^^^^^^^^
Stops the haste, memcached, redis container services
and disables them at boot time.


