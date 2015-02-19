package.path = package.path .. ';/Users/adr/.luarocks/share/lua/5.2/?.lua;/Users/adr/.luarocks/share/lua/5.2/?/init.lua;/usr/local/share/lua/5.2/?.lua;/usr/local/share/lua/5.2/?/init.lua;/usr/local/Cellar/luarocks/2.2.0_1/share/lua/5.2/?.lua;/usr/local/lib/lua/5.2/?.lua;/usr/local/lib/lua/5.2/?/init.lua;./?.lua'
package.cpath = package.cpath .. ';/Users/adr/.luarocks/lib/lua/5.2/?.so;/usr/local/lib/lua/5.2/?.so;/usr/local/lib/lua/5.2/loadall.so;./?.so'

local application = require "mjolnir.application"
local hotkey = require "mjolnir.hotkey"
local window = require "mjolnir.window"
local fnutils = require "mjolnir.fnutils"
local keycodes = require "mjolnir.keycodes"
local alert = require "mjolnir.alert"
local screen = require "mjolnir.screen"
local hints = require "mjolnir.th.hints"

local mash = {"cmd", "alt", "ctrl", "shift"}
hotkey.bind(mash, "e", hints.windowHints)
