pragma Singleton
import QtQuick
import Qt.labs.folderlistmodel
import Quickshell
import Quickshell.Io

// Модель для лаунчера: первый файл из ~/launcher-model, подготовленный prepare_model.sh,
// и её настройки (~/launcher-model/settings.json). Общие для лаунчера и окна настроек.
Singleton {
    id: store

    readonly property string dir: Quickshell.env("HOME") + "/launcher-model"
    property string modelPath: ""
    property string error: ""
    readonly property bool preparing: prepProc.running
    readonly property string srcPath: folder.count > 0 ? folder.get(0, "filePath") : ""
    readonly property string srcName: folder.count > 0 ? folder.get(0, "fileName") : ""
    property alias s: adapter

    readonly property var defaults: ({
        rotX: 0, rotY: 0, rotZ: 0, scale: 1.0, offsetX: 0, offsetY: 0, offsetZ: 0,
        autoCenter: true, spin: true, spinSeconds: 8, bob: true, bobAmount: 8, bake: "auto"
    })

    function resetSettings() {
        for (const k in defaults) adapter[k] = defaults[k];
    }

    function prepare() {
        modelPath = "";
        error = "";
        prepProc.running = false;
        if (!srcPath) return;
        prepProc.command = ["sh", Quickshell.env("HOME") + "/.config/quickshell/serplauncher/launcher/prepare_model.sh", srcPath, adapter.bake];
        prepProc.running = true;
    }

    onSrcPathChanged: prepare()

    FolderListModel {
        id: folder
        folder: "file://" + store.dir
        nameFilters: ["*.glb", "*.gltf", "*.zip", "*.fbx", "*.obj", "*.dae", "*.blend", "*.3ds", "*.ply", "*.stl", "*.vrm", "*.x3d",
                      "*.GLB", "*.GLTF", "*.ZIP", "*.FBX", "*.OBJ"]
        showDirs: false
        sortField: FolderListModel.Name
    }

    Process {
        id: prepProc
        stdout: StdioCollector { onStreamFinished: store.modelPath = this.text.trim() }
        stderr: StdioCollector { onStreamFinished: if (this.text.trim()) store.error = this.text.trim() }
    }

    FileView {
        path: store.dir + "/settings.json"
        onAdapterUpdated: writeAdapter()
        onLoadFailed: err => { if (err === FileViewError.FileNotFound) writeAdapter(); }

        JsonAdapter {
            id: adapter
            property real rotX: 0
            property real rotY: 0
            property real rotZ: 0
            property real scale: 1.0
            property real offsetX: 0
            property real offsetY: 0
            property real offsetZ: 0
            property bool autoCenter: true
            property bool spin: true
            property real spinSeconds: 8
            property bool bob: true
            property real bobAmount: 8
            property string bake: "auto"
            onBakeChanged: store.prepare()
        }
    }
}
