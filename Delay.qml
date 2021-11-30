import QtQml 2.15

Timer {
    property int value: 0
    //property int interval: 0

    Component.onCompleted: {
        console.info("Delay created")
        //Qt.callLater(function(){finished = true})
        //setInterval(interval,)

    }

    running: true
    repeat: false

    onTriggered: {
        console.log("Delay ",objectName," finished")
        //running = false
        finished = true
    }
    property bool finished : false
    //signal finished()

    Component.onDestruction: {
        console.warn("Delay ",objectName," onDestruction")
    }
}
