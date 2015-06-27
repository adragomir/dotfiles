# fpath {{{
export ZSH=$HOME/.zsh
fpath=($ZSH $fpath)
fpath=(/usr/local/share/zsh-completions $fpath)
# }}}

# {{{ modules
zmodload zsh/datetime
zmodload zsh/mathfunc
zmodload -i zsh/complist
zmodload -F zsh/parameter
zmodload zsh/termcap
zmodload zsh/terminfo
zmodload zsh/net/socket
zmodload zsh/net/tcp
zmodload zsh/system
zmodload zsh/attr
zmodload zsh/pcre
zmodload zsh/regex
# }}}

# autoload {{{
autoload add-zsh-hook
autoload -U colors && colors  # Enables colours
autoload -U compinit && compinit -d "$ZSH/cache/zcompdump-$HOST"
autoload -U url-quote-magic
autoload allopt
autoload -U zcalc
# }}}

# 256 colors sykora {{{
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

# Show all 256 colors with color number
function spectrum_ls() {
  for code in {000..255}; do
    print -P -- "$code: %F{$code}Test%f"
  done
}
# }}}

# settings {{{

# general
setopt NO_BEEP
export KEYTIMEOUT=0
setopt AUTO_CD
setopt AUTO_PUSHD
setopt CDABLE_VARS
setopt IGNORE_EOF
setopt INTERACTIVE_COMMENTS
setopt PROMPT_SUBST
setopt TRANSIENT_RPROMPT
setopt RM_STAR_SILENT
setopt C_BASES
unsetopt FLOW_CONTROL
setopt PRINT_EIGHT_BIT
setopt NO_CORRECT
setopt NO_CORRECT_ALL
setopt EXTENDED_GLOB
setopt CLOBBER

# completion
unsetopt MENU_COMPLETE   # do not autoselect the first completion entry
unsetopt AUTO_MENU         # show completion menu on succesive tab press
setopt COMPLETE_IN_WORD
setopt ALWAYS_TO_END
setopt NOMATCH
setopt COMPLETE_IN_WORD
setopt LIST_PACKED
setopt LIST_TYPES # Show types in completion
setopt REC_EXACT # Recognize exact, ambiguous matches
setopt AUTO_NAME_DIRS
setopt PUSHD_IGNORE_DUPS
setopt PUSHD_SILENT
setopt PUSHD_TO_HOME

