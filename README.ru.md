# my-niri-dots :3

[English](README.md) | **Русский** | [Українська](README.uk.md)

Дотфайлы на базе **[Noctalia Shell](https://github.com/noctalia-dev/noctalia)**.

Мой рабочий стол на **niri** (Gentoo): шелл **noctalia**, все темы в системе синхронятся с главной палитрой обоев. Свой лаунчер на **quickshell** с 3D-моделью, **kitty** с блюром, а fetch-утилиты (**fastfetch**, **hyfetch**, **fetch**) показывают PNG-логотип Gentoo, перекрашенный в цвета флага.

## Установка

```sh
git clone https://github.com/mezyqq/my-niri-dots
cd my-niri-dots
./install-gentoo.sh   # или ./install-arch.sh, ./install-debian.sh, ./install-nix.sh
```

Каждый скрипт ставит пакеты своим пакетным менеджером, а потом запускает `install/common.sh`. Тот:
- копирует конфиги в `~/.config` (то, что там уже лежит, переносится в `~/.dotfiles-backup-<дата>`);
- кладёт обои в `~/Pictures/Wallpapers`, видео-обои в `~/Videos/wallpaper`, 3D-модель лаунчера в `~/launcher-model`;
- кладёт скрипты в `~/.local/bin` и собирает `fetch` из `fetch-src/`;
- если noctalia ещё не установлена, собирает её из исходников (на Nix она ставится из своего flake).

Если нужны только файлы, без установки пакетов: `sh install/common.sh`.

## Что внутри

| Путь | Что это |
|---|---|
| `config/niri` | `config.kdl` с русскими комментариями + `noctalia.kdl` (цвета) |
| `config/noctalia`, `local/state/noctalia/settings.toml` | шаблоны noctalia (flameshot, лаунчер) и её настройки |
| `config/quickshell/serplauncher` | лаунчер (Super+D) с 3D-моделью и эмодзи |
| `config/kitty` | kitty с прозрачностью и темой noctalia |
| `config/fastfetch`, `config/hyfetch.json`, `config/fetch`, `config/macchina` | fetch-утилиты с PNG-логотипом Gentoo / Tux |
| `local/bin/hyfetch`, `local/bin/macchina` | обёртки: перекрашивают PNG-логотип в цвета флага / выводят картинку через kitty |
| `local/bin/shot`, `tty1`, `3d-launcher`, `flameshot-niri` | скриншот через grim+slurp, выход в tty1, окно настроек модели лаунчера, flameshot (Super+Shift+S), который открывается и закрывается без анимации |
| `fetch-src/` | форк [fetch](https://github.com/mezyqq/fetch-hyfetch): крутящаяся 3D-модель и цвета hyfetch |
| `config/{fuzzel,rofi,flameshot,qt5ct,qt6ct,gtk-3.0,gtk-4.0,btop,zed,opencode,vesktop,waybar,neofetch}`, `kdeglobals`, `dolphinrc`, `mimeapps.list` | остальные конфиги и темы |
| `home/.zshrc` | zsh: двухстрочный промпт, автоподсказки, команда `wallpaper <файл>` (копирует картинку в папку обоев) |
| `wallpapers/`, `videos/` | обои |

## Горячие клавиши 

| Клавиши | Действие |
|---|---|
| Super+T | kitty |
| Super+D | лаунчер |
| Super+A | Dolphin |
| Super+W | Waterfox |
| Super+S | центр управления noctalia |
| Super+Shift+W | выбор обоев |
| Super+Shift+S | скриншот (flameshot) |

Полный список: Super+Shift+/ в niri.

## Заметки
- Обёртки в `~/.local/bin` работают, только если эта папка стоит в `PATH` раньше `/usr/bin`.
- На Debian/Ubuntu niri и quickshell могут отсутствовать в apt: скрипт покажет, чего не нашёл.
- На NixOS niri лучше включить в системном конфиге: `programs.niri.enable = true;`.
- В `.zshrc` плагины ищутся в `/usr/share/zsh/plugins/` (так на Arch и Gentoo). На Debian и Nix этот путь другой.
