pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Io

// Цвета Serpantinum, взятые из палитры Noctalia (меняются вместе с обоями).
Singleton {
    id: theme
    property string fontFamily: "Adwaita Mono"
    property int borderRadius: 10
    property color base: "#1e1e2e"
    property color crust: "#11111b"
    property color surface0: "#313244"
    property color surface1: "#45475a"
    property color surface2: "#585b70"
    property color text: "#cdd6f4"
    property color subtext0: "#a6adc8"
    property color mauve: "#cba6f7"

    FileView {
        path: Quickshell.env("HOME") + "/.cache/quickshell-launcher/colors.json"
        watchChanges: true
        onFileChanged: reload()
        onLoaded: {
            try {
                const c = JSON.parse(text());
                // Через id: внутри FileView «text» — это его функция text(), а не цвет.
                theme.base = c.surface; theme.crust = c.surfaceLow; theme.surface0 = c.surfaceContainer;
                theme.surface1 = c.surfaceContainerHigh; theme.surface2 = c.outline; theme.text = c.onSurface;
                theme.subtext0 = c.onSurfaceVariant; theme.mauve = c.primary;
            } catch (e) {}
        }
    }
}
