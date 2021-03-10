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
autoload -U compinit && compinit -u -d "$ZSH/cache/zcompdump-$HOST"
autoload -U url-quote-magic
autoload allopt
autoload -U zcalc
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
unsetopt flowcontrol
setopt PRINT_EIGHT_BIT
setopt NO_CORRECT
setopt NO_CORRECT_ALL
setopt EXTENDED_GLOB
setopt CLOBBER

# completion
unsetopt MENU_COMPLETE   # do not autoselect the first completion entry
setopt AUTO_MENU         # show completion menu on succesive tab press
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
setopt -o sharehistory
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

function insert-selecta-path-in-command-line() {
    local selected_path
    # Print a newline or we'll clobber the old prompt.
    echo
    # Find the path; abort if the user doesn't select anything.
    selected_path=$(find * -type f | fzy) || return
    # Append the selection to the current command buffer.
    eval 'LBUFFER="$LBUFFER$selected_path"'
    # Redraw the prompt since Selecta has drawn several new lines of text.
    zle reset-prompt
}
# Create the zle widget
zle -N insert-selecta-path-in-command-line
# Bind the key to the newly created widget
bindkey -r "^T"
bindkey "^T" "insert-selecta-path-in-command-line"

autoload -Uz narrow-to-region

# http://qiita.com/uchiko/items/f6b1528d7362c9310da0
function _selecta-select-history() {
    local selected_entry
    # Print a newline or we'll clobber the old prompt.
    echo
    # Find the path; abort if the user doesn't select anything.
    BUFFER=$( fc -lnr 1 | fzy ) || return
    # BUFFER=$( fc -lnr 1 | select -x ) || return
    CURSOR=$#BUFFER
    # Append the selection to the current command buffer.
    # eval 'LBUFFER="$LBUFFER$selected_entry"'
    # Redraw the prompt since Selecta has drawn several new lines of text.
    zle reset-prompt
}
zle -N _selecta-select-history
bindkey -r "^R"
bindkey "^R" _selecta-select-history

function _hs-select-instance() {
    local selected_instance
    echo
    selected_instance=$(aws --no-paginate --output json ec2 describe-instances --max-results 9999 --region eu-west-1 --query 'Reservations[*].Instances[*]' --filters 'Name=instance-state-code,Values=16' | ec2_instances_dump | sort | hs --filter-only) || return
    selected_instance=$(echo $selected_instance |  gawk '{print gensub(/^.*=(.*)/, "\\1", "g", $NF);}')
    eval 'LBUFFER="$LBUFFER$selected_instance"'
    zle reset-prompt
}
zle -N _hs-select-instance
bindkey '^q' _hs-select-instance

bindkey -e
bindkey '\ew' kill-region
bindkey -M isearch "^r" history-incremental-pattern-search-backward
#bindkey "^s" history-incremental-pattern-search-forward
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
#bindkey '\e\eOD' backward-word
#bindkey '\e\eOC' forward-word


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

