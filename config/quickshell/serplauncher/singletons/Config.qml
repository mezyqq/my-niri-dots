pragma Singleton
import QtQuick
import Quickshell

// Настройки лаунчера как в Serpantinum на Arch; бар Noctalia сверху.
Singleton {
    signal settingsLoaded()
    property var rawSettings: ({
        launcher: { position: "right", width: 350, itemCount: 6, terminalCommand: "kitty -e", smartRanking: true },
        bar: { position: "top", style: "modular", height: 44 }
    })
    function getSetting(key, fallback) { return rawSettings[key] !== undefined ? rawSettings[key] : fallback; }
}
