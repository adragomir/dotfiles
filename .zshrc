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
# }}}

# autoload {{{
autoload add-zsh-hook
autoload -U colors && colors  # Enables colours
autoload -U compinit && compinit -d $HOME/.history/.zcompdump
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
  result=$( ag -l --nocolor -g . | selecta )
  RBUFFER="$result "
  CURSOR+=$#RBUFFER
}
zle -N _selecta
bindkey "\C-t" _selecta

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
# wunjo {{{
typeset -gA zgit_info
zgit_info=()

zgit_chpwd_hook() {
	zgit_info_update
}

zgit_preexec_hook() {
	if [[ $2 == git\ * ]] || [[ $2 == *\ git\ * ]]; then
		zgit_precmd_do_update=1
	fi
}

zgit_precmd_hook() {
	if [ $zgit_precmd_do_update ]; then
		unset zgit_precmd_do_update
		zgit_info_update
	fi
}

zgit_info_update() {
	zgit_info=()

	local gitdir="$(git rev-parse --show-toplevel 2>/dev/null)"
	if [ $? -ne 0 ] || [ -z "$gitdir" ]; then
		return
	fi

	zgit_info[dir]=$gitdir
	zgit_info[bare]=$(git rev-parse --is-bare-repository)
	zgit_info[inwork]=$(git rev-parse --is-inside-work-tree)
}

zgit_isgit() {
	if [ -z "$zgit_info[dir]" ]; then
		return 1
	else
		return 0
	fi
}

zgit_inworktree() {
	zgit_isgit || return
	if [ "$zgit_info[inwork]" = "true" ]; then
		return 0
	else
		return 1
	fi
}

zgit_isbare() {
	zgit_isgit || return
	if [ "$zgit_info[bare]" = "true" ]; then
		return 0
	else
		return 1
	fi
}

