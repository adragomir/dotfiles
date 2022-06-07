# This file contains fish universal variable definitions.
# VERSION: 3.0
set -U fish_greeting ""
set -Ux __fish_initialized 3100
set -Ux fish_color_autosuggestion 555\x1ebrblack
set -Ux fish_color_cancel \x2dr
set -Ux fish_color_command white
set -Ux fish_color_comment 990000
set -Ux fish_color_cwd blue
set -Ux fish_color_cwd_root red
set -Ux fish_color_end 009900
set -Ux fish_color_error ff0000
set -Ux fish_color_escape 00a6b2
set -Ux fish_color_history_current \x2d\x2dbold
set -Ux fish_color_host normal
set -Ux fish_color_host_remote yellow
set -Ux fish_color_normal normal
set -Ux fish_color_operator 00a6b2
set -Ux fish_color_param 00afff
set -Ux fish_color_quote 999900
set -Ux fish_color_redirection 00afff
set -Ux fish_color_search_match bryellow\x1e\x2d\x2dbackground\x3dbrblack
set -Ux fish_color_selection white\x1e\x2d\x2dbold\x1e\x2d\x2dbackground\x3dbrblack
set -Ux fish_color_status red
set -Ux fish_color_user brgreen
set -Ux fish_color_valid_path \x2d\x2dunderline
set -Ux fish_key_bindings fish_default_key_bindings
set -Ux fish_pager_color_completion \x1d
set -Ux fish_pager_color_description B3A06D\x1eyellow
set -Ux fish_pager_color_prefix normal\x1e\x2d\x2dbold\x1e\x2d\x2dunderline
set -Ux fish_pager_color_progress brwhite\x1e\x2d\x2dbackground\x3dcyan

set -g fish_term24bit 0

function fish_prompt --description 'Informative prompt'
    #Save the return status of the previous command
    set -l last_pipestatus $pipestatus
    set -lx __fish_last_status $status # set -x for __fish_print_pipestatus.

    set -l status_color (set_color $fish_color_status)
    set -l statusb_color (set_color --bold $fish_color_status)
    set -l pipestatus_string (__fish_print_pipestatus "[" "]" "|" "$status_color" "$statusb_color" $last_pipestatus)
    set -g fish_prompt_pwd_dir_length 10

    printf '%s%s%s %s%s%s \n%s❯%s ' (set_color blue) \
        (set_color $fish_color_cwd) (prompt_pwd) $pipestatus_string (fish_git_prompt) \
        (set_color normal) \
        (set_color red) (set_color normal)
end

if status is-interactive
    # Commands to run in interactive sessions can go here
end

set -x LANG "en_US.UTF-8"
set -x LANGUAGE "en_US.UTF-8"
set -x LC_ALL "en_US.UTF-8"
set -x LC_CTYPE "en_US.UTF-8"
set -x LC_NUMERIC "en_US.utf8"
set -x LC_TIME "en_US.utf8"
set -x LC_COLLATE "en_US.utf8"
set -x LC_MONETARY "en_US.utf8"
set -x LC_MESSAGES "en_US.utf8"
set -x LC_PAPER "en_US.utf8"
set -x LC_NAME "en_US.utf8"
set -x LC_ADDRESS "en_US.utf8"
set -x LC_TELEPHONE "en_US.utf8"
set -x LC_MEASUREMENT "en_US.utf8"
set -x LC_IDENTIFICATION "en_US.utf8"
set -x LC_ALL "en_US.UTF-8"
set -x VERSIONER_PERL_PREFER_32_BIT yes
set -x PERL_BADLANG 0
set -x CLICOLOR 1
set -x SSH_AUTH_SOCK $HOME/.ssh/.ssh-agent.sock
set -x LESS "-rX"
set -x PAGER less
set -x GREP_COLOR '1;32'
set -x GREP_COLORS "38;5;230:sl 38;5;240:cs 38;5;100:mt 38;5;161:fn 38;5;197:ln 38;5;212:bn 38;5;44:se 38;5;166"
set -x EDITOR /usr/local/bin/nvim
set -x GIT_EDITOR /usr/local/bin/nvim
set -x VISUAL '/usr/local/bin/nvim'
set -x INPUTRC ~/.inputrc
set -x PERL_LOCAL_LIB_ROOT $HOME/.perl5
set -x PERL_MB_OPT "--install_base $HOME/.perl5";
set -x PERL_MM_OPT "INSTALL_BASE $HOME/.perl5";
set -x PERL5LIB "$HOME/.perl5/lib/perl5/x86_64-linux-gnu-thread-multi:$HOME/.perl5/lib/perl5";
set -x GOPATH $HOME/.gocode
set -x GO111MODULE on
set -x OS darwin

set -x PATH \
$HOME/bin:\
$HOME/bin/$OS:\
$HOME/.local/bin:\
$HOME/.cargo/bin:\
$GOPATH/bin:\
/usr/local/bin:\
/usr/local/sbin:\
$HOME/.platformio/penv/bin:\
$PATH

alias tmux='tmux -2'
alias history='fc -l 1'
alias k="kubectl"

set -x JAVA_HOME "/Library/Java/JavaVirtualMachines/jdk-11.0.6.jdk/Contents/Home"
set -x JAR "$HOME/.local/share/nvim/lspconfig/jdtls/plugins/org.eclipse.equinox.launcher_1.6.0.v20200915-1508.jar"
set -x GRADLE_HOME "/usr/local/opt/gradle"
set -x JDTLS_CONFIG "$HOME/.local/share/nvim/lspconfig/jdtls/config_mac"
set -x WORKSPACE "$HOME/.cache/jdtls/workspace"
set -x HOMEBREW_CASK_OPTS "--appdir $HOME/Applications"

fnm env | source
