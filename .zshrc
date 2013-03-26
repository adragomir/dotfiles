export ZSH=$HOME/.zsh

export OS=`uname | tr "[:upper:]" "[:lower:]"`

# Set to this to use case-sensitive completion
export CASE_SENSITIVE="true"

# add a function path
fpath=($ZSH/functions $fpath)
fpath=(/usr/local/share/zsh-completions $fpath)

# {{{ alias
# Push and pop directories on directory stack
alias pu='pushd'
alias po='popd'

# Basic directory operations
alias ...='cd ../..'
alias -- -='cd -'

# Super user
alias _='sudo'

#alias g='grep -in'

# Show history
alias history='fc -l 1'

# List direcory contents
alias lsa='ls -lah'
alias l='ls -la'
alias ll='ls -l'
alias sl=ls # often screw this up

alias afind='ack-grep -il'
alias dtrace-providers="sudo dtrace -l | perl -pe 's/^.*?\S+\s+(\S+?)([0-9]|\s).*/\1/' | sort | uniq"
alias tail_java_complete="tail -f $HOME/javacomplete.txt $HOME/dotfiles/.vim/bundle/javacomplete/java/javacomplete_java.log"
alias gitg="/usr/local/bin/gitg >/dev/null 2>&1 &"
alias jps="jps -l | grep -vE \"^[0-9]*\s+$\" | grep -v \"sun.tools.jps\" | sort -k 2,2"
# }}}

autoload -U edit-command-line
zle -N edit-command-line
bindkey '\C-x\C-e' edit-command-line

_completeme() {
  zle -I
  completeme
  echo $tmp
}
bindkey "\C-t" _completeme
zle -N _completeme

# {{{
# ls colors
autoload colors; colors;
export LSCOLORS="Gxfxcxdxbxegedabagacad"
export LS_COLORS="*.tar.bz2=38;5;226:*.tar.xz=38;5;130:*PKGBUILD=48;5;233;38;5;160:*.html=38;5;213:*.htm=38;5;213:*.vim=38;5;142:*.css=38;5;209:*.screenrc=38;5;120:*.procmailrc=38;5;120:*.zshrc=38;5;120:*.bashrc=38;5;120:*.xinitrc=38;5;120:*.vimrc=38;5;120:*.htoprc=38;5;120:*.muttrc=38;5;120:*.gtkrc-2.0=38;5;120:*.fehrc=38;5;120:*.rc=38;5;120:*.md=38;5;130:*.markdown=38;5;130:*.conf=38;5;148:*.h=38;5;81:*.rb=38;5;192:*.c=38;5;110:*.diff=38;5;31:*.yml=38;5;208:*.pl=38;5;178:*.csv=38;5;136:tw=38;5;003:*.chm=38;5;144:*.bin=38;5;249:*.pdf=38;5;203:*.mpg=38;5;38:*.ts=38;5;39:*.sfv=38;5;191:*.m3u=38;5;172:*.txt=38;5;192:*.log=38;5;190:*.swp=38;5;241:*.swo=38;5;240:*.theme=38;5;109:*.zsh=38;5;173:*.nfo=38;5;113:mi=38;5;124:or=38;5;160:ex=38;5;197:ln=target:pi=38;5;130:ow=38;5;208:fi=38;5;007:so=38;5;167:di=38;5;30:*.pm=38;5;197:*.pl=38;5;166:*.sh=38;5;243:*.patch=38;5;37:*.tar=38;5;118:*.tar.gz=38;5;172:*.zip=38;5;11::*.rar=38;5;11:*.tgz=38;5;11:*.7z=38;5;11:*.mp3=38;5;173:*.flac=38;5;166:*.mkv=38;5;115:*.avi=38;5;114:*.wmv=38;5;113:*.jpg=38;5;66:*.jpeg=38;5;67:*.png=38;5;68:*.pacnew=38;5;33"

#export LS_COLORS

# Enable ls colors
if [ "$DISABLE_LS_COLORS" != "true" ]
then
  # Find the option for using colors in ls, depending on the version: Linux or BSD
  ls --color -d . &>/dev/null 2>&1 && alias ls='ls --color=tty' || alias ls='ls -G'
fi

setopt no_beep
setopt auto_cd
setopt multios
setopt cdablevarS
setopt ignoreeof

if [[ x$WINDOW != x ]]
then
    SCREEN_NO="%B$WINDOW%b "
else
    SCREEN_NO=""
fi

# Apply theming defaults
PS1="%n@%m:%~%# "

# git theming default: Variables for theming the git info prompt
ZSH_THEME_GIT_PROMPT_PREFIX="git:("         # Prefix at the very beginning of the prompt, before the branch name
ZSH_THEME_GIT_PROMPT_SUFFIX=")"             # At the very end of the prompt
ZSH_THEME_GIT_PROMPT_DIRTY="*"              # Text to display if the branch is dirty
ZSH_THEME_GIT_PROMPT_CLEAN=""               # Text to display if the branch is clean

# Setup the prompt with pretty colors
setopt prompt_subst
setopt transient_rprompt

# Load the theme
PROMPT=$'%{$fg_bold[yellow]%}[<%n@%{$fg_bold[green]%}%m%{$fg_bold[yellow]%}>]%{$reset_color%}%{$fg[white]%}[$fg_bold[yellow]${PWD/#$HOME/~}]%{$reset_color%}$(git_prompt_info)\
%{$fg_bold[yellow]%}$ %{$reset_color%}'