function allopen() {
  if [[ "$OSTYPE" = darwin* ]]; then
    open $1
  else
    gnome-open > /dev/null 2>&1 $*
  fi
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

function javap_method() {
  class=${1%#*}
  method=${1#*\#}
  javap -classpath `cat .run-classpath` -c $class | sed -n -e "/$method(/,/^$/p"
}

function peek() {
  tmux split-window -p 33 "$EDITOR" "$@" || exit;
}

function tm_cleanup() {
  sudo chown -R adragomi:staff ${1}
  sudo xattr -c -r ${1}
  sudo chmod -RN ${1}
  sudo chmod u+w ${1}
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

prompt_pure_preprompt_render() {
	setopt localoptions noshwordsplit
	local git_color=242

	# Initialize the preprompt array.
	local -a preprompt_parts

	# Set the path.
	preprompt_parts+=('%F{blue}%~%f')

	# Add git branch and dirty status info.
	typeset -gA prompt_pure_vcs_info
	if [[ -n $prompt_pure_vcs_info[branch] ]]; then
		preprompt_parts+=("%F{$git_color}"'${prompt_pure_vcs_info[branch]}%f')
	fi

	# Username and machine, if applicable.
	[[ -n $prompt_pure_username ]] && preprompt_parts+=('$prompt_pure_username')

	local cleaned_ps1=$PROMPT
	local -H MATCH
	if [[ $PROMPT = *$prompt_newline* ]]; then
		# When the prompt contains newlines, we keep everything before the first
		# and after the last newline, leaving us with everything except the
		# preprompt. This is needed because some software prefixes the prompt
		# (e.g. virtualenv).
		cleaned_ps1=${PROMPT%%${prompt_newline}*}${PROMPT##*${prompt_newline}}
	fi

	# Construct the new prompt with a clean preprompt.
	local -ah ps1
	ps1=(
		$prompt_newline           # Initial newline, for spaciousness.
		${(j. .)preprompt_parts}  # Join parts, space separated.
		$prompt_newline           # Separate preprompt and prompt.
		$cleaned_ps1
	)

	PROMPT="${(j..)ps1}"

  # Expand the prompt for future comparision.
	local expanded_prompt
	expanded_prompt="${(S%%)PROMPT}"

	if [[ $1 != precmd ]] && [[ $prompt_pure_last_prompt != $expanded_prompt ]]; then
		# Redraw the prompt.
		zle && zle .reset-prompt
	fi

	typeset -g prompt_pure_last_prompt=$expanded_prompt
}

prompt_pure_precmd() {
	# preform async git dirty check and fetch
	prompt_pure_async_tasks

	# store name of virtualenv in psvar if activated
	psvar[12]=
	[[ -n $VIRTUAL_ENV ]] && psvar[12]="${VIRTUAL_ENV:t}"

	# print the preprompt
	prompt_pure_preprompt_render "precmd"
}

prompt_pure_async_vcs_info() {
	setopt localoptions noshwordsplit
	builtin cd -q $1 2>/dev/null

	# configure vcs_info inside async task, this frees up vcs_info
	# to be used or configured as the user pleases.
	zstyle ':vcs_info:*' enable git
	zstyle ':vcs_info:*' use-simple true
	zstyle ':vcs_info:git*:*' get-revision true

	# only export two msg variables from vcs_info
	zstyle ':vcs_info:*' max-exports 2
	# export branch (%b) and git toplevel (%R)
	zstyle ':vcs_info:git*' formats '%b %6.6i' '%R'
	zstyle ':vcs_info:git*' actionformats '%b %6.6i|%a' '%R'

	vcs_info

	local -A info
	info[top]=$vcs_info_msg_1_
	info[branch]=$vcs_info_msg_0_

	print -r - ${(@kvq)info}
}

prompt_pure_async_tasks() {
	setopt localoptions noshwordsplit

	# initialize async worker
	((!${prompt_pure_async_init:-0})) && {
		async_start_worker "prompt_pure" -u -n
		async_register_callback "prompt_pure" prompt_pure_async_callback
		typeset -g prompt_pure_async_init=1
	}

	typeset -gA prompt_pure_vcs_info

	local -H MATCH
	if ! [[ $PWD = ${prompt_pure_vcs_info[pwd]}* ]]; then
		# stop any running async jobs
		async_flush_jobs "prompt_pure"

		# reset git preprompt variables, switching working tree
		prompt_pure_vcs_info[branch]=
		prompt_pure_vcs_info[top]=
	fi
	unset MATCH

	async_job "prompt_pure" prompt_pure_async_vcs_info $PWD

	# # only perform tasks inside git working tree
	[[ -n $prompt_pure_vcs_info[top] ]] || return
}

prompt_pure_async_callback() {
	setopt localoptions noshwordsplit
	local job=$1 code=$2 output=$3 exec_time=$4

	case $job in
		prompt_pure_async_vcs_info)
			local -A info
			typeset -gA prompt_pure_vcs_info

			# parse output (z) and unquote as array (Q@)
			info=("${(Q@)${(z)output}}")
			local -H MATCH
			# check if git toplevel has changed
			if [[ $info[top] = $prompt_pure_vcs_info[top] ]]; then
				# if stored pwd is part of $PWD, $PWD is shorter and likelier
				# to be toplevel, so we update pwd
				if [[ $prompt_pure_vcs_info[pwd] = ${PWD}* ]]; then
					prompt_pure_vcs_info[pwd]=$PWD
				fi
			else
				# store $PWD to detect if we (maybe) left the git path
				prompt_pure_vcs_info[pwd]=$PWD
			fi
			unset MATCH

			# always update branch and toplevel
			prompt_pure_vcs_info[branch]=$info[branch]
			prompt_pure_vcs_info[top]=$info[top]
			prompt_pure_preprompt_render
			;;
	esac
}

prompt_pure_setup() {
  # prevent percentage showing up
  # if output doesn't end with a newline
  export PROMPT_EOL_MARK=''

	# disallow python virtualenvs from updating the prompt
  export VIRTUAL_ENV_DISABLE_PROMPT=1

  prompt_opts=(subst percent)

	# borrowed from promptinit, sets the prompt options in case pure was not
	# initialized via promptinit.
	setopt noprompt{bang,cr,percent,subst} "prompt${^prompt_opts[@]}"

	if [[ -z $prompt_newline ]]; then
		# This variable needs to be set, usually set by promptinit.
		typeset -g prompt_newline=$'\n%{\r%}'
  fi

	zmodload zsh/datetime
	zmodload zsh/zle
	zmodload zsh/parameter

	autoload -Uz add-zsh-hook
	autoload -Uz vcs_info
  autoload -Uz async && async

  add-zsh-hook precmd prompt_pure_precmd

	# if a virtualenv is activated, display it in grey
  PROMPT='%(12V.%F{242}%12v%f .)'

  # prompt turns red if the previous command didn't exit with 0
  PROMPT='%(?.%F{magenta}.%F{red})❯%f '
}

prompt_pure_setup "$@"

# }}}

# program settings & paths {{{
export OS=`uname | tr "[:upper:]" "[:lower:]"`
# ls
#
# grep
if [[ "$OSTYPE" = darwin* ]]; then
  export GREP_OPTIONS='--color=auto'
  export GREP_COLOR='1;32'
  export GREP_COLORS="38;5;230:sl=38;5;240:cs=38;5;100:mt=38;5;161:fn=38;5;197:ln=38;5;212:bn=38;5;44:se=38;5;166"
fi

# python
export PYTHONSTARTUP=$HOME/.pythonstartup

# maven
export MAVEN_REPO=$HOME/.m2/repository
#export MAVEN_OPTS="-Djava.awt.headless=true"
#export JAVA_TOOL_OPTIONS='-Djava.awt.headless=true'
#export MVN_OPTS="-Djava.awt.headless=true"
export LESS="-rX"
export PAGER=less

if [[ "$OSTYPE" = darwin* ]]; then
  export EDITOR=/usr/local/bin/nvim
  export GIT_EDITOR=/usr/local/bin/nvim
  export VISUAL='/usr/local/bin/nvim'
else
  export EDITOR=/usr/bin/vim
  export GIT_EDITOR=/usr/bin/vim
fi

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
export LC_ALL="en_US.UTF-8"

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

# colors in terminal
export CLICOLOR=1

# java
if [[ "$OSTYPE" = darwin* ]]; then
  export JAVA_HOME=/Library/Java/JavaVirtualMachines/jdk-11.0.6.jdk/Contents/Home
  if [[ -f /usr/local/opt/jenv ]]; then
    export JENV_ROOT=/usr/local/opt/jenv
    if which jenv > /dev/null; then eval "$(jenv init -)"; fi
    export JAVA_HOME=$(readlink /usr/local/opt/jenv/versions/`cat /usr/local/opt/jenv/version`)
    #export JAVA_HOME="$(/usr/libexec/java_home -v 1.6.0_43-b01-447)"
  fi
else
  export JAVA_HOME=/usr/lib/jvm/java-8-jdk
fi

# jdtls
if [[ "$OSTYPE" = darwin* ]]; then
  export JAR=$HOME/.local/share/nvim/lspconfig/jdtls/plugins/org.eclipse.equinox.launcher_1.6.0.v20200915-1508.jar
  export GRADLE_HOME=/usr/local/opt/gradle
  export JDTLS_CONFIG=$HOME/.local/share/nvim/lspconfig/jdtls/config_mac
  export WORKSPACE=$HOME/.cache/jdtls/workspace
fi

# scala
export SCALA_HOME=/usr/local/opt/scala

# go
if [[ "$OSTYPE" = linux* ]]; then
  export GOPATH=$HOME/.golinux
else
  export GOPATH=$HOME/.gocode
fi
export GO15VENDOREXPERIMENT=1
export GO111MODULE=on

# esp8266 {{{
export XTENSA_TOOL_ROOT=/usr/local/Cellar/xtensa-lx106-elf
export XTENSA_TOOL_BIN=/usr/local/Cellar/xtensa-lx106-elf/bin
export ESP8266_SDK_BASE=/usr/local/Cellar/xtensa-lx106-elf/esp_iot_sdk
export ESP8266_RTOS_SDK_BASE=/usr/local/Cellar/xtensa-lx106-elf/esp_iot_rtos_sdk
#}}}



# path {{{
export PATH=\
$HOME/bin:\
$HOME/bin/$OS:\
$HOME/.rvm/gems/ruby-2.6.3/bin:\
/usr/local/opt/python@2/libexec/bin:\
$HOME/.rvm/bin:\
$HOME/.cargo/bin:\
/usr/local/bin:\
/usr/local/sbin:\
/usr/local/share/npm/bin:\
$SAASBASE_HOME/services:\
$HOME/.cabal/bin:\
$HOME/temp/source/other/sshuttle:\
$HOME/temp/source/other/factor:\
$HOME/work/tools/nasm:\
$HOME/temp/source/other/rock/bin:\
$HOME/Applications/emulator/n64/mupen64plus-1.99.4-osx/x86_64:\
$HOME/.perl5/bin:\
$GOPATH/bin:\
/usr/local/openresty/nginx/sbin:\
/usr/local/openresty/luajit/bin:\
$HOME/.platformio/penv/bin:\
$PATH

# }}}
#
# man path {{{
export MANPATH=\
/usr/local/man:\
$MANPATH
# }}}

# }}}

# aliases {{{
alias or1="ssh ${USER}@ops1.or1.omniture.com@scb.dmz.or1.adobe.net -i ~/.ssh/id_rsa -A"
alias lon5="ssh ${USER}@ops1.lon5.omniture.com@scb.dmz.or1.adobe.net -i ~/.ssh/id_rsa -A"
alias sin2="ssh ${USER}@ops1.sin2.omniture.com@scb.dmz.or1.adobe.net -i ~/.ssh/id_rsa -A"
alias sbx="ssh ${USER}@ops1.sbx1.omniture.com@scb.dmz.or1.adobe.net -i ~/.ssh/id_rsa -A"
alias ut1="ssh ${USER}@ops1.ut1.omniture.com -i ~/.ssh/id_rsa -A"
alias youtube720-dl="youtube-dl -q -f 'bestvideo[height<=720]+bestaudio/best[height<=720]'"
alias youtube480-dl="youtube-dl -q -f 'bestvideo[height<=480]+bestaudio/best[height<=480]'"
alias youtube360-dl="youtube-dl -q -f 'bestvideo[height<=360]+bestaudio/best[height<=360]'"
# alias luarocks="luarocks --tree=${HOME}/.luarocks"
# alias luajitrocks="luajitrocks --tree=${HOME}/.luajitrocks"
alias decrypt_hiera="openssl smime -decrypt -aes256 -binary -inform der -inkey /Users/adragomi/.ssh/hiera_private.key -in"
alias fcurl="curl -xprodproxy-000-lxc.prod.dal09.fitbit.com:3128 --proxy-negotiate -u :  "
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
if [[ "$OSTYPE" = linux* ]]; then
  alias tmux='tmux -2'
fi

# Show history
alias history='fc -l 1'

alias dtrace-providers="sudo dtrace -l | perl -pe 's/^.*?\S+\s+(\S+?)([0-9]|\s).*/\1/' | sort | uniq"
#}}}

# plugins {{{
# final settings {{{
[[ -s $HOME/.tmuxinator/scripts/tmuxinator ]] && source $HOME/.tmuxinator/scripts/tmuxinator
source $ZSH/golang.plugin.zsh
source $ZSH/url-tools.plugin.zsh

[[ -s "$HOME/.secrets/.zshrc_secret" ]] && . "$HOME/.secrets/.zshrc_secret"  # secrets

# }}}

# export LUA_PATH="\
# /usr/local/opt/lua/share/lua/5.2/?.lua;\
# /usr/local/opt/lua/share/lua/5.2/?/init.lua;\
# ${HOME}/.luarocks/share/lua/5.2/?.lua;\
# ${HOME}/.luarocks/share/lua/5.2/?/init.lua;\
# ./?.lua;\
# ./?/init.lua\
# "

# export LUA_CPATH="\
# /usr/local/opt/lua/lib/lua/5.2/?.so;\
# ${HOME}/.luarocks/lib/lua/5.2/?.so;\
# /usr/local/opt/lua/lib/lua/5.2/loadall.so;\
# ./?.so\
# "

# export LUAJIT_PATH="\
# /usr/local/opt/luajit/share/luajit-2.1.0-beta1/?.lua;\
# /usr/local/opt/luajit/share/lua/5.1/?.lua;\
# /usr/local/opt/luajit/share/lua/5.1/?/init.lua;\
# ${HOME}/.luajitrocks/share/lua/5.1/?.lua;\
# ${HOME}/.luajitrocks/share/lua/5.1/?/init.lua;\
# ./?.lua;\
# ./?/init.lua\
# "

# export LUAJIT_CPATH="\
# /usr/local/opt/luajit/lib/lua/5.1/?.so;\
# ${HOME}/.luajitrocks/lib/lua/5.1/?.so;\
# /usr/local/opt/luajit/lib/lua/5.1/loadall.so;\
# ./?.so\
# "

# alias lua='LUA_PATH=${LUA_PATH} LUA_CPATH=${LUA_CPATH} /usr/local/bin/lua'
# alias luarocks='LUA_PATH=${LUA_PATH} LUA_CPATH=${LUA_CPATH} /usr/local/bin/luarocks --tree=${HOME}/.luarocks'
# alias luajit='LUA_PATH=${LUAJIT_PATH} LUA_CPATH=${LUAJIT_CPATH} /usr/local/bin/luajit'
# alias luajitrocks='LUA_PATH=${LUAJIT_PATH} LUA_CPATH=${LUAJIT_CPATH} /usr/local/bin/luajitrocks --tree=${HOME}/.luajitrocks'

if [[ "$OSTYPE" = darwin* ]]; then
  export HOMEBREW_CASK_OPTS="--appdir=${HOME}/Applications"
fi

eval "$(direnv hook zsh)"

#[[ $OS == "Darwin" ]] && test -e ${HOME}/.iterm2_shell_integration.zsh && source ${HOME}/.iterm2_shell_integration.zsh

[ -f $HOME/.zshrc_secrets ] && . $HOME/.zshrc_secrets

command -v vg >/dev/null 2>&1 && eval "$(vg eval --shell zsh)"

export NVM_DIR="$HOME/.nvm"

if [[ "$OSTYPE" = darwin* ]]; then
  [ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"  # This loads nvm
  [ -s "$NVM_DIR/bash_completion" ] && . "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
fi

if [[ "$OSTYPE" = linux* ]]; then
  [ -s "/home/linuxbrew/.linuxbrew/opt/nvm/nvm.sh" ] && . "/home/linuxbrew/.linuxbrew/opt/nvm/nvm.sh"  # This loads nvm
  [ -s "/home/linuxbrew/.linuxbrew/opt/nvm/etc/bash_completion.d/nvm" ] && . "/home/linuxbrew/.linuxbrew/opt/nvm/etc/bash_completion.d/nvm"  # This loads nvm bash_completion
fi


[[ -d ~/.rvm/rubies ]] && RUBIES+=(~/.rvm/rubies/*)

export PATH=$HOME/.local/bin:$PATH


if [[ $OS = "linux" ]]; then
  export rvm_ignore_gemrc_issues=1
  export rvm_silence_path_mismatch_check_flag=1
fi
[[ -f $HOME/.rvm/scripts/rvm ]] && source $HOME/.rvm/scripts/rvm

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/adragomi/work/google-cloud-sdk/path.zsh.inc' ]; then source '/Users/adragomi/work/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/Users/adragomi/work/google-cloud-sdk/completion.zsh.inc' ]; then source '/Users/adragomi/work/google-cloud-sdk/completion.zsh.inc'; fi

export PATH=/Users/adragomi/.local/bin/luna-studio:$PATH
export PATH="/Users/adragomi/.deno/bin:$PATH"

ulimit -n 10240 12288

export PATH="$HOME/.yarn/bin:$HOME/.config/yarn/global/node_modules/.bin:$PATH"
export KLAM_BROWSER="Google Chrome"

# opam configuration
test -r /Users/adragomi/.opam/opam-init/init.zsh && . /Users/adragomi/.opam/opam-init/init.zsh > /dev/null 2> /dev/null || true

if [[ "$OSTYPE" = darwin* ]]; then
  source <(kubectl completion zsh)  # setup autocomplete in zsh into the current shell
  export KUBECONFIG=$(find $HOME/.kube -maxdepth 1 -type f -and ! -name "kubectx" | gtr '\n' ':')
fi

if [[ "$OSTYPE" = linux* ]]; then
  eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
fi


# Add RVM to PATH for scripting. Make sure this is the last PATH variable change.
export PATH="$PATH:$HOME/.rvm/bin"
