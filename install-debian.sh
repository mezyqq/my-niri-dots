#!/bin/sh
# Debian 13+/Ubuntu 24.04+: ставит из apt всё, что есть; чего нет (niri/quickshell на старых
# релизах) — выводит в конце. macchina — через cargo. Затем конфиги.
set -eu
cd "$(dirname "$0")"
PKGS="niri xwayland-satellite quickshell qml6-module-qtquick3d
kitty fuzzel rofi fastfetch hyfetch imagemagick
flameshot grim slurp wl-clipboard dolphin qt6ct qt5ct btop
pipewire wireplumber brightnessctl playerctl swaylock
zsh zsh-autosuggestions zsh-syntax-highlighting
assimp-utils unzip python3 git build-essential cargo fonts-jetbrains-mono
meson g++ just libwayland-dev wayland-protocols libegl-dev libgles-dev
libfreetype-dev libfontconfig-dev libcairo2-dev libpango1.0-dev libharfbuzz-dev
libxkbcommon-dev libglib2.0-dev libsecret-1-dev libsodium-dev
libsdbus-c++-dev libpipewire-0.3-dev libwireplumber-0.5-dev
libpam0g-dev libpolkit-agent-1-dev libpolkit-gobject-1-dev
libcurl4-openssl-dev libwebp-dev libjxl-dev libsndfile1-dev librsvg2-dev
libqalculate-dev libxml2-dev libmd4c-dev libtomlplusplus-dev libical-dev
nlohmann-json3-dev libstb-dev libjemalloc-dev"
sudo apt-get update
have="" miss=""
for p in $PKGS; do
    if apt-cache show "$p" >/dev/null 2>&1; then have="$have $p"; else miss="$miss $p"; fi
done
# shellcheck disable=SC2086
sudo apt-get install -y $have
command -v macchina >/dev/null || cargo install macchina
[ -z "$miss" ] || printf '\033[1;31mНет в apt (поставь вручную):\033[0m%s\n' "$miss"
exec sh install/common.sh
