if [ -n "${GHOSTTY_RESOURCES_DIR}" ]; then
    builtin source "${GHOSTTY_RESOURCES_DIR}/shell-integration/zsh/ghostty-integration"
fi

export LANG="en_US.UTF-8"
export LANGUAGE="en_US.UTF-8"
export LC_ALL="en_US.UTF-8"
export XDG_CONFIG_HOME=$HOME/.config/
export XDG_CACHE_HOME=$HOME/.cache/
export XDG_DATA_HOME=$HOME/.local/share/
export XDG_STATE_HOME=$HOME/.local/state/

# fpath {{{
export ZDOTDIR=$HOME/.config/zsh
fpath=($ZDOTDIR $fpath)
fpath=(/opt/homebrew/share/zsh-completions $fpath)
# }}}

export INPUTRC="$XDG_CONFIG_HOME"/readline/inputrc 

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
zmodload zsh/zle
zmodload zsh/parameter
# }}}

# autoload {{{
autoload add-zsh-hook
autoload -U colors && colors
autoload -U compinit && compinit -u -d $HOME/.cache/zsh/zcompdump
autoload -U url-quote-magic
autoload allopt
autoload -U zcalc
autoload -Uz zmv
autoload -U edit-command-line
autoload -Uz narrow-to-region
autoload -Uz add-zsh-hook
autoload -Uz vcs_info
autoload -Uz async && async
# }}}

source $(/opt/homebrew/bin/brew --prefix)/share/zsh-history-substring-search/zsh-history-substring-search.zsh

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
export LESSHISTFILE=-
HISTFILE=$HOME/.cache/zsh/history
HISTSIZE=10000
SAVEHIST=10000
export SHELL_SESSIONS_DISABLE=1

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
zstyle ':completion::complete:*' cache-path ${HOME}/.zsh/cache/
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

zle -N edit-command-line

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

bindkey -e
bindkey '\ew' kill-region
#bindkey -M isearch "^r" history-incremental-pattern-search-backward
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
zle -N physical-up-line _physical_up_line
bindkey "\e\e[A" physical-up-line

_physical_down_line() { zle forward-char  -n $COLUMNS }
zle -N physical-down-line _physical_down_line
bindkey "\e\e[B" physical-down-line

foreground-vi() {
  fg %nvim
}
zle -N foreground-vi
bindkey '^Z' foreground-vi
#bindkey -s '^Z' '\eqfg \n'

# file rename magick
bindkey "^[m" copy-prev-shell-word
zle -N self-insert url-quote-magic
# }}}

# functions {{{
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
	local -a preprompt_parts
	preprompt_parts+=('%F{blue}%~%f')
	typeset -gA prompt_pure_vcs_info
	if [[ -n $prompt_pure_vcs_info[branch] ]]; then
		preprompt_parts+=("%F{$git_color}"'${prompt_pure_vcs_info[branch]}%f')
	fi
	[[ -n $prompt_pure_username ]] && preprompt_parts+=('$prompt_pure_username')
	local cleaned_ps1=$PROMPT
	local -H MATCH
	if [[ $PROMPT = *$prompt_newline* ]]; then
		cleaned_ps1=${PROMPT%%${prompt_newline}*}${PROMPT##*${prompt_newline}}
	fi
	local -ah ps1
	ps1=(
		$prompt_newline
		${(j. .)preprompt_parts}
		$prompt_newline
		$cleaned_ps1
	)
	PROMPT="${(j..)ps1}" #"
	local expanded_prompt
	expanded_prompt="${(S%%)PROMPT}" #"
	if [[ $1 != precmd ]] && [[ $prompt_pure_last_prompt != $expanded_prompt ]]; then
		zle && zle .reset-prompt
	fi
	typeset -g prompt_pure_last_prompt=$expanded_prompt
}

prompt_pure_precmd() {
	prompt_pure_async_tasks
	psvar[12]=
	[[ -n $VIRTUAL_ENV ]] && psvar[12]="${VIRTUAL_ENV:t}"
	prompt_pure_preprompt_render "precmd"
}

