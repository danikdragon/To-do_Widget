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

    property string title: ""
    property string temp: ""
    property string todo: []
    property bool flagsCompletion: []
    property bool closeOnCompletion: false
    property int maxWidhtTodo: 0

    visible: true
    id: sticerWindow
    flags: Qt.FramelessWindowHint | Qt.WA_TranslucentBackground //| Qt.WindowStaysOnBottomHint
    width: titleSticer.width < maxWidhtTodo ? maxWidhtTodo : titleSticer.width
    height: todoList.height + titleSticer.height

    Material.theme: Material.System
    Material.accent: "#9C27B0"
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
        ListView{
            id: todoList
            width: maxWidhtTodo
            height: parent.height
            model: ListModel {}
            delegate: RowLayout{
                Text{
                    text: task
                    color: isColorDark(sticerWindow.color) ? "white" : "black"
                    Component.onCompleted:{
                        if(parent.widht + check.width > maxWidhtTodo){
                            maxWidhtTodo = parent.width + check.width
                        }
                    }
                }
                CheckBox {
                    id: check
                    onCheckedChanged: {
                        if(closeOnCompletion === true){
                            for(let i = 0; i < flagsCompletion; i++)
                            {
                                if(check.checked === false && flagsCompletion[i] === true)
                                {
                                    flagsCompletion[i] = false;
                                    break;
                                }
                                else if(check.checked === true && flagsCompletion[i] === false){
                                    flagsCompletion[i] = true;
                                    break;
                                }
                            }
                            let completeTusk = true;
                            for(let j = 0; j < flagsCompletion; j++)
                            {
                                if(flagsCompletion[j] === false){
                                    completeTusk = false;
                                    break;
                                }
                            }
                            completeTusk === true && sticerWindow.close();
                        }
                    }
                }
            }
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
    Component.onCompleted: {
        let buffer = "";
        for (let i = 0; i < temp.length; i++) {
            console.log("for")
            if (temp[i] === '\n') {
                if (buffer !== "") {
                    todo.push(buffer);
                    buffer = "";
                }
            } else {
                buffer += temp[i];
            }
        }
        if (buffer !== "")
            todo.push(buffer);
    }
}
