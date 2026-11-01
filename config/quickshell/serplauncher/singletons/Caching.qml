pragma Singleton
import QtQuick
import Quickshell

Singleton {
    readonly property string qsDir: Quickshell.env("HOME") + "/.config/quickshell/serplauncher"
    function getCacheDir(name) { return Quickshell.env("HOME") + "/.cache/serplauncher/" + name; }
}
