-- Catppuccin Mocha theme
-- https://github.com/catppuccin/catppuccin

local base      = 0xd911111b
local mantle    = 0xff181825
local surface0  = 0xff313244
local surface1  = 0xff45475a
local surface2  = 0xff585b70
local text      = 0xffcdd6f4
local subtext0  = 0xffbac2de
local red       = 0xfff38ba8
local green      = 0xffa6e3a1
local yellow     = 0xfff9e2af
local blue       = 0xff89b4fa
local mauve      = 0xffcba6f7
local teal       = 0xff94e2d5
local lavender    = 0xffb4befe
local rosewater   = 0xfff5e0dc

-- Text overlay
swayimg.text.color      = text
swayimg.text.background = 0x00000000
swayimg.text.shadow     = mantle
swayimg.text.font       = "monospace"
swayimg.text.size       = 14

-- Viewer mode
swayimg.viewer.set_window_background(base)
swayimg.viewer.mark_color = mauve

-- Slideshow mode
swayimg.slideshow.set_window_background(base)
swayimg.slideshow.mark_color = mauve

-- Gallery mode
swayimg.gallery.window_color      = base
swayimg.gallery.unselected_color  = surface0
swayimg.gallery.selected_color    = surface2
swayimg.gallery.border_color      = blue
swayimg.gallery.mark_color        = mauve

swayimg.antialiasing = true
swayimg.imagelist.adjacent = true
swayimg.imagelist.order = "alpha"

-- switch images functions
swayimg.viewer.on_mouse("ScrollDown", function()
  swayimg.viewer.open("next")
end)
swayimg.viewer.on_mouse("ScrollUp", function()
  swayimg.viewer.open("prev")
end)
swayimg.viewer.on_key("Right", function()
  swayimg.viewer.open("next")
end)
swayimg.viewer.on_key("Left", function()
  swayimg.viewer.open("prev")
end)
swayimg.viewer.on_key("Down", function()
  swayimg.viewer.open("next")
end)
swayimg.viewer.on_key("Up", function()
  swayimg.viewer.open("prev")
end)