// Лаунчер из Serpantinum, перенесённый на niri, + окно настроек модели.
// Лаунчер:          qs ipc -c serplauncher call launcher toggle
// Настройки модели: qs ipc -c serplauncher call modelsettings toggle
import QtQuick
import Quickshell
import Quickshell.Io

ShellRoot {
    Launcher {}
    ModelSettings { id: modelSettings }

    IpcHandler {
        target: "launcher"
        function toggle(): void { LauncherController.toggle(); }
        function open(): void { LauncherController.show(); }
        function hide(): void { LauncherController.hide(); }
    }

    IpcHandler {
        target: "modelsettings"
        function toggle(): void { modelSettings.visible = !modelSettings.visible; }
        // Всегда показать: после закрытия крестиком окно считается «видимым», поэтому сначала сбрасываем.
        function open(): void { modelSettings.visible = false; modelSettings.visible = true; }
    }
}
