-- package.path = package.path .. ';/Users/adr/.luarocks/share/lua/5.2/?.lua;/Users/adr/.luarocks/share/lua/5.2/?/init.lua;/usr/local/share/lua/5.2/?.lua;/usr/local/share/lua/5.2/?/init.lua;/usr/local/Cellar/luarocks/2.2.0_1/share/lua/5.2/?.lua;/usr/local/lib/lua/5.2/?.lua;/usr/local/lib/lua/5.2/?/init.lua;./?.lua'
-- package.cpath = package.cpath .. ';/Users/adr/.luarocks/lib/lua/5.2/?.so;/usr/local/lib/lua/5.2/?.so;/usr/local/lib/lua/5.2/loadall.so;./?.so'

-- require("mjolnir._asm.modal_hotkey").inject()

-- local application = require "mjolnir.application"
-- local hotkey = require "mjolnir.hotkey"
-- local modal_hotkey = require "mjolnir._asm.modal_hotkey"
-- local screen = require "mjolnir.screen"
-- local geometry = require "mjolnir.geometry"
-- local fnutils = require "mjolnir.fnutils"
-- local keycodes = require "mjolnir.keycodes"
-- local grid = require "mjolnir.bg.grid"
-- local hints = require "mjolnir.th.hints"
-- local alert = require "mjolnir.alert"
-- local appfinder = require "mjolnir.cmsj.appfinder"
-- local tiling = require "mjolnir.tiling"
-- local window = require "mjolnir.window"

-- grid.MARGINX = 0
-- grid.MARGINY = 0
-- grid.GRIDHEIGHT = 2
-- grid.GRIDWIDTH = 4

local mash = {"cmd", "alt", "ctrl", "shift"}
-- hs.hotkey.bind(mash, "e", hs.hints.windowHints)

-- hs.hotkey.bind(mash, "r", function()
--   hs.reload()
--   hs.alert.show("config reloaded", 0.2)
-- end)

hs.hotkey.bind(mash, "return", function()
  if hs.window.focusedWindow() then
    hs.window.focusedWindow():maximize()
  else
    hs.alert.show("no focused window", 0.2)
  end
end)

hs.loadSpoon("WindowHalfsAndThirds")
--spoon.WindowHalfsAndThirds:bindHotkeys( {
--   left_half    = { mash, "Left" },
--   right_half   = { mash, "Right" },
--   top_half     = { mash, "Up" },
--   bottom_half  = { mash, "Down" },
--   third_left   = { mash, "d" },
--   third_right  = { mash, "Right" },
--   third_up     = { mash, "Up" },
--   third_down   = { mash, "Down" },
--   top_left     = { mash, "u" },
--   top_right    = { mash, "i" },
--   bottom_left  = { mash, "j" },
--   bottom_right = { mash, "k" },
--   max_toggle   = { mash, "f" },
--   ---max          = { mash, "Up" },
--   undo         = { mash, "z" },
--   center       = { mash, "c" },
--   larger       = { mash, "Right" },
--   smaller      = { mash, "Left" },
--})

-- hotkey.bind(mash, "l", function()
--   if window.focusedWindow() then
--     grid.adjust_focused_window(function(c) 
--       local nx
--       if c.x == grid.GRIDWIDTH - 1 then
--         nx = 0
--       else
--         nx = c.x + 1
--       end

--       local nw = grid.GRIDWIDTH - nx
--       c.x = nx
--       c.w = nw
--     end)
--   else
--     alert.show("no focused window", 500)
--   end
-- end)

-- hotkey.bind(mash, "k", function()
--   grid.adjust_focused_window(function(c) 
--     local nh
--     if c.h == 1 then
--       nh = grid.GRIDHEIGHT
--     else
--       nh = c.h - 1
--     end
--     c.h = nh
--   end)
-- end)

-- hotkey.bind(mash, "j", function()
--   grid.adjust_focused_window(function(c) 
--     alert.show(c.y .. ", " .. c.h)
--     local ny
--     if c.y == grid.GRIDHEIGHT - 1 then
--       ny = 0
--     else
--       ny = c.y + 1
--     end

--     local nh = grid.GRIDHEIGHT - ny
--     c.y = ny
--     c.h = nh
--   end)
-- end)

-- hotkey.bind(mash, "h", function()
--   grid.adjust_focused_window(function(c) 
--     local nw
--     if c.w == 1 then
--       nw = grid.GRIDWIDTH
--     else
--       nw = c.w - 1
--     end

--     c.w = nw
--   end)
-- end)
hs.hotkey.bind(mash, "d", function()
  local _,url = hs.osascript.applescript('tell application "Google Chrome" to return URL of active tab of front window')
  if string.match(url, "https://www.youtube.com/watch") then
    local videoId = url:gsub(".*?v=", "")
    hs.task.new("/usr/bin/find",
      function(code, stdout, stderr)
        if stdout == nil or stdout == '' then
          hs.alert.show("NOT found !")
        else
          hs.alert.show("FOUND !")
        end
      end,
      {"/Users/adragomi/Dropbox/Video/machining", "-iname", "*" .. videoId .. "*"}):start()
  end
end)

function cycle_neovide_windows()
  local current = hs.window.focusedWindow()

  local items = hs.fnutils.imap({hs.application.find('com.neovide.neovide')}, function(app)
    local title = app:title()
    local status
    local win = app:mainWindow()

    if win ~= nil then
      title = win:title()
    end

    if win == current then
      status = '[CURRENT]'
    end

    return {
      text = title,
      subText = status,
      pid = app:pid(),
    }
  end)

  local callback = function(result)
    hs.application.applicationForPID(result.pid):activate()
  end

  hs.chooser.new(callback):choices(items):show()
end

hs.hotkey.bind({'cmd', 'ctrl'}, '`', cycle_neovide_windows)
