# Identity and secrets

## Belgian eID

`roles/workstation/eid` installs official middleware so the smart card works in **eid-viewer** and **Chromium**.

### Packages

- `eid-mw`, `eid-viewer`
- NSS tools (`libnss3-tools` / `nss-tools` / `nss` per OS)

### Vendor repository

| OS | Action |
| --- | --- |
| Debian | latest `eid-archive_latest.deb` from eid.belgium.be → `/etc/apt/sources.list.d/eid.list` |
| Fedora | `eid-archive-fedora-2025-2.noarch.rpm` → `/etc/yum.repos.d/eid-archive.repo` |
| Fedora Rawhide | `$releasever` in that repo file is replaced by `fedora.eid_repo_last_version()` (walks files.eid.belgium.be for the newest numbered Fedora that still publishes `repomd.xml`) |

### Chromium / NSS

For each pillar user, once, in `$HOME`:

```bash
mkdir -p .pki/nssdb
chmod 700 .pki/nssdb
certutil -d .pki/nssdb -N --empty-password
modutil -force -add "Belgium eID" \
    -libfile <libdir>/libbeidpkcs11.so.0 \
    -dbdir sql:.pki/nssdb
```

`libdir` is `/usr/lib/x86_64-linux-gnu` on Debian, `/usr/lib64` on RedHat, `/usr/local/lib` on FreeBSD. The state uses `creates: ~/.pki/nssdb/pkcs11.txt` so it will not re-run if you already have an NSS DB.

Firefox is installed but **not** configured for the PKCS#11 module in these states.

## HashiCorp Vault CLI

`vault` is installed from:

- Fedora: HashiCorp yum repo (`repositories.third_party_as_repo.hashicorp`) plus the `vault` package in ops/misc
- Debian: apt source `apt.releases.hashicorp.com` and the same package

Zsh exports `VAULT_ADDR=https://127.0.0.1:8200` and registers CLI completion.

**No `vault` server, TLS cert, or systemd unit is defined in this repository.** The CLI expects something already listening on localhost:8200 (or you override `VAULT_ADDR`).

## Ansible

Package `ansible` is installed on the workstation role. No inventory or `ansible.cfg` is deployed here.

## Passwords / generators

`pwgen` is installed. FreeBSD also gets `aescrypt`.