PROMPT2=$'%{$fg_bold[yellow]%}[<%n@%{$fg_bold[green]%}%m%{$fg_bold[yellow]%}>]%{$reset_color%}%{$fg[white]%}[$fg_bold[yellow]${PWD/#$HOME/~}]%{$reset_color%}$(git_prompt_info)\
%{$fg_bold[yellow]%}%_$ %{$reset_color%}'


ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg[green]%}["
ZSH_THEME_GIT_PROMPT_SUFFIX="]%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_DIRTY=" %{$fg[red]%}*%{$fg[green]%}"
ZSH_THEME_GIT_PROMPT_CLEAN=""

function battery_charge {
    echo `$HOME/bin/battery_charge` 2>/dev/null
}

setopt prompt_subst	# Enables additional prompt extentions
autoload -U colors && colors	# Enables colours

RPROMPT='[%(0?,,<%?> )][%F{cyan}%D{%e.%b.%y %H:%M:%S}%F{white}]'

# }}}

# {{{
# fixme - the load process here seems a bit bizarre

unsetopt menu_complete   # do not autoselect the first completion entry
unsetopt flowcontrol
setopt auto_menu         # show completion menu on succesive tab press
setopt complete_in_word
setopt always_to_end
setopt c_bases
setopt extended_glob
setopt no_match
setopt print_eight_bit
setopt no_correct
setopt complete_in_word
setopt list_packed # Compact completion lists
setopt list_types # Show types in completion
setopt rec_exact # Recognize exact, ambiguous matches
setopt short_loops

WORDCHARS=''
WORDCHARS=${WORDCHARS//[&=\/;\!#?[]~&;!$%^<>%\{]}

autoload -U compinit
compinit -i

zmodload -i zsh/complist

## case-insensitive (all),partial-word and then substring completion
if [ "x$CASE_SENSITIVE" = "xtrue" ]; then
  zstyle ':completion:*' matcher-list 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'
  unset CASE_SENSITIVE
else
  zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'
fi

zstyle ':completion:*' list-colors ''
zstyle ':completion:*' squeeze-slashes true

# should this be in keybindings?
bindkey -M menuselect '^o' accept-and-infer-next-history
zle -C complete-menu menu-select _generic
_complete_menu() {
  setopt localoptions alwayslastprompt
  zle complete-menu
}
zle -N _complete_menu
bindkey '^F' _complete_menu
bindkey -M menuselect '^F' accept-and-infer-next-history
bindkey -M menuselect '/'  accept-and-infer-next-history
bindkey -M menuselect '^?' undo
bindkey -M menuselect ' ' accept-and-hold
bindkey -M menuselect '*' history-incremental-search-forward

zstyle ':completion:*:*:*:*:*' menu select
zstyle ':completion:*' squeeze-slashes true
zstyle ':completion:*' select-prompt '%SScrolling active: current selection at %p%s'
zstyle ':completion:*:*:*:*:processes' command "ps -u `whoami` -o pid,user,comm -w -w"
zstyle ':completion:*:*:*:*:processes*'    force-list always
zstyle ':completion:*:*:kill:*' menu yes select
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#) ([0-9a-z-]#)*=01;34=0=01'
zstyle ':completion:*:*:kill:*:processes'  sort false
zstyle ':completion:*:*:kill:*:processes'  command 'ps -u "$USER"'
zstyle ':completion:*:*:killall:*:processes' command 'ps --forest -A -o pid,user,cmd'
zstyle ':completion:*:processes-names'     command "ps axho cmd= | sed 's:\([^ ]*\).*:\1:;s:\(/[^ ]*/\)::;/^\[/d'"
zstyle ':completion:*:processes' command 'ps -au$USER -o pid,time,cmd|grep -v "ps -au$USER -o pid,time,cmd"'
zstyle ':completion:*:matches' group yes
zstyle ':completion:*:options' description yes
zstyle ':completion:*:options' auto-description '%d'
zstyle ':completion:*:descriptions' format $'\e[01;33m-- %d --\e[0m'
zstyle ':completion:*:messages' format $'\e[01;35m-- %d --\e[0m'
zstyle ':completion:*:warnings' format $'\e[01;31m-- no matches found --\e[0m'
zstyle ':completion:*:manuals' separate-sections true
zstyle ':completion:*:manuals.*' insert-sections   true
zstyle ':completion:*:man:*' menu yes select
zstyle ':completion:*:rm:*' ignore-line yes
zstyle ':completion:*:cp:*' ignore-line yes
zstyle ':completion:*:mv:*' ignore-line yes

compdef _gnu_generic slrnpull make df du mv cp makepkg


# disable named-directories autocompletion
zstyle ':completion:*:cd:*' tag-order local-directories directory-stack path-directories
cdpath=(.)

# use /etc/hosts and known_hosts for hostname completion
[ -r ~/.ssh/known_hosts ] && _ssh_hosts=(${${${${(f)"$(<$HOME/.ssh/known_hosts)"}:#[\|]*}%%\ *}%%,*}) || _ssh_hosts=()
[ -r /etc/hosts ] && : ${(A)_etc_hosts:=${(s: :)${(ps:\t:)${${(f)~~"$(</etc/hosts)"}%%\#*}##[:blank:]#[^[:blank:]]#}}} || _etc_hosts=()
hosts=(
  "$_ssh_hosts[@]"
  "$_etc_hosts[@]"
  `hostname`
  localhost
)
zstyle ':completion:*:hosts' hosts $hosts

# Use caching so that commands like apt and dpkg complete are useable
zstyle ':completion::complete:*' use-cache 1
zstyle ':completion::complete:*' cache-path ~/.zsh/cache/

# Don't complete uninteresting users
zstyle ':completion:*:*:*:users' ignored-patterns \
        adm amanda apache avahi beaglidx bin cacti canna clamav daemon \
        dbus distcache dovecot fax ftp games gdm gkrellmd gopher \
        hacluster haldaemon halt hsqldb ident junkbust ldap lp mail \
        mailman mailnull mldonkey mysql nagios \
        named netdump news nfsnobody nobody nscd ntp nut nx openvpn \
        operator pcap postfix postgres privoxy pulse pvm quagga radvd \
        rpc rpcuser rpm shutdown squid sshd sync uucp vcsa xfs

# ... unless we really want to.
zstyle '*' single-ignored show

# }}}


# {{{
#setopt correct_all

#alias man='nocorrect man'
#alias mv='nocorrect mv'
#alias mysql='nocorrect mysql'
#alias mkdir='nocorrect mkdir'
#alias gist='nocorrect gist'
#alias heroku='nocorrect heroku'
#alias ebuild='nocorrect ebuild'
#alias hpodder='nocorrect hpodder'
# }}}

# {{{ filename completion
# Force file name completion on C-x TAB, Shift-TAB.
zle -C complete-files complete-word _generic
zstyle ':completion:complete-files:*' completer _files
bindkey "^Q" complete-files
bindkey "^[[Z" complete-files

# Force menu on C-x RET.
zle -C complete-first complete-word _generic
zstyle ':completion:complete-first:*' menu yes
bindkey "^W" complete-first
# }}}

# {{{
# Changing/making/removing directory
setopt auto_name_dirs
setopt auto_pushd
setopt pushd_ignore_dups

alias ..='cd ..'
alias cd..='cd ..'
alias cd...='cd ../..'
alias cd....='cd ../../..'
alias cd.....='cd ../../../..'
alias cd/='cd /'

alias 1='cd -'
alias 2='cd +2'
alias 3='cd +3'
alias 4='cd +4'
alias 5='cd +5'
alias 6='cd +6'
alias 7='cd +7'
alias 8='cd +8'
alias 9='cd +9'

cd () {
  if   [[ "x$*" == "x..." ]]; then
    cd ../..
  elif [[ "x$*" == "x...." ]]; then
    cd ../../..
  elif [[ "x$*" == "x....." ]]; then
    cd ../../..
  elif [[ "x$*" == "x......" ]]; then
    cd ../../../..
  else
    builtin cd "$@"
  fi
}

alias md='mkdir -p'
alias rd=rmdir

alias d='dirs -v'

# }}}

# {{{
## fixme, i duplicated this in xterms - oops
function title {
  if [[ $TERM == "screen" ]]; then
    # Use these two for GNU Screen:
    print -nR $'\033k'$1$'\033'\\\

    print -nR $'\033]0;'$2$'\a'
  elif [[ ($TERM =~ "^xterm") ]] || [[ ($TERM == "rxvt") ]]; then
    # Use this one instead for XTerms:
    print -nR $'\033]0;'$*$'\a'
  fi
}

function _backward_kill_default_word() {
  WORDCHARS='*?_-.[]~=/&;!#$%^(){}<>' zle backward-kill-word
}
zle -N backward-kill-default-word _backward_kill_default_word
bindkey '\e=' backward-kill-default-word   # = is next to backspace

function precmd {
  #title zsh "$PWD"
}

function preexec {
  emulate -L zsh
  local -a cmd; cmd=(${(z)1})
  #title $cmd[1]:t "$cmd[2,-1]"
}

zman() {
  PAGER="less -g -s '+/^       "$1"'" man zshall
}

function zsh_stats() {
  history | awk '{print $2}' | sort | uniq -c | sort -rn | head
}

function uninstall_oh_my_zsh() {
  /bin/sh $ZSH/tools/uninstall.sh
}

function upgrade_oh_my_zsh() {
  /bin/sh $ZSH/tools/upgrade.sh
}

function take() {
  mkdir -p $1
  cd $1
}

function allopen() {
  if [ "`uname`" = "Darwin" ]; then
    open $1
  else
    gnome-open > /dev/null 2>&1 $*
  fi
}

function addsshkey() {
  if [ -z $2 ];then
    echo "Usage: $0 /path/to/key username@host"
    exit 1
  fi

  KEY=$1
  shift

  if [ ! -f $KEY ];then
    echo "private key not found at $KEY"
    echo "please create it with \"ssh-keygen -t dsa\""
    exit
  fi

  echo "Putting your key ($KEY) on $1... "
  ssh -q $* "umask 0077; mkdir -p ~/.ssh ; echo "`cat $KEY`" >> ~/.ssh/authorized_keys"
  echo "done!"
}

function eclipse_project() {
  from=$1
  to=$2

  to_move=( .settings .externalToolBuilders .eclipse.templates .launches .classpath .project )
  to_move_type=( d d d d f f )
  for idx in $(seq 0 $((${#to_move[@]} - 1))); do
    t=${to_move[$idx]}
    tf=${to_move_type[$idx]}
    echo "Moving $t..."

    for d in `find $from \( -iname "$t" -a -type $tf \)`; do
      df=$(dirname $d)
      fc=${df#$from/}
      mkdir -p $to/$fc/
      echo mv $d $to/$fc/
      mv $d $to/$fc/
    done
    
  done
}

function gcc_defines() {
  gcc -dM -E - < /dev/null
}

function getwanip() {
  wget -q -O- www.showmyip.com/xml | xml2 | grep '/ip_address/ip=' | cut -d= -f2
  curl -s http://checkip.dyndns.org | awk '{print $6}' | awk ' BEGIN { FS = "<" } { print $1 } '
}

function gitroot() {
  gitroot=`git rev-parse --show-cdup 2>/dev/null`
  retval="$?"
  if [ "$retval" == "0" ]; then
    # There is a git root
    if [ -z "$gitroot" ]; then
      # It's the current dir.
      pwd
    else
      readlink -f "$gitroot"
    fi
  else
    # No gitroot. Return status 1.
    exit 1
  fi
}

function iphone_transcode() {
  INFILE="$1"
  OUTFILE="$2"
  ffmpeg -i "$INFILE" -strict experimental -f mp4 -vcodec mpeg4 -acodec aac  -maxrate 1000 -b 700 -qmin 3 -qmax 5 -bufsize 4096 -g 300 -ab 65535 -s 480x320 -aspect 4:3 "$OUTFILE"
}

function javap_method() {
  class=${1%#*}
  method=${1#*\#}

  javap -classpath `cat .run-classpath` -c $class | sed -n -e "/$method(/,/^$/p"
}

# By @ieure; copied from https://gist.github.com/1474072
#
# It finds a file, looking up through parent directories until it finds one.
# Use it like this:
#
#   $ ls .tmux.conf
#   ls: .tmux.conf: No such file or directory
#
#   $ ls `up .tmux.conf`
#   /Users/grb/.tmux.conf
#
#   $ cat `up .tmux.conf`
#   set -g default-terminal "screen-256color"
#
function up() {
    if [ "$1" != "" -a "$2" != "" ]; then
        local DIR=$1
        local TARGET=$2
    elif [ "$1" ]; then
        local DIR=$PWD
        local TARGET=$1
    fi
    while [ ! -e $DIR/$TARGET -a $DIR != "/" ]; do
        DIR=$(dirname $DIR)
    done
    test $DIR != "/" && echo $DIR/$TARGET
}


# }}}

# {{{
# get the name of the branch we are on
function git_prompt_info() {
  ref=$(git symbolic-ref HEAD 2> /dev/null) || return
  echo "$ZSH_THEME_GIT_PROMPT_PREFIX${ref#refs/heads/}$(parse_git_dirty)$ZSH_THEME_GIT_PROMPT_SUFFIX"
}

parse_git_dirty () {
  if [[ -n $(git status -s 2> /dev/null) ]]; then
    echo "$ZSH_THEME_GIT_PROMPT_DIRTY"
  else
    echo "$ZSH_THEME_GIT_PROMPT_CLEAN"
  fi
}

function tree() {
  find . | sed -e 's/[^\/]*\//|--/g' -e 's/-- |/    |/g' | $PAGER
}


# get the status of the working tree
git_prompt_status() {
  INDEX=$(git status --porcelain 2> /dev/null)
  STATUS=""
  if $(echo "$INDEX" | grep '^?? ' &> /dev/null); then
    STATUS="$ZSH_THEME_GIT_PROMPT_UNTRACKED$STATUS"
  fi
  if $(echo "$INDEX" | grep '^A  ' &> /dev/null); then
    STATUS="$ZSH_THEME_GIT_PROMPT_ADDED$STATUS"
  elif $(echo "$INDEX" | grep '^M  ' &> /dev/null); then
    STATUS="$ZSH_THEME_GIT_PROMPT_ADDED$STATUS"
  fi
  if $(echo "$INDEX" | grep '^ M ' &> /dev/null); then
    STATUS="$ZSH_THEME_GIT_PROMPT_MODIFIED$STATUS"
  fi
  if $(echo "$INDEX" | grep '^R  ' &> /dev/null); then
    STATUS="$ZSH_THEME_GIT_PROMPT_RENAMED$STATUS"
  fi
  if $(echo "$INDEX" | grep '^ D ' &> /dev/null); then
    STATUS="$ZSH_THEME_GIT_PROMPT_DELETED$STATUS"
  fi
  if $(echo "$INDEX" | grep '^UU ' &> /dev/null); then
    STATUS="$ZSH_THEME_GIT_PROMPT_UNMERGED$STATUS"
  fi
  echo $STATUS
}

# }}}

#
# Color grep results
# Examples: http://rubyurl.com/ZXv
#
export GREP_OPTIONS='--color=auto'
export GREP_COLOR='1;32'
export GREP_COLORS="38;5;230:sl=38;5;240:cs=38;5;100:mt=38;5;161:fn=38;5;197:ln=38;5;212:bn=38;5;44:se=38;5;166"

# {{{
## Command history configuration
HISTFILE=$HOME/.zsh_history
HISTSIZE=10000
SAVEHIST=10000

setopt hist_find_no_dups # ignore duplication command history list
setopt hist_ignore_all_dups # ignore duplication command history list
setopt share_history # share command history data

setopt hist_verify
setopt inc_append_history
setopt extended_history
setopt hist_expire_dups_first
setopt hist_ignore_space

setopt SHARE_HISTORY
setopt APPEND_HISTORY

# }}}

# {{{
# TODO: Explain what some of this does..
autoload -U compinit
compinit -i
autoload -Uz narrow-to-region
function _history-incremental-preserving-pattern-search-backward
{
  local state
  MARK=CURSOR  # magick, else multiple ^R don't work
  narrow-to-region -p "$LBUFFER${BUFFER:+>>}" -P "${BUFFER:+<<}$RBUFFER" -S state
  zle end-of-history
  zle history-incremental-pattern-search-backward
  narrow-to-region -R state
}
zle -N _history-incremental-preserving-pattern-search-backward

bindkey -e
bindkey '\ew' kill-region
bindkey "^r" _history-incremental-preserving-pattern-search-backward
bindkey -M isearch "^r" history-incremental-pattern-search-backward
#bindkey '^r' history-incremental-pattern-search-backward
bindkey "^s" history-incremental-pattern-search-forward
bindkey "^[[5~" up-line-or-history
bindkey "^[[6~" down-line-or-history

# make search up and down work, so partially type and hit up/down to find relevant stuff
bindkey '^[[A' up-line-or-search
bindkey '^[[B' down-line-or-search

bindkey "^[[7~" beginning-of-line # Home
bindkey "^[[8~" end-of-line # End

bindkey "^[[H" beginning-of-line
bindkey "^[[1~" beginning-of-line
bindkey "^[[F"  end-of-line
bindkey "^[[4~" end-of-line
bindkey ' ' magic-space    # also do history expansion on space

bindkey '^[[Z' reverse-menu-complete

bindkey "\e[1;3D" backward-word
bindkey "\e[1;3C" forward-word
bindkey "\e3D" backward-word
bindkey "\e3C" forward-word

bindkey '^[5D' backward-word
bindkey '^[5C' forward-word

bindkey '^[[5D' backward-word
bindkey '^[[5C' forward-word

bindkey '^[[3~' delete-char
# Move to where the arguments belong.
after-first-word() {
  zle beginning-of-line
  zle forward-word
}
zle -N after-first-word
bindkey "^X1" after-first-word
foreground-vi() {
  fg %vi
}
zle -N foreground-vi
bindkey '^Z' foreground-vi
# }}}

# {{{
## smart urls
autoload -U url-quote-magic
zle -N self-insert url-quote-magic
zstyle -e :urlglobber url-other-schema '[[ $words[1] == scp ]] && reply=("*") || reply=(http https ftp)'

## file rename magick
bindkey "^[m" copy-prev-shell-word

## jobs
setopt long_list_jobs

## pager
export PAGER=less

# }}}

# {{{
#! /bin/zsh
# A script to make using 256 colors in zsh less painful.
# P.C. Shyamshankar <sykora@lucentbeing.com>
# Copied from http://github.com/sykora/etc/blob/master/zsh/functions/spectrum/

typeset -Ag FX FG BG

FX=(
    reset     "%{[00m%}"
    bold      "%{[01m%}" no-bold      "%{[22m%}"
    italic    "%{[03m%}" no-italic    "%{[23m%}"
    underline "%{[04m%}" no-underline "%{[24m%}"
    blink     "%{[05m%}" no-blink     "%{[25m%}"
    reverse   "%{[07m%}" no-reverse   "%{[27m%}"
)

for color in {000..255}; do
    FG[$color]="%{[38;5;${color}m%}"
    BG[$color]="%{[48;5;${color}m%}"
done

# }}}

# {{{
case "$TERM" in
  xterm*|rxvt*)
    preexec () {
      #print -Pn "\e]0;%n@%m: $1\a"  # xterm
    }
    precmd () {
      #print -Pn "\e]0;%n@%m: %~\a"  # xterm
    }
    ;;
  screen*)
    preexec () {
      local CMD=${1[(wr)^(*=*|sudo|ssh|-*)]}
      #echo -ne "\ek$CMD\e\\"
      #print -Pn "\e]0;%n@%m: $1\a"  # xterm
    }
    precmd () {
      #echo -ne "\ekzsh\e\\"
      #print -Pn "\e]0;%n@%m: %~\a"  # xterm
    }
    ;;
esac

# }}}

# {{{

# Color grep results
# Examples: http://rubyurl.com/ZXv
#
export GREP_OPTIONS='--color=auto'
export GREP_COLOR='1;32'
 
# }}}

# {{{
## Command history configuration
HISTFILE=$HOME/.zsh_history
HISTSIZE=10000
SAVEHIST=10000

setopt hist_find_no_dups # ignore duplication command history list
setopt hist_ignore_all_dups # ignore duplication command history list
setopt share_history # share command history data

setopt hist_verify
setopt inc_append_history
setopt extended_history
setopt hist_expire_dups_first
setopt hist_ignore_space

setopt SHARE_HISTORY
setopt APPEND_HISTORY

# }}}

#{{{
# Aliases
alias g='git'
alias gst='git status'
alias gl='git pull'
alias gup='git fetch && git rebase'
alias gp='git push'
alias gd='git diff | mate'
alias gdv='git diff -w "$@" | vim -R -'
alias gc='git commit -v'
alias gca='git commit -v -a'
alias gb='git branch'
alias gba='git branch -a'
alias gcount='git shortlog -sn'
alias gcp='git cherry-pick'
alias glg='git log --stat --max-count=5'

# Git and svn mix
alias git-svn-dcommit-push='git svn dcommit && git push github master:svntrunk'

#
# Will return the current branch name
# Usage example: git pull origin $(current_branch)
#
function current_branch() {
  ref=$(git symbolic-ref HEAD 2> /dev/null) || return
  echo ${ref#refs/heads/}
}

# these aliases take advangate of the previous function
alias ggpull='git pull origin $(current_branch)'
alias ggpush='git push origin $(current_branch)'
alias ggpnp='git pull origin $(current_branch) && git push origin $(current_branch)'

#}}}


fpath=($HOME/.zsh/ $fpath)
autoload -Uz compinit
compinit -i

# functions {{{

function cl() { cd "$@" && l; }
function cs () {
  cd "$@"
  if [ -n "$(git status 2>/dev/null)" ]; then
    echo "$(git status 2>/dev/null)"
  fi
}
function mkd() {
  mkdir -p "$*" && cd "$*" && pwd
}

function gco {
  if [ -z "$1" ]; then
    git checkout master
  else
    git checkout $1
  fi
}

# autojump
j() {
  # change jfile if you already have a .j file for something else
  local jfile=$HOME/.j
  if [ "$1" = "--add" ]; then
    shift
    # we're in $HOME all the time, let something else get all the good letters
    [ "$*" = "$HOME" ] && return
    awk -v q="$*" -F"|" '
    $2 >= 1 { 
      if( $1 == q ) { l[$1] = $2 + 1; found = 1 } else l[$1] = $2
      count += $2
    }
    END {
      found || l[q] = 1
      if( count > 1000 ) {
        for( i in l ) print i "|" 0.9*l[i] # aging
      } else for( i in l ) print i "|" l[i]
    }
    ' $jfile 2>/dev/null > $jfile.tmp
    mv -f $jfile.tmp $jfile
  elif [ "$1" = "" -o "$1" = "--l" ];then
    shift
    awk -v q="$*" -F"|" '
      BEGIN { split(q,a," ") }
      { for( i in a ) $1 !~ a[i] && $1 = ""; if( $1 ) print $2 "\t" $1 }
    ' $jfile 2>/dev/null | sort -n
    # for completion
  elif [ "$1" = "--complete" ];then
    awk -v q="$2" -F"|" '
      BEGIN { split(substr(q,3),a," ") }
      { for( i in a ) $1 !~ a[i] && $1 = ""; if( $1 ) print $1 }
    ' $jfile 2>/dev/null
    # if we hit enter on a completion just go there (ugh, this is ugly)
  elif [[ "$*" =~ "/" ]]; then
    local x=$*; x=/${x#*/}; [ -d "$x" ] && cd "$x"
  else
    # prefer case sensitive
    local cd=$(awk -v q="$*" -F"|" '
      BEGIN { split(q,a," ") }
      { for( i in a ) $1 !~ a[i] && $1 = ""; if( $1 ) { print $2 "\t" $1; x = 1 } }
      END {
        if( x ) exit
        close(FILENAME)
        while( getline < FILENAME ) {
          for( i in a ) tolower($1) !~ tolower(a[i]) && $1 = ""
          if( $1 ) print $2 "\t" $1
        }
    }
    ' $jfile 2>/dev/null | sort -nr | head -n 1 | cut -f 2)
    [ "$cd" ] && cd "$cd"
  fi
}

extract () {
  if [ -f $1 ] ; then
    case $1 in
      *.tar.bz2) tar xvjf $1 ;;
      *.tar.gz) tar xvzf $1 ;;
      *.bz2) bunzip2 $1 ;;
      *.rar) rar x $1 ;;
      *.gz) gunzip $1 ;;
      *.tar) tar xvf $1 ;;
      *.tbz2) tar xvjf $1 ;;
      *.tgz) tar xvzf $1 ;;
      *.zip) unzip $1 ;;
      *.Z) uncompress $1 ;;
      *.7z) 7z x $1 ;;
      *) echo "don't know how to extract '$1'..." ;;
    esac
  else
    echo "'$1' is not a valid file!"
  fi
}

# hack & ship
function current_git_branch {
  git branch 2> /dev/null | grep '\*' | awk '{print $2}'
}

hack()
{
  CURRENT=$(current_git_branch)
  git checkout master
  git pull origin master
  git checkout ${CURRENT}
  git rebase master
  unset CURRENT
}
 
ship()
{
  CURRENT=$(current_git_branch)
  git checkout master
  git merge ${CURRENT}
  git push origin master
  git checkout ${CURRENT}
  unset CURRENT
}

git-pull-rebase () {
  git fetch origin
  git rebase -p origin/master
}

function pswhich {
  for i in $*; do
    grepstr=[${i[1,2]}]${i[2,${#i}]}
    tmp=`ps axwww | grep $grepstr | awk '{print $1}'`
    echo "${i}: ${tmp/\\n/,}"
  done
}

function cdgem {
  cd /opt/local/lib/ruby/gems/1.8/gems/; cd `ls|grep $1|sort|tail -1`
}

function cdpython {
  cd /Library/Frameworks/Python.framework/Versions/2.4/lib/python2.4/site-packages/;
}

function mycd {

    MYCD=/tmp/mycd.txt
    touch ${MYCD}

    typeset -i x
    typeset -i ITEM_NO
    typeset -i i
    x=0

    if [[ -n "${1}" ]]; then
       if [[ -d "${1}" ]]; then
          print "${1}" >> ${MYCD}
          sort -u ${MYCD} > ${MYCD}.tmp
          mv ${MYCD}.tmp ${MYCD}
          FOLDER=${1}
       else
          i=${1}
          FOLDER=$(sed -n "${i}p" ${MYCD})
       fi
    fi

    if [[ -z "${1}" ]]; then
       print ""
       cat ${MYCD} | while read f; do
          x=$(expr ${x} + 1)
          print "${x}. ${f}"
       done
       print "\nSelect #"
       read ITEM_NO
       FOLDER=$(sed -n "${ITEM_NO}p" ${MYCD})
    fi

    if [[ -d "${FOLDER}" ]]; then
       cd ${FOLDER}
    fi
}

# mkdir, cd into it
mkcd () {
  mkdir -p "$*"
  cd "$*"
}

function urlopen() {
  open "http://$*"
}

calc () { echo "$*" | bc -l; }

# }}}

# program settings & paths {{{
export SCONS_LIB_DIR="/Library/Python/2.6/site-packages/scons-1.2.0-py2.6.egg/scons-1.2.0"
export COPY_EXTENDED_ATTRIBUTES_DISABLE=true

# python
export PYTHONPATH="/usr/local/lib/python2.7/site-packages:$PYTHONPATH"
export PYTHONPATH=$PYTHONPATH:$HOME/.python
export PYTHONSTARTUP=$HOME/.pythonstartup

#ant
export ANT_HOME=$HOME/work/tools/apache-ant-1.8.2
export ANT_OPTS="-Xms256m -Xmx512m -XX:MaxPermSize=512m -XX:PermSize=256m"

# jrebel

export JREBEL_PATH=$HOME/work/tools/jrebel/jrebel.jar

# maven
#export M2=$HOME/work/apache-maven-3.0.3/bin/
#export M2_HOME=$HOME/work/apache-maven-3.0.3/
export MAVEN_REPO=$HOME/.m2/repository

#export LESS='-fXemPm?f%f .?lbLine %lb?L of %L..:$' # Set options for less command
export LESS="-rX"
export PAGER=less

if [ "`uname`" = "Darwin" ]; then
  export EDITOR=/usr/local/bin/vim
  export GIT_EDITOR=/usr/local/bin/vim
else
  export EDITOR=/usr/bin/vim
  export GIT_EDITOR=/usr/bin/vim
fi

export GIST_URL='git.corp.adobe.com/api/v3'

export VISUAL='vim'
export INPUTRC=~/.inputrc
export LANG="en_US.UTF-8"
export LANGUAGE="en_US.UTF-8"
export LC_ALL="en_US.UTF-8"
export LC_CTYPE="en_US.UTF-8"
export LC_NUMERIC="en_US.utf8"
export LC_TIME="en_US.utf8"
export LC_COLLATE="en_US.utf8"
export LC_MONETARY="en_US.utf8"
export LC_MESSAGES="en_US.utf8"
export LC_PAPER="en_US.utf8"
export LC_NAME="en_US.utf8"
export LC_ADDRESS="en_US.utf8"
export LC_TELEPHONE="en_US.utf8"
export LC_MEASUREMENT="en_US.utf8"
export LC_IDENTIFICATION="en_US.utf8"
#export LC_ALL=""

export VERSIONER_PERL_PREFER_32_BIT=yes
export PERL_BADLANG=0

if [ $OS = "linux" ];
then
  export PERL_LOCAL_LIB_ROOT=$HOME/.perl5
  export PERL_MB_OPT="--install_base $HOME/.perl5";
  export PERL_MM_OPT="INSTALL_BASE=$HOME/.perl5";
  export PERL5LIB="$HOME/.perl5/lib/perl5/x86_64-linux-gnu-thread-multi:$HOME/.perl5/lib/perl5";
  export PATH="$HOME/.perl5/bin:$PATH";
fi

export DISPLAY=:0.0

# hla
export hlalib=/usr/hla/hlalib
export hlainc=/usr/hla/include

# colors in terminal
export CLICOLOR=1
export LSCOLORS=ExFxCxDxBxegedabagacad

#GO
export GOROOT=$HOME/temp/source/other/go
export GOOS=$OS
export GOARCH=amd64
export GOBIN=$HOME/bin/$OS/go
export GOPATH=$HOME/.gocode

export P4CONFIG=.p4conf
export HTML_TIDY=$HOME/.tidyconf

export WIKI=$HOME/Documents/personal/life/exploded/

export SAASBASE_HOME=$HOME/work/s
source $HOME/work/s/services/use-hadoop-1
export HBASE_HOME=$HOME/work/s/hbase
export ZOOKEEPER_HOME=$HOME/work/s/zookeeper
export STORM_HOME=$HOME/work/s/storm

# ansible
export ANSIBLE_HOSTS=~/.ansible_hosts

# saasbase
export SAASBASE_DB_HOME=$HOME/work/s/saasbase/src/saasbase_db
export SAASBASE_ANALYTICS_HOME=$HOME/work/s/saasbase/src/saasbase_analytics
export SAASBASE_DATAROOT=/var

export ROO_HOME=$HOME/work/tools/spring-roo-1.1.0.M1

export MONO_GAC_PREFIX=/usr/local

# luatext
#export TEXMFCNF=/usr/local/texlive/2008/texmf/web2c/
#export LUAINPUTS='{/usr/local/texlive/texmf-local/tex/context/base,/usr/local/texlive/texmf-local/scripts/context/lua,$HOME/texmf/scripts/context/lua}'
#export TEXMF='{$HOME/.texlive2008/texmf-config,$HOME/.texlive2008/texmf-var,$HOME/texmf,/usr/local/texlive/2008/texmf-config,/usr/local/texlive/2008/texmf-var,/usr/local/texlive/2008/texmf,/usr/local/texlive/texmf-local,/usr/local/texlive/2008/texmf-dist,/usr/local/texlive/2008/texmf.gwtex}'
export TEXMFCACHE=/tmp
#export TEXMFCNF=/usr/local/texlive/2008/texmf/web2c

# java
if [ "`uname`" = "Darwin" ]; then
  export JAVA_HOME="$(/usr/libexec/java_home)"
else
  export JAVA_HOME=/usr/lib/jvm/java-6-sun/
fi

#export JUNIT_HOME=/usr/share/junit

# haxe
export HAXE_LIBRARY_PATH="$(/usr/local/bin/brew --prefix)/share/haxe/std"
#export NEKOPATH=/usr/local/neko


export NOTES=$HOME/Documents/personal/life/notes@/

if [ "`uname`" = "Darwin" ]; then
  export VIMRUNTIME=$HOME/Applications/MacVim.app/Contents/Resources/vim/runtime/
fi  
#export SCALA_HOME=/usr/local
# }}}


# path {{{
export PATH=\
/usr/local/bin:\
/usr/local/sbin:\
$HOME/bin:\
$HOME/bin/$OS:\
$SAASBASE_HOME/services:\
$HOME/.cabal/bin:\
$HOME/temp/source/other/sshuttle:\
$HOME/temp/source/other/factor:\
$HOME/work/tools/nasm:\
$HOME/temp/source/other/rock/bin:\
$ROO_HOME/bin:\
$HOME/Applications/emulator/n64/mupen64plus-1.99.4-osx/x86_64:\
$HOME/work/tools/android-sdk-$OS/tools:\
$HOME/work/tools/android-sdk-$OS/platform-tools:\
$HOME/work/tools/play-2.0.1:\
$GOBIN:\
$HOME/Library/Sprouts/1.1/cache/flex4/4.6.0.23201/bin:\
$PATH

if [ "`uname`" = "Darwin" ]; then
export PATH=$PATH:\
$HOME/bin/$OS/clic
fi

export MANPATH=\
/usr/local/man:\
$MANPATH

# }}}

# aliases {{{

# common

alias -s com=urlopen
alias -s org=urlopen
alias -s net=urlopen
alias -s io=urlopen

#alias ack="ack -i -a"
alias vidir="EDITOR=v vidir"
alias gvim="g"
alias c="clear"
alias l="ls -AGlFT"
alias lt="ls -AGlFTtr"
alias gwhat="grep -e $1"
 
#editor
case "$HOST" in
  $USER-mac*)
  alias gvim='$HOME/Applications/MacVim.app/Contents/MacOS/Vim -g';
  #alias vim='$HOME/Applications/MacVim.app/Contents/MacOS/Vim';
  ;;
  sheeva*)
  #alias vim='/usr/bin/vim';
  ;;
  $USER-mbp*)
  #alias vim='/usr/bin/vim';
  ;;
esac

# git commands
alias gss="git stash save"
alias gsp="git stash pop"
alias gl="git log"
alias ga="git add"
alias gr="git reset"
alias gs="git status"
alias gst="git status"
alias gd="git diff"
alias gdc="git diff --cached"
alias g-update-deleted="git ls-files -z --deleted | git update-index -z --remove --stdin"
alias gfr="git fetch && git rebase refs/remotes/origin/master"
alias gci="git commit"
alias gco="git checkout"

# clojure
alias clojure='rlwrap java -cp $MAVEN_REPO/org/clojure/clojure/1.4.0/clojure-1.4.0.jar:$MAVEN_REPO/org/clojure/clojure-contrib/1.2.0/clojure-contrib-1.2.0.jar clojure.main'

# builtin commands

# make top default to ordering by CPU usage:
alias top='top -ocpu'
# more lightweight version of top which doesn't use so much CPU itself:
alias ttop='top -ocpu -R -F -s 2 -n30'

# ls
alias l="ls -AGlFT"
alias la='ls -A'
alias lt="ls -AGlFTtr"
alias lc="cl"
alias cdd='cd - '
alias mkdir='mkdir -p'
alias reload="source ~/.profile"
alias rc='v ~/.profile && source ~/.profile'
alias finde='find -E'
alias pgrep='pgrep -lf'
alias df='df -h'
alias du='du -h -c'
alias psa='ps auxwww'
alias ping='ping -c 5'
alias grep='grep --colour'
alias svnaddall='svn status | grep "^\?" | awk "{print \$2}" | xargs svn add'
#alias irb='irb --readline -r irb/completion -rubygems'
alias irb='pry'
alias ri='ri -Tf ansi'
alias tu='top -o cpu'
alias tm='top -o vsize'
alias t="~/bin/todo.py -d '$HOME/Documents/personal/life/exploded/todo@/'"

# text 2 html
alias textile='/usr/bin/redcloth'
alias markdown='/usr/local/bin/markdown'

# mathematica
alias math='rlwrap $HOME/Applications/Mathematica.app/Contents/MacOS/MathKernel'

# hadoop, hbase, etc
alias hbase='$HBASE_HOME/bin/hbase'
alias zk='$ZOOKEEPER_HOME/bin/zkCli.sh'
alias storm='$STORM_HOME/bin/storm'
alias psall='pswhich NameNode DataNode TaskTracker JobTracker Quorum HMaster HRegion ThriftServer ReportServer storm.daemon.nimbus storm.ui.core'

function bases() {
  # Determine base of the number
  for i      # ==> in [list] missing...
  do         # ==> so operates on command line arg(s).
	case "$i" in
    0b*)		ibase=2;;	# binary
    0x*|[a-f]*|[A-F]*)	ibase=16;;	# hexadecimal
    0*)			ibase=8;;	# octal
    [1-9]*)		ibase=10;;	# decimal
    *)
		echo "illegal number $i - ignored"
		continue;;
	esac

	# Remove prefix, convert hex digits to uppercase (bc needs this)
	number=`echo "$i" | sed -e 's:^0[bBxX]::' | tr '[a-f]' '[A-F]'`
	# ==> Uses ":" as sed separator, rather than "/".

	# Convert number to decimal
	dec=`echo "ibase=$ibase; $number" | bc`  # ==> 'bc' is calculator utility.
	case "$dec" in
    [0-9]*)	;;			 # number ok
    *)		continue;;		 # error: ignore
	esac

	# Print all conversions in one line.
	# ==> 'here document' feeds command list to 'bc'.
	echo `bc <<!
	    obase=16; "hex="; $dec
	    obase=10; "dec="; $dec
	    obase=8;  "oct="; $dec
	    obase=2;  "bin="; $dec
!
    ` | sed -e 's: :	:g'
    done
}