zgit_head() {
	zgit_isgit || return 1

	if [ -z "$zgit_info[head]" ]; then
		local name=''
		name=$(git symbolic-ref -q HEAD)
		if [ $? -eq 0 ]; then
			if [[ $name == refs/(heads|tags)/* ]]; then
				name=${name#refs/(heads|tags)/}
			fi
		else
			name=$(git name-rev --name-only --no-undefined --always HEAD)
			if [ $? -ne 0 ]; then
				return 1
			elif [[ $name == remotes/* ]]; then
				name=${name#remotes/}
			fi
		fi
		zgit_info[head]=$name
	fi

	echo $zgit_info[head]
}

zgit_branch() {
	zgit_isgit || return 1
	zgit_isbare && return 1

	if [ -z "$zgit_info[branch]" ]; then
		local branch=$(git symbolic-ref HEAD 2>/dev/null)
		if [ $? -eq 0 ]; then
			branch=${branch##*/}
		else
			branch=$(git name-rev --name-only --always HEAD)
		fi
		zgit_info[branch]=$branch
	fi

	echo $zgit_info[branch]
	return 0
}

zgit_tracking_remote() {
	zgit_isgit || return 1
	zgit_isbare && return 1

	local branch
	if [ -n "$1" ]; then
		branch=$1
	elif [ -z "$zgit_info[branch]" ]; then
		branch=$(zgit_branch)
		[ $? -ne 0 ] && return 1
	else
		branch=$zgit_info[branch]
	fi

	local k="tracking_$branch"
	local remote
	if [ -z "$zgit_info[$k]" ]; then
		remote=$(git config branch.$branch.remote)
		zgit_info[$k]=$remote
	fi

	echo $zgit_info[$k]
	return 0
}

zgit_tracking_merge() {
	zgit_isgit || return 1
	zgit_isbare && return 1

	local branch
	if [ -z "$zgit_info[branch]" ]; then
		branch=$(zgit_branch)
		[ $? -ne 0 ] && return 1
	else
		branch=$zgit_info[branch]
	fi

	local remote=$(zgit_tracking_remote $branch)
	[ $? -ne 0 ] && return 1
	if [ -n "$remote" ]; then # tracking branch
		local merge=$(git config branch.$branch.merge)
		if [ $remote != "." ]; then
			merge=$remote/$(basename $merge)
		fi
		echo $merge
		return 0
	else
		return 1
	fi
}

zgit_isindexclean() {
	zgit_isgit || return 1
	if git diff --quiet --cached 2>/dev/null; then
		return 0
	else
		return 1
	fi
}

zgit_isworktreeclean() {
	zgit_isgit || return 1
	if [ -z "$(git ls-files $zgit_info[dir] --modified)" ]; then
		return 0
	else
		return 1
	fi
}

zgit_hasuntracked() {
	zgit_isgit || return 1
	local -a flist
	flist=($(git ls-files --others --exclude-standard))
	if [ $#flist -gt 0 ]; then
		return 0
	else
		return 1
	fi
}

zgit_hasunmerged() {
	zgit_isgit || return 1
	local -a flist
	flist=($(git ls-files -u))
	if [ $#flist -gt 0 ]; then
		return 0
	else
		return 1
	fi
}

zgit_svnhead() {
	zgit_isgit || return 1

	local commit=$1
	if [ -z "$commit" ]; then
		commit='HEAD'
	fi

	git svn find-rev $commit
}

zgit_rebaseinfo() {
	zgit_isgit || return 1
	if [ -d $zgit_info[dir]/rebase-merge ]; then
		dotest=$zgit_info[dir]/rebase-merge
	elif [ -d $zgit_info[dir]/.dotest-merge ]; then
		dotest=$zgit_info[dir]/.dotest-merge
	elif [ -d .dotest ]; then
		dotest=.dotest
	else
		return 1
	fi

	zgit_info[dotest]=$dotest

	zgit_info[rb_onto]=$(cat "$dotest/onto")
	if [ -f "$dotest/upstream" ]; then
		zgit_info[rb_upstream]=$(cat "$dotest/upstream")
	else
		zgit_info[rb_upstream]=
	fi
	if [ -f "$dotest/orig-head" ]; then
		zgit_info[rb_head]=$(cat "$dotest/orig-head")
	elif [ -f "$dotest/head" ]; then
		zgit_info[rb_head]=$(cat "$dotest/head")
	fi
	zgit_info[rb_head_name]=$(cat "$dotest/head-name")

	return 0
}

add-zsh-hook chpwd zgit_chpwd_hook
add-zsh-hook preexec zgit_preexec_hook
add-zsh-hook precmd zgit_precmd_hook

zgit_info_update

# git
revstring() {
	git rev-parse --short $1 2>/dev/null
}

coloratom() {
	local off=$1 atom=$2
	if [[ $atom[1] == [[:upper:]] ]]; then
		off=$(( $off + 60 ))
	fi
	echo $(( $off + $colorcode[${(L)atom}] ))
}

colorword() {
	local fg=$1 bg=$2 att=$3
	local -a s

	if [ -n "$fg" ]; then
		s+=$(coloratom 30 $fg)
	fi
	if [ -n "$bg" ]; then
		s+=$(coloratom 40 $bg)
	fi
	if [ -n "$att" ]; then
		s+=$attcode[$att]
	fi

	echo "%{"$'\e['${(j:;:)s}m"%}"
}

function minutes_since_last_commit {
    now=`date +%s`
    last_commit=`git log --pretty=format:'%at' -1 2>/dev/null`
    if $lastcommit ; then
      seconds_since_last_commit=$((now-last_commit))
      minutes_since_last_commit=$((seconds_since_last_commit/60))
      echo $minutes_since_last_commit
    else
      echo "-1"
    fi
}

function prompt_grb_scm_time_since_commit() {
	local -A pc
	pc=(${(kv)wunjo_prompt_colors})

	if zgit_inworktree; then
        local MINUTES_SINCE_LAST_COMMIT=`minutes_since_last_commit`
        if [ "$MINUTES_SINCE_LAST_COMMIT" -eq -1 ]; then
          COLOR="$pc[scm_time_uncommitted]"
          local SINCE_LAST_COMMIT="${COLOR}uncommitted$pc[reset]"  
        else
          if [ "$MINUTES_SINCE_LAST_COMMIT" -gt 30 ]; then
            COLOR="$pc[scm_time_long]"
          elif [ "$MINUTES_SINCE_LAST_COMMIT" -gt 10 ]; then
            COLOR="$pc[scm_time_medium]"
          else
            COLOR="$pc[scm_time_short]"
          fi
          local SINCE_LAST_COMMIT="${COLOR}$(minutes_since_last_commit)m$pc[reset]"
        fi
        echo $SINCE_LAST_COMMIT
    fi
}

prompt_repo_status() {
	zgit_isgit || return
	local zgit_isgit || returnverbose
	if [[ $TERM == screen* ]] && [ -n "$STY" ]; then
		verbose=
	else
		verbose=1
	fi

	typeset -A colorcode
	colorcode[black]=0
	colorcode[red]=1
	colorcode[green]=2
	colorcode[yellow]=3
	colorcode[blue]=4
	colorcode[magenta]=5
	colorcode[cyan]=6
	colorcode[white]=7
	colorcode[default]=9
	colorcode[k]=$colorcode[black]
	colorcode[r]=$colorcode[red]
	colorcode[g]=$colorcode[green]
	colorcode[y]=$colorcode[yellow]
	colorcode[b]=$colorcode[blue]
	colorcode[m]=$colorcode[magenta]
	colorcode[c]=$colorcode[cyan]
	colorcode[w]=$colorcode[white]
	colorcode[.]=$colorcode[default]

	typeset -A attcode
	attcode[none]=00
	attcode[bold]=01
	attcode[faint]=02
	attcode[standout]=03
	attcode[underline]=04
	attcode[blink]=05
	attcode[reverse]=07
	attcode[conceal]=08
	attcode[normal]=22
	attcode[no-standout]=23
	attcode[no-underline]=24
	attcode[no-blink]=25
	attcode[no-reverse]=27
	attcode[no-conceal]=28

	local -A pc
	pc[default]='default'
	pc[date]='cyan'
	pc[time]='Blue'
	pc[host]='Green'
	pc[user]='cyan'
	pc[punc]='yellow'
	pc[line]='magenta'
	pc[hist]='green'
	pc[path]='Cyan'
	pc[shortpath]='default'
	pc[rc]='red'
	pc[scm_branch]='Cyan'
	pc[scm_commitid]='Yellow'
	pc[scm_status_dirty]='Red'
	pc[scm_status_staged]='Green'
	pc[#]='Yellow'
	for cn in ${(k)pc}; do
		pc[${cn}]=$(colorword $pc[$cn])
	done
	pc[reset]=$(colorword . . 00)

	typeset -Ag wunjo_prompt_colors
	wunjo_prompt_colors=(${(kv)pc})

	local ret
  ret="$(prompt_grb_scm_time_since_commit)|$(prompt_wunjo_scm_status)|$(prompt_wunjo_scm_branch)"
  wrap_brackets $ret
	#add-zsh-hook precmd prompt_wunjo_precmd
}

prompt_wunjo_precmd() {
	local ex=$?
	psvar=()

	if [[ $ex -ge 128 ]]; then
		sig=$signals[$ex-127]
		psvar[1]="sig${(L)sig}"
	else
		psvar[1]="$ex"
	fi
}

prompt_wunjo_scm_status() {
	zgit_isgit || return
	local -A pc
	pc=(${(kv)wunjo_prompt_colors})

	head=$(zgit_head)
	gitcommit=$(revstring $head)

	local -a commits

	if zgit_rebaseinfo; then
		orig_commit=$(revstring $zgit_info[rb_head])
		orig_name=$(git name-rev --name-only $zgit_info[rb_head])
		orig="$pc[scm_branch]$orig_name$pc[punc]($pc[scm_commitid]$orig_commit$pc[punc])"
		onto_commit=$(revstring $zgit_info[rb_onto])
		onto_name=$(git name-rev --name-only $zgit_info[rb_onto])
		onto="$pc[scm_branch]$onto_name$pc[punc]($pc[scm_commitid]$onto_commit$pc[punc])"

		if [ -n "$zgit_info[rb_upstream]" ] && [ $zgit_info[rb_upstream] != $zgit_info[rb_onto] ]; then
			upstream_commit=$(revstring $zgit_info[rb_upstream])
			upstream_name=$(git name-rev --name-only $zgit_info[rb_upstream])
			upstream="$pc[scm_branch]$upstream_name$pc[punc]($pc[scm_commitid]$upstream_commit$pc[punc])"
			commits+="rebasing $upstream$pc[reset]..$orig$pc[reset] onto $onto$pc[reset]"
		else
			commits+="rebasing $onto$pc[reset]..$orig$pc[reset]"
		fi

		local -a revs
		revs=($(git rev-list $zgit_info[rb_onto]..HEAD))
		if [ $#revs -gt 0 ]; then
			commits+="\n$#revs commits in"
		fi

		if [ -f $zgit_info[dotest]/message ]; then
			mess=$(head -n1 $zgit_info[dotest]/message)
			commits+="on $mess"
		fi
	elif [ -n "$gitcommit" ]; then
		commits+="$pc[scm_branch]$head$pc[punc]($pc[scm_commitid]$gitcommit$pc[punc])$pc[reset]"
		local track_merge=$(zgit_tracking_merge)
		if [ -n "$track_merge" ]; then
			if git rev-parse --verify -q $track_merge >/dev/null; then
				local track_remote=$(zgit_tracking_remote)
				local tracked=$(revstring $track_merge 2>/dev/null)

				local -a revs
				revs=($(git rev-list --reverse $track_merge..HEAD))
				if [ $#revs -gt 0 ]; then
					local base=$(revstring $revs[1]~1)
					local base_name=$(git name-rev --name-only $base)
					local base_short=$(revstring $base)
					local word_commits
					if [ $#revs -gt 1 ]; then
						word_commits='commits'
					else
						word_commits='commit'
					fi

					local conj="since"
					if [[ "$base" == "$tracked" ]]; then
						conj+=" tracked"
						tracked=
					fi
					commits+="$#revs $word_commits $conj $pc[scm_branch]$base_name$pc[punc]($pc[scm_commitid]$base_short$pc[punc])$pc[reset]"
				fi

				if [ -n "$tracked" ]; then
					local track_name=$track_merge
					if [[ $track_remote == "." ]]; then
						track_name=${track_name##*/}
					fi
					tracked=$(revstring $tracked)
					commits+="<> $pc[scm_branch]$track_name$pc[punc]"
					if [[ "$tracked" != "$gitcommit" ]]; then
						commits[$#commits]+="($pc[scm_commitid]$tracked$pc[punc])"
					fi
					commits[$#commits]+="$pc[reset]"
				fi
			fi
		fi
	fi

	if [ $#commits -gt 0 ]; then
		echo -n "${(j: :)commits}"
	fi
}

prompt_wunjo_scm_branch() {
	zgit_isgit || return
	local -A pc
	pc=(${(kv)wunjo_prompt_colors})

	if zgit_inworktree; then
		if ! zgit_isindexclean; then
			echo -n "$pc[scm_status_staged]+"
		fi

		local -a dirty
		if ! zgit_isworktreeclean; then
			dirty+='!'
		fi

		if zgit_hasunmerged; then
			dirty+='*'
		fi

		if zgit_hasuntracked; then
			dirty+='?'
		fi

		if [ $#dirty -gt 0 ]; then
			echo -n "$pc[scm_status_dirty]${(j::)dirty}"
		fi
	fi
	echo $pc[reset]
}

# }}}

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
  export JENV_ROOT=/usr/local/opt/jenv
  if which jenv > /dev/null; then eval "$(jenv init -)"; fi
  export JAVA_HOME=$(readlink /usr/local/opt/jenv/versions/`cat /usr/local/opt/jenv/version`)
  #export JAVA_HOME="$(/usr/libexec/java_home -v 1.6.0_43-b01-447)"
else
  export JAVA_HOME=/usr/lib/jvm/java-6-sun/
fi

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
source $HOME/work/s/services/use-hadoop-2
export HBASE_HOME=$HOME/work/s/hbase
export ZOOKEEPER_HOME=$HOME/work/s/zookeeper
export STORM_HOME=$HOME/work/s/storm
export KAFKA_HOME=$HOME/work/s/kafka

# saasbase
export SAASBASE_DB_HOME=$HOME/work/s/db/db
export SAASBASE_ANALYTICS_HOME=$HOME/work/s/saasbase/analytics
export SAASBASE_DATAROOT=/var

if [ "`uname`" = "Darwin" ]; then
  export VIMRUNTIME=$HOME/Applications/MacVim.app/Contents/Resources/vim/runtime/
fi  
export ENSIMEHOME=/Users/adr/work/tools/ensime/

# go

export GOPATH=$HOME/.gocode
# {{{ amazon

# credentials
aws_use_account() {
export EC2_CERT_PAIR=$1
export EC2_PRIVATE_KEY="$(/bin/ls $HOME/.ec2/$EC2_CERT_PAIR/pk-*.pem)"
export EC2_CERT="$(/bin/ls $HOME/.ec2/$EC2_CERT_PAIR/cert-*.pem)"
export AWS_CREDENTIAL_FILE=$HOME/.secrets/.aws-credentials-$1
export AWS_ACCESS_KEY_ID=$(cat $AWS_CREDENTIAL_FILE | grep AWSAccessKeyId | sed 's/^.*=//')
export AWS_SECRET_ACCESS_KEY="$(cat $AWS_CREDENTIAL_FILE | grep AWSSecretKey | sed 's/^.*=//')"
}
export AWS_CONFIG_FILE=$HOME/.secrets/.awscli
aws_use_account 'pass'

# ec2-api-tools
export EC2_HOME="/usr/local/Library/LinkedKegs/ec2-api-tools/jars"
# ec2-ami-tools
export EC2_AMITOOL_HOME="/usr/local/Library/LinkedKegs/ec2-ami-tools/jars"
# aws-iam-tools
export AWS_IAM_HOME="/usr/local/Cellar/aws-iam-tools/1.5.0/jars"
# aws-cfn-tools
export AWS_CLOUDFORMATION_HOME="/usr/local/Cellar/aws-cfn-tools/1.0.12/jars"
# elb-tools
export AWS_ELB_HOME="/usr/local/Cellar/elb-tools/1.0.12.0/jars"
# auto scaling
export AWS_AUTO_SCALING_HOME="/usr/local/Library/LinkedKegs/auto-scaling/jars"

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
$HOME/Library/Sprouts/1.1/cache/flex4/4.6.0.23201/bin:\
$HOME/.rvm/bin:\
$HOME/.perl5/bin:\
$GOPATH/bin:\
$GOPATH/src/github.com/mitchellh/packer/pkg/darwin_amd64/:\
/usr/local/openresty/nginx/sbin/:\
/usr/local/openresty/luajit/bin/:\
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
 
#editor
case "$HOST" in
  $USER-mac*)
  alias gvim='$HOME/Applications/MacVim.app/Contents/MacOS/Vim -g';
  ;;
  sheeva*)
  #alias vim='/usr/bin/vim';
  ;;
  $USER-mbp*)
  #alias vim='/usr/bin/vim';
  ;;
esac

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
alias reload="source ~/.zshrc"
alias finde='find -E'
alias df='df -h'
alias du='du -h -c'
alias psa='ps auxwww'
alias ping='ping -c 5'
alias grep='grep --colour'
alias irb='pry'
alias ri='ri -Tf ansi'
alias tu='top -o cpu'
alias tm='top -o vsize'

# hadoop, hbase, etc
alias hbase='$HBASE_HOME/bin/hbase'
alias zk='$ZOOKEEPER_HOME/bin/zkCli.sh'
alias storm='$STORM_HOME/bin/storm'
alias psall='pgrep -l -f NameNode DataNode TaskTracker JobTracker Quorum HMaster HRegion ThriftServer \
  ReportServer storm.daemon.nimbus storm.ui.core'
alias d='dirs -v'

# Show history
alias history='fc -l 1'

alias dtrace-providers="sudo dtrace -l | perl -pe 's/^.*?\S+\s+(\S+?)([0-9]|\s).*/\1/' | sort | uniq"
#}}}

# final settings {{{
[[ -s $HOME/.tmuxinator/scripts/tmuxinator ]] && source $HOME/.tmuxinator/scripts/tmuxinator
eval "$(fasd --init auto)"

source $ZSH/zsh-history-substring-search/zsh-history-substring-search.zsh
[[ -s "$HOME/.secrets/.zshrc_secret" ]] && . "$HOME/.secrets/.zshrc_secret"  # secrets

source $HOME/.rvm/scripts/rvm
# }}}
#vim:foldmethod=marker
