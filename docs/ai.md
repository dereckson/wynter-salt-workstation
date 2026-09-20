# AI and GPU

`roles/workstation/ai` runs only when `grains['kernel'] == 'Linux'`. It always includes Ollama; it includes ROCm only if `node.has('amd_gpu')` (BlueDrake).

## Ollama (Docker)

Salt states:

- `docker_image.present` for `ollama/ollama:rocm` if `amd_gpu`, else `ollama/ollama`
- `docker_container.running` named **`ollama`**

Container settings (both images):

| Key | Value |
| --- | --- |
| Devices | `/dev/kfd`, `/dev/dri` (always passed, even without AMD) |
| Volume | named volume `ollama` → `/root/.ollama` |
| Ports | `11434:11434` |

Talk to it as a normal Ollama daemon on **localhost:11434** (`ollama` CLI is not installed by these states; curl or a local client against that port).

!!! warning "Docker is a prerequisite"
    Nothing in this repository installs Docker Engine, the Salt docker Python extra, or adds your user to the `docker` group. If `docker_image.present` fails, that is expected on a box that only ran these states.

## ROCm (BlueDrake)

On RedHat family with `amd_gpu`:

- Yum repo `https://repo.radeon.com/rocm/fedora/rocm.repo`
- `/etc/profile.d/rocm.sh` prepends `/opt/rocm/bin` to `PATH` and `/opt/rocm/lib` to `LD_LIBRARY_PATH`

Packages on all OS maps: `rocm-dev` / `rocm-devel`, `rocm-opencl`, `hipblas`, plus cmake, git, make, gcc-c++, python3, pip.

Debian/FreeBSD package names for `rocm` exist in `map.jinja`; the AMD yum repo block is RedHat-only.

New login shells pick up `rocm.sh`; already-open terminals need `source /etc/profile.d/rocm.sh` or a re-login.