WORDCHARS='*?[]~&;!$%^<>'
WORDCHARS=${WORDCHARS//[&=\/;\!#?[]~&;!$%^<>%\{]}

# history settings {{{
HISTFILE=$HOME/.history/.zsh_history
HISTSIZE=10000
SAVEHIST=10000

setopt HIST_FIND_NO_DUPS
setopt HIST_IGNORE_ALL_DUPS # ignore duplication command history list
setopt SHARE_HISTORY # share command history data
setopt HIST_VERIFY
setopt INC_APPEND_HISTORY
setopt EXTENDED_HISTORY
setopt HIST_EXPIRE_DUPS_FIRST
setopt HIST_IGNORE_SPACE
setopt APPEND_HISTORY
setopt LONG_LIST_JOBS
# }}}

# }}}

# {{{ completions 
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'
# zstyle ':completion:*' matcher-list '' \
#   'm:{a-z\-}={A-Z\_}' \
#   'r:[^[:alpha:]]||[[:alpha:]]=** r:|=* m:{a-z\-}={A-Z\_}' \
#   'r:[[:ascii:]]||[[:ascii:]]=** r:|=* m:{a-z\-}={A-Z\_}'zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'
zstyle ':completion:*' users $USER
zstyle ':completion:*' list-colors ''
zstyle ':completion:*' squeeze-slashes true
zstyle ':completion:*:*:*:*:*' menu select
zstyle ':completion:*' squeeze-slashes true
zstyle ':completion:*' select-prompt '%SScrolling active: current selection at %p%s'
zstyle ':completion:*:*:*:*:processes' command "ps -u `whoami` -o pid,user,comm -w -w"
zstyle ':completion:*:*:*:*:processes*'    force-list always
zstyle ':completion:*:functions' ignored-patterns '_*'
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

# zstyle ':completion:*:hosts' hosts $hosts
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
# Force file name completion on C-x TAB, Shift-TAB.
zle -C complete-files complete-word _generic
zstyle ':completion:complete-files:*' completer _files
zstyle ':completion:complete-first:*' menu yes
zstyle -e :urlglobber url-other-schema '[[ $words[1] == scp ]] && reply=("*") || reply=(http https ftp)'
# }}}

# hooks {{{
function preexec {
  emulate -L zsh
  local -a cmd; cmd=(${(z)1})
}
# }}}

# key bindings {{{

eval "insert-cycledleft () { zle push-line; LBUFFER='pushd -q +1'; zle accept-line }"
zle -N insert-cycledleft
bindkey "\e[1;6D" insert-cycledleft
eval "insert-cycledright () { zle push-line; LBUFFER='pushd -q -0'; zle accept-line }"
zle -N insert-cycledright
bindkey "\e[1;6C" insert-cycledright

function _backward_kill_default_word() {
  WORDCHARS='*?_-.[]~=/&;!#$%^(){}<>' zle backward-kill-word
}
zle -N backward-kill-default-word _backward_kill_default_word

bindkey '\e=' backward-kill-default-word   # = is next to backspace
bindkey "^[[Z" complete-files

# should this be in keybindings DISABLED
# zle -C complete-menu menu-select _generic
# _complete_menu() {
#   setopt localoptions alwayslastprompt
#   zle complete-menu
# }
# zle -N _complete_menu
# bindkey '^F' _complete_menu
# bindkey -M menuselect '^o' accept-and-infer-next-history
# bindkey -M menuselect '^F' accept-and-infer-next-history
# bindkey -M menuselect '/'  accept-and-infer-next-history
# bindkey -M menuselect '^?' undo
# bindkey -M menuselect '*' history-incremental-search-forward

autoload -U edit-command-line
zle -N edit-command-line
bindkey '\C-x\C-e' edit-command-line

_completeme() {
  zle -I
  TMPFILE=`mktemp 2> /dev/null || mktemp -t completeme 2> /dev/null`
  completeme $TMPFILE
  test -e $TMPFILE
  source $TMPFILE
  rm -f $TMPFILE
}
zle -N _completeme

_selecta() {
  zle -I
  result=$( pt -l --nocolor -g . | selecta )
  RBUFFER="$result "
  CURSOR+=$#RBUFFER
}

function insert-selecta-path-in-command-line() {
    local selected_path
    # Print a newline or we'll clobber the old prompt.
    echo
    # Find the path; abort if the user doesn't select anything.
    selected_path=$(find * -type f | selecta) || return
    # Append the selection to the current command buffer.
    eval 'LBUFFER="$LBUFFER$selected_path"'
    # Redraw the prompt since Selecta has drawn several new lines of text.
    zle reset-prompt
}
# Create the zle widget
zle -N insert-selecta-path-in-command-line
# Bind the key to the newly created widget
bindkey "^S" "insert-selecta-path-in-command-line"

zle -N _selecta
bindkey "\C-t" _selecta

function p() {
    proj=$(cat ~/.projects | awk '{print $1}' | selecta)
    if [[ -n "$proj" ]]; then
        cd $(cat ~/.projects | grep "^$proj" | awk '{print $2}')
    fi
}

autoload -Uz narrow-to-region
function _history-incremental-preserving-pattern-search-backward {
  local state
  MARK=CURSOR  # magick, else multiple ^R don't work
  narrow-to-region -p "$LBUFFER${BUFFER:+>>}" -P "${BUFFER:+<<}$RBUFFER" -S state
  zle end-of-history
  zle history-incremental-pattern-search-backward
  narrow-to-region -R state
}
zle -N _history-incremental-preserving-pattern-search-backward
#bindkey "^r" _history-incremental-preserving-pattern-search-backward

# http://qiita.com/uchiko/items/f6b1528d7362c9310da0
function _selecta-select-history() {
    local selected_entry
    # Print a newline or we'll clobber the old prompt.
    echo
    # Find the path; abort if the user doesn't select anything.
    selected_entry=$(history | selecta) || return
    # Append the selection to the current command buffer.
    eval 'LBUFFER="$LBUFFER$selected_entry"'
    # Redraw the prompt since Selecta has drawn several new lines of text.
    zle reset-prompt
}
zle -N _selecta-select-history

function _peco-select-history() {
    local tac
    if which gtac > /dev/null; then
        tac="gtac"
    else
        tac="tail -r"
    fi
    BUFFER=$(\history -n 1 | \
        eval $tac | \
        peco --query "$LBUFFER")
    CURSOR=$#BUFFER
    zle clear-screen
}
zle -N _peco-select-history
bindkey '^h' _selecta-select-history

bindkey -e
bindkey '\ew' kill-region
bindkey -M isearch "^r" history-incremental-pattern-search-backward
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

bindkey "\e[1;3D" backward-word
bindkey "\e3D" backward-word
bindkey '^[5D' backward-word
bindkey '^[[5D' backward-word
bindkey "\e[1;3C" forward-word
bindkey "\e3C" forward-word
bindkey '^[5C' forward-word
bindkey '^[[5C' forward-word
bindkey '^[[3~' delete-char

_physical_up_line()   { zle backward-char -n $COLUMNS }
_physical_down_line() { zle forward-char  -n $COLUMNS }
zle -N physical-up-line _physical_up_line
zle -N physical-down-line _physical_down_line
bindkey "\e\e[A" physical-up-line
bindkey "\e\e[B" physical-down-line

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

# file rename magick
bindkey "^[m" copy-prev-shell-word
zle -N self-insert url-quote-magic
# }}}

# functions {{{

tree() {
  find . | sed -e 's/[^\/]*\//|--/g' -e 's/-- |/    |/g' | $PAGER
}

title() {
  if [[ $TERM == "screen" ]]; then
    # Use these two for GNU Screen:
    print -nR $'\033k'$1$'\033'\\\

    print -nR $'\033]0;'$2$'\a'
  elif [[ ($TERM =~ "^xterm") ]] || [[ ($TERM == "rxvt") ]]; then
    # Use this one instead for XTerms:
    print -nR $'\033]0;'$*$'\a'
  fi
}

bases() {
  # Determine base of the number
  for i      # ==> in [list] missing...
  do         # ==> so operates on command line arg(s).
  case "$i" in
    0b*)    ibase=2;;  # binary
    0x*|[a-f]*|[A-F]*)  ibase=16;;  # hexadecimal
    0*)      ibase=8;;  # octal
    [1-9]*)    ibase=10;;  # decimal
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
    [0-9]*)  ;;       # number ok
    *)    continue;;     # error: ignore
  esac

  # Print all conversions in one line.
  # ==> 'here document' feeds command list to 'bc'.
  echo `bc <<!
      obase=16; "hex="; $dec
      obase=10; "dec="; $dec
      obase=8;  "oct="; $dec
      obase=2;  "bin="; $dec
!
    ` | sed -e 's: :  :g'
    done
}

