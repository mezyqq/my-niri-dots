import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell
import "../"

// Окно настроек модели лаунчера: живой предпросмотр слева, настройки справа.
// Изменения сразу применяются в лаунчере и сохраняются в ~/launcher-model/settings.json.
FloatingWindow {
    id: win
    visible: false
    title: "Модель лаунчера"
    implicitWidth: 1000
    implicitHeight: 660
    color: ThemeBackend.base

    readonly property var s: ModelStore.s

    // Сцену создаём после появления окна и убираем до его скрытия (иначе QtQuick3D падает).
    property bool show3d: false
    onVisibleChanged: { if (visible) show3dTimer.restart(); else { show3dTimer.stop(); show3d = false; } }
    Timer { id: show3dTimer; interval: 120; onTriggered: win.show3d = win.visible }

    component Label2: Text {
        color: ThemeBackend.text
        font.family: ThemeBackend.fontFamily
        font.pixelSize: 13
    }

    component Section: Text {
        Layout.topMargin: 14
        color: ThemeBackend.mauve
        font.family: ThemeBackend.fontFamily
        font.pixelSize: 12
        font.bold: true
        font.letterSpacing: 1.2
        font.capitalization: Font.AllUppercase
    }

    component SliderRow: ColumnLayout {
        id: row
        property string label
        property real from: 0
        property real to: 1
        property real step: 1
        property int decimals: 0
        property string unit: ""
        property real value
        signal moved(real v)
        Layout.fillWidth: true
        spacing: 0
        RowLayout {
            Layout.fillWidth: true
            Label2 { text: row.label }
            Item { Layout.fillWidth: true }
            Label2 { text: row.value.toFixed(row.decimals) + row.unit; color: ThemeBackend.subtext0 }
        }
        Slider {
            Layout.fillWidth: true
            from: row.from; to: row.to; stepSize: row.step
            value: row.value
            onMoved: row.moved(value)
        }
    }

    component SwitchRow: RowLayout {
        id: sw
        property string label
        property bool checked
        signal toggled(bool v)
        Layout.fillWidth: true
        Label2 { text: sw.label }
        Item { Layout.fillWidth: true }
        Switch { checked: sw.checked; onToggled: sw.toggled(checked) }
    }

    RowLayout {
        anchors.fill: parent
        anchors.margins: 16
        spacing: 16

        // ---------- Предпросмотр ----------
        Rectangle {
            Layout.fillWidth: true
            Layout.fillHeight: true
            radius: 16
            color: ThemeBackend.crust
            clip: true

            // Рамка области модели в лаунчере (300 × ~высота лаунчера) — для ориентира.
            Rectangle {
                anchors.centerIn: parent
                width: 300; height: 400
                color: "transparent"
                radius: 12
                border.width: 1
                border.color: Qt.alpha(ThemeBackend.subtext0, 0.25)
                Loader {
                    anchors.fill: parent
                    active: win.show3d && ModelStore.modelPath !== ""
                    sourceComponent: Component { ModelView { running: true } }
                }
            }

            Label2 {
                anchors.centerIn: parent
                width: parent.width - 60
                horizontalAlignment: Text.AlignHCenter
                wrapMode: Text.WordWrap
                visible: ModelStore.modelPath === ""
                color: ThemeBackend.subtext0
                text: ModelStore.error ? ("Не получилось загрузить: " + ModelStore.error)
                    : ModelStore.preparing ? "Готовлю модель…"
                    : "Положи модель (.glb, .gltf, .zip с Sketchfab, .fbx, .obj…)\nв ~/launcher-model"
            }

            Label2 {
                anchors { left: parent.left; bottom: parent.bottom; margins: 14 }
                text: ModelStore.srcName ? ("Файл: " + ModelStore.srcName) : ""
                color: ThemeBackend.subtext0
                font.pixelSize: 12
            }
        }

        // ---------- Настройки ----------
        ScrollView {
            Layout.preferredWidth: 380
            Layout.fillHeight: true
            contentWidth: availableWidth
            clip: true

            ColumnLayout {
                width: parent.width
                spacing: 4

                Text {
                    text: "Модель лаунчера"
                    color: ThemeBackend.text
                    font.family: ThemeBackend.fontFamily
                    font.pixelSize: 22
                    font.bold: true
                }

                Section { text: "Поворот модели" }
                SliderRow { label: "Наклон вперёд/назад (X)"; from: -180; to: 180; unit: "°"; value: win.s.rotX; onMoved: v => win.s.rotX = v }
                SliderRow { label: "Разворот (Y)"; from: -180; to: 180; unit: "°"; value: win.s.rotY; onMoved: v => win.s.rotY = v }
                SliderRow { label: "Наклон вбок (Z)"; from: -180; to: 180; unit: "°"; value: win.s.rotZ; onMoved: v => win.s.rotZ = v }

                Section { text: "Размер и положение" }
                SliderRow { label: "Масштаб"; from: 0.2; to: 2.5; step: 0.05; decimals: 2; unit: "×"; value: win.s.scale; onMoved: v => win.s.scale = v }
                SliderRow { label: "Сдвиг по горизонтали"; from: -150; to: 150; value: win.s.offsetX; onMoved: v => win.s.offsetX = v }
                SliderRow { label: "Сдвиг по вертикали"; from: -150; to: 150; value: win.s.offsetY; onMoved: v => win.s.offsetY = v }
                SliderRow { label: "Ближе/дальше"; from: -150; to: 150; value: win.s.offsetZ; onMoved: v => win.s.offsetZ = v }
                SwitchRow { label: "Автоцентрирование"; checked: win.s.autoCenter; onToggled: v => win.s.autoCenter = v }

                Section { text: "Анимация" }
                SwitchRow { label: "Вращение"; checked: win.s.spin; onToggled: v => win.s.spin = v }
                SliderRow { label: "Один оборот за"; from: 2; to: 30; step: 0.5; decimals: 1; unit: " с"; value: win.s.spinSeconds; onMoved: v => win.s.spinSeconds = v }
                SwitchRow { label: "Покачивание"; checked: win.s.bob; onToggled: v => win.s.bob = v }
                SliderRow { label: "Высота покачивания"; from: 0; to: 30; value: win.s.bobAmount; onMoved: v => win.s.bobAmount = v }

                Section { text: "Обработка файла" }
                RowLayout {
                    Layout.fillWidth: true
                    Label2 { text: "Запекание преобразований" }
                    Item { Layout.fillWidth: true }
                    ComboBox {
                        readonly property var keys: ["auto", "on", "off"]
                        model: ["Авто", "Вкл", "Выкл"]
                        currentIndex: Math.max(0, keys.indexOf(win.s.bake))
                        onActivated: i => win.s.bake = keys[i]
                    }
                }
                Label2 {
                    Layout.fillWidth: true
                    wrapMode: Text.WordWrap
                    color: ThemeBackend.subtext0
                    font.pixelSize: 11
                    text: "Вкл — центр всегда точный, но модели со скелетом (руки, шарфы) могут встать криво. Выкл — модель как в файле. Авто — запекать только модели без скелета."
                }

                RowLayout {
                    Layout.topMargin: 16
                    Layout.fillWidth: true
                    Button { text: "Сбросить"; onClicked: ModelStore.resetSettings() }
                    Button { text: "Открыть папку"; onClicked: Quickshell.execDetached(["xdg-open", ModelStore.dir]) }
                    Item { Layout.fillWidth: true }
                    Button { text: "Закрыть"; onClicked: win.visible = false }
                }
            }
        }
    }
}
