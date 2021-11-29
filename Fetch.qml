import QtQml 2.15
import QtQuick 2.15

QtObject {
    property var request
    property var result
    property var exception
    property bool finished : false

    Component.onCompleted: {
        var xhr = new XMLHttpRequest();
        if (!request.method) request.method = "GET"

        xhr.open(request.method, request.url, true);
        //xhr.responseType = "text";

        if (request.headers){
            for (const [key, value] of Object.entries(request.headers)) {
                if (value)
                    _request.setRequestHeader(key, value)
            }
        }

        //status = 0HttpRequest.Status.InProgress;

        xhr.onload = function(){
            var headersString = xhr.getAllResponseHeaders()
            var headersArrayOfStrings = headersString.split('\r\n');
            var headers = headersArrayOfStrings.reduce(function (acc, current, i){
                  var parts = current.split(': ');
                  acc[parts[0]] = parts[1];
                  return acc;
            }, {});

            result = {
                body: xhr.response,
                headers: headers
            }

            finished = true
        }
        xhr.onerror = function(e){
            exception = e
            finished = true
        }
        xhr.send(request.body)
    }



}
