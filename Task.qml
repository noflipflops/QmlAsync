import QtQml 2.15
import QtQuick 2.15

QtObject {
    id: root
    property var result
    property var exception
    property bool finished : false

    property var iterable






    //property var th: root
    onIterableChanged: {
        if (!finished){

        }
    }

    Component.onCompleted: {
        πInternal = πInitInternal()
        πInternal.iteration()
        //Async.keepAlive(root)
    }

    property var πInternal : πInitInternal

    function πInitInternal(){

        var previousResult = undefined
        var subtask = null

        function iteration(){
            while (true){
                let iterableResult = undefined
                try{
                    if (exception){
                        iterableResult = iterable.throw(exception)
                        exception = undefined
                    } else {
                        iterableResult = iterable.next(previousResult)
                    }
                } catch (e){
                    exception = e
                    return
                }


                if (iterableResult.done){
                    result = iterableResult.value
                    finish()
                    return;
                }

                if (Async.isTask(iterableResult.value)){
                    subtask = iterableResult.value
                    if (subtask.finished){
                        previousResult = subtask.result
                        root.exception = subtask.exception
                        subtask = null
                        continue;
                    }

                    subtask.onFinishedChanged.connect(resume)

                    //subtask.then =  resume //onFinishedChanged.connect(resume)
                    return

                } else {


                }
            }
        }


        function resume(){
            subtask.onFinishedChanged.disconnect(resume)
            previousResult = subtask.result
            root.exception = subtask.exception
            subtask = null
            iteration()
        }

        function funalize(){
            if (subtask) subtask.onFinishedChanged.disconnect(resume)
            subtask = null
        }

        return {
            iteration: iteration,
            resume: resume,
            funalize: funalize
        }
    }





    function finish(){
        finished = true
        //delete Async._keepAlive[root]
    }






    Component.onDestruction: {
        if (πInternal) πInternal.funalize()

        //subtask = null
        console.warn("Task ",objectName," onDestruction")
    }

}
