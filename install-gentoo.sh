#!/bin/sh
# Gentoo: пакеты из ::gentoo и ::guru, затем конфиги.
set -eu
cd "$(dirname "$0")"
command -v eselect >/dev/null && ! eselect repository list -i | grep -q ' guru ' && {
    sudo eselect repository enable guru && sudo emaint sync -r guru; }

PKGS="gui-wm/niri gui-apps/xwayland-satellite gui-apps/quickshell dev-qt/qtquick3d
x11-terms/kitty gui-apps/fuzzel x11-misc/rofi
app-misc/fastfetch app-misc/hyfetch app-misc/macchina media-gfx/imagemagick
media-gfx/flameshot gui-apps/grim gui-apps/slurp gui-apps/wl-clipboard
kde-apps/dolphin gui-apps/qt6ct sys-process/btop x11-misc/matugen
media-video/wireplumber app-misc/brightnessctl media-sound/playerctl gui-apps/swaylock
app-shells/zsh app-shells/zsh-autosuggestions app-shells/zsh-syntax-highlighting
media-libs/assimp app-arch/unzip dev-lang/python dev-vcs/git
media-fonts/jetbrains-mono media-fonts/symbols-nerd-font
dev-build/just dev-build/meson dev-cpp/sdbus-c++ dev-cpp/tomlplusplus dev-libs/md4c
sci-libs/libqalculate dev-libs/libical dev-cpp/nlohmann_json dev-libs/stb dev-libs/libsodium
app-crypt/libsecret media-libs/libjxl media-libs/libwebp media-libs/libsndfile gnome-base/librsvg
dev-libs/jemalloc sys-auth/polkit media-video/pipewire"
# shellcheck disable=SC2086
sudo emerge --ask --noreplace --autounmask-continue $PKGS
exec sh install/common.sh
