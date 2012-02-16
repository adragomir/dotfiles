cls = window.get_active_class()
if cls.find("google-chrome") >= 0:
    keyboard.send_keys("<ctrl>+l")