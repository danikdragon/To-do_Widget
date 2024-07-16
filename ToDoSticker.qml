import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Controls.Material

ApplicationWindow {
    function createTodo(area, cheackBox) {
        closeOnCompletion = cheackBox;
        let buffer = "";
        for (let i = 0; i < area.length; i++) {
            if (area[i] === '\n') {
                if (buffer !== "") {
                    todo.model.append({task: buffer, checkedModel: false});
                    buffer = "";
                }
            } else {
                buffer += area[i];
            }
        }
        if (buffer !== "")
            todo.model.append({task: buffer});
    }
    function editTodo(area, cheackBox){
        for (let i = todo.count - 1; i >= 0; i--) {
            stickerWindow.height -= 68;
            todo.model.remove(i);
        }
        createTodo(area, cheackBox)
    }
    function destroyEmpty(){
        if(titleSticer.text === "")
            titleSticer.visible = false;
    }
    function returnViseble(){
        titleSticer.visible = true;
    }

    property bool closeOnCompletion: false
    property string title: ""
    visible: true
    id: stickerWindow
    flags: Qt.FramelessWindowHint | Qt.WA_TranslucentBackground //| Qt.WindowStaysOnBottomHint
    width: titleSticer.contentWidth + 20
    height: titleSticer.contentHeight

    Material.theme: Material.System
    Material.accent: Material.Purple

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
            firstX = mouseX;
            firstY = mouseY;
        }
        onPositionChanged: {
            if (mouse.buttons & Qt.LeftButton) {
                stickerWindow.x += mouseX - firstX;
                stickerWindow.y += mouseY - firstY;
            }
        }
        Menu {
            id: menu
            MenuItem {
                text: "Закрыть"
                onTriggered: {
                    stickerWindow.close()
                }
            }
            MenuItem {
                text: "Редактировать"
                onTriggered: {
                    titleArea.text = titleSticer.text
                    let temp = "";
                    for(let i = 0; i < todo.count; i++){
                        temp += todo.model.get(i).task + '\n'
                    }
                    discriptionArea.text = temp
                    pngOrCancel.text = "Отмена"
                    createWindowButton.text = "Сохранить"
                    tempId = customId
                    editFlag = true;
                    checkTodo.checked = true
                }
            }
        }
    }
    ColumnLayout{
        anchors.fill: parent
        anchors.centerIn: parent
        anchors.margins: 10
        spacing: 10
        Text {
            id: titleSticer
            font.bold: true
            text: title
            color: isColorDark(stickerWindow.color)? "white" : "black"
            onVisibleChanged:{
                //!visible ? stickerWindow.height -= titleSticer.contentHeight : stickerWindow.height += titleSticer.contentHeight
                stickerWindow.height += !visible ? -titleSticer.contentHeight : titleSticer.contentHeight
            }
        }
        Repeater{
            id: todo
            anchors.fill: parent
            model: ListModel {}
            delegate: RowLayout {
                CheckBox {
                    id: check
                    anchors{
                        verticalCenter: todoText.verticalCenter
                    }
                    checked: checkedModel
                    onCheckedChanged: {
                        checkedModel = check.checked
                        if(closeOnCompletion === true){
                            let completeTusk = true
                            for(let i = 0; i < todo.count; i++){
                                todo.model.get(i).checkedModel === false && (completeTusk = false);
                            }
                            completeTusk && stickerWindow.close();
                        }
                    }
                }
                Text{
                    id: todoText
                    text: task
                    color: isColorDark(stickerWindow.color)? "white" : "black"
                    Component.onCompleted:{
                        stickerWindow.height += check.height + 20;
                        if(todoText.contentWidth + check.width > stickerWindow.width){
                            stickerWindow.width = todoText.contentWidth + check.width + 30
                        }
                    }
                }
            }
        }
    }
}
