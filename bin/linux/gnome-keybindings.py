#!/usr/bin/env python
# gnome-keybindings

# Description:
#   Manages the keybindings found in the gnome-keybinding-properties applet
# Dependencies:
#   gconftool-2
#   zenity
#   python 2.6-3.1

'''gnome-keybindings - A tool for managing keybindings within the gnome shell environment

Usage:  gnome-keybindings [option]...
        gnome-keybindings [option] [path]...

Import/Export options:
  -i, --import                                  Import the gnome keybindings from a file.
  -e, --export                                  Export the gnome keybindings to a file.

If a path is NOT given following these commands a zenity file dialog will be spawned to select one.

Application options:
  -v, --version                                 Print version
'''

__author__ = "Evan Plaice"
__version__ = "0.1.0"

import os
import sys
import subprocess
import json
from pprint import pprint

# grab the python version
pyVersion = sys.version_info[0]

# define the gconf locations for all of the keybindings
keyLocations = {
    '/apps/gnome_settings_daemon/keybindings/volume_mute' : '',
    '/apps/gnome_settings_daemon/keybindings/volume_down' : '',
    '/apps/gnome_settings_daemon/keybindings/volume_up' : '',
    '/apps/gnome_settings_daemon/keybindings/media' : '',
    '/apps/gnome_settings_daemon/keybindings/play' : '',
    '/apps/gnome_settings_daemon/keybindings/pause' : '',
    '/apps/gnome_settings_daemon/keybindings/stop' : '',
    '/apps/gnome_settings_daemon/keybindings/previous' : '',
    '/apps/gnome_settings_daemon/keybindings/next' : '',
    '/apps/gnome_settings_daemon/keybindings/eject' : '',
    '/apps/gnome_settings_daemon/keybindings/help' : '',
    '/apps/gnome_settings_daemon/keybindings/calculator' : '',
    '/apps/gnome_settings_daemon/keybindings/email' : '',
    '/apps/gnome_settings_daemon/keybindings/www' : '',
    '/apps/gnome_settings_daemon/keybindings/power' : '',
    '/apps/gnome_settings_daemon/keybindings/screensaver' : '',
    '/apps/gnome_settings_daemon/keybindings/home' : '',
    '/apps/gnome_settings_daemon/keybindings/search' : '',
    '/apps/metacity/global_keybindings/panel_run_dialog' : '',
    '/apps/metacity/global_keybindings/panel_main_menu' : '',
    '/apps/metacity/global_keybindings/run_command_screenshot' : '',
    '/apps/metacity/global_keybindings/run_command_window_screenshot' : '',
    '/apps/metacity/global_keybindings/run_command_terminal' : '',
    '/apps/compiz/plugins/scale/allscreens/options/initiate_key' : '',
    '/apps/compiz/plugins/ezoom/allscreens/options/zoom_in_key' : '',
    '/apps/compiz/plugins/ezoom/allscreens/options/zoom_out_key' : '',
    '/apps/compiz/plugins/expo/allscreens/options/expo_key' : '',
    '/desktop/gnome/keybindings/magnifier/binding' : '',
    '/desktop/gnome/keybindings/screenreader/binding' : '',
    '/desktop/gnome/keybindings/onscreenkeyboard/binding' : '',
    '/apps/metacity/window_keybindings/activate_window_menu' : '',
    '/apps/metacity/window_keybindings/toggle_fullscreen' : '',
    '/apps/metacity/window_keybindings/toggle_maximized' : '',
    '/apps/metacity/window_keybindings/maximize' : '',
    '/apps/metacity/window_keybindings/unmaximize' : '',
    '/apps/metacity/window_keybindings/toggle_shaded' : '',
    '/apps/metacity/window_keybindings/close' : '',
    '/apps/metacity/window_keybindings/minimize' : '',
    '/apps/metacity/window_keybindings/begin_move' : '',
    '/apps/metacity/window_keybindings/begin_resize' : '',
    '/apps/metacity/window_keybindings/toggle_on_all_workspaces' : '',
    '/apps/metacity/window_keybindings/raise_or_lower' : '',
    '/apps/metacity/window_keybindings/raise' : '',
    '/apps/metacity/window_keybindings/lower' : '',
    '/apps/metacity/window_keybindings/maximize_vertically' : '',
    '/apps/metacity/window_keybindings/maximize_horizontally' : '',
    '/apps/metacity/window_keybindings/move_to_workspace_1' : '',
    '/apps/metacity/window_keybindings/move_to_workspace_2' : '',
    '/apps/metacity/window_keybindings/move_to_workspace_3' : '',
    '/apps/metacity/window_keybindings/move_to_workspace_4' : '',
    '/apps/metacity/window_keybindings/move_to_workspace_5' : '',
    '/apps/metacity/window_keybindings/move_to_workspace_6' : '',
    '/apps/metacity/window_keybindings/move_to_workspace_7' : '',
    '/apps/metacity/window_keybindings/move_to_workspace_8' : '',
    '/apps/metacity/window_keybindings/move_to_workspace_9' : '',
    '/apps/metacity/window_keybindings/move_to_workspace_10' : '',
    '/apps/metacity/window_keybindings/move_to_workspace_11' : '',
    '/apps/metacity/window_keybindings/move_to_workspace_12' : '',
    '/apps/metacity/window_keybindings/move_to_workspace_left' : '',
    '/apps/metacity/window_keybindings/move_to_workspace_right' : '',
    '/apps/metacity/window_keybindings/move_to_workspace_up' : '',
    '/apps/metacity/window_keybindings/move_to_workspace_down' : '',
    '/apps/metacity/global_keybindings/switch_windows' : '',
    '/apps/metacity/global_keybindings/show_desktop' : '',
    '/apps/metacity/global_keybindings/switch_to_workspace_1' : '',
    '/apps/metacity/global_keybindings/switch_to_workspace_2' : '',
    '/apps/metacity/global_keybindings/switch_to_workspace_3' : '',
    '/apps/metacity/global_keybindings/switch_to_workspace_4' : '',
    '/apps/metacity/global_keybindings/switch_to_workspace_5' : '',
    '/apps/metacity/global_keybindings/switch_to_workspace_6' : '',
    '/apps/metacity/global_keybindings/switch_to_workspace_7' : '',
    '/apps/metacity/global_keybindings/switch_to_workspace_8' : '',
    '/apps/metacity/global_keybindings/switch_to_workspace_9' : '',
    '/apps/metacity/global_keybindings/switch_to_workspace_10' : '',
    '/apps/metacity/global_keybindings/switch_to_workspace_11' : '',
    '/apps/metacity/global_keybindings/switch_to_workspace_12' : '',
    '/apps/metacity/global_keybindings/switch_to_workspace_left' : '',
    '/apps/metacity/global_keybindings/switch_to_workspace_right' : '',
    '/apps/metacity/global_keybindings/switch_to_workspace_up' : '',
    '/apps/metacity/global_keybindings/switch_to_workspace_down' : '',
}