prompt_pure_async_vcs_info() {
	setopt localoptions noshwordsplit
	builtin cd -q $1 2>/dev/null
	zstyle ':vcs_info:*' enable git
	zstyle ':vcs_info:*' use-simple true
	zstyle ':vcs_info:git*:*' get-revision true
	zstyle ':vcs_info:*' max-exports 2
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
	((!${prompt_pure_async_init:-0})) && {
		async_start_worker "prompt_pure" -u -n
		async_register_callback "prompt_pure" prompt_pure_async_callback
		typeset -g prompt_pure_async_init=1
	}
	typeset -gA prompt_pure_vcs_info
	local -H MATCH
	if ! [[ $PWD = ${prompt_pure_vcs_info[pwd]}* ]]; then
		async_flush_jobs "prompt_pure"
		prompt_pure_vcs_info[branch]=
		prompt_pure_vcs_info[top]=
	fi
	unset MATCH
	async_job "prompt_pure" prompt_pure_async_vcs_info $PWD
	[[ -n $prompt_pure_vcs_info[top] ]] || return
}

prompt_pure_async_callback() {
	setopt localoptions noshwordsplit
	local job=$1 code=$2 output=$3 exec_time=$4
	case $job in
		prompt_pure_async_vcs_info)
			local -A info
			typeset -gA prompt_pure_vcs_info
			info=("${(Q@)${(z)output}}") #"
			local -H MATCH
			if [[ $info[top] = $prompt_pure_vcs_info[top] ]]; then
				if [[ $prompt_pure_vcs_info[pwd] = ${PWD}* ]]; then
					prompt_pure_vcs_info[pwd]=$PWD
				fi
			else
				prompt_pure_vcs_info[pwd]=$PWD
			fi
			unset MATCH
			prompt_pure_vcs_info[branch]=$info[branch]
			prompt_pure_vcs_info[top]=$info[top]
			prompt_pure_preprompt_render
			;;
	esac
}

prompt_pure_setup() {
  export PROMPT_EOL_MARK=''
  export VIRTUAL_ENV_DISABLE_PROMPT=1
  prompt_opts=(subst percent)
	setopt noprompt{bang,cr,percent,subst} "prompt${^prompt_opts[@]}" #"
	if [[ -z $prompt_newline ]]; then
		typeset -g prompt_newline=$'\n%{\r%}'
  fi
  add-zsh-hook precmd prompt_pure_precmd
  PROMPT='%(12V.%F{242}%12v%f .)'
  PROMPT='%(?.%F{magenta}.%F{red})❯%f '
}
prompt_pure_setup "$@"

source $ZDOTDIR/golang.plugin.zsh
source $ZDOTDIR/autoenv.plugin.zsh
[[ -x "$(command -v kubectl)" ]] && source <(kubectl completion zsh)
[[ -x "$(command -v jira)" ]] && eval "$(jira --completion-script-zsh)"
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
export EDITOR=nvim
export GIT_EDITOR=nvim
export VISUAL=nvim
export CLICOLOR=1
export LESS="-rX"
export PAGER=less
export GOPATH=$HOME/.gocode
export GOBIN=$HOME/.gocode/bin
export GO111MODULE=on
export SOLARGRAPH_CACHE=$HOME/.cache/solargraph
export RUSTUP_HOME=$HOME/.cache/rustup
export RUST_SRC_PATH=${RUSTUP_HOME}/toolchains/stable-aarch64-apple-darwin/lib/rustlib/src/rust
export CARGO_HOME=$HOME/.cache/cargo
export FNM_DIR=$HOME/.cache/fnm
export npm_config_devdir=$HOME/.cache/node-gyp
export npm_config_userconfig=$HOME/.config/npm/npmrc
export BUNDLE_USER_HOME=$HOME/.cache/bundle
export FRUM_DIR=$HOME/.cache/frum
export JAVA_HOME=/opt/homebrew/opt/openjdk@17/
# export CONDA_PREFIX=$HOME/.conda
export HOMEBREW_CASK_OPTS="--appdir=${HOME}/Applications"
export HOMEBREW_NO_INSTALL_FROM_API=1
export HOMEBREW_NO_ENV_HINTS=1
if [[ $(arch) == "arm64" ]]; then
  eval $(/opt/homebrew/bin/brew shellenv)
else
  eval $(/usr/local/bin/brew shellenv)
fi

export ZVM_PATH=$XDG_DATA_HOME/zvm
export ZVM_INSTALL="$ZVM_PATH/self"

