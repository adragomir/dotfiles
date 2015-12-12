package.path = package.path .. ';/Users/adr/.luarocks/share/lua/5.2/?.lua;/Users/adr/.luarocks/share/lua/5.2/?/init.lua;/usr/local/share/lua/5.2/?.lua;/usr/local/share/lua/5.2/?/init.lua;/usr/local/Cellar/luarocks/2.2.0_1/share/lua/5.2/?.lua;/usr/local/lib/lua/5.2/?.lua;/usr/local/lib/lua/5.2/?/init.lua;./?.lua'
package.cpath = package.cpath .. ';/Users/adr/.luarocks/lib/lua/5.2/?.so;/usr/local/lib/lua/5.2/?.so;/usr/local/lib/lua/5.2/loadall.so;./?.so'

require("mjolnir._asm.modal_hotkey").inject()

local application = require "mjolnir.application"
local hotkey = require "mjolnir.hotkey"
local modal_hotkey = require "mjolnir._asm.modal_hotkey"
local screen = require "mjolnir.screen"
local geometry = require "mjolnir.geometry"
local fnutils = require "mjolnir.fnutils"
local keycodes = require "mjolnir.keycodes"
local grid = require "mjolnir.bg.grid"
local hints = require "mjolnir.th.hints"
local alert = require "mjolnir.alert"
local appfinder = require "mjolnir.cmsj.appfinder"
local tiling = require "mjolnir.tiling"
local window = require "mjolnir.window"

grid.MARGINX = 0
grid.MARGINY = 0
grid.GRIDHEIGHT = 2
grid.GRIDWIDTH = 4

local mash = {"cmd", "alt", "ctrl", "shift"}
hotkey.bind(mash, "e", hints.windowHints)
--space_modal = modal_hotkey.new(mash, "return")

hotkey.bind(mash, "r", function()
  mjolnir.reload()
  alert.show("reloaded", 500)
end)

hotkey.bind(mash, "return", function()
  if window.focusedwindow() then
    window.focusedwindow():maximize()
  else
    alert.show("no focused window", 500)
  end
end)

hotkey.bind(mash, "l", function()
  if window.focusedwindow() then
    grid.adjust_focused_window(function(c) 
      local nx
      if c.x == grid.GRIDWIDTH - 1 then
        nx = 0
      else
        nx = c.x + 1
      end

      local nw = grid.GRIDWIDTH - nx
      c.x = nx
      c.w = nw
    end)
  else
    alert.show("no focused window", 500)
  end
end)

hotkey.bind(mash, "k", function()
  grid.adjust_focused_window(function(c) 
    local nh
    if c.h == 1 then
      nh = grid.GRIDHEIGHT
    else
      nh = c.h - 1
    end
    c.h = nh
  end)
end)

hotkey.bind(mash, "j", function()
  grid.adjust_focused_window(function(c) 
    alert.show(c.y .. ", " .. c.h)
    local ny
    if c.y == grid.GRIDHEIGHT - 1 then
      ny = 0
    else
      ny = c.y + 1
    end

    local nh = grid.GRIDHEIGHT - ny
    c.y = ny
    c.h = nh
  end)
end)

hotkey.bind(mash, "h", function()
  grid.adjust_focused_window(function(c) 
    local nw
    if c.w == 1 then
      nw = grid.GRIDWIDTH
    else
      nw = c.w - 1
    end

    c.w = nw
  end)
end)

-- space_modal:bind({}, "J", function()
--    alert("Pressed J")
-- end)
