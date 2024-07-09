import QtQuick
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
                FileDialog{
                    id: shearePng
                    onAccepted:{
                        let item = pngComponent.createObject()
                        item.href = shearePng.file
                        console.log(shearePng.file);
                    }
                }
                onClicked: {
                    shearePng.open();
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
                    let item = stickerComponent.createObject()
                    item.title = titleArea.text
                    item.description = discriptionArea.text
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
    Component {
        id: stickerComponent
        Sticker{
            id: strickerWindow
        }
    }
    Component {
        id: pngComponent
        PngSticker{
            id: strickerWindow
        }
    }
}
