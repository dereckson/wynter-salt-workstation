#   -------------------------------------------------------------
#   Salt — Provision a small local network
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Wynter
#   License:        Trivial work, not eligible for copyright
#   -------------------------------------------------------------

#   -------------------------------------------------------------
#   Software
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

unbound:
  pkg.installed

#   -------------------------------------------------------------
#   Configuration
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

/etc/unbound/conf.d/local-resolver.conf:
  file.managed:
    - source: salt://roles/core/network/files/local-resolver.conf
    - user: root
    - group: unbound
    - mode: 644
    - makedirs: true
    - template: jinja
    - context:
        gateway: {{ pillar["network"]["gateway"] }}
        dns_servers: {{ pillar["network"]["dns"] }}

#   -------------------------------------------------------------
#   Service
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

unbound_service:
  service.running:
    - name: unbound
    - enable: true
    - watch:
      - file: /etc/unbound/conf.d/local-resolver.conf

/etc/systemd/resolved.conf.d/10-unbound.conf:
  file.managed:
    - user: root
    - group: root
    - mode: "0644"
    - makedirs: true
    - contents: |
        [Resolve]
        DNS=127.0.0.1 ::1
        FallbackDNS=
        DNSStubListener=yes
    - require:
      - pkg: unbound

systemd-resolved:
  service.running:
    - name: systemd-resolved
    - enable: true
    - watch:
      - file: /etc/systemd/resolved.conf.d/10-unbound.conf

#   -------------------------------------------------------------
#   Network Manager integration
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

{% set device = salt["node.get"]("network:main_interface") %}

networkmanager_dns_hook:
  cmd.run:
    - name: |
        CON=$(nmcli -g GENERAL.CONNECTION device show {{ device }})
        nmcli connection modify "$CON" \
          ipv4.ignore-auto-dns yes \
          ipv4.dns "127.0.0.1" \
          ipv6.ignore-auto-dns yes \
          ipv6.dns "::1" \
          ipv4.dns-priority -50 \
          ipv6.dns-priority -50
        nmcli connection up "$CON"
    - onchanges:
      - file: /etc/systemd/resolved.conf.d/10-unbound.conf
