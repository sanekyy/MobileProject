import QtQuick 2.5
import QtGraphicalEffects 1.0
import QtQuick.Window 2.0
import QuickAndroid 0.1
import QuickAndroid.Private 0.1
//import ".."



/*
  USING

   MySwitch{
       id:commentsSwitch
       anchors.verticalCenter: parent.verticalCenter
       anchors.right: parent.right
       anchors.rightMargin: 16*A.dp
   }

  */



/*!
\qmltype AppSwitch
\inqmlmodule VPlayApps 1.0
\ingroup apps-controls
\brief An on/off button-like control

This displays a slide-able switch which can be used to toggle some functionality on or off.

It has a \l checked property, that can be modified by the user, either by sliding the
switch to the left (off) or to the right (on), or by simply tapping on it (toggles on/off).

It will emit the signal \l toggled, when the \l checked state has changed.
By default, the styling of the button is changed to match different platforms.
*/
Item {
    id: control


    // Public API


    /*!
  A Boolean property that determines the off/on state of the switch. Set this property to \c true or \c false to
  change the switch's state.

  \sa toggle()
  \sa setChecked()
 */
    property bool checked: false

    /*!
  The background color when the switch is on.

  \since V-Play 2.6.2
 */
    property color backgroundColorOn: "skyblue"//Theme.isAndroid ? Theme.tintLightColor : Theme.tintColor

    /*!
  The background color when the switch is on and pressed.

  \since V-Play 2.6.2
 */
    property color backgroundColorOnPressed: "skyblue" //Theme.tintLightColor

    /*!
  The background color when the switch is off.

  \since V-Play 2.6.2
 */
    property color backgroundColorOff: "#ccc"//Theme.isAndroid ? "#ccc" : "white"

    /*!
  The background color when the switch is off and pressed.

  \since V-Play 2.6.2
 */
    property color backgroundColorOffPressed: "#ccc"//Theme.isAndroid ?  "#ccc" : "#E5E5E5"

    /*!
  The knob color when the switch is off.

  \since V-Play 2.6.2
 */
    property color knobColorOff: "white"

    /*!
  The knob color when the switch is on.

  \since V-Play 2.6.2
 */
    property color knobColorOn: "dodgerblue"//Theme.isAndroid ? Theme.tintColor : "white"

    /*!
  The border color of the knob.

  \since V-Play 2.6.2
 */
    property color knobBorderColor: knob.color//Theme.isAndroid ? knob.color : "#E5E5E5"

    /*!
  \internal

  Whether the knob should drop a shadow.

  Internal for now, as changing that property on iOS leads to a broken control

  \since V-Play 2.6.2
 */
    property bool dropShadow: true//Theme.isAndroid

    /*!
  \internal

  If set to false, the checked property is not changed when this control is toggled. Can be useful if it is bound
  to some other value.
*/
    property bool updateChecked: true

    /*!
  Emitted each time the \l checked state of the switch changes. This is the case when the user toggles the button or
  it gets set from within your code.
 */
    signal toggled()

    /*!
  Call this method to toggle the current \l checked state of the switch. If the switch is currently off it changes to
  on and vice-versa.

  \sa checked
  \sa setChecked()
 */
    function toggle() {
        setChecked(!control.checked)
    }

    /*!
  Call this method to set the current \l checked state of the switch. This has the same effect as setting the
  \l{checked} property directly.

  \sa checked
  \sa toggle()
 */
    function setChecked(checked) {
        if(checked !== control.checked) {
            if(updateChecked) {
                control.checked = checked
            }
            control.toggled()
        }
    }


    // Public API end


    height: 22*Device.dp//dp(Theme.isAndroid ? 22 : 30)
    width: height / 0.55//Theme.isAndroid ? height / 0.65 : height / 0.59

    Rectangle {
        id: background
        radius: height
        width: control.width
        height: control.height/1.5 //Theme.isAndroid ? control.height / 1.5 : control.height
        anchors.verticalCenter: parent.verticalCenter

        color: knobContainer.effectiveChecked
               ? (innerArea.pressed ? backgroundColorOnPressed : backgroundColorOn)
               : (innerArea.pressed ? backgroundColorOffPressed : backgroundColorOff)
        border.color: control.checked ? backgroundColorOn : backgroundColorOffPressed
        border.width: control.height * 0.04//(Theme.isAndroid ? 0.04 : 0.048)

        Behavior on color {
            ColorAnimation { duration: 150 }
        }

        Behavior on border.color {
            ColorAnimation { duration: 150 }
        }

        // the container for the knob (needed because of knob shadow)
        Item {
            id: knobContainer
            width:  knobWidth  + (2 * knobShadow.radius)
            height: knobWidth + (2 * knobShadow.radius)
            visible: !dropShadow

            readonly property bool dragChecked: x > xMiddle
            readonly property bool effectiveChecked: innerArea.drag.active ? dragChecked : control.checked

            readonly property real offset: background.border.width
            property color knobColor: effectiveChecked ? control.knobColorOn : control.knobColorOff
            readonly property real knobWidth: control.height - background.border.width * 2

            readonly property real xLeft: offset - 2 * knobShadow.radius
            readonly property real xRight: control.width - offset - knobContainer.width + 2 * knobShadow.radius
            readonly property real xMiddle: (xLeft + xRight) / 2
            readonly property real xDefault: (control.checked ? xRight : xLeft)

            x: xDefault
            y: offset - background.y - knobShadow.radius

            // Inner knob
            Rectangle {
                id: knob

                anchors.centerIn: parent
                width: parent.knobWidth
                height: parent.knobWidth

                radius: height * 0.5
                color: parent.knobColor

                border.color: control.knobBorderColor
                border.width: control.height * 0.04
            }

            Behavior on knobColor {
                ColorAnimation { duration: 150 }
            }

            Behavior on x {
                NumberAnimation { easing.type: Easing.InOutQuad; duration: 150 }
            }
        }

        // add drop shadow
        DropShadow {
            id: knobShadow
            radius: dropShadow ? control.height * 0.1 : 0
            samples: radius * 2
            verticalOffset: radius * 0.5
            anchors.fill: source
            source: knobContainer
            color: Qt.rgba(0, 0, 0, 0.2)
            visible: control.dropShadow
        }
    }

    MouseArea {
        id: innerArea
        anchors.fill: parent
        //radius: control.height

        // move ripple effect with knob
        property real knobX: background.x + knobContainer.x + knob.x + knob.width / 2
        property real knobY: background.y + knobContainer.y + knob.y + knob.height / 2
        //touchPoint: Qt.point(knobX, knobY)
        //fixedPosition: false // always follow touch point
        //centerAnimation: true // always center fill animation

        // don't cancel events if mouse moved too much (because of because of dragging feature)
        //cancelOnMouseMove: false

        // configure mouse area drag and toggle
        property bool dragged: false
        drag.onActiveChanged: if(drag.active) dragged = true

        drag.target: knobContainer
        drag.axis: Drag.XAxis
        drag.minimumX: knobContainer.xLeft
        drag.maximumX: knobContainer.xRight

        onReleased: {
            if(dragged) {
                control.setChecked(knobContainer.dragChecked)

                //MouseArea's drag and drop overrides x binding -> set it again
                knobContainer.x = Qt.binding(function() { return knobContainer.xDefault })
            }
            else
                toggle()
            dragged = false
        }
    }
}
