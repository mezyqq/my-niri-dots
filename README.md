# my-niri-dots :3

**English** | [Русский](README.ru.md) | [Українська](README.uk.md)

Dotfiles based on **[Noctalia Shell](https://github.com/noctalia-dev/noctalia)**.

My **niri** desktop (Gentoo): **noctalia** shell, and every theme on the system follows the main color palette of the wallpaper. A custom **quickshell** launcher with a 3D model, **kitty** with blur, and fetch tools (**fastfetch**, **hyfetch**, **fetch**) that show a PNG Gentoo logo recolored in the flag colors.

## Installation

```sh
git clone https://github.com/mezyqq/my-niri-dots
cd my-niri-dots
./install-gentoo.sh   # or ./install-arch.sh, ./install-debian.sh, ./install-nix.sh
```

Each script installs packages with its distro's package manager and then runs `install/common.sh`, which:
- copies configs to `~/.config` (anything already there is moved to `~/.dotfiles-backup-<date>`);
- puts wallpapers in `~/Pictures/Wallpapers`, the video wallpaper in `~/Videos/wallpaper`, and the launcher's 3D model in `~/launcher-model`;
- puts scripts in `~/.local/bin` and builds `fetch` from `fetch-src/`;
- builds noctalia from source if it isn't installed yet (on Nix it comes from its own flake).

To copy only the files, without installing packages: `sh install/common.sh`.

## What's inside

| Path | What it is |
|---|---|
| `config/niri` | `config.kdl` (comments in Russian) + `noctalia.kdl` (colors) |
| `config/noctalia`, `local/state/noctalia/settings.toml` | noctalia templates (flameshot, launcher) and its settings |
| `config/quickshell/serplauncher` | launcher (Super+D) with a 3D model and emoji |
| `config/kitty` | kitty with transparency and the noctalia theme |
| `config/fastfetch`, `config/hyfetch.json`, `config/fetch`, `config/macchina` | fetch tools with a PNG Gentoo / Tux logo |
| `local/bin/hyfetch`, `local/bin/macchina` | wrappers: recolor the PNG logo in the flag colors / draw the image through kitty |
| `local/bin/shot`, `tty1`, `3d-launcher` | screenshot via grim+slurp, drop to tty1, launcher model settings window |
| `fetch-src/` | a fork of [fetch](https://github.com/mezyqq/fetch-hyfetch): spinning 3D model and hyfetch colors |
| `config/{fuzzel,rofi,flameshot,qt5ct,qt6ct,gtk-3.0,gtk-4.0,btop,zed,opencode,vesktop,waybar,neofetch}`, `kdeglobals`, `dolphinrc`, `mimeapps.list` | other configs and themes |
| `home/.zshrc` | zsh: two-line prompt, autosuggestions, `wallpaper <file>` command (copies an image into the wallpapers folder) |
| `wallpapers/`, `videos/` | wallpapers |

## Keybindings

| Keys | Action |
|---|---|
| Super+T | kitty |
| Super+D | launcher |
| Super+A | Dolphin |
| Super+W | Waterfox |
| Super+S | noctalia control center |
| Super+Shift+W | wallpaper picker |
| Super+Shift+S | screenshot (flameshot) |

Full list: Super+Shift+/ in niri.

## Notes
- The wrappers in `~/.local/bin` only work if that folder comes before `/usr/bin` in `PATH`.
- On Debian/Ubuntu, niri and quickshell may be missing from apt: the script lists what it couldn't find.
- On NixOS, enable niri in the system config instead: `programs.niri.enable = true;`.
- `.zshrc` looks for plugins in `/usr/share/zsh/plugins/` (the Arch and Gentoo path). Debian and Nix use a different path.
