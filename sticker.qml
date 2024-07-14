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
    function destroyEmpty(){
        if(titleSticker.text === "")
        {
            titleSticker.visible = false;
            stickerWindow.width = descriptionSticker.contentWidth + 20 < 100 ? 100 : descriptionSticker.contentWidth + 20
            stickerWindow.height = descriptionSticker.contentHeight + 40
        }
        if(descriptionSticker.text === "")
        {
            descriptionSticker.visible = false;
            stickerWindow.width = titleSticker.contentWidth + 20 < 100 ? 100 : titleSticker.contentWidth + 20
            stickerWindow.height = titleSticker.contentHeight + 40
        }
    }
    function returnViseble(){
        titleSticker.visible = true;
        descriptionSticker.visible = true;
    }
    property string description: ""

    visible: true
    id: stickerWindow
    flags: Qt.FramelessWindowHint | Qt.WA_TranslucentBackground //| Qt.WindowStaysOnBottomHint
    width: titleSticker.contentWidth < descriptionSticker.contentWidth ?
               (descriptionSticker.contentWidth + 20 < 100 ? 100 : descriptionSticker.contentWidth + 20) :
               (titleSticker.contentWidth + 20 < 100 ? 100 : titleSticker.contentWidth + 20)

    height: titleSticker.contentHeight + descriptionSticker.contentHeight + 40

    Material.theme: Material.System
    Material.accent: "#9C27B0"
    ColumnLayout{
        anchors.fill: parent
        anchors.centerIn: parent
        anchors.margins: 10
        Text {
            id: titleSticker
            font.bold: true
            text: title
            color: isColorDark(stickerWindow.color) ? "white" : "black"
        }
        Text {
            id: descriptionSticker
            text: description
            color: isColorDark(stickerWindow.color) ? "white" : "black"
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
                    titleArea.text = titleSticker.text
                    discriptionArea.text = descriptionSticker.text
                    pngOrCancel.text = "Отмена"
                    createWindowButton.text = "Сохранить"
                    tempId = customId
                }
            }
        }
    }
}
