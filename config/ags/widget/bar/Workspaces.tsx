import AstalHyprland from "gi://AstalHyprland"
import { createBinding, For } from "ags"

export default function Workspaces() {
  const hypr = AstalHyprland.get_default()
  const workspaces = createBinding(hypr, "workspaces")
  const focused = createBinding(hypr, "focusedWorkspace")

  return (
    <box class="workspaces">
      <For each={workspaces((ws) => [...ws].sort((a, b) => a.id - b.id))}>
        {(ws) => (
          <button
            class={focused((f) =>
              f?.id === ws.id ? "workspace focused" : "workspace"
            )}
            onClicked={() => ws.focus()}
          >
            <label label={String(ws.id)} />
          </button>
        )}
      </For>
    </box>
  )
}