cls = window.get_active_class()
if cls.find("gnome-terminal") >= 0:
    keyboard.send_keys("<ctrl>+<shift>+w")
elif cls.find("gvim") >= 0:
    keyboard.send_keys("<alt>+w")
else:
    keyboard.send_keys("<ctrl>+w")