# E-Tron

E-Tron (short for **Exploitron**) is a Docker-based workbench for solving binary exploitation CTF challenges, with an embedded AI agent.

## What's inside

The container is built on Debian 13 and ships a full pwn toolkit:

| Category | Tools |
|---|---|
| Reverse engineering | `radare2` + `r2ghidra` (Ghidra decompiler plugin) |
| Debugging | `gdb`, `gdb-multiarch`, `pwndbg`, `gdb-pt-dump` |
| Exploit development | `pwntools`, `angr`, `ROPgadget`, `ropper`, `ropr`, `one_gadget` |
| Emulation | `qemu-system`, `qemu-user-static` |
| Utilities | `checksec`, `objdump`, `strace`, `socat`, `netcat`, `readelf` |
| AI agent | [opencode](https://opencode.ai) with `radare2` and `gdb` MCP servers |

The shell is `zsh` with Oh My Zsh and `atuin` for history.

## Usage

Build the image once:

```sh
docker build -t exploitron:latest build/
```

Then, from any challenge directory, run:

```sh
/path/to/exploitron/launch.sh
```

This mounts the current directory into `/home/user/chal` inside the container, so any binaries or files present locally are immediately available. Each challenge directory gets its own isolated opencode session (keyed by the directory path), so conversation history is preserved across runs for the same challenge.

The container also forwards Wayland, PipeWire, GPU (`/dev/dri`), and sound (`/dev/snd`) devices for GUI tools.

## AI agent workflow

The embedded opencode agent follows this workflow for remote pwn challenges:

1. **Binary analysis** — run `checksec`, load into `radare2`/r2ghidra, identify the vulnerability
2. **Exploit development** — craft the exploit with `pwntools`, debug locally with `gdb`/`pwndbg`
3. **Remote exploitation** — connect to the target, execute the exploit, capture the flag
4. **Documentation** — summarize the vulnerability and exploit steps

See [`prompts/AGENTS.md`](prompts/AGENTS.md) for the full agent prompt.

## CI

A GitHub Actions workflow builds the Docker image on every push and pull request. See [`.github/workflows/build.yml`](.github/workflows/build.yml).
