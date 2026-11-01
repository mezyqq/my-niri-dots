#!/bin/sh
# Общая часть: раскладывает конфиги, обои, скрипты; собирает fetch и noctalia.
# Вызывается из install-<дистр>.sh после установки пакетов. Можно запустить и отдельно.
# Переменные: SKIP_NOCTALIA_BUILD=1 — не собирать noctalia (Nix ставит её сам).
set -eu
DOTS=$(cd "$(dirname "$0")/.." && pwd)
BACKUP="$HOME/.dotfiles-backup-$(date +%Y%m%d-%H%M%S)"

say() { printf '\033[1;33m==>\033[0m %s\n' "$*"; }

# копирует $1 (из репо) в $2, старое кладёт в бэкап
put() {
    src=$DOTS/$1 dst=$2
    if [ -e "$dst" ] || [ -L "$dst" ]; then
        mkdir -p "$BACKUP/$(dirname "${dst#"$HOME"/}")"
        mv "$dst" "$BACKUP/${dst#"$HOME"/}"
    fi
    mkdir -p "$(dirname "$dst")"
    cp -a "$src" "$dst"
}

say "Конфиги -> ~/.config (старые -> $BACKUP)"
for item in "$DOTS"/config/* "$DOTS"/config/.[!.]*; do
    [ -e "$item" ] || continue
    name=$(basename "$item")
    put "config/$name" "$HOME/.config/$name"
done
put home/.zshrc "$HOME/.zshrc"

say "Скрипты -> ~/.local/bin"
mkdir -p "$HOME/.local/bin"
for f in "$DOTS"/local/bin/*; do put "local/bin/$(basename "$f")" "$HOME/.local/bin/$(basename "$f")"; done
chmod +x "$HOME"/.local/bin/hyfetch "$HOME"/.local/bin/macchina "$HOME"/.local/bin/3d-launcher "$HOME"/.local/bin/shot "$HOME"/.local/bin/tty1

say "Ярлыки, цветовые схемы, настройки noctalia"
put local/share/applications/launcher-model-settings.desktop "$HOME/.local/share/applications/launcher-model-settings.desktop"
for f in "$DOTS"/local/share/color-schemes/*; do put "local/share/color-schemes/$(basename "$f")" "$HOME/.local/share/color-schemes/$(basename "$f")"; done
put local/state/noctalia/settings.toml "$HOME/.local/state/noctalia/settings.toml"

say "Обои -> ~/Pictures/Wallpapers, видео-обои -> ~/Videos/wallpaper, 3D-модель -> ~/launcher-model"
mkdir -p "$HOME/Pictures/Wallpapers" "$HOME/Videos/wallpaper" "$HOME/launcher-model"
cp -n "$DOTS"/wallpapers/* "$HOME/Pictures/Wallpapers/"
cp -n "$DOTS"/videos/* "$HOME/Videos/wallpaper/"
cp -n "$DOTS"/launcher-model/* "$HOME/launcher-model/"

# в нескольких конфигах прописан абсолютный путь автора
say "Пути /home/mezyq -> $HOME"
for f in .config/qt5ct/qt5ct.conf .config/qt6ct/qt6ct.conf .config/fuzzel/fuzzel.ini .local/state/noctalia/settings.toml; do
    [ -f "$HOME/$f" ] && sed -i "s#/home/mezyq#$HOME#g" "$HOME/$f"
done

say "Сборка fetch (форк с 3D-моделью Gentoo и цветами hyfetch)"
tmp=$(mktemp -d)
cp "$DOTS"/fetch-src/* "$tmp/"
make -C "$tmp" fetch >/dev/null
install -m 755 "$tmp/fetch" "$HOME/.local/bin/fetch"
rm -rf "$tmp"

if [ "${SKIP_NOCTALIA_BUILD:-0}" != 1 ] && ! command -v noctalia >/dev/null; then
    say "Сборка noctalia из исходников (github.com/noctalia-dev/noctalia)"
    src="$HOME/src/noctalia"
    [ -d "$src/.git" ] || git clone --depth 1 https://github.com/noctalia-dev/noctalia "$src"
    (cd "$src" && just configure release && just build release && sudo just install release)
fi

say "Готово. Бэкап старых файлов: $BACKUP"
echo "  - сменить шелл на zsh:   chsh -s \"\$(command -v zsh)\""
echo "  - выбрать сессию niri в дисплей-менеджере (или запустить: niri-session)"
echo "  - ~/.local/bin должен быть в PATH раньше /usr/bin (для обёрток hyfetch/macchina)"
