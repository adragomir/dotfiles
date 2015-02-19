from ranger.api.commands import *
import curses
import sys
import base64
import subprocess

# CUSTOM COMMANDS

class quickLook(Command):
    """:quicklook
    """

    context = 'browser'

    def execute(self):
        self.fm.execute_file(
                files = [f for f in self.fm.thistab.get_selection()],
                app = 'ql',
                flags = 'f')

class pro(Command):
    """:pro <query>
    """

    context = 'browser'

    def execute(self):
        command = ['pro', 'search', self.rest(1)]
        loc = subprocess.check_output(command)
        self.fm.cd(str(loc).rstrip())

class app(Command):
    """:app
    """

    context = 'browser'

    def execute(self):
        action = ['mv', '-f', self.fm.thisfile.path, '/Applications']
        self.fm.execute_command(action)

class trash(Command):
    """:trash [-q]
    Moves the selected files to the trash bin using Ali Rantakari's 'trash'
    program. Optionally takes the -q flag to suppress listing the files
    afterwards.
    """

    def execute(self):

        # Calls the trash program
        action = ['trash']
        action.extend(f.path for f in self.fm.thistab.get_selection())
        self.fm.execute_command(action)

        # TODO: check if the trashing was successful.

        # Echoes the basenames of the trashed files
        if not self.rest(1) == "-q":
            names = []
            names.extend(f.basename for f in self.fm.thistab.get_selection())
            self.fm.notify("Files moved to the trash: " + ', '.join(map(str, names)))

class pbcopy(Command):
    """:pbcopy <macro>
    Uses the OSX pbcopy program to copy to the clipboard.
    Macros are expanded.
    """

    context = 'browser'

    def execute(self):
        board = self.fm.substitute_macros(self.rest(1), escape=True)
        p = subprocess.Popen(['pbcopy'], stdout=subprocess.PIPE,
            stdin=subprocess.PIPE, stderr=None)
        p.communicate(input=board)

