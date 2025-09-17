#   -------------------------------------------------------------
#   Install Ollama
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Wynter
#   License:        Trivial work, not eligible to copyright
#   -------------------------------------------------------------

{% if salt['node.has']('amd_gpu') %}
  {% set ollama_image = "ollama/ollama:rocm" %}
{% else %}
  {% set ollama_image = "ollama/ollama" %}
{% endif %}

ollama_docker_image:
  docker_image.present:
    - name: {{ ollama_image }}

ollama_docker_container:
  docker_container.running:
    - name: ollama
    - image: {{ ollama_image }}
    - detach: True
    - devices:
      - /dev/kfd
      - /dev/dri
    - binds:
      - ollama:/root/.ollama
    - port_bindings:
      - 11434:11434
