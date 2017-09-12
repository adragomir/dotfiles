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

_selecta() {
  zle -I
  result=$( pt -l --nocolor -g . | selecta )
  RBUFFER="$result "
  CURSOR+=$#RBUFFER
}
zle -N _selecta
bindkey "\C-t" _selecta

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

autoload -Uz narrow-to-region

# http://qiita.com/uchiko/items/f6b1528d7362c9310da0
function _selecta-select-history() {
    local selected_entry
    # Print a newline or we'll clobber the old prompt.
    echo
    # Find the path; abort if the user doesn't select anything.
    BUFFER=$( fc -lnr 1 | hs --filter-only ) || return
    # BUFFER=$( fc -lnr 1 | select -x ) || return
    CURSOR=$#BUFFER
    # Append the selection to the current command buffer.
    # eval 'LBUFFER="$LBUFFER$selected_entry"'
    # Redraw the prompt since Selecta has drawn several new lines of text.
    zle reset-prompt
}
zle -N _selecta-select-history
bindkey '^r' _selecta-select-history

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
prompt_pure_git_dirty() {
  # check if we're in a git repo
  command git rev-parse --is-inside-work-tree &>/dev/null || return
  # check if it's dirty
  [[ "$PURE_GIT_UNTRACKED_DIRTY" == 0 ]] && local umode="-uno" || local umode="-unormal"
  test -n "$(git status --porcelain --ignore-submodules ${umode})"

  (($? == 0)) && echo '*'
}

prompt_pure_preexec() {
  # shows the current dir and executed command in the title when a process is active
  print -Pn "\e]0;"
  echo -nE "$PWD:t: $2"
  print -Pn "\a"
}

prompt_pure_precmd() {
  # shows the full path in the title
  #repeat $COLUMNS printf '-'
  print -Pn '\e]0;%~\a'

  # git info
  vcs_info

  local prompt_pure_preprompt="\n%F{blue}%~%F{242}$vcs_info_msg_0_`prompt_pure_git_dirty` $prompt_pure_username%f"
  print -P $prompt_pure_preprompt
}

