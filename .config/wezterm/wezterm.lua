local wezterm = require 'wezterm'
local mux = wezterm.mux

-- local gpus = wezterm.gui.enumerate_gpus()
wezterm.on('gui-startup', function()
  local tab, pane, window = mux.spawn_window({})
  window:gui_window():maximize()
end)

local tmp = {
  line_height = 0.95,
  bold_brightens_ansi_colors = true,
  harfbuzz_features = {"calt=0", "clig=0", "liga=0"},
  warn_about_missing_glyphs = false,
  animation_fps = 1,
  cursor_blink_rate = 0,
  font_size = 14.0,
  font = wezterm.font("Consolas"),
  enable_csi_u_key_encoding = true,
  --enable_kitty_keyboard = true,
  -- font = wezterm.font("JetBrains Mono NL"),
  -- font = wezterm.font("Berkeley Mono"),
  -- font_rules= {
  --   -- Select a fancy italic font for italic text
  --   {
  --     italic = true,
  --     font = wezterm.font("JetBrains Mono Italic Nerd Font Complete"),
  --   },
  --   -- Similarly, a fancy bold+italic font
  --   {
  --     italic = true,
  --     intensity = "Bold",
  --     font = wezterm.font("JetBrains Mono Bold Italic Nerd Font Complete"),
  --   },
  --   -- Make regular bold text a different color to make it stand out even more
  --   {
  --     intensity = "Bold",
  --     font = wezterm.font("JetBrains Mono Bold Nerd Font Complete", {weight="Bold"}),
  --   },
  -- },
  colors = {
      -- The default text color
      foreground = "#c7c7c7",
      -- The default background color
      background = "#000000",

      -- Overrides the cell background color when the current cell is occupied by the
      -- cursor and the cursor style is set to Block
      cursor_bg = "#ffb473",
      -- Overrides the text color when the current cell is occupied by the cursor
      cursor_fg = "black",
      -- Specifies the border color of the cursor when the cursor style is set to Block,
      -- of the color of the vertical or horizontal bar when the cursor style is set to
      -- Bar or Underline.

      -- The color of the scrollbar "thumb"; the portion that represents the current viewport
      scrollbar_thumb = "#222222",

      -- The color of the split lines between panes
      split = "#444444",

      ansi = {"#616161", "#ff8272", "#b4fa72", "#fefdc2", "#a5d5fe", "#ff8ffd", "#d0d1fe", "#f1f1f1"},
      brights = {"#8e8e8e", "#ffc4bd", "#d6fcb9", "#fefdd5", "#c1e3fe", "#ffb1fe", "#e5e6fe", "#feffff"},
  },
  disable_default_key_bindings = true,
  send_composed_key_when_left_alt_is_pressed = false,
  send_composed_key_when_right_alt_is_pressed = false,
  keys = {
    {key="q", mods="CMD", action="QuitApplication"},
    {key="c", mods="CMD", action=wezterm.action{CopyTo="Clipboard"}},
    {key="v", mods="CMD", action=wezterm.action{PasteFrom="Clipboard"}},
    {key="n", mods="CMD", action="SpawnWindow"},
    {key="Enter", mods="ALT", action="ToggleFullScreen"},
    {key="phys:Minus", mods="SHIFT|CMD", action="DecreaseFontSize"},
    {key="phys:Equal", mods="SHIFT|CMD", action="IncreaseFontSize"},
    {key="phys:0", mods="SHIFT|CMD", action="ResetFontSize"},
    {key="t", mods="SUPER", action=wezterm.action{SpawnTab="CurrentPaneDomain"}},
    {key="w", mods="SUPER", action=wezterm.action{CloseCurrentPane={confirm=false}}},
    {key="phys:LeftBracket", mods="SHIFT|SUPER", action=wezterm.action{ActivateTabRelative=-1}},
    {key="phys:RightBracket", mods="SHIFT|SUPER", action=wezterm.action{ActivateTabRelative=1}},
    {key="9", mods="ALT", action="ShowTabNavigator"},
    {key="r", mods="SUPER|SHIFT", action="ReloadConfiguration"},
    {key="k", mods="SUPER", action=wezterm.action{ClearScrollback="ScrollbackAndViewport"}},
    {key="f", mods="SUPER", action=wezterm.action{Search={CaseSensitiveString=""}}},
    {key="x", mods="SUPER|SHIFT", action="ActivateCopyMode"},
    {key="Enter", mods="SUPER|SHIFT", action="TogglePaneZoomState" },
    {key="d", mods="SUPER", action=wezterm.action{SplitHorizontal={domain="CurrentPaneDomain"}}},
    {key="d", mods="SUPER|SHIFT", action=wezterm.action{SplitVertical={domain="CurrentPaneDomain"}}},
    {key="RightArrow", mods="SUPER|SHIFT", action=wezterm.action{ActivatePaneDirection="Right"}},
    {key="LeftArrow", mods="SUPER|SHIFT", action=wezterm.action{ActivatePaneDirection="Left"}},
    {key="UpArrow", mods="SUPER|SHIFT", action=wezterm.action{ActivatePaneDirection="Up"}},
    {key="DownArrow", mods="SUPER|SHIFT", action=wezterm.action{ActivatePaneDirection="Down"}},
    {key="LeftArrow", mods="OPT", action=wezterm.action{SendString="\x1bb"}},
    {key="RightArrow", mods="OPT", action=wezterm.action{SendString="\x1bf"}},
    {key=" ", mods="SUPER|SHIFT", action="QuickSelect"},
    {key="'", mods="CTRL", action=wezterm.action{SendString="\x1bOj"}},
    {key="1", mods="CTRL", action=wezterm.action{SendString="\x1b[27;5;49~"}},
    {key="2", mods="CTRL", action=wezterm.action{SendString="\x1b[27;5;50~"}},
    {key="3", mods="CTRL", action=wezterm.action{SendString="\x1b[27;5;51~"}},
    {key="4", mods="CTRL", action=wezterm.action{SendString="\x1b[27;5;52~"}},
    {key="5", mods="CTRL", action=wezterm.action{SendString="\x1b[27;5;53~"}},
    {key="6", mods="CTRL", action=wezterm.action{SendString="\x1b[27;5;54~"}},
    {key="7", mods="CTRL", action=wezterm.action{SendString="\x1b[27;5;55~"}},
    {key="8", mods="CTRL", action=wezterm.action{SendString="\x1b[27;5;56~"}},
    {key="9", mods="CTRL", action=wezterm.action{SendString="\x1b[27;5;57~"}},
    {key="0", mods="CTRL", action=wezterm.action{SendString="\x1b[27;5;48~"}},
    {key="1", mods="CTRL|ALT", action=wezterm.action{MoveTab=0}},
    {key="2", mods="CTRL|ALT", action=wezterm.action{MoveTab=1}},
    {key="3", mods="CTRL|ALT", action=wezterm.action{MoveTab=2}},
    {key="4", mods="CTRL|ALT", action=wezterm.action{MoveTab=3}},
    {key="5", mods="CTRL|ALT", action=wezterm.action{MoveTab=4}},
    {key="6", mods="CTRL|ALT", action=wezterm.action{MoveTab=5}},
    {key="7", mods="CTRL|ALT", action=wezterm.action{MoveTab=6}},
    {key="8", mods="CTRL|ALT", action=wezterm.action{MoveTab=7}},
    {key="9", mods="CTRL|ALT", action=wezterm.action{MoveTab=8}},
    {key="0", mods="CTRL|ALT", action=wezterm.action{MoveTab=9}},
    {key="1", mods="SUPER", action=wezterm.action{ActivateTab=0}},
    {key="2", mods="SUPER", action=wezterm.action{ActivateTab=1}},
    {key="3", mods="SUPER", action=wezterm.action{ActivateTab=2}},
    {key="4", mods="SUPER", action=wezterm.action{ActivateTab=3}},
    {key="5", mods="SUPER", action=wezterm.action{ActivateTab=4}},
    {key="6", mods="SUPER", action=wezterm.action{ActivateTab=5}},
    {key="7", mods="SUPER", action=wezterm.action{ActivateTab=6}},
    {key="8", mods="SUPER", action=wezterm.action{ActivateTab=7}},
    {key="9", mods="SUPER", action=wezterm.action{ActivateTab=8}},
    {key="0", mods="SUPER", action=wezterm.action{ActivateTab=9}},
    {
      key = "/",
      mods = "SUPER",
      action = wezterm.action.Multiple({
        wezterm.action.CopyMode("ClearPattern"),
        wezterm.action.Search({ CaseSensitiveString = "" }),
      }),
    },
  },
  scrollback_lines = 10000,
  skip_close_confirmation_for_processes_named = {
    "bash", "sh", "zsh", "fish", "tmux", "ncdu"
  },
  window_decorations = "TITLE | RESIZE",
  hyperlink_rules = {},
  inactive_pane_hsb = {
    saturation = 0.9,
    brightness = 0.8,
  },
  -- webgpu_preferred_adapter = gpus[0],
  -- webgpu_power_preference = "HighPerformance",
  front_end = 'OpenGL',
  use_dead_keys = false
}

return tmp
