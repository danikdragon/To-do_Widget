import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
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
    function createTodo(area, cheackBox,) {
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
    function destroyEmpty(){
        if(titleSticer.text === "")
        {
            titleSticer.destroy()
        }

    }
    property bool closeOnCompletion: false

    visible: true
    id: sticerWindow
    flags: Qt.FramelessWindowHint | Qt.WA_TranslucentBackground //| Qt.WindowStaysOnBottomHint
    width: titleSticer.contentWidth + 20
    height: titleSticer.contentHeight

    Material.theme: Material.System
    Material.accent: "#9C27B0"
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
            MenuItem {
                text: "Редактировать"
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
            color: isColorDark(sticerWindow.color) ? "white" : "black"
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
                            completeTusk && sticerWindow.close();
                        }
                    }
                }
                Text{
                    id: todoText
                    text: task
                    color: isColorDark(sticerWindow.color) ? "white" : "black"
                    Component.onCompleted:{
                        sticerWindow.height += check.height + 20;
                        if(todoText.contentWidth + check.width > sticerWindow.width){
                            sticerWindow.width = todoText.contentWidth + check.width + 30
                        }
                    }
                }
            }
        }
    }
}
