import QtQml 2.15
import QtQuick 2.15

QtObject {
    id: root
    property var result
    property var exception
    property bool finished : false

    property var generator


    property var πIterable
    //property var previousResult

    //property var subtask

    //property var th: root


    onGeneratorChanged: {
        if (!πCompleted) return

        if (!finished){
            πFinalize()
        }
        if (generator){
            πRun()
        }
    }

    property bool πCompleted: false

    Component.onCompleted: {
        πCompleted = true
        if (generator){
            πRun()
        }
        //Async.keepAlive(root)
    }

    /*function finish(){
        finished = true
        //delete Async._keepAlive[root]
    }*/

    property var πState

    function πRun(){
        πIterable = generator.call(root)
        πState = {
            previousResult: undefined,
            subtask: undefined
        }
        πIteration()
    }

    function πFinalize(){
        if (πState){
            if (πState.subtask) πSubTaskDiconnect()
        }
        πState = {}
    }

    function πResume(){
        πSubTaskDiconnect()

        πState.previousResult = πState.subtask.result
        exception = πState.subtask.exception
        πState.subtask = null
        πIteration()
    }

    function πSubTaskCanceled(){
        exception = πState.subtask
        πIteration()
    }

    function πSubTaskConnect(){
        πState.subtask.onFinishedChanged.connect(πResume)
        πState.subtask.Component.onDestruction.connect(πSubTaskCanceled)
    }

    function πSubTaskDiconnect(){
        πState.subtask.onFinishedChanged.disconnect(πResume)
        πState.subtask.Component.onDestruction.disconnect(πSubTaskCanceled)
    }

    function πIteration(){
        while (true){
            let iterableResult = undefined
            try{
                if (exception){
                    iterableResult = πIterable.throw(exception)
                    exception = undefined
                } else {
                    iterableResult = πIterable.next(πState.previousResult)
                }
            } catch (e){
                console.error(`Task "${objectName}" throws exception: ${e}`)
                exception = e
                return
            }


            if (iterableResult.done){
                result = iterableResult.value
                finished = true
                return;
            }

            if (iterableResult.value === undefined){
                πState.previousResult = undefined
                Qt.callLater(function(){root.πIteration()})
                return
            }

            if (Async.isTask(iterableResult.value)){
                πState.subtask = iterableResult.value
                if (πState.subtask.finished){
                    πState.previousResult = πState.subtask.result
                    exception = πState.subtask.exception
                    πState.subtask = null
                    continue;
                }

                πSubTaskConnect()
                return

            } else {


            }
        }
    }


    Component.onDestruction: {
        πFinalize()
        console.warn("Task ",objectName," onDestruction")
    }

}
