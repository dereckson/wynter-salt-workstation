#   -------------------------------------------------------------
#   Salt — Provision a small local network
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Wynter
#   License:        Trivial work, not eligible to copyright
#   -------------------------------------------------------------

{% if salt['node.has']('razer') %}

#   -------------------------------------------------------------
#   PulseAudio configuration
#
#   On some Linux distributions not using PipeWire,
#   alsa_dir could be /usr/share/pulseaudio/alsa-mixer
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

{% set alsa_dir = '/usr/share/alsa-card-profile/mixer' %}

razer_nari_ultimate_pulseaudio_paths:
  file.recurse:
    - source: salt://roles/core/drivers/files/pulseaudio/razer-nari-ultimate/paths
    - name: {{ alsa_dir }}/paths/
    - clean: False

{{ alsa_dir }}/profile-sets/razer-nari-usb-audio.conf:
  file.managed:
    - source: salt://roles/core/drivers/files/pulseaudio/razer-nari-ultimate/razer-nari-usb-audio.conf

/lib/udev/rules.d/91-pulseaudio-razer-nari.rules:
  file.managed:
    - source: salt://roles/core/drivers/files/pulseaudio/razer-nari-ultimate/91-pulseaudio-razer-nari.rules
    - template: mako # as Jinja doesn't like {{{ }}}
    - context:
        profile_set_instruction: ACP_PROFILE_SET

{% endif %}
