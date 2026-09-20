# Networking

`roles/core/network` (every minion) installs a **local Unbound** recursive cache and points systemd-resolved at it.

## Resolver layout

```
applications → systemd-resolved (stub) → Unbound on 127.0.0.1 / ::1 → upstream
```

Unbound config: `/etc/unbound/conf.d/local-resolver.conf` (group `unbound`).

| Setting | Value |
| --- | --- |
| Listen | `127.0.0.1` and `::1`, port 53 |
| ACL | localhost only |
| Hardening | hide identity/version, harden-below-nxdomain, harden-referral-path, qname-minimisation |
| Forward `lan.` | pillar `network.gateway` (currently **172.27.26.100**) |
| Forward `.` | pillar `network.dns` (see below) |

`unbound` is enabled and running; the unit is restarted when the conf file changes.

### systemd-resolved drop-in

`/etc/systemd/resolved.conf.d/10-unbound.conf`:

```ini
[Resolve]
DNS=127.0.0.1 ::1
FallbackDNS=
DNSStubListener=yes
```

`systemd-resolved` is enabled and watched on that file.

## Upstream DNS (pillar)

`pillar/core/network.sls`:

```yaml
network:
  gateway: 172.27.26.100
  dns:
    - 9.9.9.9
    - 8.8.8.8
    - 1.1.1.1
    - 4.2.2.1
```

To change public resolvers or the LAN forwarder, edit those keys and re-apply `roles/core/network`.

## NetworkManager (BlueDrake)

If Salt can read `nodes:<id>.network.main_interface`, a `cmd.run` (on changes to the resolved drop-in) will:

1. Resolve the NM connection name for that device (`nmcli -g GENERAL.CONNECTION device show <iface>`)
2. Set IPv4/IPv6 to ignore DHCP DNS, DNS `127.0.0.1` / `::1`, priority `-50`
3. `nmcli connection up` that connection

Only **BlueDrake** currently defines `main_interface: eno1`.

!!! warning "Hosts without `main_interface`"
    The Jinja still emits `nmcli … device show` with an empty device name when the key is absent. The state is `onchanges` of the resolved drop-in, so it may fail on Yakin/Draugh the first time that file is written. Whether that is tolerated is not documented in-repo.

## Other network software

Workstation packages include `mosh`, `nmap`, `whois`, `rsync`. There is no firewall state in this tree (`map.jinja` only *names* iptables/firewalld/pf per OS).
