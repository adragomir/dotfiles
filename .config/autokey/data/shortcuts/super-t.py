cls = window.get_active_class()
if cls.find("gnome-terminal") >= 0 or cls.find("terminator") >= 0:
    keyboard.send_keys("<ctrl>+<shift>+t")
elif cls.find("gvim") >= 0:
    keyboard.send_keys("<alt>+t")
else:
    keyboard.send_keys("<ctrl>+t")
