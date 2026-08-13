import app from "ags/gtk4/app"
import style from "./style/main.scss"
import Bar from "./widget/bar/Bar"

app.start({
  css: style,
  main() {
    app.get_monitors().forEach(Bar)
  },
})