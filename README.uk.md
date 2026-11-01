# my-niri-dots :3

[English](README.md) | [Русский](README.ru.md) | **Українська**

Дотфайли на базі **[Noctalia Shell](https://github.com/noctalia-dev/noctalia)**.

Мій робочий стіл на **niri** (Gentoo): шел **noctalia**, усі теми в системі синхронізуються з головною палітрою шпалер. Власний лаунчер на **quickshell** з 3D-моделлю, **kitty** з розмиттям, а fetch-утиліти (**fastfetch**, **hyfetch**, **fetch**) показують PNG-логотип Gentoo, перефарбований у кольори прапора.

## Встановлення

```sh
git clone https://github.com/mezyqq/my-niri-dots
cd my-niri-dots
./install-gentoo.sh   # або ./install-arch.sh, ./install-debian.sh, ./install-nix.sh
```

Кожен скрипт ставить пакети своїм пакетним менеджером, а потім запускає `install/common.sh`. Той:
- копіює конфіги в `~/.config` (те, що там уже лежить, переноситься в `~/.dotfiles-backup-<дата>`);
- кладе шпалери в `~/Pictures/Wallpapers`, відеошпалери в `~/Videos/wallpaper`, 3D-модель лаунчера в `~/launcher-model`;
- кладе скрипти в `~/.local/bin` і збирає `fetch` з `fetch-src/`;
- якщо noctalia ще не встановлена, збирає її з вихідного коду (на Nix вона ставиться зі свого flake).

Якщо потрібні тільки файли, без встановлення пакетів: `sh install/common.sh`.

## Що всередині

| Шлях | Що це |
|---|---|
| `config/niri` | `config.kdl` з коментарями російською + `noctalia.kdl` (кольори) |
| `config/noctalia`, `local/state/noctalia/settings.toml` | шаблони noctalia (flameshot, лаунчер) і її налаштування |
| `config/quickshell/serplauncher` | лаунчер (Super+D) з 3D-моделлю та емодзі |
| `config/kitty` | kitty з прозорістю та темою noctalia |
| `config/fastfetch`, `config/hyfetch.json`, `config/fetch`, `config/macchina` | fetch-утиліти з PNG-логотипом Gentoo / Tux |
| `local/bin/hyfetch`, `local/bin/macchina` | обгортки: перефарбовують PNG-логотип у кольори прапора / виводять картинку через kitty |
| `local/bin/shot`, `tty1`, `3d-launcher` | скриншот через grim+slurp, вихід у tty1, вікно налаштувань моделі лаунчера |
| `fetch-src/` | форк [fetch](https://github.com/mezyqq/fetch-hyfetch): 3D-модель, що крутиться, і кольори hyfetch |
| `config/{fuzzel,rofi,flameshot,qt5ct,qt6ct,gtk-3.0,gtk-4.0,btop,zed,opencode,vesktop,waybar,neofetch}`, `kdeglobals`, `dolphinrc`, `mimeapps.list` | інші конфіги та теми |
| `home/.zshrc` | zsh: дворядковий промпт, автопідказки, команда `wallpaper <файл>` (копіює картинку в папку шпалер) |
| `wallpapers/`, `videos/` | шпалери |

## Гарячі клавіші

| Клавіші | Дія |
|---|---|
| Super+T | kitty |
| Super+D | лаунчер |
| Super+A | Dolphin |
| Super+W | Waterfox |
| Super+S | центр керування noctalia |
| Super+Shift+W | вибір шпалер |
| Super+Shift+S | скриншот (flameshot) |

Повний список: Super+Shift+/ у niri.

## Примітки
- Обгортки в `~/.local/bin` працюють, тільки якщо ця папка стоїть у `PATH` раніше за `/usr/bin`.
- На Debian/Ubuntu niri і quickshell можуть бути відсутні в apt: скрипт покаже, чого не знайшов.
- На NixOS niri краще ввімкнути в системному конфізі: `programs.niri.enable = true;`.
- У `.zshrc` плагіни шукаються в `/usr/share/zsh/plugins/` (так на Arch і Gentoo). На Debian і Nix цей шлях інший.
