import re
from typing import Any, Dict

from kitty.boss import Boss
from kitty.window import Window

def on_set_user_var(boss: Boss, window: Window, data: Dict[str, Any]) -> None:
    tmp = window.title
    for k, v in data.items():
        if k == "AWS_PROFILE":
            tmp = re.sub(r'AWS_PROFILE=.*$', "", tmp)
            window.set_title(window.title.replace + f" AWS_PROFILE={v}")
