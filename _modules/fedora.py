# -*- coding: utf-8 -*-

#   -------------------------------------------------------------
#   Salt — Node execution module
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Wynter
#   Description:    Helper functions for Fedora states
#   License:        BSD-2-Clause
#   -------------------------------------------------------------


def get_version(rawhide_name = 'rawhide'):
    if is_rawhide():
      return rawhide_name

    return __grains__['osrelease']


def is_rawhide():
    return __salt__["node.get"]("rollingRelease")

    return __pillar__.get(f'nodes:{nodename}:rollingRelease', False)
