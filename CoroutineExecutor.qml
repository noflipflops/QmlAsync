import QtQml 2.15
import QtQuick 2.15

import "CoroutineVariables.js" as CoroutineVariables
Timer {
    id: root
    property var job
    property var result

    running: true
    repeat: true
    interval: 100

    Component.onCompleted: {

        iteration()
    }

    Component.onDestruction: {

        console.warn("CoroutineExecutor.qml onDestruction")
    }

    onTriggered: iteration()

    function iteration(){
        if (job){
            let coroutineResult = job.next()
            //console.log("coroutineResult ",JSON.stringify(coroutineResult))

            if (coroutineResult.value !== undefined){
                CoroutineVariables.currentExecutor = root
                result = coroutineResult.value
                CoroutineVariables.currentExecutor = undefined
            }
            if (coroutineResult.done){
                //job = undefined
                root.destroy()
            }
        }
    }


}
