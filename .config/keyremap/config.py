CONFIG= {
    "Mod4-Shift-bracketleft": """
self.send_keys("Control-Page_Up")
    """,
    "Mod4-Shift-bracketright": """
self.send_keys("Control-Page_Down")""",
    "Mod4-a": """
if wm_class.find("gvim") >= 0:
    self.send_keys("Control-a")
else:
    self.send_keys("Control-a")""",
    "Mod4-BackSpace": """
if wm_class.find("jetbrains") >= 0:
    self.send_keys("Control-BackSpace")""",
    "Mod4-b": """
self.send_keys("Control-b")""",
    "Mod4-c": """
if wm_class.find("gnome-terminal") >= 0:
    self.send_keys("Control-Shift-c")
elif wm_class.find("Terminator") >= 0:
    self.send_keys("Control-Shift-c")
else:
    self.send_keys("Control-c")""",
    "Mod4-delete": """
if wm_class.find("jetbrains") >= 0:
    self.send_keys("Control-Delete")""",
    "Mod4-d": """
if wm_class.find("vim") >= 0:
    self.send_keys("Mod1-d")
elif wm_class.find("google-chrome") >= 0:
    self.send_keys("Mod1-d")
elif wm_class.find("mucommander") >= 0:
    self.send_keys("Mod1-Shift-c")""",
    "Mod4-e": """
if wm_class.find("gvim") >= 0:
    self.send_keys("Mod1-e")""",
    "Mod4-F12": """
self.send_keys("Control-F12")""",
    "Mod4-F2": """
self.send_keys("Control-F2")""",
    "Mod4-f": """
self.send_keys("Control-f")""",
    "Mod4-left": """
if wm_class.find("jetbrains") >= 0:
    self.send_keys("Control-Left")""",
    "Mod4-l": """
if wm_class.find("google-chrome") >= 0:
    self.send_keys("Control-l")""",
    "Mod4-n": """
self.send_keys("Control-n")""",
    "Mod4-r": """
self.send_keys("Control-r")""",
    "Mod4-right": """
if wm_class.find("jetbrains") >= 0:
    self.send_keys("Control-Right")""",
    "Mod4-Shift-f": """
self.send_keys("Control-Shift-f")""",
    "Mod4-Shift-left": """
if wm_class.find("jetbrains") >= 0:
    self.send_keys("Mod1-Shift-Left")
else:
    self.send_keys("Control-Shift-Left")""",
    "Mod4-Shift-r": """
self.send_keys("Control-Shift-r")""",
    "Mod4-Shift-right": """
if wm_class.find("jetbrains") >= 0:
    self.send_keys("Mod1-Shift-Right")
else:
    self.send_keys("Control-Shift-Right")""",
    "Mod4-slash": """
self.send_keys("Control-slash")""",
    "Mod4-s": """
self.send_keys("Control-s")""",
    "Mod4-t": """
if wm_class.find("gnome-terminal") >= 0 or wm_class.find("terminator") >= 0:
    self.send_keys("Control-Shift-t")
elif wm_class.find("vim") >= 0:
    self.send_keys("Mod1-t")
else:
    self.send_keys("Control-t")
    """,
    "Mod4-v": """
if wm_class.find("gnome-terminal") >= 0:
    self.send_keys("Control-Shift-v")
elif wm_class.find("Terminator") >= 0:
    self.send_keys("Control-Shift-v")
else:
    self.send_keys("Control-v")""",
    "Mod4-w": """
if wm_class.find("gnome-terminal") >= 0:
    self.send_keys("Control-Shift-w")
elif wm_class.find("gvim") >= 0:
    self.send_keys("Mod1-w")
else:
    self.send_keys("Control-w")""",
    "Mod4-x": """
self.send_keys("Control-x")""",
    "Mod4-y": """
if wm_class.find("jetbrains") >= 0:
    self.send_keys("Control-Shift-z")
else:
    self.send_keys("Control-y")""",
    "Mod4-z": """
self.send_keys("Control-z")
    """,
}
