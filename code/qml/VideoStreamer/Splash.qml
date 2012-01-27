import QtQuick 1.1

Item {
    id: splash

    property bool portrait: height > width

    anchors.fill: parent
    Image {
        id: bgImg
        anchors.fill: parent
        source: portrait ? "gfx/FilmReel_N9.png" : "gfx/FilmReel_landscape.png"
    }
}
