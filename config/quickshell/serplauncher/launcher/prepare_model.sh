#!/bin/sh
# Готовит модель для лаунчера и печатает путь к файлу, который понимает Qt (.glb/.gltf).
#   $1 — файл из ~/launcher-model; $2 — запекание преобразований: auto (по умолчанию) | on | off
#   .zip            — распаковывается в кэш, внутри ищется модель (так качается glTF с Sketchfab)
#   fbx/obj/dae/... — конвертируется в .glb через assimp
#   Запекание (assimp -ptv) переносит сдвиги/повороты узлов в вершины, чтобы центр считался верно,
#   но ломает модели со скелетом (руки, шарфы встают криво). auto = запекать только без костей.
set -eu
src=$1
bake=${2:-auto}
cache=${XDG_CACHE_HOME:-$HOME/.cache}/serplauncher/model
key=$(printf '%s:%s:%s' "$src" "$(stat -c %Y "$src")" "$bake" | md5sum | cut -c1-16)
out=$cache/$key
mkdir -p "$out"

pick() {  # первая модель в папке: сначала glTF, потом всё остальное, что знает assimp
    find "$1" -type f \( -iname '*.glb' -o -iname '*.gltf' \) | sort | head -n1 | grep . ||
        find "$1" -type f \( -iname '*.fbx' -o -iname '*.obj' -o -iname '*.dae' -o -iname '*.blend' \
            -o -iname '*.3ds' -o -iname '*.ply' -o -iname '*.stl' -o -iname '*.vrm' -o -iname '*.x3d' \) | sort | head -n1
}

case $(printf '%s' "$src" | tr 'A-Z' 'a-z') in
    *.zip)
        [ -e "$out/.unzipped" ] || { unzip -oq "$src" -d "$out/zip" && touch "$out/.unzipped"; }
        inner=$(pick "$out/zip") || true
        [ -n "$inner" ] || { echo "в архиве нет модели" >&2; exit 1; }
        src=$inner ;;
esac

if [ "$bake" = auto ]; then
    bones=$(assimp info "$src" 2>/dev/null | awk '/^Bones:/{print $2; exit}')
    if [ "${bones:-0}" -gt 0 ]; then bake=off; else bake=on; fi
fi

if [ "$bake" = off ]; then
    # glTF Qt читает сам (со скелетом и анимацией); остальное — просто конвертируем без запекания
    case $(printf '%s' "$src" | tr 'A-Z' 'a-z') in
        *.glb|*.gltf) echo "$src"; exit 0 ;;
    esac
    [ -s "$out/model.glb" ] || assimp export "$src" "$out/model.glb" -f glb2 >/dev/null
else
    [ -s "$out/model.glb" ] || assimp export "$src" "$out/model.glb" -f glb2 -ptv >/dev/null
fi
echo "$out/model.glb"
