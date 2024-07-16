import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Material
import QtQuick.Layouts
import Qt.labs.platform

ApplicationWindow {
    id: rootWin
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

    property alias titleArea: titleArea
    property alias discriptionArea: discriptionArea
    property alias pngOrCancel: pngOrCancel
    property alias createWindowButton: createWindowButton
    property alias checkTodo: checkTodo
    property int tempId

    property bool editFlag: false

    function edit(){
        if(checkTodo.checked === false){
            classicStickers[tempId].title = titleArea.text;
            classicStickers[tempId].description = discriptionArea.text;
            classicStickers[tempId].returnViseble();
            classicStickers[tempId].destroyEmpty();
        }
        else{
            todoStickers[tempId].title = titleArea.text;
            todoStickers[tempId].editTodo(discriptionArea.text,closeTodo);
            todoStickers[tempId].returnViseble();
            todoStickers[tempId].destroyEmpty();
        }
        swapMode()
        clearArea()
    }
    function isColorDark(color) {
        var colorComponents = Qt.rgba(color.r, color.g, color.b, color.a);
        var r = colorComponents.r * 255;
        var g = colorComponents.g * 255;
        var b = colorComponents.b * 255;
        var brightness = (r * 299 + g * 587 + b * 114) / 1000;
        return brightness < 128;
    }
    function clearArea(){
        titleArea.text = ""
        discriptionArea.text = ""
        checkTodo.checked = false;
    }
    function swapMode(){
        editFlag = false;
        pngOrCancel.text = "Создать png/gif"
        createWindowButton.text = "Создать стикер"
    }

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
                placeholderText: "Название или текст png"
                color: "white"
                anchors{
                    left: parent.left
                    right: parent.right
                }
                wrapMode: "Wrap"
                onHeightChanged: {
                    //16
                    if(discriptionArea.height + titleArea.height + (createWindowButton.height * 2) > rootWin.height){
                        rootWin.height += 16
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
                    if(discriptionArea.height + titleArea.height + (createWindowButton.height * 2) > rootWin.height){
                        rootWin.height += 16
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
                id: pngOrCancel
                text: "Создать png/gif"
                FileDialog{
                    nameFilters: ["*.png *.jpg *.jpeg *.gif *.bmp *.ico *.svg *.jfif *.webp" ]
                    id: shearePng
                    onAccepted:{
                        let item = pngComponent.createObject()
                        item.href = shearePng.file
                        item.title = titleArea.text;
                        pngStickers.push(item)
                        item.customId = pngStickers.length - 1;
                    }
                }
                onClicked: {
                    if(pngOrCancel.text !== "Отмена"){
                        shearePng.open();
                    }
                    else{
                        swapMode()
                        clearArea()
                    }
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
                    onCheckedChanged: {
                        !editFlag && swapMode()
                    }
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
                    if(createWindowButton.text === "Создать стикер"){
                        if(checkTodo.checked && discriptionArea.text !== ""){
                            let item = todoComponent.createObject();
                            item.title = titleArea.text;
                            item.createTodo(discriptionArea.text, closeTodo.checked);
                            item.destroyEmpty();
                            todoStickers.push(item);
                            item.customId = todoStickers.length - 1;
                        }
                        else if(titleArea.text !== "" || discriptionArea.text !== ""){
                            let item = stickerComponent.createObject();
                            item.title = titleArea.text;
                            item.description = discriptionArea.text;
                            item.destroyEmpty();
                            classicStickers.push(item);
                            item.customId = classicStickers.length - 1;
                        }
                    }
                    else{
                        edit();
                    }
                    clearArea()
                }
            }
        }
    }

    SystemTrayIcon {
        visible: true
        onActivated: {
            rootWin.show()
            rootWin.raise()
            rootWin.requestActivate()
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
            property int customId
            id: customId
        }
    }
    Component {
        id: pngComponent
        PngSticker{
            property int customId
            id: customId
        }
    }
    Component {
        id: todoComponent
        ToDoSticker{
            property int customId
            id: customId
        }
    }
}
