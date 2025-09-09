import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.15

Item {
    property bool showPassword: false
    property bool loginFailed: false

    Rectangle {
        color: config.backgroundColor
        anchors.fill: parent
    }

    Image {
        id: backgroundImage
        anchors.fill: parent
        fillMode: Image.PreserveAspectCrop
        visible: false

        Component.onCompleted: {
            if (typeof config.background === "string" && config.background !== "") {
                backgroundImage.source = config.background;
                backgroundImage.visible = true;
            }
        }
    }

    Rectangle {
        anchors.centerIn: parent
        width: 500
        height: columnContent.implicitHeight + 32
        color: config.boxColor
        border.width: 2
        border.color: config.borderColor
        radius: 12

        Connections {
            target: sddm
            function onLoginFailed() {
                loginFailed = true;
            }
        }

        Column {
            id: columnContent
            anchors.fill: parent
            anchors.margins: 16
            spacing: 12   // slight reduction from 14

            Column {
                width: parent.width
                spacing: 5   // slight reduction from 6

                Text {
                    id: lblUsername
                    text: qsTr("Username")
                    color: config.textColor
                    font.pixelSize: 14
                    font.weight: Font.Medium
                }

                Rectangle {
                    width: parent.width
                    height: 40
                    color: config.buttonColor
                    border.width: 2
                    border.color: usernameField.focus ? config.accentColor : config.borderColor

                    TextField {
                        id: usernameField
                        text: userModel.lastUser
                        anchors.fill: parent
                        anchors.leftMargin: 8
                        anchors.rightMargin: 8
                        font.pixelSize: 14
                        color: config.secondaryTextColor
                        background: null

                        Keys.onPressed: function (event) {
                            if (event.key === Qt.Key_Return || event.key === Qt.Key_Enter) {
                                loginFailed = false;
                                sddm.login(usernameField.text, passwordField.text, session.currentIndex);
                                event.accepted = true;
                            }
                        }

                        KeyNavigation.backtab: session
                        KeyNavigation.tab: passwordField
                    }
                }
            }

            Column {
                width: parent.width
                spacing: 5   // slight reduction from 6

                Text {
                    id: lblPassword
                    text: qsTr("Password")
                    color: config.textColor
                    font.pixelSize: 14
                    font.weight: Font.Medium
                }

                Rectangle {
                    width: parent.width
                    height: 40
                    color: config.buttonColor
                    border.width: 2
                    border.color: passwordField.focus ? config.accentColor : config.borderColor

                    TextField {
                        id: passwordField
                        anchors.left: parent.left
                        anchors.leftMargin: 8
                        anchors.top: parent.top
                        anchors.bottom: parent.bottom
                        anchors.right: eyeIcon.left
                        anchors.rightMargin: 8
                        font.pixelSize: 14
                        color: config.secondaryTextColor
                        echoMode: showPassword ? TextInput.Normal : TextInput.Password
                        background: null

                        Keys.onPressed: function (event) {
                            if (event.key === Qt.Key_Return || event.key === Qt.Key_Enter) {
                                loginFailed = false;
                                sddm.login(usernameField.text, passwordField.text, session.currentIndex);
                                event.accepted = true;
                            }
                        }

                        KeyNavigation.backtab: usernameField
                        KeyNavigation.tab: loginButton
                    }

                    Image {
                        id: eyeIcon
                        width: 20
                        height: 20
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.right: parent.right
                        anchors.rightMargin: 8
                        source: showPassword ? config.eyePath : config.eyeSlashPath
                        fillMode: Image.PreserveAspectFit

                        MouseArea {
                            anchors.fill: parent
                            cursorShape: Qt.PointingHandCursor
                            onClicked: showPassword = !showPassword
                        }
                    }
                }
            }

            Rectangle {
                id: loginButton
                width: parent.width
                height: 40
                color: config.accentColor
                radius: 8
                opacity: loginMouseArea.containsMouse ? 0.9 : 1

                Text {
                    anchors.centerIn: parent
                    text: qsTr("Login")
                    color: config.onAccentColor
                    font.pixelSize: 14
                }

                MouseArea {
                    id: loginMouseArea
                    hoverEnabled: true
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor

                    onClicked: {
                        loginFailed = false;
                        sddm.login(usernameField.text, passwordField.text, session.currentIndex);
                    }

                    KeyNavigation.backtab: usernameField
                    KeyNavigation.tab: session
                }
            }

            Row {
                width: parent.width
                spacing: 12   // slight reduction from 14

                Column {
                    width: parent.width - 120
                    spacing: 4
                    anchors.bottom: parent.bottom

                    ComboBox {
                        id: session
                        width: parent.width
                        height: 40
                        font.pixelSize: 12

                        indicator: Image {
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.right: parent.right
                            anchors.rightMargin: 8
                            width: 20
                            height: 20
                            source: config.chevronDownPath
                        }
                        model: sessionModel
                        textRole: "name"
                        currentIndex: sessionModel.lastIndex

                        KeyNavigation.backtab: loginButton
                        KeyNavigation.tab: restartButton

                        background: Rectangle {
                            radius: 0
                            border.width: 2
                            border.color: sessionMouseArea.containsMouse ? config.accentColor : config.borderColor
                            color: config.buttonColor

                            MouseArea {
                                id: sessionMouseArea
                                anchors.fill: parent
                                hoverEnabled: true
                                cursorShape: Qt.PointingHandCursor
                                propagateComposedEvents: false
                                onClicked: {
                                    mouse.accepted = false;
                                    if (session.popup.opened) {
                                        session.popup.close();
                                    } else {
                                        session.popup.open();
                                    }
                                }
                            }
                        }

                        contentItem: Text {
                            text: session.displayText
                            color: config.textColor
                            font.pixelSize: 12
                            verticalAlignment: Text.AlignVCenter
                            elide: Text.ElideRight
                            anchors.fill: parent
                            anchors.leftMargin: 8
                        }

                        popup: Popup {
                            y: session.height
                            width: session.width
                            padding: 0

                            contentItem: ListView {
                                implicitHeight: contentHeight
                                model: session.popup.visible ? session.delegateModel : null
                                delegate: session.delegate
                                currentIndex: session.highlightedIndex
                            }

                            background: Rectangle {
                                radius: 8
                                border.width: 2
                                border.color: config.borderColor
                                color: config.buttonColor
                            }
                        }

                        delegate: ItemDelegate {
                            width: session.width
                            highlighted: session.highlightedIndex === index
                            contentItem: Text {
                                text: model.name
                                color: config.textColor
                                font.pixelSize: 12
                                elide: Text.ElideRight
                                verticalAlignment: Text.AlignVCenter
                            }
                            background: Rectangle {
                                color: highlighted ? config.borderColor : "transparent"
                                MouseArea {
                                    anchors.fill: parent
                                    hoverEnabled: true
                                    cursorShape: Qt.PointingHandCursor
                                    onClicked: {
                                        mouse.accepted = false;
                                        session.currentIndex = index;
                                        session.popup.close();
                                    }
                                }
                            }
                        }
                    }
                }

                Rectangle {
                    width: 40
                    height: 40
                    color: config.buttonColor
                    border.width: 2
                    border.color: (restartButton.containsMouse || restartButton.activeFocus) ? config.accentColor : config.borderColor
                    radius: 20
                    anchors.leftMargin: 16

                    Image {
                        anchors.centerIn: parent
                        source: config.restartPath
                        width: 28
                        height: 28
                    }

                    MouseArea {
                        id: restartButton
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        hoverEnabled: true
                        activeFocusOnTab: true
                        onClicked: sddm.reboot()
                    }
                }

                Rectangle {
                    width: 40
                    height: 40
                    color: config.buttonColor
                    border.width: 2
                    border.color: (powerButton.containsMouse || powerButton.activeFocus) ? config.accentColor : config.borderColor
                    radius: 20

                    Image {
                        anchors.centerIn: parent
                        source: config.shutdownPath
                        width: 28
                        height: 28
                    }

                    MouseArea {
                        id: powerButton
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        hoverEnabled: true
                        activeFocusOnTab: true
                        onClicked: sddm.powerOff()

                        KeyNavigation.backtab: restartButton
                        KeyNavigation.tab: usernameField
                    }
                }
            }

            Text {
                id: loginFailedText
                visible: loginFailed
                width: parent.width
                text: qsTr("Login Failed")
                color: config.dangerColor
                font.pixelSize: 14
                font.weight: Font.Medium
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
            }
        }
    }

    Component.onCompleted: {
        if (usernameField.text == "")
            usernameField.focus = true;
        else
            passwordField.focus = true;
    }
}