def ImportFileDialog():
    cmd = ['zenity', '--file-selection',]
    dialog = subprocess.Popen(cmd, stdout=subprocess.PIPE,)
    path = dialog.stdout.readline().rstrip()
    return path;

def ExportFileDialog():
    cmd = ['zenity', '--file-selection', '--save', '--confirm-overwrite']
    dialog = subprocess.Popen(cmd, stdout=subprocess.PIPE,)
    path = dialog.stdout.readline().rstrip()
    return path;

def Import(path):
    # load the settings dictionary from pickle
    if pyVersion == 2:
        with open(path, mode='rb') as f:
            keyLocations = json.load(f)
    if pyVersion == 3:
        with open(path, mode='r') as f:
            keyLocations = json.load(f)
    # apply the settings
    for location in keyLocations:
        cmd =['gconftool-2', '--type', 'string', '--set', location, keyLocations[location]]
        proc = subprocess.Popen(cmd)
        proc.wait()

def Export(path):
    # extract the settings from gnome-config
    if pyVersion == 2:
        for location in keyLocations:
            cmd =['gconftool-2', '--get', location]
            proc = subprocess.Popen(cmd, stdout=subprocess.PIPE, stderr=subprocess.STDOUT)
            output = proc.stdout.readline()
            keyLocations[location] = output.rstrip()
        # pickle the settings dictionary
        with open(path, mode='wb') as f:
            json.dump(keyLocations, f, indent=4)
    if pyVersion == 3:
        for location in keyLocations:
            cmd =['gconftool-2', '--get', location]
            proc = subprocess.Popen(cmd, stdout=subprocess.PIPE, stderr=subprocess.STDOUT)
            output = proc.stdout.readline()
            keyLocations[location] = bytes.decode(output).rstrip()
        # pickle the settings dictionary
        with open(path, mode='w') as f:
            json.dump(keyLocations, f, indent=4)
            

# the application entry point
if __name__ == '__main__':
    print(pyVersion)
    helpString = "Run 'gnome-keybindings --help' to see a full list of available command line options."
    # initialize default filepath

    if len(sys.argv) == 1:
        print(helpString)

    elif sys.argv[1] == '--help':
        print(__doc__)

    elif sys.argv[1] == '-i' or sys.argv[1] == '--import':
        if len(sys.argv) == 2:
            path = ImportFileDialog()
            if (pyVersion == 2 and path == None) or (pyVersion == 3 and path == b''):
                print("Import cancelled: No file selected")
                exit(1)
        elif len(sys.argv) == 3:
            path = sys.argv[2] 
        else:
            print("Error while parsing: Too many arguments")
            print(helpString)
            exit(1)
        Import(path)

    elif sys.argv[1] == '-e' or sys.argv[1] == '--export':
        if len(sys.argv) == 2:
            path = ExportFileDialog()
            if (pyVersion == 2 and path == None) or (pyVersion == 3 and path == b''):
                print("Export cancelled: No path selected")
                exit(1)            
        elif len(sys.argv) == 3:
            path = sys.argv[2]
        else:
            print("Error while parsing: Too many arguments")
            print(helpString)
            exit(1)
        Export(path)

    elif sys.argv[1] == '-v' or sys.argv[1] == '--version':
        print(__version__)
    else:
        print("Error while parsing options: Unknown option " + sys.argv[1])
        print(helpString)
        exit(1)