export MODULAR_HOME="/Users/adragomi/.modular"
#export RUSTC_WRAPPER=/opt/homebrew/bin/sccache
export SCCACHE_DIR=$HOME/.cache/sccache
export SCCACHE_CACHE_SIZE="30G"
export KLAYOUT_HOME=$XDG_CONFIG_HOME/klayout
export GNUPGHOME=$XDG_DATA_HOME/gnupg
export NPM_CONFIG_USERCONFIG=$XDG_CONFIG_HOME/npm/npmrc 
export PLATFORMIO_CORE_DIR=$XDG_DATA_HOME/platformio 
export AWS_SHARED_CREDENTIALS_FILE=$XDG_CONFIG_HOME/aws/credentials
export AWS_CONFIG_FILE=$XDG_CONFIG_HOME/aws/config
export AZURE_CONFIG_DIR=$XDG_DATA_HOME/azure 
export PYTHON_HISTORY=$XDG_STATE_HOME/python_history
export PYTHONPYCACHEPREFIX=$XDG_CACHE_HOME/python
export PYTHONUSERBASE=$XDG_DATA_HOME/python 
export MAVEN_OPTS="-Dmaven.repo.local=$XDG_DATA_HOME/maven/repository"
export MAVEN_ARGS="--settings $XDG_CONFIG_HOME/maven/settings.xml"
export MPLCONFIGDIR=$XDG_DATA_HOME/matplotlib
export SQLITE_HISTORY=$XDG_STATE_HOME/sqlite_history

# for prost-build crate
export PROTOC=/opt/homebrew/bin/protoc

export SDK=/Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX.sdk

export PATH=\
/opt/blink/bin:\
/opt/cosmo/bin:\
/opt/homebrew/opt/bison/bin:\
$HOME/bin:\
$HOME/bin/$OS:\
$HOME/.krew/bin:\
$HOME/.local/bin:\
$HOME/.cache/cargo/bin:\
$ZVM_INSTALL:\
$ZVM_PATH/bin:\
$GOPATH/bin:\
$HOME/work/tools/uxn:\
$HOME/work/tools/jai/bin:\
$HOME/.local/share/npm/bin:\
/opt/homebrew/share/dotnet:\
/opt/homebrew/bin:\
/opt/homebrew/sbin:\
/usr/local/bin:\
/opt/local/sbin:\
$HOME/.dotnet/tools:\
/opt/X11/bin:\
/opt/homebrew/share/dotnet:\
/usr/bin:/bin:\
/usr/sbin:\
/sbin:\
$PATH

bindkey "^R" _selecta-select-history
bindkey '^xe' edit-command-line

[[ -s "$HOME/.secrets/.zshrc_secret" ]] && . "$HOME/.secrets/.zshrc_secret"

alias tmux='tmux -2'
alias history='fc -l 1'
alias k="kubectl"
alias 4ed="${HOME}/Applications/Development\ Tools/4coder/4ed &"
alias icat="kitty +kitten icat"
alias hg="kitty +kitten hyperlinked_grep"
alias rg="rg --hyperlink-format=kitty"

if [[ "$OSTYPE" = msys* ]]; then
  export PYTHONHOME=/c/tools/msys64/mingw64
  export PATH=$PATH:/c/tools/neovim-msys/bin:/mingw64/bin:/usr/bin
fi

export PIP_BREAK_SYSTEM_PACKAGES=1
export VCPKG_ROOT="$HOME/.cache/vcpkg"
export DOCKER_BUILDKIT=1
export BUILDKIT_PROGRESS=plain
export OLLAMA_MODELS=$HOME/.cache/ollama
export PATH="$PATH:/Users/adragomi/.modular/bin"
export PIPENV_VENV_IN_PROJECT=1
# Added by LM Studio CLI (lms)
export PATH="$PATH:/Users/adragomi/.lmstudio/bin"

eval "$(_PIO_COMPLETE=zsh_source pio)"
export CONAN_HOME=$HOME/.config/conan2
export LUAROCKS_CONFIG="$HOME/.config/lua/luarocks-5.1.lua"
export LUA_PATH="$LUA_PATH;$HOME/.local/lib/lua/share/lua/5.1/?.lua"
export LUA_PATH="$LUA_PATH;$HOME/.local/lib/lua/share/lua/5.1/?/init.lua"
export LUA_CPATH="$HOME/.local/lib/lua/lib/lua/5.1/?.so"
export VSCODE_CLI_DATA_DIR=/Users/adragomi/Applications/DevelopmentTools/code-insiders-portable-data/data/cli

export CLAUDE_CODE=$HOME/.config/claude
export CLAUDE_CONFIG_DIR=$HOME/.config/claude
export PI_CODING_AGENT_DIR=$HOME/.config/pi/agent
