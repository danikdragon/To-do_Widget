import QtQuick
import QtQuick.Window
import QtQuick.Controls
import QtQuick.Controls.Material

ApplicationWindow {
    function isColorDark(color) {
        var colorComponents = Qt.rgba(color.r, color.g, color.b, color.a);
        var r = colorComponents.r * 255;
        var g = colorComponents.g * 255;
        var b = colorComponents.b * 255;
        var brightness = (r * 299 + g * 587 + b * 114) / 1000;
        return brightness < 128;
    }
    visible: true
    width: 640
    height: 480
    title: "To-Do"
    background: Rectangle{
        color: "black"
        opacity: 0.5
    }

    Button {
        id: createWindowButton
        text: "Create New Window"
        anchors.centerIn: parent
        onClicked: {
            windowComponent.createObject(null);
        }
    }

    Component {
        id: windowComponent
        Window {
            id: root
            flags: Qt.FramelessWindowHint | Qt.WA_TranslucentBackground //| Qt.WindowStaysOnBottomHint
            visible: true
            width: 300
            height: 200
            color: "black"
            Text {
                text: "Привет, мир!"
                anchors.centerIn: parent
                color: isColorDark(root.color) ? "white" : "black"
            }
            MouseArea {
                anchors.fill: parent
                onPositionChanged: {
                    root.x += mouseX - (root.width / 2)
                    root.y += mouseY - (root.height / 2)
                }
            }
        }
    }
}
