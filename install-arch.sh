#!/bin/sh
# Arch: pacman (+ AUR через yay/paru для того, чего нет в репах), затем конфиги.
set -eu
cd "$(dirname "$0")"
PKGS="niri xwayland-satellite quickshell qt6-quick3d
kitty fuzzel rofi fastfetch hyfetch macchina imagemagick
flameshot grim slurp wl-clipboard dolphin qt6ct qt5ct btop matugen
pipewire wireplumber brightnessctl playerctl swaylock
zsh zsh-autosuggestions zsh-syntax-highlighting
assimp unzip python git base-devel ttf-jetbrains-mono ttf-nerd-fonts-symbols
meson just wayland wayland-protocols libglvnd freetype2 fontconfig cairo pango harfbuzz
libxkbcommon glib2 libsecret libsodium sdbus-cpp libpipewire polkit pam curl libwebp
libjxl libsndfile librsvg libqalculate libxml2 md4c tomlplusplus libical nlohmann-json stb jemalloc"
aur=$(command -v yay || command -v paru || true)
# shellcheck disable=SC2086
if [ -n "$aur" ]; then "$aur" -S --needed $PKGS; else sudo pacman -S --needed $PKGS; fi
exec sh install/common.sh
