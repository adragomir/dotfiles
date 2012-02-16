cls = window.get_active_class()
if cls.find("gvim") >= 0:
    keyboard.send_keys("<ctrl>+a")
else:
    keyboard.send_keys("<ctrl>+a")