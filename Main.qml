
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



        /*Task{
            iterable: function*(){
                yield Async.delay(1000)
                console.error("1000")
                yield Async.delay(1000)

                iterable = function*(){
                    console.error("start other")
                    yield Async.delay(1000)
                    console.error("finish onher")
                }()

                console.error("2000")
                yield Async.delay(1000)
                console.error("3000")

            }()
        }*/



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
            text: "finishTask"
            onClicked: {
                new Promise()
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

                Async._iterableExecute(iterable)



            }

        }

    }




}
