# QmlAsync

Qml library for asynchronous programming
# Warning!! Work in progress. Not for production use. 

# Types
## Task
---

## Fetch

---

## Delay
Parameter `interval` - miliseconds

In generators:
```javascript
yield Async.delay(2000)
``` 
In Qml
```QML
Delay{
    id: delay
    interval: 2000
}
```

---


## Condition
Create `Condition` directly in generator
```javascript
function*(){
    yield Async.condition(()=>checkbox.checked)
    console.log("checkbox checked")
}
```
or create qml object `Condition` and ~~await~~ `yield` it in generator
```QML
Condition{
    id: condition
    predicate: checkbox.checked
}
```
```javascript
function*(){
    yield condition
    console.log("checkbox checked")
}
```
`predicate` may be `property` or `function` with enclosed properties
```QML
Condition{
    predicate: function(){
        return checkbox.checked && checkbox2.checked
    }
}
```
---