# }}}

# {{{ modules
zmodload zsh/datetime
zmodload zsh/stat
zmodload zsh/mathfunc

# stty discard undef
# stty -ixon

# }}}

#!/usr/bin/env zsh
# -------------------------------------------------------------------------------------------------
# Copyright (c) 2010-2011 zsh-syntax-highlighting contributors
# All rights reserved.
#
# Redistribution and use in source and binary forms, with or without modification, are permitted
# provided that the following conditions are met:
#
#  * Redistributions of source code must retain the above copyright notice, this list of conditions
#    and the following disclaimer.
#  * Redistributions in binary form must reproduce the above copyright notice, this list of
#    conditions and the following disclaimer in the documentation and/or other materials provided
#    with the distribution.
#  * Neither the name of the zsh-syntax-highlighting contributors nor the names of its contributors
#    may be used to endorse or promote products derived from this software without specific prior
#    written permission.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR
# IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND
# FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR
# CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
# DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
# DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER
# IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT
# OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
# -------------------------------------------------------------------------------------------------
# -*- mode: zsh; sh-indentation: 2; indent-tabs-mode: nil; sh-basic-offset: 2; -*-
# vim: ft=zsh sw=2 ts=2 et
# -------------------------------------------------------------------------------------------------


# -------------------------------------------------------------------------------------------------
# Core highlighting update system
# -------------------------------------------------------------------------------------------------

