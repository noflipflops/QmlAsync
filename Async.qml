pragma Singleton
//import QtQml 2.15
import QtQuick 2.15

QtObject {

    /*Component{
        id: delayComponent
        Delay{
        }
    }*/

    property var delayComponent: Qt.createComponent("Delay.qml");

    function delay(interval, parent, name = ""){
        var obj = delayComponent.createObject(parent,{interval: interval, objectName: name})
        return obj
    }



    //property var fetchComponent: Qt.createComponent("Fetch.qml");

    /*function fetch(request, parent, name = ""){
        if (typeof request === "string"){
            request = {
                url: request
            }
        }
        var obj = fetchComponent.createObject(parent,{request: request, objectName: name})
        return obj
    }*/

    function fetch(request, parent, name = ""){
        if (typeof request === "string"){
            request = {
                url: request
            }
        }
        let task = engine.fetch(request, parent)
        task.objectName = name
        return task
    }

    function process(program, arguments, parent, name = ""){
        let task = engine.process(program, arguments, parent)
        task.objectName = name
        return task
    }


    property var taskComponent: Qt.createComponent("Task.qml");

    function startTask(generator, parent, name = ""){

        var obj = taskComponent.createObject(parent,{/*iterable: generator(),*/ objectName: name})

        obj.generator =  generator

        return obj
    }



    property var conditionComponent: Qt.createComponent("Condition.qml");

    function condition(predicate, parent, name = ""){
        var obj = conditionComponent.createObject(parent,{predicate: predicate, objectName: name})
        return obj
    }

    function isTask(object){
        //if (!object instanceof QtObject) return false
        return typeof(object.finished) === "boolean"
    }

    function isIterable(object){
        return typeof(object.next) === "function"
    }

    function isGenerator(fn) {
        return fn.constructor.name === 'GeneratorFunction';
    }

    /*function keepAlive(object) {
        var result = πKeepAliveCount
        πKeepAlive[πKeepAliveCount] = object
        πKeepAliveCount++
        return result;
    }

    property int πKeepAliveCount: 0
    property var πKeepAlive: ({})*/

}
