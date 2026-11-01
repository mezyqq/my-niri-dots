#!/bin/sh
# Nix / NixOS: пакеты в профиль пользователя через `nix profile`, noctalia — из её flake.
# На NixOS niri лучше включить системно: programs.niri.enable = true; в configuration.nix.
set -eu
cd "$(dirname "$0")"
F="--extra-experimental-features nix-command --extra-experimental-features flakes"
PKGS="niri xwayland-satellite quickshell kitty fuzzel rofi fastfetch hyfetch macchina
imagemagick flameshot grim slurp wl-clipboard kdePackages.dolphin qt6ct libsForQt5.qt5ct
btop matugen wireplumber brightnessctl playerctl swaylock
zsh zsh-autosuggestions zsh-syntax-highlighting assimp unzip python3 git gnumake gcc
jetbrains-mono nerd-fonts.symbols-only"
set --
for p in $PKGS; do set -- "$@" "nixpkgs#$p"; done
# shellcheck disable=SC2086
nix $F profile install "$@" github:noctalia-dev/noctalia
# .zshrc ищет плагины в /usr/share/zsh/plugins — на Nix они в профиле
prof="$HOME/.nix-profile/share"
echo "Плагины zsh: $prof/zsh-autosuggestions, $prof/zsh-syntax-highlighting (поправь пути в ~/.zshrc)"
SKIP_NOCTALIA_BUILD=1 exec sh install/common.sh
