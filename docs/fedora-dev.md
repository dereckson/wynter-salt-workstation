# Fedora RPM work

Role `fedora-dev` is assigned to **BlueDrake** and **Draugh**. It only includes `roles/fedora-dev/software`.

## Packages

| Package | Typical use |
| --- | --- |
| `dnf-utils` | `dnf repoquery`, `dnf download`, `dnf builddep`, etc. |
| `perl-generators` | RPM dependency generation for Perl |
| `setools-console` | SELinux policy queries (`sesearch`, `seinfo`, …) |

Nothing else (no mock/koji/rpmbuild wrapper, no `~/rpmbuild` layout) is declared in this role. General compilers and git still come from the workstation software states on those same hosts.