up() {
  local op=print
  [[ -t 1 ]] && op=cd
  case "$1" in
    '') up 1;;
    -*|+*) $op ~$1;;
    <->) $op $(printf '../%.0s' {1..$1});;
    *) local -a seg; seg=(${(s:/:)PWD%/*})
       local n=${(j:/:)seg[1,(I)$1*]}
       if [[ -n $n ]]; then
         $op /$n
       else
         print -u2 up: could not find prefix $1 in $PWD
         return 1
       fi
  esac
}

zman() {
  PAGER="less -g -s '+/^       "$1"'" man zshall
}

zsh_stats() {
  history | awk '{print $2}' | sort | uniq -c | sort -rn | head
}

function up() {
    local DIR=$PWD
    local TARGET=$1
    while [ ! -e $DIR/$TARGET -a $DIR != "/" ]; do
        DIR=$(dirname $DIR)
    done
    test $DIR != "/" && echo $DIR/$TARGET
}

function allopen() {
  if [[ "$OSTYPE" = darwin* ]]; then
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

l() {
  local p=$argv[-1]
  [[ -d $p ]] && { argv[-1]=(); } || p='.'
  find $p ! -type d | sed 's:^./::' | egrep "${@:-.}"
}

lr() {
  zparseopts -D -E S=S t=t r=r h=h U=U l=l F=F d=d
  local sort="sort -t/ -k2"                                # by name (default)
  local numfmt="cat"
  local long='s:[^/]* /::; s:^\./\(.\):\1:;'               # strip detail
  local classify=''
  [[ -n $F ]] && classify='/^d/s:$:/:; /^-[^ ]*x/s:$:*:;'  # dir/ binary*
  [[ -n $l ]] && long='s: /\./\(.\): \1:; s: /\(.\): \1:;' # show detail
  [[ -n $S ]] && sort="sort -n -k5"                        # by size
  [[ -n $r ]] && sort+=" -r"                               # reverse
  [[ -n $t ]] && sort="sort -k6" && { [[ -n $r ]] || sort+=" -r" } # by date
  [[ -n $U ]] && sort=cat                                  # no sort, live output
  [[ -n $h ]] && numfmt="numfmt --field=5 --to=iec --padding=6"  # human fmt
  [[ -n $d ]] && set -- "$@" -prune                        # don't enter dirs
  find "$@" -printf "%M %2n %u %g %9s %TY-%Tm-%Td %TH:%TM /%p -> %l\n" |
    $=sort | $=numfmt |
    sed '/^[^l]/s/ -> $//; '$classify' '$long
}

function autoenv_chpwd_hook() {
  local env_file="$PWD/.env"
  local unenv_file="${dirstack[1]}/.unenv"
  if [[ -f $unenv_file ]]; then
      source $unenv_file
  fi
  if [[ -f $env_file ]]; then
      source $env_file
      return 0
  fi
}
add-zsh-hook chpwd autoenv_chpwd_hook

function getwanip() {
  wget -q -O- www.showmyip.com/xml | xml2 | grep '/ip_address/ip=' | cut -d= -f2
  curl -s http://checkip.dyndns.org | awk '{print $6}' | awk ' BEGIN { FS = "<" } { print $1 } '
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

# }}}

# prompt settings {{{

# Load the theme
# PROMPT=$'$(prompt_exit_code $?)$(prompt_user_host)$(prompt_job_counts)$(prompt_folder)$(prompt_repo_status)\
# $(prompt_actual)'
# PROMPT2=$'%_$(prompt_actual)'

prompt_job_counts() {
  local running=$(( $(jobs -r | wc -l) ))
  local stopped=$(( $(jobs -s | wc -l) ))
  local n_screen=$(screen -ls 2> /dev/null | grep -c Detach)
  local n_tmux=$(tmux list-sessions 2> /dev/null | grep -cv attached)
  local detached=$(( $n_screen + $n_tmux ))
  local m_detached="d"
  local m_stop="z"
  local m_run="&"
  local ret=""

  if [[ $detached != "0" ]] ; then
    ret="${ret}${DETACHED_JOB_COLOR}${detached}${m_detached}${FX[reset]}"
  fi

  if [[ $running != "0" ]] ; then
    if [[ $ret != "" ]] ; then ret="${ret}/"; fi
    ret="${ret}${RUNNING_JOB_COLOR}${running}${m_run}${FX[reset]}"
  fi

  if [[ $stopped != "0" ]] ; then
    if [[ $ret != "" ]] ; then ret="${ret}/"; fi
    ret="${ret}${STOPPED_JOB_COLOR}${stopped}${m_stop}${FX[reset]}"
  fi
  echo $ret
}

prompt_pure_human_time() {
  local tmp=$1
  local days=$(( tmp / 60 / 60 / 24 ))
  local hours=$(( tmp / 60 / 60 % 24 ))
  local minutes=$(( tmp / 60 % 60 ))
  local seconds=$(( tmp % 60 ))
  (( $days > 0 )) && echo -n "${days}d "
  (( $hours > 0 )) && echo -n "${hours}h "
  (( $minutes > 0 )) && echo -n "${minutes}m "
  echo "${seconds}s"
}

# fastest possible way to check if repo is dirty
prompt_pure_git_dirty() {
  # check if we're in a git repo
  command git rev-parse --is-inside-work-tree &>/dev/null || return
  # check if it's dirty
  [[ "$PURE_GIT_UNTRACKED_DIRTY" == 0 ]] && local umode="-uno" || local umode="-unormal"
  test -n "$(git status --porcelain --ignore-submodules ${umode})"

  (($? == 0)) && echo '*'
}

# displays the exec time of the last command if set threshold was exceeded
prompt_pure_cmd_exec_time() {
  local stop=$EPOCHSECONDS
  local start=${cmd_timestamp:-$stop}
  integer elapsed=$stop-$start
  (($elapsed > ${PURE_CMD_MAX_EXEC_TIME:=5})) && prompt_pure_human_time $elapsed
}

prompt_pure_preexec() {
  cmd_timestamp=$EPOCHSECONDS

  # shows the current dir and executed command in the title when a process is active
  print -Pn "\e]0;"
  echo -nE "$PWD:t: $2"
  print -Pn "\a"
}

# string length ignoring ansi escapes
prompt_pure_string_length() {
  echo ${#${(S%%)1//(\%([KF1]|)\{*\}|\%[Bbkf])}}
}

prompt_pure_precmd() {
  # shows the full path in the title
  print -Pn '\e]0;%~\a'

  # git info
  vcs_info

  local prompt_pure_preprompt="\n%F{blue}%~%F{242}$vcs_info_msg_0_`prompt_pure_git_dirty` $prompt_pure_username%f %F{yellow}`prompt_pure_cmd_exec_time`%f"
  print -P $prompt_pure_preprompt

  # check async if there is anything to pull
  (( ${PURE_GIT_PULL:-1} )) && {
    # check if we're in a git repo
    command git rev-parse --is-inside-work-tree &>/dev/null &&
    # make sure working tree is not $HOME
    [[ "$(command git rev-parse --show-toplevel)" != "$HOME" ]] &&
    # check check if there is anything to pull
    command git fetch &>/dev/null &&
    # check if there is an upstream configured for this branch
    command git rev-parse --abbrev-ref @'{u}' &>/dev/null && {
      local arrows=''
      (( $(command git rev-list --right-only --count HEAD...@'{u}' 2>/dev/null) > 0 )) && arrows='⇣'
      (( $(command git rev-list --left-only --count HEAD...@'{u}' 2>/dev/null) > 0 )) && arrows+='⇡'
      print -Pn "\e7\e[A\e[1G\e[`prompt_pure_string_length $prompt_pure_preprompt`C%F{cyan}${arrows}%f\e8"
    }
  } &!

  # reset value since `preexec` isn't always triggered
  unset cmd_timestamp
}


prompt_pure_setup() {
  # prevent percentage showing up
  # if output doesn't end with a newline
  export PROMPT_EOL_MARK=''

  prompt_opts=(cr subst percent)

  zmodload zsh/datetime
  autoload -Uz add-zsh-hook
  autoload -Uz vcs_info

  add-zsh-hook precmd prompt_pure_precmd
  add-zsh-hook preexec prompt_pure_preexec

  zstyle ':vcs_info:*' enable git
  #zstyle ':vcs_info:*' check-for-changes true
  zstyle ':vcs_info:git*:*' get-revision true
  zstyle ':vcs_info:git*' formats ' %b %6.6i'
  zstyle ':vcs_info:git*' actionformats ' %b %6.6i|%a'

  # show username@host if logged in through SSH
  [[ "$SSH_CONNECTION" != '' ]] && prompt_pure_username='%n@%m '

  # prompt turns red if the previous command didn't exit with 0
  PROMPT='%(?.%F{magenta}.%F{red})❯%f '
}

prompt_pure_setup "$@"

# }}}

# program settings & paths {{{
export OS=`uname | tr "[:upper:]" "[:lower:]"`
# ls
export LSCOLORS="gxfxcxdxbxegedabagacad"
export LSCOLORS="ExGxBxDxCxEgEdxbxgxcxd"

# grep
export GREP_OPTIONS='--color=auto'
export GREP_COLOR='1;32'
export GREP_COLORS="38;5;230:sl=38;5;240:cs=38;5;100:mt=38;5;161:fn=38;5;197:ln=38;5;212:bn=38;5;44:se=38;5;166"

# scons
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
export MAVEN_OPTS="-Djava.awt.headless=true"
export JAVA_TOOL_OPTIONS='-Djava.awt.headless=true'
export MVN_OPTS="-Djava.awt.headless=true"

#export LESS='-fXemPm?f%f .?lbLine %lb?L of %L..:$' # Set options for less command
export LESS="-rX"
export PAGER=less

if [[ "$OSTYPE" = darwin* ]]; then
  export EDITOR=/usr/local/bin/vim
  export GIT_EDITOR=/usr/local/bin/vim
else
  export EDITOR=/usr/bin/vim
  export GIT_EDITOR=/usr/bin/vim
fi

export GIST_URL='git.corp.adobe.com/api/v3'

export VISUAL='vim'
export INPUTRC=~/.inputrc

# locale
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

# perl
export VERSIONER_PERL_PREFER_32_BIT=yes
export PERL_BADLANG=0

if [ $OS = "linux" ];
then
  export PERL_LOCAL_LIB_ROOT=$HOME/.perl5
  export PERL_MB_OPT="--install_base $HOME/.perl5";
  export PERL_MM_OPT="INSTALL_BASE=$HOME/.perl5";
  export PERL5LIB="$HOME/.perl5/lib/perl5/x86_64-linux-gnu-thread-multi:$HOME/.perl5/lib/perl5";
fi

# ice
export ICE_HOME=/usr/local/Ice

export DISPLAY=:0.0

# hla
export hlalib=/usr/hla/hlalib
export hlainc=/usr/hla/include

# colors in terminal
export CLICOLOR=1

# p4
export P4CONFIG=.p4conf

# html tidy
export HTML_TIDY=$HOME/.tidyconf

# ansible
export ANSIBLE_HOSTS=~/.ansible/hosts

export MONO_GAC_PREFIX=/usr/local

# haxe
if [[ "$OSTYPE" = darwin* ]]; then
    export HAXE_LIBRARY_PATH="$(/usr/local/bin/brew --prefix)/share/haxe/std"
fi
#export NEKOPATH=/usr/local/neko

# java
if [[ "$OSTYPE" = darwin* ]]; then
  export JENV_ROOT=/usr/local/opt/jenv
  if which jenv > /dev/null; then eval "$(jenv init -)"; fi
  export JAVA_HOME=$(readlink /usr/local/opt/jenv/versions/`cat /usr/local/opt/jenv/version`)
  #export JAVA_HOME="$(/usr/libexec/java_home -v 1.6.0_43-b01-447)"
else
  export JAVA_HOME=/usr/lib/jvm/java-6-sun/
fi

# scala
export SCALA_HOME=/usr/local/opt/scala

# luatex
#export TEXMFCNF=/usr/local/texlive/2008/texmf/web2c/
#export LUAINPUTS='{/usr/local/texlive/texmf-local/tex/context/base,\
#  /usr/local/texlive/texmf-local/scripts/context/lua,$HOME/texmf/scripts/context/lua}'
#export TEXMF='{\
#$HOME/.texlive2008/texmf-config,\
#$HOME/.texlive2008/texmf-var,\
#$HOME/texmf,\
#/usr/local/texlive/2008/texmf-config,\
#/usr/local/texlive/2008/texmf-var,\
#/usr/local/texlive/2008/texmf,\
#/usr/local/texlive/texmf-local,\
#/usr/local/texlive/2008/texmf-dist,\
#/usr/local/texlive/2008/texmf.gwtex\
#}'
export TEXMFCACHE=/tmp
#export TEXMFCNF=/usr/local/texlive/2008/texmf/web2c

export SAASBASE_HOME=$HOME/work/s
# source $HOME/work/s/services/use-hadoop-2
# export HBASE_HOME=$HOME/work/s/hbase
# export ZOOKEEPER_HOME=$HOME/work/s/zookeeper
export STORM_HOME=$HOME/work/s/storm
export KAFKA_HOME=$HOME/work/s/kafka

# saasbase
export SAASBASE_DB_HOME=$HOME/work/s/db/db
export SAASBASE_ANALYTICS_HOME=$HOME/work/s/saasbase/analytics
export SAASBASE_DATAROOT=/var

if [[ "$OSTYPE" = darwin* ]]; then
  export VIMRUNTIME=$HOME/Applications/MacVim.app/Contents/Resources/vim/runtime/
fi  
export ENSIMEHOME=/Users/adr/work/tools/ensime/

# go

if [ "" = "${ALREADY_GLIDING}" ]; then
  export GOPATH=$HOME/.gocode
fi
# {{{ amazon

# credentials
export EC2_CERT_PAIR=pass
if [ -d $HOME/.ec2/$EC2_CERT_PAIR ]; then
  export AWS_CREDENTIAL_FILE=$HOME/.ec2/$EC2_CERT_PAIR/.aws-credentials
  export AWS_ACCESS_KEY_ID=$(cat $AWS_CREDENTIAL_FILE | grep AWSAccessKeyId | sed 's/^.*=//')
  export AWS_ACCESS_KEY=$AWS_ACCESS_KEY_ID
  export AWS_SECRET_ACCESS_KEY="$(cat $AWS_CREDENTIAL_FILE | grep AWSSecretKey | sed 's/^.*=//')"
  export AWS_SECRET_KEY=$AWS_SECRET_ACCESS_KEY
  export AWS_USER="$(cat $AWS_CREDENTIAL_FILE | grep AWSUser | sed 's/^.*=//')"
  export AWS_CONFIG_FILE=$HOME/.ec2/$EC2_CERT_PAIR/.awscli
fi

# ec2-api-tools
export EC2_HOME="/usr/local/Library/LinkedKegs/ec2-api-tools/libexec"
# ec2-ami-tools
export EC2_AMITOOL_HOME="/usr/local/Library/LinkedKegs/ec2-ami-tools/libexec/"
# aws-iam-tools
export AWS_IAM_HOME="/usr/local/Library/LinkedKegs/aws-iam-tools"
# aws-cfn-tools
export AWS_CLOUDFORMATION_HOME="/usr/local/Library/LinkedKegs/aws-cfn-tools"
# elb-tools
export AWS_ELB_HOME="/usr/local/Library/LinkedKegs/elb-tools"
# auto scaling
export AWS_AUTO_SCALING_HOME="/usr/local/Library/LinkedKegs/auto-scaling"

# }}}

# esp8266 {{{
export XTENSA_TOOL_ROOT=/usr/local/Cellar/xtensa-lx106-elf
export XTENSA_TOOL_BIN=/usr/local/Cellar/xtensa-lx106-elf/bin
export ESP8266_SDK_BASE=/usr/local/Cellar/xtensa-lx106-elf/esp_iot_sdk
export ESP8266_RTOS_SDK_BASE=/usr/local/Cellar/xtensa-lx106-elf/esp_iot_rtos_sdk
#}}}

[[ -f $HOME/.rvm/scripts/rvm ]] && source $HOME/.rvm/scripts/rvm

# path {{{
export PATH=\
/usr/local/bin:\
/usr/local/sbin:\
/usr/local/share/npm/bin:\
$HOME/bin:\
$HOME/bin/$OS:\
$SAASBASE_HOME/services:\
$HOME/.cabal/bin:\
$HOME/temp/source/other/sshuttle:\
$HOME/temp/source/other/factor:\
$HOME/work/tools/nasm:\
$HOME/temp/source/other/rock/bin:\
$HOME/Applications/emulator/n64/mupen64plus-1.99.4-osx/x86_64:\
$HOME/.rvm/bin:\
$HOME/.perl5/bin:\
$GOPATH/bin:\
$GOPATH/src/github.com/mitchellh/packer/pkg/darwin_amd64:\
/usr/local/openresty/nginx/sbin:\
/usr/local/openresty/luajit/bin:\
$PATH

# }}}
#
# plan 9 {{{

# * Add these to your profile environment.
export PLAN9=/usr/local/Cellar/plan9/HEAD
export PATH=${PATH}:${PLAN9}/bin
# }}}

# man path {{{
export MANPATH=\
/usr/local/man:\
$MANPATH
# }}}

# }}}

# aliases {{{
alias -s com=urlopen
alias -s org=urlopen
alias -s net=urlopen
alias -s io=urlopen

#alias ack="ack -i -a"
alias v="view -"
alias vidir="EDITOR=v vidir"
alias gvim="g"
alias h=" history | tail -n 10 | cut -d' ' -f3-"
alias luarocks="luarocks --tree=user"

# clojure
alias clojure='rlwrap java -cp $MAVEN_REPO/org/clojure/clojure/1.4.0/clojure-1.4.0.jar:\
$MAVEN_REPO/org/clojure/clojure-contrib/1.2.0/clojure-contrib-1.2.0.jar clojure.main'

# builtin commands

# make top default to ordering by CPU usage:
alias top='top -ocpu'
# more lightweight version of top which doesn't use so much CPU itself:
alias ttop='top -ocpu -R -F -s 2 -n30'

# ls
#alias l="ls -AGlFT"
alias la='ls -A'
alias lt="ls -AGlFTtr"
alias lc="cl"
alias mkdir='mkdir -p'
alias finde='find -E'
alias df='df -h'
alias du='du -h -c'
alias psa='ps auxwww'
alias ping='ping -c 5'
alias grep='grep --colour -a'
alias irb='pry'
alias ri='ri -Tf ansi'
alias tu='top -o cpu'
alias tm='top -o vsize'

# hadoop, hbase, etc
# alias hbase='$HBASE_HOME/bin/hbase'
# alias zk='$ZOOKEEPER_HOME/bin/zkCli.sh'
alias storm='$STORM_HOME/bin/storm'
alias psall='pgrep -l -f NameNode DataNode TaskTracker JobTracker Quorum HMaster HRegion ThriftServer \
  ReportServer storm.daemon.nimbus storm.ui.core'
alias d='dirs -v'

# Show history
alias history='fc -l 1'

alias dtrace-providers="sudo dtrace -l | perl -pe 's/^.*?\S+\s+(\S+?)([0-9]|\s).*/\1/' | sort | uniq"
#}}}

# plugins {{{
# zsh-reload.plugin.zsh
function reload() {
  local cache="$ZSH/cache"
  autoload -U compinit zrecompile
  compinit -d "$cache/zcomp-$HOST"

  for f in ~/.zshrc "$cache/zcomp-$HOST"; do
    zrecompile -p $f && command rm -f $f.zwc.old
  done

  source ~/.zshrc
}
# }}}

# final settings {{{
[[ -s $HOME/.tmuxinator/scripts/tmuxinator ]] && source $HOME/.tmuxinator/scripts/tmuxinator

source $ZSH/golang.plugin.zsh
source $ZSH/url-tools.plugin.zsh
source $ZSH/history-substring-search.zsh
source /usr/local/share/zsh/site-functions/_aws

[[ -s "$HOME/.secrets/.zshrc_secret" ]] && . "$HOME/.secrets/.zshrc_secret"  # secrets


# }}}
#vim:foldmethod=marker
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

export DOCKER_TLS_VERIFY=1
export DOCKER_HOST=tcp://192.168.59.103:2376
export DOCKER_CERT_PATH=/Users/adr/.boot2docker/certs/boot2docker-vm

export LUA_PATH='/Users/adr/.luarocks/share/lua/5.2/?.lua;/Users/adr/.luarocks/share/lua/5.2/?/init.lua;/usr/local/share/lua/5.2/?.lua;/usr/local/share/lua/5.2/?/init.lua;/usr/local/Cellar/luarocks/2.2.0_1/share/lua/5.2/?.lua;/usr/local/lib/lua/5.2/?.lua;/usr/local/lib/lua/5.2/?/init.lua;./?.lua'
export LUA_CPATH='/Users/adr/.luarocks/lib/lua/5.2/?.so;/usr/local/lib/lua/5.2/?.so;/usr/local/lib/lua/5.2/loadall.so;./?.so'
export LIBGUESTFS_PATH=/usr/local/share/libguestfs-appliance
export PATH="$HOME/.gobrew/bin:$PATH"
eval "$(gobrew init -)"
