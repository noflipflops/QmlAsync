pragma Singleton
import QtQml 2.15

QtObject {

    property var value
    function start(argument){

        if (CoroutineVariables.currentExecutor){
            return CoroutineVariables.currentExecutor.result;
        }

        let _job
        if (isIterable(argument)){
            _job = argument
        }else{
            if (isGenerator(argument))
                _job = argument()
        }

        if (_job===undefined){
            return argument
        }

        console.error("Qt.createComponent(CoroutineExecutor.qml);")
        let component = Qt.createComponent("CoroutineExecutor.qml");
        console.log("this: ",this)
        let executor = component.createObject(this, {job: _job});


        return executor.result//function(){return executor.result}
    }

    function* waitMs(miliseconds){
        console.log("waitMs")
        let endDime = Date.now()+miliseconds;
        while (Date.now() < endDime){
            yield
        }
    }


    function* waitFor(predicate){
        while (!predicate()){
            yield
        }
    }

    function* waitForFirst(){
        while (true){
            for (let i = 0; i < arguments.length; i++) {
                let x = arguments[i].next()
                if (x.done){
                    return
                }
            }
            yield
        }
    }

    function* serial(){
        let functionResult = undefined

        for (let i = 0; i < arguments.length; i++) {
            let iterable
            if (isIterable(arguments[i])){
                iterable = arguments[i]
            }
            if (!iterable){
                if (isGenerator(arguments[i])){
                    iterable = arguments[i]()
                }
            }

            if (iterable){
                let done = false
                while (!done){
                    let iterationResult = iterable.next()
                    yield iterationResult.value
                    done = iterationResult.done
                }
                continue;
            }

            if (typeof(arguments[i]) === "function"){

                let currentFunctionResult = arguments[i]()
                if (currentFunctionResult!==undefined)
                    functionResult = currentFunctionResult

                if (functionResult!==undefined){
                    if (i == (arguments.length-1))
                        return functionResult
                    if (isIterable(arguments.length[i+1])){
                        yield functionResult
                    }
                }
                continue;
            }

            yield arguments[i]

        }
    }

    function* parallel(){
        let active = [...arguments]
        while(active.length>0){
            active = active.filter(x=>{
                let done = x.next().done
                return !done
            })
            yield
        }
    }


    function isIterable(object){
        return typeof(object.next) === "function"
    }

    function isGenerator(fn) {
        return fn.constructor.name === 'GeneratorFunction';
    }


}
