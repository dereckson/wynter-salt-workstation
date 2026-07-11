# -*- coding: utf-8 -*-

#   -------------------------------------------------------------
#   Salt — Node execution module
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Wynter
#   Description:    Helper functions for Fedora states
#   License:        BSD-2-Clause
#   -------------------------------------------------------------

import logging
import urllib.error
import urllib.request


log = logging.getLogger(__name__)


def get_version(rawhide_name = 'rawhide'):
    if is_rawhide():
      return rawhide_name

    return __grains__['osrelease']


def is_rawhide():
    return __salt__["node.get"]("rollingRelease")


#   -------------------------------------------------------------
#   eID
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


BASE_URL = "https://files.eid.belgium.be/rpm/fedora"
DEFAULT_FLOOR = 19
TIMEOUT = 10


def eid_repo_last_version():
    cache_key = "fedorae.id_repo_last_version"
    if cache_key in __context__:
        return __context__[cache_key]

    version = int(__grains__["osrelease"])
    while version >= DEFAULT_FLOOR:
        if _repomd_exists(version):
            __context__[cache_key] = version
            return version

        version -= 1

    raise CommandExecutionError(
        "eid_repo.last_version: no repomd.xml found walking down "
        "from {0} to {1} at {2}".format(initial, floor, BASE_URL)
    )


def _repomd_exists(version):
    """
    True if <BASE_URL>/<version>/repodata/repomd.xml responds HTTP 200.
    """
    url = f"{BASE_URL}/{version}/repodata/repomd.xml"

    req = urllib.request.Request(url, method="HEAD")
    try:
        with urllib.request.urlopen(req, timeout=TIMEOUT) as resp:
            return resp.status == 200
    except urllib.error.HTTPError as exc:
        log.debug("eid_repo: %s -> HTTP %s", url, exc.code)
        return False
    except urllib.error.URLError as exc:
        log.warning("eid_repo: %s -> %s", url, exc)
        return False
