# Notes: ----------------------------------------------------------
# When you start an interactive shell (log in, open terminal or iTerm in OS X,
# or create a new tab in iTerm) the following files are read and run, in this order:
# profile
# bashrc
# .bash_profile
# .bashrc (only because this file is run (sourced) in .bash_profile)
#
# When an interactive shell, that is not a login shell, is started
# (when you run "bash" from inside a shell, or when you start a shell in
# xwindows [xterm/gnome-terminal/etc] ) the following files are read and executed,
# in this order:
# bashrc
# .bashrc
 

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

# bash completions for j
complete -C 'j --complete "$COMP_LINE"' j

###
###
###
export SCONS_LIB_DIR="/Library/Python/2.6/site-packages/scons-1.2.0-py2.6.egg/scons-1.2.0"
export COPY_EXTENDED_ATTRIBUTES_DISABLE=true

#export LESS='-fXemPm?f%f .?lbLine %lb?L of %L..:$' # Set options for less command
export PAGER=less
export EDITOR='vim'
export VISUAL='vim'
export LC_ALL="en_US.UTF-8"
# Fancy PWD display function
# The home directory (HOME) is replaced with a ~
# /home/me/stuff          -> ~/stuff               if USER=me
# /usr/share/big_dir_name -> ../share/big_dir_name if pwdmaxlen=20
bash_prompt_command() {
  if [ $? -ne 0 ]
  then
    ERROR_FLAG=1
  else
    ERROR_FLAG=
  fi
  # How many characters of the $PWD should be kept
  local pwdmaxlen=25
  # Indicate that there has been dir truncation
  local trunc_symbol=".."
  local dir=${PWD##*/}
  pwdmaxlen=$(( ( pwdmaxlen < ${#dir} ) ? ${#dir} : pwdmaxlen ))
  NEW_PWD=${PWD/#$HOME/\~}
  local pwdoffset=$(( ${#NEW_PWD} - pwdmaxlen ))
  if [ ${pwdoffset} -gt "0" ]
  then
      NEW_PWD=${NEW_PWD:$pwdoffset:$pwdmaxlen}
      NEW_PWD=${trunc_symbol}/${NEW_PWD#*/}
  fi
}

# Tab complete for sudo
complete -cf sudo
# type and which complete on commands
complete -c command type which
# builtin completes on builtins
#complete -b builtin
# shopt completes with shopt options
#complete -A shopt shopt
# set completes with set options
complete -A setopt set
# readonly and unset complete with shell variables
complete -v readonly unset
# bg completes with stopped jobs
complete -A stopped -P '%' bg
# other job commands
complete -j -P '%' fg jobs disown

#stops ctrl+d from logging me out
set -o ignoreeof

# Turn on extended globbing and programmable completion
shopt -s extglob progcomp

source ~/.bash/git-completion.bash
source ~/.bash/todo_completer.sh
complete -F _todo_sh -o default t

VERSIONER_PERL_PREFER_32_BIT=yes
PERL_BADLANG=0

#prompt
sh_norm="\[\033[0m\]"
sh_black="\[\033[0;30m\]"
sh_darkgray="\[\033[1;30m\]"
sh_blue="\[\033[0;34m\]"
sh_light_blue="\[\033[1;34m\]"
sh_green="\[\033[0;32m\]"
sh_light_green="\[\033[1;32m\]"
sh_cyan="\[\033[0;36m\]"
sh_light_cyan="\[\033[1;36m\]"
sh_red="\[\033[0;31m\]"
sh_light_red="\[\033[1;31m\]"
sh_purple="\[\033[0;35m\]"
sh_light_purple="\[\033[1;35m\]"
sh_brown="\[\033[0;33m\]"
sh_yellow="\[\033[1;33m\]"
sh_light_gray="\[\033[0;37m\]"
sh_white="\[\033[1;37m\]"

# TODO
HOSTCOLOUR=${sh_green}

function git_dirty_flag() {
  [[ $(git status 2> /dev/null | tail -n1) != "nothing to commit (working directory clean)" ]] && echo "⚡"
  #git status 2> /dev/null | grep -c : | awk '{if ($1 > 0) print "☠"}'
}

export PS1="${sh_yellow}[<\u@${HOSTCOLOUR}\h${sh_norm}${sh_yellow}>][\t][\w][${sh_red}\$(__git_ps1 '%s')${sh_yellow}]\n${sh_yellow}$ ${sh_norm}"

#########
# Path 
#########
export CURLY_LOCATION=$HOME/bin/ozzy
export PATH=/usr/local/php5/bin:$PATH
export PATH=/usr/local/bin:$PATH:$HOME/bin:$HOME/bin/ozzy:$HOME/andrei/leo/bin
export PATH=$PATH:"/System/Library/Frameworks/Ruby.framework/Versions/Current/usr/bin"
export PATH=$PATH:"$HOME/Applications/Graphics/Graphviz.app/Contents/MacOS"
export PATH=$PATH:/usr/local/lib/ocaml_godi/bin/
export PATH=$PATH:"$HOME/Applications/Racket v5.0.1/bin/"
export PATH=$HOME/.cabal/bin/:$PATH
export PATH=$PATH:/usr/hla


export hlalib=/usr/hla/hlalib
export hlainc=/usr/hla/include

#export DISPLAY=:0.0

# colors in terminal
export CLICOLOR=1
export LSCOLORS=ExFxCxDxBxegedabagacad

# Flex & Apollo
# don't know which is used
export FLEX_HOME=$HOME/work/tools/flex-3.4.1
export FLEX_SDK=$FLEX_HOME
export FLEX_SDK_HOME=$FLEX_HOME

# tamarin, asc and friends
export TAMARIN_HOME=$HOME/temp/svn_other_projects/lang.tamarin-central
export ASC=$HOME/temp/svn_other_projects/flexsdk/lib/asc.jar
export ASC_COMMAND="java -ea -DAS3 -DAVMPLUS -classpath ${ASC} macromedia.asc.embedding.ScriptCompiler  -abcfuture "
export AVMSHELL_COMMAND=$HOME/temp/svn_other_projects/lang.tamarin-central/__build/shell/avmshell
export AVMSHELL_DEBUG_COMMAND=$HOME/temp/svn_other_projects/lang.tamarin-central/__build_debugger/shell/avmshell

export PATH=$PATH:$FLEX_HOME/bin

#ant
export ANT_HOME=$HOME/work/tools/apache-ant-1.7.1
export ANT_OPTS="-Xms256m -Xmx512m"

# maven
export MAVEN_REPO=$HOME/.m2/repository
export PATH=/Users/adragomi/work/tools/apache-maven-3.0/bin/:$PATH
#
# Your previous .profile  (if any) is saved as .profile.dpsaved
# Setting the path for DarwinPorts.
export PATH=$PATH:/opt/local/bin:/opt/local/sbin
export PATH=$PATH:/opt/local/jruby/bin
export LC_CTYPE=en_US.UTF-8

# Setting PATH for MacPython 2.5
# The orginal version is saved in .profile.pysave
PATH="/usr/local/mysql/bin:${PATH}"
export PATH

# Setting PATH for MacPython 2.5
# The orginal version is saved in .profile.pysave
PATH=$PATH:$HOME/Applications/zero-1.0.0.P20070702-1062
export PATH

export PYTHONPATH=/opt/local/lib/python2.5/site-packages:$HOME/.python
export PYTHONPATH=$PYTHONPATH:$HOME/.python
export JMETER_HOME=~/work/tools/jakarta-jmeter-2.3.2
PATH=$PATH:$JMETER_HOME/bin
export PATH=$PATH:/System/Library/Frameworks/Ruby.framework/Versions/1.8/usr/bin/

####################
### history settings
####################
export HISTFILE=$HOME/.history/`date +%Y%m%d`.hist
export HISTSIZE=100000
export HISTCONTROL=ignoredups

# browser
export BROWSER=/Applications/Firefox.app/Contents/MacOS/firefox-bin

# shell options
# extended globbing
shopt -s extglob
# allow .dotfile to be returned in path-name expansion
shopt -s dotglob
# this allows editing of multi-line commands.
shopt -s cmdhist
# make it append, rather than overwrite the history
shopt -s histappend
# fix typos
shopt -s cdspell
shopt -s histverify
shopt -s globstar
shopt -s autocd

export P4CONFIG=.p4conf
export HTML_TIDY=$HOME/.tidyconf
export FCSH_VIM_ROOT=$HOME/work/flex/sdk/bin

#########
# aliases
#########

# pssh 
alias pssh_mia='pssh -P -l admin -h ~/.pssh/hosts_saasbase_miami'
alias pssh_rtc='pssh -P -l hadoop -h ~/.pssh/hosts_rtc'
alias pscp_rtc='pscp -l hadoop -h ~/.pssh/hosts_rtc'
alias pssh_rtc='pssh -P -l admin -h ~/.pssh/hosts_staging_css'
alias pscp_rtc='pscp -l admin -h ~/.pssh/hosts_staging_css'
# bochs
alias bochs='LTDL_LIBRARY_PATH=$HOME/work/tools/bochs/lib/bochs/plugins BXSHARE=$HOME/work/tools/bochs/share/bochs $HOME/work/tools/bochs/bin/bochs'

#editor
case "$HOSTNAME" in
  $USER-mac*)
  alias gvim='$HOME/Applications/MacVim.app/Contents/MacOS/Vim -g';
  alias vim='$HOME/Applications/MacVim.app/Contents/MacOS/Vim';
  ;;
  sheeva*)
  alias vim='/usr/bin/vim';
  ;;
esac

# git commands
alias gss="git stash save"
alias gsp="git stash pop"
# git
alias gl="git log"
alias ga="git add"
alias gr="git reset"
alias gs="git status"
alias gst="git status"

# git diff
alias gd="git diff"
alias gdc="git diff --cached"

alias g-update-deleted="git ls-files -z --deleted | git update-index -z --remove --stdin"

#git branch
alias gb="git branch"
alias gba="git branch -a -v"

alias gfr="git fetch && git rebase refs/remotes/origin/master"
alias gci="git commit"
alias gco="git checkout"

# asc, tamarin
alias asc='$ASC_COMMAND'
alias asc_tamarin='$ASC_COMMAND -import $TAMARIN_HOME/core/builtin.abc'
alias asc_flash='$ASC_COMMAND -import $FLEX_HOME/modules/asc/abc/builtin.abc -import $FLEX_HOME/modules/asc/abc/playerglobal.abc'
alias asc_tamarin_shell='$FLEX_HOME/bin/asc -AS3 -import $TAMARIN_HOME/core/builtin.abc -import $TAMARIN_HOME/shell/shell_toplevel.abc'
alias avm='$AVMSHELL_COMMAND'
alias avm_debug='$AVMSHELL_DEBUG_COMMAND'


# clojure
alias clojure='rlwrap java -cp $MAVEN_REPO/org/clojure/clojure/1.1.0-master-SNAPSHOT/clojure-1.1.0-master-SNAPSHOT.jar:$MAVEN_REPO/org/clojure/clojure-contrib/1.1.0-master-SNAPSHOT/clojure-contrib-1.1.0-master-SNAPSHOT.jar clojure.main'
alias clojure_boot='rlwrap java -Xbootclasspath/a:$MAVEN_REPO/org/clojure/clojure/1.1.0-master-SNAPSHOT/clojure-1.1.0-master-SNAPSHOT.jar:$MAVEN_REPO/org/clojure/clojure-contrib/1.1.0-master-SNAPSHOT/clojure-contrib-1.1.0-master-SNAPSHOT.jar clojure.main'
alias clj='rlwrap java -cp $MAVEN_REPO/org/clojure/clojure/1.1.0-master-SNAPSHOT/clojure-1.1.0-master-SNAPSHOT.jar:$MAVEN_REPO/org/clojure/clojure-contrib/1.1.0-master-SNAPSHOT/clojure-contrib-1.1.0-master-SNAPSHOT.jar clojure.main'
alias ng-server='rlwrap java -cp $MAVEN_REPO/org/clojure/clojure/1.1.0-master-SNAPSHOT/clojure-1.1.0-master-SNAPSHOT.jar:$MAVEN_REPO/org/clojure/clojure-contrib/1.1.0-master-SNAPSHOT/clojure-contrib-1.1.0-master-SNAPSHOT.jar:$MAVEN_REPO/vimclojure/vimclojure/2.2.0-SNAPSHOT/vimclojure-2.2.0-SNAPSHOT.jar com.martiansoftware.nailgun.NGServer 127.0.0.1'

#builtin commands
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
alias finde='find -E'
alias g='gvim.sh'

alias ack="ack -i -a"
alias pgrep='pgrep -lf'

alias df='df -h'
alias du='du -h -c'

alias psa='ps auxwww'
alias ping='ping -c 5'
alias grep='grep --colour'
alias svnaddall='svn status | grep "^\?" | awk "{print \$2}" | xargs svn add'
alias irb='irb --readline -r irb/completion -rubygems'
alias ri='ri -Tf ansi'
alias tu='top -o cpu'
alias tm='top -o vsize'

alias t="~/bin/todo.py -d '$HOME/Documents/personal/life/exploded/todo@/'"

# text 2 html
alias textile='/usr/bin/redcloth'
alias markdown='/usr/local/bin/markdown'

alias math='rlwrap $HOME/Applications/Mathematica.app/Contents/MacOS/MathKernel'

# hadoop, hbase, etc
alias hadoop='$HOME/work/saasbase_env/hadoop/bin/hadoop'
alias hdfs='$HOME/work/saasbase_env/hadoop/bin/hdfs'
alias mapred='$HOME/work/saasbase_env/hadoop/bin/mapred'
alias hbase='$HOME/work/saasbase_env/hbase/bin/hbase'
alias zk='$HOME/work/saasbase_env/zookeeper/bin/zkCli.sh'
alias saasbase='$HOME/work/saasbase_env/saasbase/src/saasbase_thrift/bin/saasbase'
alias psall='ps? NameNode DataNode TaskTracker JobTracker Quorum HMaster HRegion ThriftServer'

alias nasm='$HOME/work/tools/nasm/nasm'

function ps? {
  for i in $*; do
    grepstr=[${i:0:1}]${i:1:${#i}}
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


##########
#functions
##########

# mkdir, cd into it
mkcd () {
  mkdir -p "$*"
  cd "$*"
}

calc () 
{ echo "$*" | bc -l; }

alias h="sudo hostname $USER-mac.corp.adobe.com"

export MONO_GAC_PREFIX=/usr/local

export PATH=$PATH:$CINTSYSDIR
export PATH=$PATH:$HOME/Applications/dev/Factor

export PYTHONSTARTUP=~/.pythonstartup


# luatext
#export TEXMFCNF=/usr/local/texlive/2008/texmf/web2c/
#export LUAINPUTS='{/usr/local/texlive/texmf-local/tex/context/base,/usr/local/texlive/texmf-local/scripts/context/lua,$HOME/texmf/scripts/context/lua}'
#export TEXMF='{$HOME/.texlive2008/texmf-config,$HOME/.texlive2008/texmf-var,$HOME/texmf,/usr/local/texlive/2008/texmf-config,/usr/local/texlive/2008/texmf-var,/usr/local/texlive/2008/texmf,/usr/local/texlive/texmf-local,/usr/local/texlive/2008/texmf-dist,/usr/local/texlive/2008/texmf.gwtex}'
export TEXMFCACHE=/tmp
#export TEXMFCNF=/usr/local/texlive/2008/texmf/web2c

#export PATH=$PATH:/usr/local/texlive/2008/bin/universal-darwin

export JAVA_HOME=/System/Library/Frameworks/JavaVM.framework/Versions/1.6.0/Home
#export MAVEN_HOME=/usr/share/maven
#export JUNIT_HOME=/usr/share/junit

export PATH=$PATH:$HOME/work/tools/emulator/Vice/tools
# haxe
#export HAXE_LIBRARY_PATH=/usr/local/haxe/std:.
#export NEKOPATH=/usr/local/neko
#export PATH=$PATH:/usr/local/arm-apple-darwin/bin/
export MANPATH=/opt/local/share/man:/usr/local/man:$MANPATH

export LANDINGPAD=

test -r /sw/bin/init.sh && . /sw/bin/init.sh

# wiki
export WIKI=$HOME/Documents/personal/life/exploded/
export DVA_HOME=$HOME/work/theoden/depot/shared_code/adobe/dva/adobe

export DYLD_LIBRARY_PATH=$DYLD_LIBRARY_PATH:/usr/local/spidermonkey/lib
export DYLD_FRAMEWORK_PATH=$DYLD_FRAMEWORK_PATH:"$HOME/Applications/Racket v5.0.1/lib/"

export PATH=/Users/adragomi/work/tools/gradle-0.9-rc-3/bin/:$PATH


#GO
export GOROOT=$HOME/temp/svn_other_projects/go
export GOOS=darwin
export GOARCH=amd64
export GOBIN=$HOME/bin/go

export PATH=$PATH:$HOME/bin/go
export PATH=$PATH:$HOME/work/tools/rhino1_7R2/
export PATH=$PATH:$HOME/work/tools/nasm/
# ooc
export PATH=$PATH:$HOME/temp/svn_other_projects/rock/bin

export JAQL_HOME=$HOME/work/saasbase_env/jaql
export HADOOP_HOME=$HOME/work/saasbase_env/hadoop

export PATH=$HOME/.cljr/bin:$PATH
export ROO_HOME=$HOME/work/tools/spring-roo-1.1.0.M1
export PATH=$PATH:$ROO_HOME/bin

export M2_HOME=/usr/share/maven
export NOTES=$HOME/Documents/personal/life/notes@/
