cls = window.get_active_class()
if cls.find("gnome-terminal") >= 0:
    keyboard.send_keys("<ctrl>+<shift>+c")
elif cls.find("Terminator") >= 0:
    keyboard.send_keys("<ctrl>+<shift>+c")
else:
    keyboard.send_keys("<ctrl>+c")