cls = window.get_active_class()
if cls.find("jetbrains") >= 0:
    keyboard.send_keys("<ctrl>+<shift>+z")
else:
    keyboard.send_keys("<ctrl>+y")