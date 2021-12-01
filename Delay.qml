import QtQml 2.15

Timer {
    Component.onCompleted: {
        console.info("Delay created")
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
