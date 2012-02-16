cls = window.get_active_class()
if cls.find("vim") >= 0:
    keyboard.send_keys("<alt>+d")
elif cls.find("google-chrome") >= 0:
    keyboard.send_keys("<alt>+d")
elif cls.find("mucommander") >= 0:
    keyboard.send_keys("<alt>+<shift>+c")