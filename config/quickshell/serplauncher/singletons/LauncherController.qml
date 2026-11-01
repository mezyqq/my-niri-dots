pragma Singleton
import QtQuick
import Quickshell

Singleton {
    property bool isVisible: false
    property var screen: null
    function show() { isVisible = true; }
    function hide() { isVisible = false; }
    function toggle() { isVisible = !isVisible; }
}
