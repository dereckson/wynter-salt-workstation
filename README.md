      ___ ___             __
     |   Y   .--.--.-----|  |_.-----.----.
     |.  |   |  |  |     |   _|  -__|   _|
     |. / \  |___  |__|__|____|_____|__|
     |:      |_____|
     |::.|:. |        Dereckson's states
     `--- ---'        for a workstation.

This state root configuration allows to maintain workstations
details like the eid in Chromium installation automatically.

Structure
=========

States are organized in roles and units. A role is an intent
like "a workstation". An unit is a set of states to deploy
something like "eid".

Directories follow the `roles/<role name>/<unit name>` structure.

Roles
=====

* core: units for every machine, workstation or not
* workstation: a dev/ssh/browser machine used as a workstation

Setup a new machine
===================

For a master, or masterless installation:

1. Include it in the pillar data if needed (e.g. declare a laptop)
2. Symlink your local copy of this repository to /srv/salt
3. Sync the custom modules (_modules/ folder):
   `salt-call --local saltutil.sync_all`

Servers
=======

Wynter salt states aren't intended for servers but for workstations.

To get a comprehensive dev environment for remote dev servers,
check https://devcentral.nasqueron.org/diffusion/OPS/ devserver
role.
