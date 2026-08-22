export LANG="en_US.UTF-8"
export LANGUAGE="en_US.UTF-8"
export LC_ALL="en_US.UTF-8"
export XDG_CONFIG_HOME=$HOME/.config/
export XDG_CACHE_HOME=$HOME/.cache/
export XDG_DATA_HOME=$HOME/.local/share/
export XDG_STATE_HOME=$HOME/.local/state/
export INPUTRC="$XDG_CONFIG_HOME"/readline/inputrc 

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
export LESS="-RX"
export PAGER=/opt/homebrew/bin/less
export GOPATH=$HOME/.gocode
export GOBIN=$HOME/.gocode/bin
export GO111MODULE=on
export SOLARGRAPH_CACHE=$HOME/.cache/solargraph

# allow -Z shit
export RUSTC_BOOTSTRAP=1
export RUSTUP_HOME=$HOME/.cache/rustup
export RUSTUP_TOOLCHAIN=stable-aarch64-apple-darwin

export CARGO_HOME=$HOME/.cache/cargo
export FNM_DIR=$HOME/.cache/fnm
export npm_config_userconfig=$HOME/.config/npm/npmrc
export BUNDLE_USER_HOME=$HOME/.cache/bundle
export FRUM_DIR=$HOME/.cache/frum
export JAVA_HOME=/opt/homebrew/opt/openjdk@21/
# export CONDA_PREFIX=$HOME/.conda
export HOMEBREW_CASK_OPTS="--appdir=${HOME}/Applications"
export HOMEBREW_NO_INSTALL_FROM_API=1
export HOMEBREW_NO_ENV_HINTS=1
export HOMEBREW_NO_INSTALL_CLEANUP=1
if [[ $(arch) == "arm64" ]]; then
  eval $(/opt/homebrew/bin/brew shellenv)
else
  eval $(/usr/local/bin/brew shellenv)
fi

export ZVM_PATH=$XDG_DATA_HOME/zvm
export ZVM_INSTALL="$ZVM_PATH/self"

export MODULAR_HOME="/Users/adragomi/.modular"
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
/opt/homebrew/opt/rustup/bin:\
$HOME/.cache/cargo/bin:\
$ZVM_INSTALL:\
$ZVM_PATH/bin:\
$GOPATH/bin:\
$HOME/work/tools/uxn:\
$HOME/work/tools/jai/bin:\
$HOME/.local/share/npm/bin:\
$HOME/.local/tomo/bin:\
$HOME/Applications/Documents/calibre.app/Contents/MacOS:\
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

export PIP_BREAK_SYSTEM_PACKAGES=1
export VCPKG_ROOT="$HOME/.cache/vcpkg"
export DOCKER_BUILDKIT=1
export BUILDKIT_PROGRESS=plain
export OLLAMA_MODELS=$HOME/.cache/ollama
export PATH="$PATH:/Users/adragomi/.modular/bin"
export PIPENV_VENV_IN_PROJECT=1
export PATH="$PATH:/Users/adragomi/.lmstudio/bin"

export CONAN_HOME=$HOME/.config/conan2
export LUAROCKS_CONFIG="$HOME/.config/lua/luarocks-5.1.lua"
export LUA_PATH="$LUA_PATH;$HOME/.local/lib/lua/share/lua/5.1/?.lua"
export LUA_PATH="$LUA_PATH;$HOME/.local/lib/lua/share/lua/5.1/?/init.lua"
export LUA_CPATH="$HOME/.local/lib/lua/lib/lua/5.1/?.so"
export VSCODE_CLI_DATA_DIR=/Users/adragomi/Applications/DevelopmentTools/code-insiders-portable-data/data/cli
export JFROG_CLI_HOME_DIR=$XDG_STATE_HOME/jfrog

export CLAUDE_CODE=$HOME/.config/claude
export CLAUDE_CONFIG_DIR=$HOME/.config/claude
export PI_CODING_AGENT_DIR=$HOME/.config/pi/agent

export BROWSER_BIN="$HOME/Applications/Browsers/Google Chrome.app/Contents/MacOS/Google Chrome"
export WEB_BROWSE_BROWSER_BIN="$HOME/Applications/Browsers/Google Chrome.app/Contents/MacOS/Google Chrome"
export KACHE_CONFIG=$XDG_CONFIG_HOME/kache/config.toml
export KACHE_CACHE_DIR=$XDG_CACHE_HOME/kache
export KACHE_RUSTC_PATH_NORMALIZE=0
export KACHE_CC_PATH_NORMALIZE=0


