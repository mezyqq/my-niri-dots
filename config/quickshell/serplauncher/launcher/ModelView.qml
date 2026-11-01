import QtQuick
import QtQuick3D
import QtQuick3D.AssetUtils
import "../"

// 3D-сцена с моделью из ModelStore: одинаковая в лаунчере и в окне настроек.
// Создавать только когда окно уже на экране (см. Loader в Launcher.qml) — иначе QtQuick3D падает.
Item {
    id: mv
    property bool running: true
    readonly property var s: ModelStore.s

    View3D {
        anchors.fill: parent
        environment: SceneEnvironment {
            backgroundMode: SceneEnvironment.Transparent
            antialiasingMode: SceneEnvironment.MSAA
            antialiasingQuality: SceneEnvironment.High
        }

        PerspectiveCamera { position: Qt.vector3d(0, 0, 330) }
        DirectionalLight { eulerRotation: Qt.vector3d(-30, -25, 0); brightness: 1.3 }
        DirectionalLight { eulerRotation: Qt.vector3d(-10, 160, 0); brightness: 0.5 }
        PointLight { position: Qt.vector3d(-200, 120, 200); color: ThemeBackend.mauve; brightness: 1.2 }

        Node {
            SequentialAnimation on y {
                running: mv.running && mv.s.bob; loops: Animation.Infinite
                NumberAnimation { from: -mv.s.bobAmount * 0.6; to: mv.s.bobAmount; duration: 1600; easing.type: Easing.InOutSine }
                NumberAnimation { from: mv.s.bobAmount; to: -mv.s.bobAmount * 0.6; duration: 1600; easing.type: Easing.InOutSine }
            }

            Node {
                id: spinNode
                NumberAnimation on eulerRotation.y {
                    id: spinAnim
                    running: mv.running && mv.s.spin; loops: Animation.Infinite
                    from: 0; to: 360; duration: Math.max(1, mv.s.spinSeconds) * 1000
                }
                // Без вращения модель смотрит прямо в камеру.
                Connections {
                    target: mv.s
                    function onSpinChanged() { if (!mv.s.spin) spinNode.eulerRotation.y = 0; }
                }

                // Ручные поправки из настроек: сдвиг и базовый поворот.
                Node {
                    position: Qt.vector3d(mv.s.offsetX, mv.s.offsetY, mv.s.offsetZ)
                    eulerRotation: Qt.vector3d(mv.s.rotX, mv.s.rotY, mv.s.rotZ)

                    // Нормализация: наибольшая сторона = 200 единиц × масштаб из настроек.
                    Node {
                        id: fit
                        readonly property vector3d bmin: loader.bounds.minimum
                        readonly property vector3d bmax: loader.bounds.maximum
                        readonly property real extent: Math.max(bmax.x - bmin.x, bmax.y - bmin.y, bmax.z - bmin.z)
                        readonly property real k: (extent > 0 ? 200 / extent : 1) * mv.s.scale
                        scale: Qt.vector3d(k, k, k)

                        RuntimeLoader {
                            id: loader
                            source: ModelStore.modelPath ? "file://" + ModelStore.modelPath : ""
                            position: mv.s.autoCenter
                                ? Qt.vector3d(-(fit.bmin.x + fit.bmax.x) / 2, -(fit.bmin.y + fit.bmax.y) / 2, -(fit.bmin.z + fit.bmax.z) / 2)
                                : Qt.vector3d(0, 0, 0)
                        }
                    }
                }
            }
        }
    }
}
