import QtQuick
import QtQuick.Window
import QtQuick.Controls
import QtQuick.Controls.Material
import QtQuick.Layouts
import Qt.labs.platform

ApplicationWindow {
    id: root
    width: 700
    height: 450
    visible: true
    minimumWidth: 685
    minimumHeight: 200
    title: "To-Do Widgets"
    Material.theme: Material.System
    Material.accent: "#9C27B0"
    ColumnLayout{
        anchors.margins: 10
        anchors.fill: parent
        ColumnLayout{
            anchors.margins: 10
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: parent.top
            TextArea {
                placeholderText: "Название"
                id: titleArea
                color: "white"
                anchors.left: parent.left
                anchors.right: parent.right
            }
            TextArea{
                placeholderText: "Запись: Enter создает новый пункт To-Do"
                Material.background: "white"
                anchors.left: parent.left
                anchors.right: parent.right
                id: discriptionArea
            }
        }

        RowLayout{
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            Button {
                text: "Создать png/gif"
                onClicked: {
                    root.hide()
                }
            }
            RowLayout{
                anchors.centerIn: parent
                CheckBox {
                    id: winStartup
                    text: "Запускать вместе с windows"
                }
                CheckBox {
                    text: "To-do"
                }
                CheckBox {
                    text: "Закрывать To-do"
                }
            }
            Button {
                id: createWindowButton
                anchors.right: parent.right
                text: "Создать стикер"
                onClicked: {
                    let item = windowComponent.createObject();
                    item.title = titleArea.text;
                    item.description = discriptionArea.text;
                }
            }
        }
    }

    SystemTrayIcon {
        visible: true
        onActivated: {
            root.show()
            root.raise()
            root.requestActivate()
        }
        menu: Menu {
            MenuItem {
                text: "Выйти"
                onTriggered: Qt.quit()
            }
        }
    }

    onClosing: {
        Qt.quit()
    }
    function isColorDark(color) {
        var colorComponents = Qt.rgba(color.r, color.g, color.b, color.a);
        var r = colorComponents.r * 255;
        var g = colorComponents.g * 255;
        var b = colorComponents.b * 255;
        var brightness = (r * 299 + g * 587 + b * 114) / 1000;
        return brightness < 128;
    }

    Component {
        id: windowComponent
        ApplicationWindow {
            visible: true
            id: sticerWindow
            property string title: ""
            property string description: ""
            flags: Qt.FramelessWindowHint | Qt.WA_TranslucentBackground //| Qt.WindowStaysOnBottomHint
            width: titleSticer.width < descriptionSticer.width ?
                       (descriptionSticer.width < 200 ? 100 : descriptionSticer.width + 40) :
                       (titleSticer.width < 200 ? 100 : titleSticer.width + 40)

            height: descriptionSticer.height < 200 ? 100 : descriptionSticer.height + 40
            Material.theme: Material.System
            Material.accent: "#9C27B0"
            ColumnLayout{
                anchors.fill: parent
                anchors.margins: 10
                Text {
                    id: titleSticer
                    font.bold: true
                    text: title
                    color: isColorDark(sticerWindow.color) ? "white" : "black"
                }
                Text {
                    id: descriptionSticer
                    text: description
                    color: isColorDark(sticerWindow.color) ? "white" : "black"
                }
            }
            MouseArea {
                acceptedButtons: Qt.LeftButton | Qt.RightButton
                anchors.fill: parent
                property int firstX: 0
                property int firstY: 0
                onClicked: {
                    if (mouse.button === Qt.RightButton)
                        menu.open()
                }
                onPressed: {
                    if (mouse.button === Qt.RightButton) {
                        contextMenu.visible = true
                    }else{
                        firstX = mouseX;
                        firstY = mouseY;
                    }
                }
                onPositionChanged: {
                    if (mouse.buttons & Qt.LeftButton) {
                        sticerWindow.x += mouseX - firstX;
                        sticerWindow.y += mouseY - firstY;
                    }
                }
                Menu {
                    id: menu
                    MenuItem {
                        text: "Закрыть"
                        onTriggered: {
                            sticerWindow.close()
                        }
                    }
                    MenuItem { text: "Редактировать" }
                }
            }
        }
    }
}
