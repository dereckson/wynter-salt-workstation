#   -------------------------------------------------------------
#   Deploy AI LLM stack
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Wynter
#   License:        Trivial work, not eligible to copyright
#   -------------------------------------------------------------

{% if grains['kernel'] == 'Linux' %}

include:
  # Docker stack
  - .ollama

  # AMD GPU stack on workstation
  {% if salt['node.has']('amd_gpu') %}
  - .rocm
  {% endif %}

{% endif %}
