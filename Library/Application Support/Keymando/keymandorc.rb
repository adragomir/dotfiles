# Start Keymando at login
# -----------------------------------------------------------
start_at_login

# Disable Keymando when using these applications
# -----------------------------------------------------------
disable "Remote Desktop Connection"
disable /VirtualBox/

# Basic mapping
# -----------------------------------------------------------
# map "<Ctrl-[>", "<Escape>"
# map "<Ctrl-m>", "<Ctrl-F2>"


# Commands
# -----------------------------------------------------------

# Command launcher window via Cmd-Space
# map "<Cmd- >" do
#   trigger_item_with(Commands.items, RunRegisteredCommand.new)                                                                                                                                                             
# end 

map "<Ctrl-Shift-I>" do
    activate('iTerm')
    send('<Cmd-Option-1>')
    send('<Cmd-1>')
end
map "<Ctrl-Shift-S>" do
    activate('iTerm')
    send('<Cmd-Option-1>')
    send('<Cmd-2>')
end

# Register commands 
# -----------------------------------------------------------
# command "Volume Up" do 
#   `osascript -e 'set volume output volume (output volume of (get volume settings) + 7)'`
# end
# 
# command "Volume Down" do 
#   `osascript -e 'set volume output volume (output volume of (get volume settings) - 7)'`
# end

# Repeat last command via Cmd-.
map "<Cmd-.>", RunLastCommand.instance

# -----------------------------------------------------------
# Visit http://keymando.com to see what else Keymando can do!
# -----------------------------------------------------------
