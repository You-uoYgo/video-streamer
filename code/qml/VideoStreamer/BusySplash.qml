/**
 * Copyright (c) 2012 Nokia Corporation.
 */

import QtQuick 1.1
import com.nokia.meego 1.0

Item {

    // Signalled, when opacity reaches 0.
    signal dismissed

    Splash {
        id: splash
        portrait: visual.inPortrait
    }

    BusyIndicator {
        anchors.centerIn: splash
        platformStyle: BusyIndicatorStyle { size: "large" }
        running: true
    }

    Behavior on opacity {
        SequentialAnimation {
            NumberAnimation { duration: visual.animationDurationLong }
            ScriptAction { script: dismissed() }
        }
    }
}
