import app from "ags/gtk4/app"
import { Astal, Gdk } from "ags/gtk4"
import { createPoll } from "ags/time"
import Workspaces from "./Workspaces"

function Clock() {
  const time = createPoll("", 1000, "date +'%H:%M:%S'")
  return <label class="clock" label={time} />
}

export default function Bar(monitor: Gdk.Monitor) {
  const { TOP, LEFT, RIGHT } = Astal.WindowAnchor

  return (
    <window
        visible
        gdkmonitor={monitor}
        anchor={TOP | LEFT | RIGHT}
        exclusivity={Astal.Exclusivity.EXCLUSIVE}
        application={app}
        class="Bar"
        marginTop={6}
        marginLeft={10}
        marginRight={10}
    >
      <centerbox class="bar-inner">
        <box $type="start">
            <Workspaces />
        </box>
        <box $type="center">
          <Clock />
        </box>
        <box $type="end" />
      </centerbox>
    </window>
  )
}