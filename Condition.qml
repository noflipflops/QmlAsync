import QtQuick 2.15

QtObject {
    property bool finished : if (predicate) predicate()

    property var predicate

}
