// Time.qml

// with this line our type becomes a Singleton
pragma Singleton

import Quickshell
import QtQuick

Singleton {
  property string time: Qt.formatDateTime(clock.date, "hh:mm:ss")
  
  SystemClock {
	  id: clock
	  precision: SystemClock.Seconds
  }
}
