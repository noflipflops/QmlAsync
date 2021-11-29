pragma Singleton
import QtQml 2.15
import QtQuick 2.15

QtObject {

    property var delayComponent: Qt.createComponent("Delay.qml");

    /*Component{
        id: delayComponent
        Delay{
        }
    }*/

    function delay(miliseconds){
        var obj = delayComponent.createObject(null,{interval: miliseconds})
        return obj
    }

    property var fetchComponent: Qt.createComponent("Fetch.qml");

    function fetch(request){
        if (typeof request === "string"){
            request = {
                url: request
            }
        }
        var obj = fetchComponent.createObject(null,{request: request})
        return obj
    }


    property var taskComponent: Qt.createComponent("Task.qml");

    function startTask(generator){
        var obj = taskComponent.createObject(null,{iterable: generator()})
        return obj
    }


    function _iterableExecute(iterable, previousResult){

        var iterableResult = iterable.next(previousResult)


        if (!iterableResult.done){
            var task = iterableResult.value
            if (task.finished){
                _iterableExecute(iterable, task.result)
            }else{
                task.onFinishedChanged.connect(function(){
                    /*if (task.exception)
                        iterable.throw(task.exception);
                    else*/
                    _iterableExecute(iterable, task.result)
                })
            }
        }
    }

    function isTask(object){
        if (!object instanceof QtObject) return false
        return typeof(object.finished) === "boolean"
    }

    function isIterable(object){
        return typeof(object.next) === "function"
    }

    function isGenerator(fn) {
        return fn.constructor.name === 'GeneratorFunction';
    }

    function keepAlive(object) {
        var result = πKeepAliveCount
        πKeepAlive[πKeepAliveCount] = object
        πKeepAliveCount++
        return result;
    }

    property int πKeepAliveCount: 0
    property var πKeepAlive: ({})

}