prompt_pure_setup() {
  # prevent percentage showing up
  # if output doesn't end with a newline
  export PROMPT_EOL_MARK=''

  prompt_opts=(cr subst percent)

  autoload -Uz add-zsh-hook
  autoload -Uz vcs_info

  add-zsh-hook precmd prompt_pure_precmd
  add-zsh-hook preexec prompt_pure_preexec

  zstyle ':vcs_info:*' enable git
  #zstyle ':vcs_info:*' check-for-changes true
  zstyle ':vcs_info:git*:*' get-revision true
  zstyle ':vcs_info:git*' formats ' %b %6.6i'
  zstyle ':vcs_info:git*' actionformats ' %b %6.6i|%a'

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
export MAVEN_OPTS="-Djava.awt.headless=true"
export JAVA_TOOL_OPTIONS='-Djava.awt.headless=true'
export MVN_OPTS="-Djava.awt.headless=true"
export LESS="-rX"
export PAGER=less

if [[ "$OSTYPE" = darwin* ]]; then
  export EDITOR=/usr/local/bin/vim
  export GIT_EDITOR=/usr/local/bin/vim
else
  export EDITOR=/usr/bin/vim
  export GIT_EDITOR=/usr/bin/vim
fi

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
  export JENV_ROOT=/usr/local/opt/jenv
  if which jenv > /dev/null; then eval "$(jenv init -)"; fi
  export JAVA_HOME=$(readlink /usr/local/opt/jenv/versions/`cat /usr/local/opt/jenv/version`)
  #export JAVA_HOME="$(/usr/libexec/java_home -v 1.6.0_43-b01-447)"
else
  export JAVA_HOME=/usr/lib/jvm/java-8-jdk
fi

# scala
export SCALA_HOME=/usr/local/opt/scala

if [[ "$OSTYPE" = darwin* ]]; then
  export VIMRUNTIME=/usr/local/opt/vim/share/vim/vim80/
fi  
if [[ "$OSTYPE" = linux* ]]; then
  export VIMRUNTIME=/usr/share/vim/vim80
fi

# go
export GOPATH=$HOME/.gocode
export GO15VENDOREXPERIMENT=1

# esp8266 {{{
export XTENSA_TOOL_ROOT=/usr/local/Cellar/xtensa-lx106-elf
export XTENSA_TOOL_BIN=/usr/local/Cellar/xtensa-lx106-elf/bin
export ESP8266_SDK_BASE=/usr/local/Cellar/xtensa-lx106-elf/esp_iot_sdk
export ESP8266_RTOS_SDK_BASE=/usr/local/Cellar/xtensa-lx106-elf/esp_iot_rtos_sdk
#}}}


if [[ $OS = "linux" ]]; then
  export rvm_ignore_gemrc_issues=1
fi
[[ -f $HOME/.rvm/scripts/rvm ]] && source $HOME/.rvm/scripts/rvm

# path {{{
export PATH=\
/usr/local/opt/python/libexec/bin:\
$HOME/.rvm/bin:\
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
$HOME/.perl5/bin:\
$GOPATH/bin:\
/usr/local/openresty/nginx/sbin:\
/usr/local/openresty/luajit/bin:\
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
alias youtube720-dl="youtube-dl -f 'bestvideo[height<=720]+bestaudio/best[height<=720]'"
alias youtube480-dl="youtube-dl -f 'bestvideo[height<=480]+bestaudio/best[height<=480]'"
alias youtube360-dl="youtube-dl -f 'bestvideo[height<=360]+bestaudio/best[height<=360]'"
alias luarocks="luarocks --tree=${HOME}/.luarocks"
alias luajitrocks="luajitrocks --tree=${HOME}/.luajitrocks"

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

export LUA_PATH="\
/usr/local/opt/lua/share/lua/5.2/?.lua;\
/usr/local/opt/lua/share/lua/5.2/?/init.lua;\
${HOME}/.luarocks/share/lua/5.2/?.lua;\
${HOME}/.luarocks/share/lua/5.2/?/init.lua;\
./?.lua;\
./?/init.lua\
"

export LUA_CPATH="\
/usr/local/opt/lua/lib/lua/5.2/?.so;\
${HOME}/.luarocks/lib/lua/5.2/?.so;\
/usr/local/opt/lua/lib/lua/5.2/loadall.so;\
./?.so\
"

export LUAJIT_PATH="\
/usr/local/opt/luajit/share/luajit-2.1.0-beta1/?.lua;\
/usr/local/opt/luajit/share/lua/5.1/?.lua;\
/usr/local/opt/luajit/share/lua/5.1/?/init.lua;\
${HOME}/.luajitrocks/share/lua/5.1/?.lua;\
${HOME}/.luajitrocks/share/lua/5.1/?/init.lua;\
./?.lua;\
./?/init.lua\
"

export LUAJIT_CPATH="\
/usr/local/opt/luajit/lib/lua/5.1/?.so;\
${HOME}/.luajitrocks/lib/lua/5.1/?.so;\
/usr/local/opt/luajit/lib/lua/5.1/loadall.so;\
./?.so\
"

alias lua='LUA_PATH=${LUA_PATH} LUA_CPATH=${LUA_CPATH} /usr/local/bin/lua'
alias luarocks='LUA_PATH=${LUA_PATH} LUA_CPATH=${LUA_CPATH} /usr/local/bin/luarocks --tree=${HOME}/.luarocks'
alias luajit='LUA_PATH=${LUAJIT_PATH} LUA_CPATH=${LUAJIT_CPATH} /usr/local/bin/luajit'
alias luajitrocks='LUA_PATH=${LUAJIT_PATH} LUA_CPATH=${LUAJIT_CPATH} /usr/local/bin/luajitrocks --tree=${HOME}/.luajitrocks'

export HOMEBREW_CASK_OPTS="--appdir=${HOME}/Applications"

eval "$(direnv hook zsh)"

#[[ $OS == "Darwin" ]] && test -e ${HOME}/.iterm2_shell_integration.zsh && source ${HOME}/.iterm2_shell_integration.zsh

#[ -f $HOME/.nix-profile/etc/profile.d/nix.sh ] && . $HOME/.nix-profile/etc/profile.d/nix.sh
[ -f $HOME/.zshrc_secrets ] && . $HOME/.zshrc_secrets

eval "$(vg eval --shell zsh)"

export NVM_DIR="$HOME/.nvm"
. "/usr/local/opt/nvm/nvm.sh"

source /usr/local/opt/chruby/share/chruby/chruby.sh
RUBIES+=(~/.rvm/rubies/*)
source /usr/local/share/gem_home/gem_home.sh

[[ -s "/Users/adr/.gvm/scripts/gvm" ]] && source "/Users/adr/.gvm/scripts/gvm"
