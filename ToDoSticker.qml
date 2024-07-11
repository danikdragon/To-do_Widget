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
        {
            todo.model.append({task: buffer});
        }

    }
    property string title: ""
    property bool closeOnCompletion: false
    property int maxWidhtTodo
    property int allHeightElemetns

    visible: true
    id: sticerWindow
    flags: Qt.FramelessWindowHint | Qt.WA_TranslucentBackground //| Qt.WindowStaysOnBottomHint
    // width: titleSticer.width > maxWidhtTodo ? maxWidhtTodo : titleSticer.width + 100
    height: allHeightElemetns + titleSticer.height
    width: maxWidhtTodo

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
            MenuItem { text: "Редактировать" }
        }
    }
    ColumnLayout{
        anchors.fill: parent
        anchors.centerIn: parent
        anchors.margins: 10
        Text {
            id: titleSticer
            font.bold: true
            text: title
            color: isColorDark(sticerWindow.color) ? "white" : "black"
        }
        Repeater{
            id: todo
            anchors.fill: parent
            // width: maxWidhtTodo
            // height: parent.height
            model: ListModel {}
            delegate: RowLayout{
                Text{
                    text: task
                    color: isColorDark(sticerWindow.color) ? "white" : "black"
                    Component.onCompleted:{
                        if(parent.height > check.height){
                            allHeightElemetns += parent.height;
                        }
                        else{
                            allHeightElemetns += check.height;
                        }
                        if(parent.widht > maxWidhtTodo){
                            maxWidhtTodo = parent.width
                        }
                    }
                }
                CheckBox {
                    id: check
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
            }
        }
    }
}
