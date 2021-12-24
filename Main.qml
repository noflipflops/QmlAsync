
import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

import "CoroutineVariables.js" as CoroutineVariables


Pane{
    id: root


    Component.onCompleted: {

        //console.error("Coroutine.value: ",Coroutine.value)
        //Coroutine.value = 50
    }


    Column {
        anchors.fill: parent


        /*Label{
            text: Coroutine.start(
                      Coroutine.serial(
                          "Zero",
                          Coroutine.waitMs(1000),
                          "One",
                          Coroutine.waitMs(1000),
                          function* () {
                              yield 10
                              yield* Coroutine.waitMs(1000)
                              return 15
                          }

                          )
                      )
        }*/

        Timer{
            running: true
            repeat: true
            interval: 1000
            property int value: 0
            property var special

            onTriggered: {

                //Task.create()

                /*let component = Qt.createComponent("Task.qml");



                let task = component.createObject(null, {value: value});
                if (value == 66){
                    special = function(){return task}
                }


                value++*/

            }

        }

        Rectangle {
            id: colorRectangle
            //width: root.width
            height: 50/* Coroutine.start(
                        Coroutine.serial(
                            50,
                            Coroutine.waitMs(1000),
                            100,
                            Coroutine.waitMs(1000),
                            200
                            )
                        )*/


            /*CoroutineExecutor{
                id: coroutineExecutor
                interval: 20
                job: function*(){
                    while (true){
                        const period = 5000
                        let phase = (Date.now() / period) % 1
                        parent.width =  colorRectangle.parent.width*phase
                        yield {
                            color:Qt.hsva(phase,0.2,0.8,1),
                        }
                    }
                }()
            }*/

            //color: coroutineExecutor.result.color


            /*color: Coroutine.start(function*(){
                while (true){
                    let phase = (Date.now() / 1000) % 1
                    yield Qt.hsva(phase,1,1,1)
                }
            })*/
        }


        CheckBox{
            id: checkbox

        }

        CheckBox{
            id: checkbox2
        }

        Condition{
            id: condition
            predicate: function(){
                return checkbox.checked && checkbox2.checked
            }
        }


        /*QtObject{
            id: common
            property var commonTask:Async.startTask(function*(){
                //throw new Error("I don't wanna work today")
                console.error("commonTask 0")
                yield Async.delay(2000)
                console.error("commonTask 1")
                yield Async.delay(2000)
                console.error("commonTask 2")
                yield Async.delay(2000)
                console.error("commonTask 3")
                return 53
            })

        }*/

       /* Task{
            id: task
            objectName: "task"
            iterable: function*(){
                //console.log("commonTask returned ", yield common.commonTask)

                yield Async.condition(()=>checkbox.checked)
                //checkbox2.checked = true


                console.error("0")
                yield Async.delay(2000)
                console.error("1")
                yield Async.delay(2000)
                console.error("2")
                yield Async.delay(2000)
                console.error("3")

            }()
        }*/

        Task{
            id: task2
            objectName: "task2"
            generator: function*(){
                yield Async.condition(() => checkbox.checked)
                //yield* Coroutine.waitMs(10000)


                /*var checkboxWatcher = Async.startTask(function*(){
                    yield Async.condition(()=>checkbox.checked,this)
                    task2.destroy()
                },this)


                try{
                    yield Async.delay(5000,token,"Cancelation test")
                }catch(e){
                    if (Async.isTask(e)){
                        console.log("task was canceled")
                    }else{
                        throw e
                    }
                }*/
                /*var [google,github] = [
                            Async.fetch("https://google.com"),
                            Async.fetch("https://github.com")
                        ]*/


                var m = yield Async.fetch("https://google.com");//yield* [Async.fetch("https://github.io"), Async.fetch("https://google.com")]

                console.error("task2 0")
                yield Async.delay(2000)
                console.error("task2 1")
                yield Async.delay(2000)
                console.error("task2 2")
                yield Async.delay(2000)
                console.error("task2 3")
            }

        }

        Button {
            text: "I changed my mind"
            onClicked: {
                task.generator = function*(){
                    console.error("start other")
                    yield Async.delay(5000)
                    console.error("finish onher")
                }
            }

        }


        Button {
            id: token
            text: "Cancelation"

            onClicked: {




                token.destroy()
            }
        }


        Button {
            text: "Coroutine"
            onClicked: Async.startTask(function*(){
                while (true){
                    for (var i=0; i<10000; i++){
                        yield
                    }
                    console.log("Coroutine is spinning")

                }
            })

        }

        Button{
            text: "Binding"
            onClicked: {
                var binding = Qt.binding(function() { return inputHandler.pressed ? "steelblue" : "lightsteelblue" })
                console.log(typeof binding)
            }
        }


        Button {
            text: "Task GC test"




            onClicked: {
                var task = Async.startTask(function*(){
                    //while (true){
                        yield Async.delay(1000)
                    console.log("Task GC test done")
                    //}
                })
                task.objectName = "Task GC test"

            }
        }


        Button {
            text: "gc()"
            onClicked: {
                gc()
            }

        }


        Button {
            text: "create 100 objects"

            property int objectNumber: 0

            onClicked: {
                for (var i = 0; i< 100; i++){

                    //var task = Async.delay(1000)

                    var task = Async.startTask(function*(){
                        Async.delay(1000)
                    })

                    task.objectName = "Task #"+objectNumber
                    objectNumber++
                }

            }

        }



        Button{
            text: "start coroutine"


            onClicked: {

                var iterable = function*(){

                    var smallDelay = Async.delay(500)

                    var github = yield Async.fetch("https://github.com")

                    try{
                        yield Async.delay(1000)
                        console.log("after Async.delay(1000)")
                    } catch (e){
                        console.error("error Async.delay(1000) ",e)
                    }

                    yield smallDelay
                    console.log("after Async.delay(500)")

                    yield Async.delay(2000)
                    console.log("after Async.delay(2000)")
                }()

                //Async._iterableExecute(iterable)



            }

        }

        ScrollView {
            id: view
            width: parent.width

            TextArea{
                id:  textArea
                font.pixelSize: 10
                width: parent.width

            }
        }



        Button {
            text: "Fetch"
            property var t
            onClicked: {

                t = Async.startTask(function*(){

                    //var td = new String("hello")

                    var response = yield Async.fetch(
                                {
                                    url: "https://reqres.in/api/users/2",
                                    /*headers: {
                                        a: "a",
                                        b: 12
                                    },*/
                                    //body: "hello"
                                })

                    textArea.text = response.json().data.email
                    //console.log(array)
                    //var i = 0
                    //while (true){

                        //console.log(i)
                        //i++
                    //}
                })


            }

        }


        Label{
            id: gitVersionLabel
            text: "git version..."
        }

        Task {
            generator: function*(){
                var gitVersion = (yield Async.process("git",["--version"])).standardOutput.text();
                gitVersionLabel.text = gitVersion;

                try {
                    yield Async.process("notExistingCommand")
                }catch(e){
                    console.error(e);
                }

            }
        }


    }




}
