# fpath {{{
export ZSH=$HOME/.zsh
fpath=($ZSH $fpath)
fpath=(/usr/local/share/zsh-completions $fpath)
# }}}

# {{{ modules
zmodload zsh/datetime
zmodload zsh/stat
zmodload zsh/mathfunc
zmodload -i zsh/complist
zmodload -F zsh/parameter
zmodload zsh/termcap
zmodload zsh/terminfo
zmodload zsh/net/socket
zmodload zsh/net/tcp
# }}}

# autoload {{{
autoload -U colors && colors  # Enables colours
autoload -U compinit && compinit
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
setopt no_beep
setopt auto_cd
setopt multios
setopt cdablevarS
setopt ignoreeof
setopt prompt_subst
setopt transient_rprompt

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

setopt auto_name_dirs
setopt auto_pushd
setopt pushd_ignore_dups

WORDCHARS=''
WORDCHARS=${WORDCHARS//[&=\/;\!#?[]~&;!$%^<>%\{]}

# history settings {{{
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
setopt long_list_jobs
# }}}

# }}}

# {{{ completions 
zstyle ':completion:*' matcher-list 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'
zstyle ':completion:*' list-colors ''
zstyle ':completion:*' squeeze-slashes true
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
# if [[ -r ~/.ssh/known_hosts ]]; then
#   _ssh_hosts=( ${${${${(f)"$(<$HOME/.ssh/known_hosts)"}:#[\|]*}%%\ *}%%,*} ) || _ssh_hosts=()
# fi
# if [[ -r /etc/hosts ]]; then
#   _etc_hosts=( ${(s: :)${(ps:\t:)${${(f)~~"$(</etc/hosts)"}%%\#*}##[:blank:]#[^[:blank:]]#}} ) || _etc_hosts=()
# fi
# hosts=(
#   "$_ssh_hosts[@]"
#   "$_etc_hosts[@]"
#   `hostname`
#   localhost
# )

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

# Changing/making/removing directory
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
# }}}

# key bindings {{{
function _backward_kill_default_word() {
  WORDCHARS='*?_-.[]~=/&;!#$%^(){}<>' zle backward-kill-word
}
zle -N backward-kill-default-word _backward_kill_default_word

bindkey '\e=' backward-kill-default-word   # = is next to backspace
bindkey "^W" complete-first
bindkey "^Q" complete-files
bindkey "^[[Z" complete-files

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

autoload -U edit-command-line
zle -N edit-command-line
bindkey '\C-x\C-e' edit-command-line

_completeme() {
  zle -I
  completeme
  echo $tmp
}
zle -N _completeme
bindkey "\C-t" _completeme

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
bindkey "^r" _history-incremental-preserving-pattern-search-backward

bindkey -e
bindkey '\ew' kill-region
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
up() {
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

zman() {
  PAGER="less -g -s '+/^       "$1"'" man zshall
}

zsh_stats() {
  history | awk '{print $2}' | sort | uniq -c | sort -rn | head
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

function cl() {
  cd "$@" && l;
}

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

hack() {
  CURRENT=$(current_git_branch)
  git checkout master
  git pull origin master
  git checkout ${CURRENT}
  git rebase master
  unset CURRENT
}
 
ship() {
  CURRENT=$(current_git_branch)
  git checkout master
  git merge ${CURRENT}
  git push origin master
  git checkout ${CURRENT}
  unset CURRENT
}

function pswhich {
  for i in $*; do
    grepstr=[${i[1,2]}]${i[2,${#i}]}
    tmp=`ps axwww | grep $grepstr | awk '{print $1}'`
    echo "${i}: ${tmp/\\n/,}"
  done
}

mkcd () {
  mkdir -p "$*"
  cd "$*"
}
# }}}

# prompt settings {{{

# get the name of the branch we are on

ERROR_COLOR="${FG[001]}"
UPTODATE_COLOR="${FG[002]}"
CHANGES_COLOR="${FG[009]}"
COMMITS_COLOR="${FG[011]}"
DIFF_COLOR="${FG[013]}"
USER_COLOR="${FG[013]}"
HOST_COLOR="${FG[011]}"
DIR_COLOR="${FG[011]}"
STOPPED_JOB_COLOR="${FG[008]}"
RUNNING_JOB_COLOR="${FG[002]}"
DETACHED_JOB_COLOR="${FG[226]}"
DETACHED_JOB_COLOR="${FG[226]}"
PROMPT_COLOR="${FG[011]}"

_escape() {
    printf "%q" "$*"
}

wrap_brackets() {
  if [[ ! -z "$1" ]] ; then
    echo -ne "[$1]"
  fi
}

prompt_exit_code() {
  if [[ "$1" -ne "0" ]]
  then
    wrap_brackets "${ERROR_COLOR}$1${FX[reset]}"
  fi
}

prompt_user_host() {
  local ret=""
  ret="${USER_COLOR}%n${FX[reset]}"
  ret="${ret}@"
  ret="${ret}${HOST_COLOR}%m${FX[reset]}"
  wrap_brackets $ret
}

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
  wrap_brackets $ret
}

prompt_folder() {
  local ret=""
  ret="${DIR_COLOR}${PWD/#$HOME/~}${FX[reset]}"
  wrap_brackets $ret
}

prompt_git_branch() {
  local gitdir
  gitdir="$(git rev-parse --git-dir 2>/dev/null)"
  [[ $? -ne 0 || ! $gitdir =~ (.*\/)?\.git.* ]] && return
  local branch="$(git symbolic-ref HEAD 2>/dev/null)"
  if [[ $? -ne 0 || -z "$branch" ]] ; then
      # In detached head state, use commit instead
      branch="$(git rev-parse --short HEAD 2>/dev/null)"
  fi
  [[ $? -ne 0 || -z "$branch" ]] && return
  branch="${branch#refs/heads/}"
  echo $(_escape "$branch")
}

prompt_repo_status() {
  local branch
  branch=$(prompt_git_branch)
  if [[ ! -z "$branch" ]] ; then
    local GD
    git diff --quiet >/dev/null 2>&1
    GD=$?

    local GDC
    git diff --cached --quiet >/dev/null 2>&1
    GDC=$?

    local has_untracked
    has_untracked=$(git status 2>/dev/null | grep '\(# Untracked\)')
    if [[ -z "$has_untracked" ]] ; then
      has_untracked=""
    else
      has_untracked="${CHANGES_COLOR}*${FX[reset]}"
    fi

    local has_stash
    has_stash=$(git stash list 2>/dev/null)
    if [[ -z "$has_stash" ]] ; then
      has_stash=""
    else
      has_stash="${COMMITS_COLOR}+${FX[reset]}"
    fi

    local remote
    remote="$(git config --get branch.${branch}.remote 2>/dev/null)"
    # if git has no upstream, use origin
    if [[ -z "$remote" ]]; then
      remote="origin"
    fi
    local remote_branch
    remote_branch="$(git config --get branch.${branch}.merge 2>/dev/null)"
    # without any remote branch, use the same name
    if [[ -z "$remote_branch" ]]; then
      remote_branch="$branch"
    fi

    local has_commit
    has_commit=0
    if [[ -n "$remote" && -n "$remote_branch" ]] ; then
      has_commit=$(git rev-list --no-merges --count $remote/${remote_branch}..${branch} 2>/dev/null)
      if [[ -z "$has_commit" ]] ; then
        has_commit=0
      fi
    fi
    if [[ "$GD" -eq 1 || "$GDC" -eq "1" ]] ; then
      local has_line
      has_lines=$(git diff --numstat 2>/dev/null | awk 'NF==3 {plus+=$1; minus+=$2} END {printf("+%d/-%d\n", plus, minus)}')
      if [[ "$has_commit" -gt "0" ]] ; then
        # Changes to commit and commits to push
        ret="${CHANGES_COLOR}${branch}${FX[reset]}"
        ret="${ret}("
        ret="${ret}${DIFF_COLOR}$has_lines${FX[reset]}"
        ret="${ret},"
        ret="${ret}${COMMITS_COLOR}$has_commit${FX[reset]}"
        ret="${ret})"
        ret="${ret}${has_stash}"
        ret="${ret}${has_untracked}"
      else
        ret="${CHANGES_COLOR}${branch}${FX[reset]}"
        ret="${ret}("
        ret="${ret}${DIFF_COLOR}$has_lines${FX[reset]}"
        ret="${ret})"
        ret="${ret}${has_stash}"
        ret="${ret}${has_untracked}"
      fi
    else
      if [[ "$has_commit" -gt "0" ]] ; then
        # some commit(s) to push
        ret="${COMMITS_COLOR}${branch}${FX[reset]}"
        ret="${ret}("
        ret="${ret}${COMMITS_COLOR}$has_commit${FX[reset]}"
        ret="${ret})"
        ret="${ret}${has_stash}"
        ret="${ret}${has_untracked}"
      else
        ret="${UPTODATE_COLOR}${branch}"
        ret="${ret}${has_stash}"
        ret="${ret}${has_untracked}"
      fi
    fi
    ret="${ret}${FX[reset]}"
    wrap_brackets $ret
  fi
}

prompt_actual() {
  echo -ne "${PROMPT_COLOR}➜ ${FX[reset]}"
}

# Load the theme
PROMPT=$'$(prompt_exit_code $?)$(prompt_user_host)$(prompt_job_counts)$(prompt_folder)$(prompt_repo_status)\
$(prompt_actual)'
PROMPT2=$'%_$(prompt_actual)'
# }}}

# program settings & paths {{{

export OS=`uname | tr "[:upper:]" "[:lower:]"`
# ls
export LSCOLORS="gxfxcxdxbxegedabagacad"
export LSCOLORS="exfxcxdxbxegedabagacad"
export LS_COLORS="*.tar.bz2=38;5;226:*.tar.xz=38;5;130:*PKGBUILD=48;5;233;38;5;160:*.html=38;5;213:*.htm=38;5;213:*.vim=38;5;142:*.css=38;5;209:*.screenrc=38;5;120:*.procmailrc=38;5;120:*.zshrc=38;5;120:*.bashrc=38;5;120:*.xinitrc=38;5;120:*.vimrc=38;5;120:*.htoprc=38;5;120:*.muttrc=38;5;120:*.gtkrc-2.0=38;5;120:*.fehrc=38;5;120:*.rc=38;5;120:*.md=38;5;130:*.markdown=38;5;130:*.conf=38;5;148:*.h=38;5;81:*.rb=38;5;192:*.c=38;5;110:*.diff=38;5;31:*.yml=38;5;208:*.pl=38;5;178:*.csv=38;5;136:tw=38;5;003:*.chm=38;5;144:*.bin=38;5;249:*.pdf=38;5;203:*.mpg=38;5;38:*.ts=38;5;39:*.sfv=38;5;191:*.m3u=38;5;172:*.txt=38;5;192:*.log=38;5;190:*.swp=38;5;241:*.swo=38;5;240:*.theme=38;5;109:*.zsh=38;5;173:*.nfo=38;5;113:mi=38;5;124:or=38;5;160:ex=38;5;197:ln=target:pi=38;5;130:ow=38;5;208:fi=38;5;007:so=38;5;167:di=38;5;30:*.pm=38;5;197:*.pl=38;5;166:*.sh=38;5;243:*.patch=38;5;37:*.tar=38;5;118:*.tar.gz=38;5;172:*.zip=38;5;11::*.rar=38;5;11:*.tgz=38;5;11:*.7z=38;5;11:*.mp3=38;5;173:*.flac=38;5;166:*.mkv=38;5;115:*.avi=38;5;114:*.wmv=38;5;113:*.jpg=38;5;66:*.jpeg=38;5;67:*.png=38;5;68:*.pacnew=38;5;33"

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
export ANSIBLE_HOSTS=~/.ansible_hosts

export ROO_HOME=$HOME/work/tools/spring-roo-1.1.0.M1

export FLEX_SDK_BIN_DIR=/Users/adr/Library/Sprouts/1.1/cache/flex4/4.6.0.23201/bin

export MONO_GAC_PREFIX=/usr/local

# haxe
export HAXE_LIBRARY_PATH="$(/usr/local/bin/brew --prefix)/share/haxe/std"
#export NEKOPATH=/usr/local/neko

# java
if [ "`uname`" = "Darwin" ]; then
  export JAVA_HOME="$(/usr/libexec/java_home -v 1.6)"
else
  export JAVA_HOME=/usr/lib/jvm/java-6-sun/
fi

# luatext
#export TEXMFCNF=/usr/local/texlive/2008/texmf/web2c/
#export LUAINPUTS='{/usr/local/texlive/texmf-local/tex/context/base,/usr/local/texlive/texmf-local/scripts/context/lua,$HOME/texmf/scripts/context/lua}'
#export TEXMF='{$HOME/.texlive2008/texmf-config,$HOME/.texlive2008/texmf-var,$HOME/texmf,/usr/local/texlive/2008/texmf-config,/usr/local/texlive/2008/texmf-var,/usr/local/texlive/2008/texmf,/usr/local/texlive/texmf-local,/usr/local/texlive/2008/texmf-dist,/usr/local/texlive/2008/texmf.gwtex}'
export TEXMFCACHE=/tmp
#export TEXMFCNF=/usr/local/texlive/2008/texmf/web2c

export WIKI=$HOME/Documents/personal/life/exploded/
export NOTES=$HOME/Documents/personal/life/notes@/

export SAASBASE_HOME=$HOME/work/s
source $HOME/work/s/services/use-hadoop-1
export HBASE_HOME=$HOME/work/s/hbase
export ZOOKEEPER_HOME=$HOME/work/s/zookeeper
export STORM_HOME=$HOME/work/s/storm
export KAFKA_HOME=$HOME/work/s/kafka

# saasbase
export SAASBASE_DB_HOME=$HOME/work/s/saasbase/src/saasbase_db
export SAASBASE_ANALYTICS_HOME=$HOME/work/s/saasbase/src/saasbase_analytics
export SAASBASE_DATAROOT=/var

if [ "`uname`" = "Darwin" ]; then
  export VIMRUNTIME=$HOME/Applications/MacVim.app/Contents/Resources/vim/runtime/
fi  
export ENSIMEHOME=/Users/adr/work/tools/ensime/ensime_2.9.2-0.9.8.9/

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

export ANDROID_HOME=$HOME/work/tools/android-sdk-linux/
export AIR_ANDROID_SDK_HOME=$HOME/work/tools/android-sdk-linux/

# }}}

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
$ROO_HOME/bin:\
$HOME/Applications/emulator/n64/mupen64plus-1.99.4-osx/x86_64:\
$HOME/work/tools/android-sdk-$OS/tools:\
$HOME/work/tools/android-sdk-$OS/platform-tools:\
$HOME/work/tools/play-2.0.1:\
$GOBIN:\
$HOME/Library/Sprouts/1.1/cache/flex4/4.6.0.23201/bin:\
$HOME/.rvm/bin:\
$HOME/.perl5/bin:\
$PATH

# }}}


if [ "`uname`" = "Darwin" ]; then
export PATH=$PATH:\
$HOME/bin/$OS/clic
fi

export MANPATH=\
/usr/local/man:\
$MANPATH

# }}}

# aliases {{{

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
alias d='dirs -v'
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
current_branch() {
  ref=$(git symbolic-ref HEAD 2> /dev/null) || return
  echo ${ref#refs/heads/}
}

# these aliases take advangate of the previous function
alias ggpull='git pull origin $(current_branch)'
alias ggpush='git push origin $(current_branch)'
alias ggpnp='git pull origin $(current_branch) && git push origin $(current_branch)'

#}}}

# final settings {{{
[[ -s $HOME/.tmuxinator/scripts/tmuxinator ]] && source $HOME/.tmuxinator/scripts/tmuxinator
eval "$(fasd --init auto)"


ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets pattern cursor)
source $ZSH/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source $ZSH/zsh-history-substring-search/zsh-history-substring-search.zsh

[[ -s "$HOME/.secrets/.zshrc_secret" ]] && . "$HOME/.secrets/.zshrc_secret"  # secrets

source $HOME/.rvm/scripts/rvm

# }}}
#vim:foldmethod=marker
