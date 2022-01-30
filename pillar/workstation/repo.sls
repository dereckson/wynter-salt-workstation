repositories:

    ###
    ### RHEL family
    ###

    ### Fedora Copr (Cool Other Package Repo)
    copr:
      - keefle/glow

    ### RPM Fusion
    rpmfusion:
      - free
      - nonfree

    rpmfusion_extra:
      - free-release-tainted
      - nonfree-release-tainted

    rpmfusion_rawhide:
      - free-release-rawhide
      - nonfree-release-rawhide

    # Third party repositories can be given as:
    #   a) URL repository, to be placed directly in repos folder
    #      or to be used through dnf config-manager --add-repo
    #      --> put them in third_party_as_repo
    #
    #   b) RPM package, the definition alone or with a GPG key
    #      --> put them in third_party_as_rpm

    third_party_as_repo:
        hashicorp: https://rpm.releases.hashicorp.com/fedora/hashicorp.repo

    third_party_as_rpm:
        eid-archive: https://eid.belgium.be/sites/default/files/software/eid-archive-fedora-2021-1.noarch.rpm
