# if not running interactively, don't do anything
[ -z "$PS1" ] && return

if [ -f ~/.bashrc ]; then
   source ~/.bashrc
fi

