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

    property var pngStickers: []
    property var classicStickers: []
    property var todoStickers: []

    ColumnLayout{
        anchors{
            margins: 10
            fill: parent
        }
        ColumnLayout{
            anchors{
                margins: 10
                left: parent.left
                right: parent.right
                top: parent.top
            }
            TextArea {
                id: titleArea
                placeholderText: "Название"
                color: "white"
                anchors{
                    left: parent.left
                    right: parent.right
                }
                wrapMode: "Wrap"
                onHeightChanged: {
                    //16
                    if(discriptionArea.height + titleArea.height + (createWindowButton.height * 2) > root.height){
                        root.height += 16
                    }
                }
            }
            TextArea{
                id: discriptionArea
                placeholderText: "Запись: Enter создает новый пункт To-Do"
                Material.background: "white"
                anchors{
                    left: parent.left
                    right: parent.right
                }
                wrapMode: "Wrap"
                onHeightChanged: {
                    //16
                    if(discriptionArea.height + titleArea.height + (createWindowButton.height * 2) > root.height){
                        root.height += 16
                    }
                }
            }
        }

        RowLayout{
            anchors{
                left: parent.left
                right: parent.right
                bottom: parent.bottom
            }
            Button {
                text: "Создать png/gif"
                FileDialog{
                    id: shearePng
                    onAccepted:{
                        let item = pngComponent.createObject()
                        item.href = shearePng.file
                        pngStickers.push(item)
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
                    id: checkTodo
                    text: "To-do"
                }
                CheckBox {
                    id: closeTodo
                    text: "Закрывать To-do"
                }
            }
            Button {
                id: createWindowButton
                anchors.right: parent.right
                text: "Создать стикер"
                onClicked: {
                    if(checkTodo.checked && discriptionArea.text !== ""){
                        let item = todoComponent.createObject();
                        item.title = titleArea.text;
                        item.createTodo(discriptionArea.text, closeTodo.checked);
                        item.destroyEmpty();
                        todoStickers.push(item);
                    }
                    else if(titleArea.text !== "" || discriptionArea.text !== ""){
                        let item = stickerComponent.createObject();
                        item.title = titleArea.text;
                        item.description = discriptionArea.text;
                        item.destroyEmpty();
                        classicStickers.push(item);
                    }
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
    Component {
        id: todoComponent
        ToDoSticker{
            id: strickerWindow
        }
    }
}