# Array declaring active highlighters names.
typeset -ga ZSH_HIGHLIGHT_HIGHLIGHTERS

# Update ZLE buffer syntax highlighting.
#
# Invokes each highlighter that needs updating.
# This function is supposed to be called whenever the ZLE state changes.
_zsh_highlight()
{
  setopt localoptions nowarncreateglobal

  # Store the previous command return code to restore it whatever happens.
  local ret=$?

  # Do not highlight if there are more than 300 chars in the buffer. It's most
  # likely a pasted command or a huge list of files in that case..
  [[ -n ${ZSH_HIGHLIGHT_MAXLENGTH:-} ]] && [[ $#BUFFER -gt $ZSH_HIGHLIGHT_MAXLENGTH ]] && return $ret

  # Do not highlight if there are pending inputs (copy/paste).
  [[ $PENDING -gt 0 ]] && return $ret

  {
    local -a selected_highlighters
    local cache_place

    # Select which highlighters in ZSH_HIGHLIGHT_HIGHLIGHTERS need to be invoked.
    local highlighter; for highlighter in $ZSH_HIGHLIGHT_HIGHLIGHTERS; do

      # If highlighter needs to be invoked
      if "_zsh_highlight_${highlighter}_highlighter_predicate"; then

        # Mark the highlighter as selected for update.
        selected_highlighters+=($highlighter)

        # Remove what was stored in its cache from region_highlight.
        cache_place="_zsh_highlight_${highlighter}_highlighter_cache"
        typeset -ga ${cache_place}
        [[ ${#${(P)cache_place}} -gt 0 ]] && [[ ! -z ${region_highlight-} ]] && region_highlight=(${region_highlight:#(${(P~j.|.)cache_place})})

      fi
    done

    # Invoke each selected highlighter and store the result in its cache.
    local -a region_highlight_copy
    for highlighter in $selected_highlighters; do
      cache_place="_zsh_highlight_${highlighter}_highlighter_cache"
      region_highlight_copy=($region_highlight)
      {
        "_zsh_highlight_${highlighter}_highlighter"
      } always  {
        [[ ! -z ${region_highlight-} ]] && : ${(PA)cache_place::=${region_highlight:#(${(~j.|.)region_highlight_copy})}}
      }
    done

  } always {
    _ZSH_HIGHLIGHT_PRIOR_BUFFER=$BUFFER
    _ZSH_HIGHLIGHT_PRIOR_CURSOR=$CURSOR
    return $ret
  }
}


# -------------------------------------------------------------------------------------------------
# API/utility functions for highlighters
# -------------------------------------------------------------------------------------------------

# Array used by highlighters to declare user overridable styles.
typeset -gA ZSH_HIGHLIGHT_STYLES

# Whether the command line buffer has been modified or not.
#
# Returns 0 if the buffer has changed since _zsh_highlight was last called.
_zsh_highlight_buffer_modified()
{
  [[ "${_ZSH_HIGHLIGHT_PRIOR_BUFFER:-}" != "$BUFFER" ]]
}

# Whether the cursor has moved or not.
#
# Returns 0 if the cursor has moved since _zsh_highlight was last called.
_zsh_highlight_cursor_moved()
{
  [[ -n $CURSOR ]] && [[ -n ${_ZSH_HIGHLIGHT_PRIOR_CURSOR-} ]] && (($_ZSH_HIGHLIGHT_PRIOR_CURSOR != $CURSOR))
}


# -------------------------------------------------------------------------------------------------
# Setup functions
# -------------------------------------------------------------------------------------------------

# Rebind all ZLE widgets to make them invoke _zsh_highlights.
_zsh_highlight_bind_widgets()
{
  # Load ZSH module zsh/zleparameter, needed to override user defined widgets.
  zmodload zsh/zleparameter 2>/dev/null || {
    echo 'zsh-syntax-highlighting: failed loading zsh/zleparameter.' >&2
    return 1
  }

  # Override ZLE widgets to make them invoke _zsh_highlight.
  local cur_widget
  for cur_widget in ${${(f)"$(builtin zle -la)"}:#(.*|_*|orig-*|run-help|which-command|beep)}; do
    case $widgets[$cur_widget] in

      # Already rebound event: do nothing.
      user:$cur_widget|user:_zsh_highlight_widget_*);;

      # User defined widget: override and rebind old one with prefix "orig-".
      user:*) eval "zle -N orig-$cur_widget ${widgets[$cur_widget]#*:}; \
                    _zsh_highlight_widget_$cur_widget() { builtin zle orig-$cur_widget -- \"\$@\" && _zsh_highlight }; \
                    zle -N $cur_widget _zsh_highlight_widget_$cur_widget";;

      # Completion widget: override and rebind old one with prefix "orig-".
      completion:*) eval "zle -C orig-$cur_widget ${${widgets[$cur_widget]#*:}/:/ }; \
                          _zsh_highlight_widget_$cur_widget() { builtin zle orig-$cur_widget -- \"\$@\" && _zsh_highlight }; \
                          zle -N $cur_widget _zsh_highlight_widget_$cur_widget";;

      # Builtin widget: override and make it call the builtin ".widget".
      builtin) eval "_zsh_highlight_widget_$cur_widget() { builtin zle .$cur_widget -- \"\$@\" && _zsh_highlight }; \
                     zle -N $cur_widget _zsh_highlight_widget_$cur_widget";;

      # Default: unhandled case.
      *) echo "zsh-syntax-highlighting: unhandled ZLE widget '$cur_widget'" >&2 ;;
    esac
  done
}

# Load highlighters from directory.
#
# Arguments:
#   1) Path to the highlighters directory.
_zsh_highlight_load_highlighters()
{
}


# -------------------------------------------------------------------------------------------------
# Setup
# -------------------------------------------------------------------------------------------------

# Try binding widgets.
_zsh_highlight_bind_widgets || {
  echo 'zsh-syntax-highlighting: failed binding ZLE widgets, exiting.' >&2
  return 1
}

# Resolve highlighters directory location.
_zsh_highlight_load_highlighters "${ZSH_HIGHLIGHT_HIGHLIGHTERS_DIR:-${0:h}/highlighters}" || {
  echo 'zsh-syntax-highlighting: failed loading highlighters, exiting.' >&2
  return 1
}

# Reset scratch variables when commandline is done.
_zsh_highlight_preexec_hook()
{
  _ZSH_HIGHLIGHT_PRIOR_BUFFER=
  _ZSH_HIGHLIGHT_PRIOR_CURSOR=
}
autoload -U add-zsh-hook
add-zsh-hook preexec _zsh_highlight_preexec_hook 2>/dev/null || {
    echo 'zsh-syntax-highlighting: failed loading add-zsh-hook.' >&2
  }

# Initialize the array of active highlighters if needed.
[[ $#ZSH_HIGHLIGHT_HIGHLIGHTERS -eq 0 ]] && ZSH_HIGHLIGHT_HIGHLIGHTERS=(main cursor brackets) || true

# main highlighter
# Define default styles.
: ${ZSH_HIGHLIGHT_STYLES[default]:=none}
: ${ZSH_HIGHLIGHT_STYLES[unknown-token]:=fg=red,bold}
: ${ZSH_HIGHLIGHT_STYLES[reserved-word]:=fg=yellow}
: ${ZSH_HIGHLIGHT_STYLES[alias]:=fg=green}
: ${ZSH_HIGHLIGHT_STYLES[builtin]:=fg=green}
: ${ZSH_HIGHLIGHT_STYLES[function]:=fg=green}
: ${ZSH_HIGHLIGHT_STYLES[command]:=fg=green}
: ${ZSH_HIGHLIGHT_STYLES[precommand]:=fg=green,underline}
: ${ZSH_HIGHLIGHT_STYLES[commandseparator]:=none}
: ${ZSH_HIGHLIGHT_STYLES[hashed-command]:=fg=green}
: ${ZSH_HIGHLIGHT_STYLES[path]:=underline}
: ${ZSH_HIGHLIGHT_STYLES[globbing]:=fg=blue}
: ${ZSH_HIGHLIGHT_STYLES[history-expansion]:=fg=blue}
: ${ZSH_HIGHLIGHT_STYLES[single-hyphen-option]:=none}
: ${ZSH_HIGHLIGHT_STYLES[double-hyphen-option]:=none}
: ${ZSH_HIGHLIGHT_STYLES[back-quoted-argument]:=none}
: ${ZSH_HIGHLIGHT_STYLES[single-quoted-argument]:=fg=yellow}
: ${ZSH_HIGHLIGHT_STYLES[double-quoted-argument]:=fg=yellow}
: ${ZSH_HIGHLIGHT_STYLES[dollar-double-quoted-argument]:=fg=cyan}
: ${ZSH_HIGHLIGHT_STYLES[back-double-quoted-argument]:=fg=cyan}
: ${ZSH_HIGHLIGHT_STYLES[assign]:=none}

# Whether the highlighter should be called or not.
_zsh_highlight_main_highlighter_predicate()
{
  _zsh_highlight_buffer_modified
}

# Main syntax highlighting function.
_zsh_highlight_main_highlighter()
{
  emulate -L zsh 
  setopt localoptions extendedglob bareglobqual
  local start_pos=0 end_pos highlight_glob=true new_expression=true arg style
  typeset -a ZSH_HIGHLIGHT_TOKENS_COMMANDSEPARATOR
  typeset -a ZSH_HIGHLIGHT_TOKENS_PRECOMMANDS
  typeset -a ZSH_HIGHLIGHT_TOKENS_FOLLOWED_BY_COMMANDS
  region_highlight=()

  ZSH_HIGHLIGHT_TOKENS_COMMANDSEPARATOR=(
    '|' '||' ';' '&' '&&'
  )
  ZSH_HIGHLIGHT_TOKENS_PRECOMMANDS=(
    'builtin' 'command' 'exec' 'nocorrect' 'noglob' 'sudo'
  )
  # Tokens that are always immediately followed by a command.
  ZSH_HIGHLIGHT_TOKENS_FOLLOWED_BY_COMMANDS=(
    $ZSH_HIGHLIGHT_TOKENS_COMMANDSEPARATOR $ZSH_HIGHLIGHT_TOKENS_PRECOMMANDS
  )

  for arg in ${(z)BUFFER}; do
    local substr_color=0
    [[ $start_pos -eq 0 && $arg = 'noglob' ]] && highlight_glob=false
    ((start_pos+=${#BUFFER[$start_pos+1,-1]}-${#${BUFFER[$start_pos+1,-1]##[[:space:]]#}}))
    ((end_pos=$start_pos+${#arg}))
    if $new_expression; then
      new_expression=false
     if [[ -n ${(M)ZSH_HIGHLIGHT_TOKENS_PRECOMMANDS:#"$arg"} ]]; then
      style=$ZSH_HIGHLIGHT_STYLES[precommand]
     else
      res=$(LC_ALL=C builtin type -w $arg 2>/dev/null)
      case $res in
        *': reserved')  style=$ZSH_HIGHLIGHT_STYLES[reserved-word];;
        *': alias')     style=$ZSH_HIGHLIGHT_STYLES[alias]
                        local aliased_command="${"$(alias $arg)"#*=}"
                        [[ -n ${(M)ZSH_HIGHLIGHT_TOKENS_FOLLOWED_BY_COMMANDS:#"$aliased_command"} && -z ${(M)ZSH_HIGHLIGHT_TOKENS_FOLLOWED_BY_COMMANDS:#"$arg"} ]] && ZSH_HIGHLIGHT_TOKENS_FOLLOWED_BY_COMMANDS+=($arg)
                        ;;
        *': builtin')   style=$ZSH_HIGHLIGHT_STYLES[builtin];;
        *': function')  style=$ZSH_HIGHLIGHT_STYLES[function];;
        *': command')   style=$ZSH_HIGHLIGHT_STYLES[command];;
        *': hashed')    style=$ZSH_HIGHLIGHT_STYLES[hashed-command];;
        *)              if _zsh_highlight_main_highlighter_check_assign; then
                          style=$ZSH_HIGHLIGHT_STYLES[assign]
                          new_expression=true
                        elif _zsh_highlight_main_highlighter_check_path; then
                          style=$ZSH_HIGHLIGHT_STYLES[path]
                        elif [[ $arg[0,1] = $histchars[0,1] ]]; then
                          style=$ZSH_HIGHLIGHT_STYLES[history-expansion]
                        else
                          style=$ZSH_HIGHLIGHT_STYLES[unknown-token]
                        fi
                        ;;
      esac
     fi
    else
      case $arg in
        '--'*)   style=$ZSH_HIGHLIGHT_STYLES[double-hyphen-option];;
        '-'*)    style=$ZSH_HIGHLIGHT_STYLES[single-hyphen-option];;
        "'"*"'") style=$ZSH_HIGHLIGHT_STYLES[single-quoted-argument];;
        '"'*'"') style=$ZSH_HIGHLIGHT_STYLES[double-quoted-argument]
                 region_highlight+=("$start_pos $end_pos $style")
                 _zsh_highlight_main_highlighter_highlight_string
                 substr_color=1
                 ;;
        '`'*'`') style=$ZSH_HIGHLIGHT_STYLES[back-quoted-argument];;
        *"*"*)   $highlight_glob && style=$ZSH_HIGHLIGHT_STYLES[globbing] || style=$ZSH_HIGHLIGHT_STYLES[default];;
        *)       if _zsh_highlight_main_highlighter_check_path; then
                   style=$ZSH_HIGHLIGHT_STYLES[path]
                 elif [[ $arg[0,1] = $histchars[0,1] ]]; then
                   style=$ZSH_HIGHLIGHT_STYLES[history-expansion]
                 elif [[ -n ${(M)ZSH_HIGHLIGHT_TOKENS_COMMANDSEPARATOR:#"$arg"} ]]; then
                   style=$ZSH_HIGHLIGHT_STYLES[commandseparator]
                 else
                   style=$ZSH_HIGHLIGHT_STYLES[default]
                 fi
                 ;;
      esac
    fi
    [[ $substr_color = 0 ]] && region_highlight+=("$start_pos $end_pos $style")
    [[ -n ${(M)ZSH_HIGHLIGHT_TOKENS_FOLLOWED_BY_COMMANDS:#"$arg"} ]] && new_expression=true
    start_pos=$end_pos
  done
}

# Check if the argument is variable assignment
_zsh_highlight_main_highlighter_check_assign()
{
    setopt localoptions extended_glob
    [[ ${(Q)arg} == [[:alpha:]_]([[:alnum:]_])#=* ]]
}

# Check if the argument is a path.
_zsh_highlight_main_highlighter_check_path()
{
  setopt localoptions nonomatch
  local expanded_path; : ${expanded_path:=${(Q)~arg}}
  [[ -z $expanded_path ]] && return 1
  [[ -e $expanded_path ]] && return 0
  [[ ! -e ${expanded_path:h} ]] && return 1
  [[ ${BUFFER[1]} != "-" && ${#BUFFER} == $end_pos && -n $(print ${expanded_path}*(N)) ]] && return 0
  return 1
}

# Highlight special chars inside double-quoted strings
_zsh_highlight_main_highlighter_highlight_string()
{
  setopt localoptions noksharrays
  local i j k style
  # Starting quote is at 1, so start parsing at offset 2 in the string.
  for (( i = 2 ; i < end_pos - start_pos ; i += 1 )) ; do
    (( j = i + start_pos - 1 ))
    (( k = j + 1 ))
    case "$arg[$i]" in
      '$')  style=$ZSH_HIGHLIGHT_STYLES[dollar-double-quoted-argument];;
      "\\") style=$ZSH_HIGHLIGHT_STYLES[back-double-quoted-argument]
            (( k += 1 )) # Color following char too.
            (( i += 1 )) # Skip parsing the escaped char.
            ;;
      *)    continue;;
    esac
    region_highlight+=("$j $k $style")
  done
}

# root highlighter
# Define default styles.
: ${ZSH_HIGHLIGHT_STYLES[root]:=standout}

# Whether the root highlighter should be called or not.
_zsh_highlight_root_highlighter_predicate()
{
  _zsh_highlight_buffer_modified
}

# root highlighting function.
_zsh_highlight_root_highlighter()
{
  [[ $(command id -u) -eq 0 ]] && region_highlight+=("0 $#BUFFER $ZSH_HIGHLIGHT_STYLES[root]")
}

# pattern highlighter
# List of keyword and color pairs.
typeset -gA ZSH_HIGHLIGHT_PATTERNS

# Whether the pattern highlighter should be called or not.
_zsh_highlight_pattern_highlighter_predicate()
{
  _zsh_highlight_buffer_modified
}

# Pattern syntax highlighting function.
_zsh_highlight_pattern_highlighter()
{
  setopt localoptions extendedglob
  for pattern in ${(k)ZSH_HIGHLIGHT_PATTERNS}; do
    _zsh_highlight_pattern_highlighter_loop "$BUFFER" "$pattern"
  done
}

_zsh_highlight_pattern_highlighter_loop()
{
  # This does *not* do its job syntactically, sorry.
  local buf="$1" pat="$2"
  local -a match mbegin mend
  if [[ "$buf" == (#b)(*)(${~pat})* ]]; then
    region_highlight+=("$((mbegin[2] - 1)) $mend[2] $ZSH_HIGHLIGHT_PATTERNS[$pat]")
    "$0" "$match[1]" "$pat"; return $?
  fi
}
# brackets highlighter

# Define default styles.
: ${ZSH_HIGHLIGHT_STYLES[bracket-error]:=fg=red,bold}
: ${ZSH_HIGHLIGHT_STYLES[bracket-level-1]:=fg=blue,bold}
: ${ZSH_HIGHLIGHT_STYLES[bracket-level-2]:=fg=green,bold}
: ${ZSH_HIGHLIGHT_STYLES[bracket-level-3]:=fg=magenta,bold}
: ${ZSH_HIGHLIGHT_STYLES[bracket-level-4]:=fg=yellow,bold}
: ${ZSH_HIGHLIGHT_STYLES[bracket-level-5]:=fg=cyan,bold}
: ${ZSH_HIGHLIGHT_STYLES[cursor-matchingbracket]:=standout}

# Whether the brackets highlighter should be called or not.
_zsh_highlight_brackets_highlighter_predicate()
{
  _zsh_highlight_cursor_moved || _zsh_highlight_buffer_modified
}

# Brackets highlighting function.
_zsh_highlight_brackets_highlighter()
{
  local level=0 pos
  local -A levelpos lastoflevel matching typepos

  # Find all brackets and remember which one is matching
  for (( pos = 0; $pos < ${#BUFFER}; pos++ )) ; do
    local char="$BUFFER[pos+1]"
    case $char in
      ["([{"])
        levelpos[$pos]=$((++level))
        lastoflevel[$level]=$pos
        _zsh_highlight_brackets_highlighter_brackettype "$char"
        ;;
      [")]}"])
        matching[$lastoflevel[$level]]=$pos
        matching[$pos]=$lastoflevel[$level]
        levelpos[$pos]=$((level--))
        _zsh_highlight_brackets_highlighter_brackettype "$char"
        ;;
      ['"'\'])
        # Skip everything inside quotes
        local quotetype=$char
        while (( $pos < ${#BUFFER} )) ; do
          (( pos++ ))
          [[ $BUFFER[$pos+1] == $quotetype ]] && break
        done
        ;;
    esac
  done

  # Now highlight all found brackets
  for pos in ${(k)levelpos}; do
    if [[ -n $matching[$pos] ]] && [[ $typepos[$pos] == $typepos[$matching[$pos]] ]]; then
      local bracket_color_size=${#ZSH_HIGHLIGHT_STYLES[(I)bracket-level-*]}
      local bracket_color_level=bracket-level-$(( (levelpos[$pos] - 1) % bracket_color_size + 1 ))
      local style=$ZSH_HIGHLIGHT_STYLES[$bracket_color_level]
      region_highlight+=("$pos $((pos + 1)) $style")
    else
      local style=$ZSH_HIGHLIGHT_STYLES[bracket-error]
      region_highlight+=("$pos $((pos + 1)) $style")
    fi
  done

  # If cursor is on a bracket, then highlight corresponding bracket, if any
  pos=$CURSOR
  if [[ -n $levelpos[$pos] ]] && [[ -n $matching[$pos] ]]; then
    local otherpos=$matching[$pos]
    local style=$ZSH_HIGHLIGHT_STYLES[cursor-matchingbracket]
    region_highlight+=("$otherpos $((otherpos + 1)) $style")
  fi
}

# Helper function to differentiate type 
_zsh_highlight_brackets_highlighter_brackettype()
{
  case $1 in
    ["()"]) typepos[$pos]=round;;
    ["[]"]) typepos[$pos]=bracket;;
    ["{}"]) typepos[$pos]=curly;;
    *) ;;
  esac
}

# Define default styles.
: ${ZSH_HIGHLIGHT_STYLES[cursor]:=standout}

# Whether the cursor highlighter should be called or not.
_zsh_highlight_cursor_highlighter_predicate()
{
  _zsh_highlight_cursor_moved
}

# Cursor highlighting function.
_zsh_highlight_cursor_highlighter()
{
  region_highlight+=("$CURSOR $(( $CURSOR + 1 )) $ZSH_HIGHLIGHT_STYLES[cursor]")
}


# {{{
HISTORY_SUBSTRING_SEARCH_HIGHLIGHT_FOUND='bg=magenta,fg=white,bold'
HISTORY_SUBSTRING_SEARCH_HIGHLIGHT_NOT_FOUND='bg=red,fg=white,bold'
HISTORY_SUBSTRING_SEARCH_GLOBBING_FLAGS='i'

#-----------------------------------------------------------------------------
# the main ZLE widgets
#-----------------------------------------------------------------------------

function history-substring-search-up() {
  _history-substring-search-begin

  _history-substring-search-up-history ||
  _history-substring-search-up-buffer ||
  _history-substring-search-up-search

  _history-substring-search-end
}

function history-substring-search-down() {
  _history-substring-search-begin

  _history-substring-search-down-history ||
  _history-substring-search-down-buffer ||
  _history-substring-search-down-search

  _history-substring-search-end
}

zle -N history-substring-search-up
zle -N history-substring-search-down

bindkey '\e[A' history-substring-search-up
bindkey '\e[B' history-substring-search-down

#-----------------------------------------------------------------------------
# implementation details
#-----------------------------------------------------------------------------

zmodload -F zsh/parameter

#
# We have to "override" some keys and widgets if the
# zsh-syntax-highlighting plugin has not been loaded:
#
# https://github.com/nicoulaj/zsh-syntax-highlighting
#
if [[ $+functions[_zsh_highlight] -eq 0 ]]; then
  #
  # Dummy implementation of _zsh_highlight() that
  # simply removes any existing highlights when the
  # user inserts printable characters into $BUFFER.
  #
  function _zsh_highlight() {
    if [[ $KEYS == [[:print:]] ]]; then
      region_highlight=()
    fi
  }

  #
  # The following snippet was taken from the zsh-syntax-highlighting project:
  #
  # https://github.com/zsh-users/zsh-syntax-highlighting/blob/56b134f5d62ae3d4e66c7f52bd0cc2595f9b305b/zsh-syntax-highlighting.zsh#L126-161
  #
  # Copyright (c) 2010-2011 zsh-syntax-highlighting contributors
  # All rights reserved.
  #
  # Redistribution and use in source and binary forms, with or without
  # modification, are permitted provided that the following conditions are
  # met:
  #
  #  * Redistributions of source code must retain the above copyright
  #    notice, this list of conditions and the following disclaimer.
  #
  #  * Redistributions in binary form must reproduce the above copyright
  #    notice, this list of conditions and the following disclaimer in the
  #    documentation and/or other materials provided with the distribution.
  #
  #  * Neither the name of the zsh-syntax-highlighting contributors nor the
  #    names of its contributors may be used to endorse or promote products
  #    derived from this software without specific prior written permission.
  #
  # THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS
  # IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO,
  # THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR
  # PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR
  # CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
  # EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
  # PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR
  # PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
  # LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
  # NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
  # SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
  #
  #--------------8<-------------------8<-------------------8<-----------------
  # Rebind all ZLE widgets to make them invoke _zsh_highlights.
  _zsh_highlight_bind_widgets()
  {
    # Load ZSH module zsh/zleparameter, needed to override user defined widgets.
    zmodload zsh/zleparameter 2>/dev/null || {
      echo 'zsh-syntax-highlighting: failed loading zsh/zleparameter.' >&2
      return 1
    }

    # Override ZLE widgets to make them invoke _zsh_highlight.
    local cur_widget
    for cur_widget in ${${(f)"$(builtin zle -la)"}:#(.*|_*|orig-*|run-help|which-command|beep)}; do
      case $widgets[$cur_widget] in

        # Already rebound event: do nothing.
        user:$cur_widget|user:_zsh_highlight_widget_*);;

        # User defined widget: override and rebind old one with prefix "orig-".
        user:*) eval "zle -N orig-$cur_widget ${widgets[$cur_widget]#*:}; \
                      _zsh_highlight_widget_$cur_widget() { builtin zle orig-$cur_widget -- \"\$@\" && _zsh_highlight }; \
                      zle -N $cur_widget _zsh_highlight_widget_$cur_widget";;

        # Completion widget: override and rebind old one with prefix "orig-".
        completion:*) eval "zle -C orig-$cur_widget ${${widgets[$cur_widget]#*:}/:/ }; \
                            _zsh_highlight_widget_$cur_widget() { builtin zle orig-$cur_widget -- \"\$@\" && _zsh_highlight }; \
                            zle -N $cur_widget _zsh_highlight_widget_$cur_widget";;

        # Builtin widget: override and make it call the builtin ".widget".
        builtin) eval "_zsh_highlight_widget_$cur_widget() { builtin zle .$cur_widget -- \"\$@\" && _zsh_highlight }; \
                       zle -N $cur_widget _zsh_highlight_widget_$cur_widget";;

        # Default: unhandled case.
        *) echo "zsh-syntax-highlighting: unhandled ZLE widget '$cur_widget'" >&2 ;;
      esac
    done
  }
  #-------------->8------------------->8------------------->8-----------------

  _zsh_highlight_bind_widgets
fi

function _history-substring-search-begin() {
  setopt localoptions extendedglob

  _history_substring_search_refresh_display=
  _history_substring_search_query_highlight=

  #
  # Continue using the previous $_history_substring_search_result by default,
  # unless the current query was cleared or a new/different query was entered.
  #
  if [[ -z $BUFFER || $BUFFER != $_history_substring_search_result ]]; then
    _history_substring_search_query=$BUFFER
    _history_substring_search_query_escaped=${BUFFER//(#m)[\][()|\\*?#<>~^]/\\$MATCH}

    _history_substring_search_matches=(${(kon)history[(R)(#$HISTORY_SUBSTRING_SEARCH_GLOBBING_FLAGS)*${_history_substring_search_query_escaped}*]})

    _history_substring_search_matches_count=$#_history_substring_search_matches
    _history_substring_search_matches_count_plus=$(( _history_substring_search_matches_count + 1 ))
    _history_substring_search_matches_count_sans=$(( _history_substring_search_matches_count - 1 ))
    if [[ $WIDGET == history-substring-search-down ]]; then
       _history_substring_search_match_index=$_history_substring_search_matches_count
    else
      _history_substring_search_match_index=$_history_substring_search_matches_count_plus
    fi
  fi
}

function _history-substring-search-end() {
  setopt localoptions extendedglob

  _history_substring_search_result=$BUFFER

  # the search was succesful so display the result properly by clearing away
  # existing highlights and moving the cursor to the end of the result buffer
  if [[ $_history_substring_search_refresh_display -eq 1 ]]; then
    region_highlight=()
    CURSOR=${#BUFFER}
  fi

  # highlight command line using zsh-syntax-highlighting
  _zsh_highlight

  # highlight the search query inside the command line
  if [[ -n $_history_substring_search_query_highlight && -n $_history_substring_search_query ]]; then
    : ${(S)BUFFER##(#m$HISTORY_SUBSTRING_SEARCH_GLOBBING_FLAGS)($_history_substring_search_query##)}
    local begin=$(( MBEGIN - 1 ))
    local end=$(( begin + $#_history_substring_search_query ))
    region_highlight+=("$begin $end $_history_substring_search_query_highlight")
  fi

  return 0
}

function _history-substring-search-up-buffer() {
  local buflines XLBUFFER xlbuflines
  buflines=(${(f)BUFFER})
  XLBUFFER=$LBUFFER"x"
  xlbuflines=(${(f)XLBUFFER})

  if [[ $#buflines -gt 1 && $CURSOR -ne $#BUFFER && $#xlbuflines -ne 1 ]]; then
    zle up-line-or-history
    return 0
  fi

  return 1
}

function _history-substring-search-down-buffer() {
  local buflines XRBUFFER xrbuflines
  buflines=(${(f)BUFFER})
  XRBUFFER="x"$RBUFFER
  xrbuflines=(${(f)XRBUFFER})

  if [[ $#buflines -gt 1 && $CURSOR -ne $#BUFFER && $#xrbuflines -ne 1 ]]; then
    zle down-line-or-history
    return 0
  fi

  return 1
}

function _history-substring-search-up-history() {
  #
  # Behave like up in ZSH, except clear the $BUFFER
  # when beginning of history is reached like in Fish.
  #
  if [[ -z $_history_substring_search_query ]]; then

    # we have reached the absolute top of history
    if [[ $HISTNO -eq 1 ]]; then
      BUFFER=

    # going up from somewhere below the top of history
    else
      zle up-line-or-history
    fi

    return 0
  fi

  return 1
}

function _history-substring-search-down-history() {
  if [[ -z $_history_substring_search_query ]]; then

    # going down from the absolute top of history
    if [[ $HISTNO -eq 1 && -z $BUFFER ]]; then
      BUFFER=${history[1]}
      _history_substring_search_refresh_display=1

    # going down from somewhere above the bottom of history
    else
      zle down-line-or-history
    fi

    return 0
  fi

  return 1
}

function _history-substring-search-not-found() {
  _history_substring_search_old_buffer=$BUFFER
  BUFFER=$_history_substring_search_query
  _history_substring_search_query_highlight=$HISTORY_SUBSTRING_SEARCH_HIGHLIGHT_NOT_FOUND
}

function _history-substring-search-up-search() {
  _history_substring_search_refresh_display=1
  if [[ $_history_substring_search_match_index -ge 2 ]]; then
    (( _history_substring_search_match_index-- ))
    BUFFER=$history[$_history_substring_search_matches[$_history_substring_search_match_index]]
    _history_substring_search_query_highlight=$HISTORY_SUBSTRING_SEARCH_HIGHLIGHT_FOUND

  elif [[ $_history_substring_search_match_index -eq 1 ]]; then
    (( _history_substring_search_match_index-- ))
    _history-substring-search-not-found

  elif [[ $_history_substring_search_match_index -eq $_history_substring_search_matches_count_plus ]]; then
    (( _history_substring_search_match_index-- ))
    BUFFER=$_history_substring_search_old_buffer
    _history_substring_search_query_highlight=$HISTORY_SUBSTRING_SEARCH_HIGHLIGHT_FOUND

  else
    _history-substring-search-not-found
  fi
}

function _history-substring-search-down-search() {
  _history_substring_search_refresh_display=1
  if [[ $_history_substring_search_match_index -le $_history_substring_search_matches_count_sans ]]; then
    (( _history_substring_search_match_index++ ))
    BUFFER=$history[$_history_substring_search_matches[$_history_substring_search_match_index]]
    _history_substring_search_query_highlight=$HISTORY_SUBSTRING_SEARCH_HIGHLIGHT_FOUND

  elif [[ $_history_substring_search_match_index -eq $_history_substring_search_matches_count ]]; then
    (( _history_substring_search_match_index++ ))
    _history-substring-search-not-found

  elif [[ $_history_substring_search_match_index -eq 0 ]]; then
    (( _history_substring_search_match_index++ ))
    BUFFER=$_history_substring_search_old_buffer
    _history_substring_search_query_highlight=$HISTORY_SUBSTRING_SEARCH_HIGHLIGHT_FOUND

  else
    _history-substring-search-not-found
  fi
}
# }}}

# {{{ amazon

# credentials
export EC2_PRIVATE_KEY="$(/bin/ls $HOME/.ec2/asit/pk-*.pem)"
export EC2_CERT="$(/bin/ls $HOME/.ec2/asit/cert-*.pem)"
export AWS_CREDENTIAL_FILE=$HOME/.secrets/.aws-credentials-pass

# ec2-api-tools
export EC2_HOME="/usr/local/Library/LinkedKegs/ec2-api-tools/jars"
# ec2-ami-tools
export EC2_AMITOOL_HOME="/usr/local/Library/LinkedKegs/ec2-ami-tools/jars"
# aws-iam-tools
export AWS_IAM_HOME="/usr/local/Cellar/aws-iam-tools/1.5.0/jars"
# aws-cfn-tools
export AWS_CLOUDFORMATION_HOME="/usr/local/Cellar/aws-cfn-tools/1.0.8/jars"
# elb-tools
export AWS_ELB_HOME="/usr/local/Cellar/elb-tools/1.0.12.0/jars"

# }}}

# {{{ virtualenvs
#export WORKON_HOME=$HOME/.virtualenvs
#source /usr/local/bin/virtualenvwrapper.sh
# }}}

# {{{ tmuxinator
[[ -s $HOME/.tmuxinator/scripts/tmuxinator ]] && source $HOME/.tmuxinator/scripts/tmuxinator
# }}}

export ANDROID_HOME=$HOME/work/tools/android-sdk-linux/
export AIR_ANDROID_SDK_HOME=$HOME/work/tools/android-sdk-linux/

export ICE_HOME=/usr/local/Ice

if [ "`uname`" = "Darwin" ]; then
  compctl -f -x 'p[2]' -s "`/bin/ls -d1 /Applications/*/*.app /Applications/*.app $HOME/Applications/*/*.app $HOME/Applications/*.app | sed 's|^.*/\([^/]*\)\.app.*|\\1|;s/ /\\\\ /g'`" -- open alias run='open -a'
fi

if [ "`uname`" = "Darwin" ]; then
  #TODO: WTF
  #eval `direnv hook $-1`
fi

eval "$(fasd --init auto)"

[[ -s "$HOME/.secrets/.zshrc_secret" ]] && . "$HOME/.secrets/.zshrc_secret"  # secrets

export PATH=$PATH:$HOME/.rvm/bin # Add RVM to PATH for scripting
source $HOME/.rvm/scripts/rvm

