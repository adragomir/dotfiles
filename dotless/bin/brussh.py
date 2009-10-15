#!/usr/bin/python
###########################################################
# BRUSSH - BASIC, RUDIMENTARY SSH WRAPPER, CALLED BY PUSSH
###########################################################
# This brussh.py is part of PuSSH Version 2. Please don't
# confuse it with the brussh.py from PuSSH version 1.
###########################################################
# This program is free software; you can redistribute it
# and/or modify it under the terms of the GNU General
# Public License as published by the Free Software
# Foundation; either version 2 of the License, or (at your
# option) any later version.
###########################################################
# http://pussh.sourceforge.net
###########################################################

import os
import sys
import time
import getopt
import string
import commands
import threading

################################################################################################
# Various useful functions
################################################################################################
# Function "keyboard_interrupt"
################################################################################################
def keyboard_interrupt():
    print "brussh function <<<<< Keyboard Interrupt ! >>>>>\n"
    os._exit(1)

################################################################################################
# Function "kill_this_dead" - consequences of a timeout - crude but nice, to be improved :)
################################################################################################
def kill_this_dead():
    os.system('echo \"<<<<< response timed out after %i seconds ... >>>>>\"' %  (timeout_value))
    thispid = os.getpid()
    os.system('ps wwwaux | grep %s | grep %s | grep -e StrictHostKeyChecking -e nc | grep -v grep | awk \'{ print $2 }\' | xargs kill -9' % (machine, login))
    os.kill(thispid,9)
    os._exit(1)

################################################################################################
# Function "is_it_listening"
################################################################################################

def is_it_listening():
    nc_cmd = 'echo QUIT | netcat -zvw' + ' ' + t + ' ' + machine + ' ' + portno
    print nc_cmd
    v1,v2 = commands.getstatusoutput(nc_cmd)
    timeout = v2.count("Connection timed out")
    unknown = v2.count("Unknown host")
    if v1 == 0: 
        status = 0
        return status
    elif v1 == 256 and timeout == 1: 
        status = 1
        return status
    elif v1 == 256 and unknown == 1: 
        status = 2
        return status

################################################################################################
# Function "the_command" - this is where the action really is ...
################################################################################################
def the_command():
    sshcmd = 'ssh ' + ssh_options + ' -p ' + port + ' -l ' + login + ' ' + machine + ' ' + payload 
    result = os.system(sshcmd)
    if result == 65024: os.system('echo \"X === Failed: STATUS=254 === X\"')

################################################################################################
# MAIN PROGRAM STARTS HERE !
################################################################################################
# Initializing some variables
################################################################################################

login = os.environ['LOGNAME']
port = "22"
timeout_value = 3 
t = str(timeout_value)
parallel = 1
ssh_options = "-1 -2 -x -T -o StrictHostKeyChecking=no -o Batchmode=yes"

################################################################################################
# Command line options and arguments pre-amble:
################################################################################################
try: 
    options, arguments = getopt.getopt(sys.argv[1:],'P:l:t:rsh')
    # print "options are", options
    # print "arguments are", arguments
except getopt.error:
    print "brussh: options error"
    sys.exit(2)

for opt in options:
    if opt[0] == '-t':
        var = opt[1]
        if int(var) < 301 and int(var) > 0: 
			timeout_value = int(var)
			t = str(var)
        else:
            print "Invalid timeout value - timeout must be greater than or equal to 1 second, and less than or equal to 300 seconds. Try brussh -h <ENTER> to learn more."
            sys.exit(1)
   
    if opt[0] == '-s': 
        parallel = 0
        ssh_options = "-1 -2 -x -T -o StrictHostKeyChecking=no"
 
    if opt[0] == '-r': login = "root"      # login is now officially "root", the superuser
  
    if opt[0] == '-h': 
        print "duh"
        sys.exit(1)

    if opt[0] == '-l': login = opt[1]      # login is now officially declared 

    if opt[0] == '-P': port = opt[1]       # port is now officially declared   
    
if len(arguments)<2: 
    print "BRUSSH.PY(001): ... not enough command(s) to send to the target host ..."
    os._exit(1)
else: pass

pid = os.getpid ()
machine = arguments[0]
payload = '\"' + string.join(arguments[1:]) + '\"'
# listening_status = is_it_listening()

timeout = str(timeout_value)
portno = str(port)

ssh_listening_status = is_it_listening()

# os.system('echo status is %s' % ssh_listening_status) 

### set up the timer

timer = threading.Timer(timeout_value, kill_this_dead)

### fire up the timer
timer.start()

### can the machine be contacted ? if so, send the command 1st class airmail

if ssh_listening_status == 0:
    the_command()
    os._exit(0)
elif ssh_listening_status == 1:
    os.system('echo X === Host is there, but no response on port %s === X' % port) 
    os._exit(1) 
elif ssh_listening_status == 2:
    os.system('echo X === Host is Unreachable. === X')
    os._exit(2)
else: 
    os.system('echo X === Unexpected error: your target may be a file, but not set up validly. === X') 
    os._exit(1)
