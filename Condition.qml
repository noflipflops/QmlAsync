import QtQuick 2.15

QtObject {
    property bool finished: if (typeof predicate === "function") predicate()
        else predicate

    property var predicate
}
