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
if [[ "$OSTYPE" = darwin* ]]; then
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
fi

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

_physical_up_line()   { zle backward-char -n $COLUMNS }
_physical_down_line() { zle forward-char  -n $COLUMNS }
zle -N physical-up-line _physical_up_line
zle -N physical-down-line _physical_down_line
bindkey "\e\e[A" physical-up-line
bindkey "\e\e[B" physical-down-line

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

	PROMPT="${(j..)ps1}" #"

  # Expand the prompt for future comparision.
	local expanded_prompt
	expanded_prompt="${(S%%)PROMPT}" #"

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
			info=("${(Q@)${(z)output}}") #"
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
	setopt noprompt{bang,cr,percent,subst} "prompt${^prompt_opts[@]}" #"

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

source $ZSH/golang.plugin.zsh
source $ZSH/url-tools.plugin.zsh
source $ZSH/autoenv.plugin.zsh
source <($HOME/bin/kubectl completion zsh)  # setup autocomplete in zsh into the current shell
# }}}

# program settings & paths {{{
case $OSTYPE in 
  darwin*)
    export OS=darwin
    ;;
  linux*)
    export OS=linux
    ;;
  msys*)
    export OS=windows
esac

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
export VERSIONER_PERL_PREFER_32_BIT=yes
export PERL_BADLANG=0
export CLICOLOR=1
export SSH_AUTH_SOCK=$HOME/.ssh/.ssh-agent.sock
export LESS="-rX"
export PAGER=less
export GREP_OPTIONS='--color=auto'
export GREP_COLOR='1;32'
export GREP_COLORS="38;5;230:sl=38;5;240:cs=38;5;100:mt=38;5;161:fn=38;5;197:ln=38;5;212:bn=38;5;44:se=38;5;166"
export EDITOR=/usr/local/bin/nvim
export GIT_EDITOR=/usr/local/bin/nvim
export VISUAL='/usr/local/bin/nvim'
export INPUTRC=~/.inputrc
export PERL_LOCAL_LIB_ROOT=$HOME/.perl5
export PERL_MB_OPT="--install_base $HOME/.perl5";
export PERL_MM_OPT="INSTALL_BASE=$HOME/.perl5";
export PERL5LIB="$HOME/.perl5/lib/perl5/x86_64-linux-gnu-thread-multi:$HOME/.perl5/lib/perl5";
export GOPATH=$HOME/.gocode
export GO111MODULE=on

export PATH=\
/usr/local/opt/bison/bin:\
$HOME/.config/isomorphic_copy/bin:\
$HOME/bin:\
$HOME/bin/$OS:\
$HOME/.local/bin:\
$HOME/.cargo/bin:\
$GOPATH/bin:\
/usr/local/bin:\
/usr/local/sbin:\
$HOME/.platformio/penv/bin:\
$PATH

[[ -s "$HOME/.secrets/.zshrc_secret" ]] && . "$HOME/.secrets/.zshrc_secret"
alias tmux='tmux -2'
alias history='fc -l 1'
alias k="kubectl"
alias zigup="zigup --install-dir $HOME/.zig --path-link $HOME/bin/darwin/zig"

if [[ "$OSTYPE" = darwin* ]]; then
  export JAVA_HOME=/Library/Java/JavaVirtualMachines/jdk-11.0.6.jdk/Contents/Home
  export JAR=$HOME/.local/share/nvim/lspconfig/jdtls/plugins/org.eclipse.equinox.launcher_1.6.0.v20200915-1508.jar
  export GRADLE_HOME=/usr/local/opt/gradle
  export JDTLS_CONFIG=$HOME/.local/share/nvim/lspconfig/jdtls/config_mac
  export WORKSPACE=$HOME/.cache/jdtls/workspace
  export HOMEBREW_CASK_OPTS="--appdir=${HOME}/Applications"
  export HOMEBREW_NO_ENV_HINTS=1
fi

if [[ "$OSTYPE" = msys* ]]; then
  export PYTHONHOME=/c/tools/msys64/mingw64
  export PATH=$PATH:/c/tools/neovim-msys/bin:/mingw64/bin:/usr/bin
fi

if [[ $OSTYPE = linux* ]]; then
  export EDITOR=/usr/bin/vim
  export GIT_EDITOR=/usr/bin/vim
  export JAVA_HOME=/home/linuxbrew/.linuxbrew/opt/openjdk/libexec/
  export GOPATH=$HOME/.golinux
  export CARGO_HOME=$HOME/.cargo-linux
  export RUSTUP_HOME=$HOME/.rustup-linux
  export PATH=$PATH:/home/linuxbrew/.linuxbrew/bin
fi

eval $(brew shellenv)

# nvm
eval "$(fnm env)"

# conda
# !! Contents within this block are managed by 'conda init' !!
export CONDA_PREFIX=/Users/adragomi/.conda
conda() {
  __conda_setup="$('/usr/local/Caskroom/miniconda/base/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
  if [ $? -eq 0 ]; then
      eval "$__conda_setup"
  else
      if [ -f "/usr/local/Caskroom/miniconda/base/etc/profile.d/conda.sh" ]; then
          . "/usr/local/Caskroom/miniconda/base/etc/profile.d/conda.sh"
      else
          export PATH="/usr/local/Caskroom/miniconda/base/bin:$PATH"
      fi
  fi
  unset __conda_setup
}
# <<< conda initialize <<<

eval "$(frum init)"


export PATH="${KREW_ROOT:-$HOME/.krew}/bin:$PATH"
