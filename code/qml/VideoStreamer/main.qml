import QtQuick 1.1
import com.nokia.meego 1.1

Window {
    id: root

    property bool showStatusBar: true
    property bool showToolBar: true
    property variant initialPage
    property alias pageStack: stack

    property bool platformSoftwareInputPanelEnabled: false

    Component.onCompleted: {
        contentArea.initialized = true
        if (initialPage && stack.depth == 0)
            stack.push(initialPage, null, true)
    }

    onInitialPageChanged: {
        if (initialPage && contentArea.initialized) {
            if (stack.depth == 0)
                stack.push(initialPage, null, true)
            else if (stack.depth == 1)
                stack.replace(initialPage, null, true)
        }
    }

    // Attribute definitions
    initialPage: VideoListView {tools: toolBarLayout}

    // Background, shown everywhere
    Image {
        id: backgroundImg
        anchors.fill: parent
        source: visual.inPortrait ? visual.images.portraitBackground
                                  : visual.images.landscapeBackground
    }

    // VisualStyle has platform differentiation attribute definitions.
    VisualStyle {
        id: visual

        // Bind the layout orientation attribute.
        inPortrait: root.inPortrait
        // Check, whether or not the device is E6
        isE6: root.height == 480
    }

    // Default ToolBarLayout
    ToolBarLayout {
        id: toolBarLayout
        ToolButton {
            flat: true
            iconSource: "toolbar-back"
            onClicked: root.pageStack.depth <= 1 ? Qt.quit() : root.pageStack.pop()
        }
        ToolButton {
            flat: true
            iconSource: "toolbar-search"
            // Create the SearchView to the pageStack dynamically.
            onClicked: pageStack.push(Qt.resolvedUrl("SearchView.qml"), {pageStack: stack})
        }
        ToolButton {
            flat: true
            iconSource: visual.images.infoIcon
            onClicked: aboutDlg.open()
        }
    }

    Item {
        id: contentArea

        property bool initialized: false

        anchors {
            top: sbar.bottom; bottom: sip.top;
            left: parent.left; right: parent.right;
        }

        PageStack {
            id: stack
            anchors.fill: parent
            toolBar: tbar
        }
    }

    StatusBar {
        id: sbar

        width: parent.width
        state: root.showStatusBar ? "Visible" : "Hidden"
        platformInverted: root.platformInverted

        states: [
            State {
                name: "Visible"
                PropertyChanges { target: sbar; y: 0; opacity: 1 }
            },
            State {
                name: "Hidden"
                PropertyChanges { target: sbar; y: -height; opacity: 0 }
            }
        ]

        transitions: [
            Transition {
                from: "Hidden"; to: "Visible"
                ParallelAnimation {
                    NumberAnimation { target: sbar; properties: "y"; duration: 200; easing.type: Easing.OutQuad }
                    NumberAnimation { target: sbar; properties: "opacity"; duration: 200; easing.type: Easing.Linear }
                }
            },
            Transition {
                from: "Visible"; to: "Hidden"
                ParallelAnimation {
                    NumberAnimation { target: sbar; properties: "y"; duration: 200; easing.type: Easing.Linear }
                    NumberAnimation { target: sbar; properties: "opacity"; duration: 200; easing.type: Easing.Linear }
                }
            }
        ]
    }

    Item {
        id: sip

        anchors { bottom: parent.bottom; left: parent.left; right: parent.right }

        Behavior on height { PropertyAnimation { duration: 200 } }

        states: [
            State {
                name: "Visible"; when: inputContext.visible && root.platformSoftwareInputPanelEnabled
                PropertyChanges { target: sip; height: inputContext.height }
            },

            State {
                name: "Hidden"; when: root.showToolBar
                PropertyChanges { target: sip; height: tbar.height }
            },

            State {
                name: "HiddenInFullScreen"; when: !root.showToolBar
                PropertyChanges { target: sip; height: 0 }
            }
        ]
    }

    ToolBar {
        id: tbar

        width: parent.width
        state: root.showToolBar ? "Visible" : "Hidden"
        platformInverted: root.platformInverted

        states: [
            State {
                name: "Visible"
                PropertyChanges { target: tbar; y: parent.height - height; opacity: 1 }
            },
            State {
                name: "Hidden"
                PropertyChanges { target: tbar; y: parent.height; opacity: 0 }
            }
        ]

        transitions: [
            Transition {
                from: "Hidden"; to: "Visible"
                ParallelAnimation {
                    NumberAnimation { target: tbar; properties: "y"; duration: 200; easing.type: Easing.OutQuad }
                    NumberAnimation { target: tbar; properties: "opacity"; duration: 200; easing.type: Easing.Linear }
                }
            },
            Transition {
                from: "Visible"; to: "Hidden"
                ParallelAnimation {
                    NumberAnimation { target: tbar; properties: "y"; duration: 200; easing.type: Easing.Linear }
                    NumberAnimation { target: tbar; properties: "opacity"; duration: 200; easing.type: Easing.Linear }
                }
            }
        ]
    }

    // About dialog
    QueryDialog {
        id: aboutDlg

        titleText: qsTr("YouTube Video Channel")
        message: qsTr("<p>QML VideoStreamer application is a Nokia Developer example " +
                      "demonstrating the  QML Video playing capabilies." +
                      "<p>Version: " + cp_versionNumber + "</p>" +
                      "<p>Developed and published by Nokia. All rights reserved.</p>" +
                      "<p>Learn more at " +
                      "<a href=\"http://projects.developer.nokia.com/QMLVideoStreamer\">" +
                      "developer.nokia.com</a>.</p>")
        acceptButtonText: qsTr("Ok")
        onAccepted: {
            // When backing away from the about dialog, return the keyboard
            // focus for the ListView.
            initialPage.forceKeyboardFocus();
        }
    }

    // event preventer when page transition is active
    MouseArea {
        anchors.fill: parent
        enabled: pageStack.busy
    }
}
