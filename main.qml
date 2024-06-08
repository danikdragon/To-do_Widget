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
    TextArea{
        id: xyz
    }
    Button {
        id: createWindowButton
        text: "Создать стикер"
        anchors.centerIn: parent
        onClicked: {
            let item = windowComponent.createObject();
            item.abc = xyz.text
        }
    }

    Component {
        id: windowComponent
        Window {
            id: root
            property string abc: ""
            flags: Qt.FramelessWindowHint | Qt.WA_TranslucentBackground | Qt.WindowStaysOnBottomHint
            visible: true
            width: textSticer.width < 200 ? 100 : textSticer.width + 40
            height: textSticer.height < 100 ? 100: textSticer.height + 40

            color: "black"
            Text {
                id: textSticer
                text: abc
                anchors.centerIn: parent
                color: isColorDark(root.color) ? "white" : "black"
            }
            MouseArea {
                anchors.fill: parent
                property int firstX: 0
                property int firstY: 0
                onPressed: {
                    firstX = mouseX
                    firstY = mouseY
                }
                onPositionChanged: {
                    if (mouse.buttons & Qt.LeftButton) {
                        root.x += mouseX - firstX
                        root.y += mouseY - firstY
                    }
                }
            }
        }
    }
}
