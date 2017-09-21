local awful = require('awful')

local run_once = function (cmd)
  findme = cmd
  firstspace = cmd:find(" ")
  if firstspace then
     findme = cmd:sub(0, firstspace-1)
  end
  awful.util.spawn_with_shell("pgrep -u $USER -x " .. findme .. " > /dev/null || (" .. cmd .. ")")

  awful.util.spawn("nm-applet")
  awful.util.spawn("volti")
  awful.util.spawn("synclient CircularScrolling=1 VertEdgeScroll=1 TapButton1=1 HorizTwoFingerScroll=1")
  awful.util.spawn("redshift -l 59.934280:30.335099")
  awful.util.spawn_with_shell("wmname LG3D")
  awful.util.spawn_with_shell("setxkbmap -layout us,ru -option grp:lctrl_lshift_toggle")


end

return run_once