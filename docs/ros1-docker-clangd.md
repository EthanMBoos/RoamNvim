# ROS 1 + devcontainer + clangd LSP

Use `remote-nvim.nvim` to open the workspace inside its `.devcontainer`. Neovim,
clangd, and the build all run on the container side, so there is no `docker exec`
wrapper or host/guest path mapping to maintain.

## Prerequisites

- `devpod` is installed on your local machine
- The project has a working `.devcontainer/`
- The devcontainer image installs `clangd`
- The workspace is built in the container with `catkin_make -DCMAKE_EXPORT_COMPILE_COMMANDS=ON`

## Optional `.clangd` (workspace root, commit this)

If ROS-generated headers live in `devel/include/`, point clangd at them with a
container-side path:

```yaml
CompileFlags:
  Add:
    - -I/workspaces/your_ws/devel/include
```

Use the path as it exists **inside the devcontainer**.

## Workflow

1. Open Neovim from the project root on your host
2. Run `:RemoteStart`
3. Pick the current project's `.devcontainer`
4. In the remote session, build the workspace with `catkin_make -DCMAKE_EXPORT_COMPILE_COMMANDS=ON`
5. Open any `.cpp` file — clangd now runs inside the container and reads the container paths directly

## Troubleshooting

**Devcontainer does not show up** — confirm `.devcontainer/` exists in the current project and `devpod` is on `PATH`. `:checkhealth remote-nvim` is the fastest sanity check.

**clangd not starting** — check `:LspInfo` inside the remote session. The container image must include `clangd`.

**Custom messages not resolving** — confirm `devel/include/your_msgs/` exists after the in-container build.
