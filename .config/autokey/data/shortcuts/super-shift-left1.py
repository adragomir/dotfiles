cls = window.get_active_class()
if cls.find("jetbrains") >= 0:
    keyboard.send_keys("<alt>+<shift>+<left>")
else:
    keyboard.send_keys("<ctrl>+<shift>+<left>")