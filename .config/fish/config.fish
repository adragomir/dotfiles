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

function default
  for val in $argv
    if test "$val" != ""
      echo $val
      break
    end
  end
end

function up-or-search -d "Depending on cursor position and current mode, either search backward or move up one line"
    # If we are already in search mode, continue
    if commandline --search-mode
        commandline -f history-search-backward
        return
    end

    # If we are navigating the pager, then up always navigates
    if commandline --paging-mode
        commandline -f up-line
        return
    end

    # We are not already in search mode.
    # If we are on the top line, start search mode,
    # otherwise move up
    set lineno (commandline -L)

    switch $lineno
        case 1
            commandline -f history-search-backward
            history merge # <-- ADDED THIS

        case '*'
            commandline -f up-line
    end
end

# a called to `_pure_prompt_new_line` is triggered by an event
function _pure_set_color \
    --argument-names var

    set --local color $var
    # Backwards compatibility for colors defined as control sequencies instead of fish colors
    if not string match --quiet --all --regex '\e\[[^m]*m' $color[1]
        and set -q $color
            set color $$var
    end

    set --local result $color
    if not string match --quiet --all --regex '\e\[[^m]*m' $result[1]
        and not test -z $result[1]
            set result (set_color $color)
    end

    echo "$result"
end

function _pure_string_width \
    --argument-names prompt

    set --local empty ''
    set --local raw_prompt (string replace --all --regex '\e\[[^m]*m' $empty -- $prompt)
    string length -- $raw_prompt
end

function _pure_parse_git_branch --description "Parse current Git branch name"
    command git symbolic-ref --short HEAD 2>/dev/null;
        or command git name-rev --name-only HEAD 2>/dev/null
end

function _pure_prompt_git_branch
    set --local git_branch (_pure_parse_git_branch) # current git branch
    set --local git_branch_color (_pure_set_color brblack)
    echo "$git_branch_color$git_branch"
end

function _pure_prompt_git_dirty
    set --local git_dirty_symbol
    set --local git_dirty_color

    set --local is_git_dirty (
        not command git diff-index --ignore-submodules --cached --quiet HEAD -- >/dev/null 2>&1
        or not command git diff --ignore-submodules --no-ext-diff --quiet --exit-code >/dev/null 2>&1
        and echo "true"
    )
    if test -n "$is_git_dirty"  # untracked or un-commited files
        set git_dirty_symbol "*"
        set git_dirty_color (_pure_set_color brblack)
    end

    echo "$git_dirty_color$git_dirty_symbol"
end

function _pure_prompt_git
    set --local is_git_repository (command git rev-parse --is-inside-work-tree 2>/dev/null)
    if test -n "$is_git_repository"
        set --local git_prompt (_pure_prompt_git_branch)(_pure_prompt_git_dirty)
        echo $git_prompt
    end
end

function _pure_print_prompt
    set --local prompt

    for prompt_part in $argv
        if test (_pure_string_width $prompt_part) -gt 0
            set --append prompt "$prompt_part"
        end
    end

    echo (string trim -l $prompt)
end

function _pure_prompt_current_folder --argument-names current_prompt_width
    set --local current_folder (string replace $HOME '~' $PWD) 
    set --local current_folder_color (_pure_set_color blue)
    echo "$current_folder_color$current_folder"
end

function _pure_prompt_first_line
    set --local prompt_git (_pure_prompt_git)
    set --local prompt (_pure_print_prompt $prompt_git)
    set --local current_folder (_pure_prompt_current_folder)

    set --local prompt_components
    set prompt_components $current_folder $prompt_git
    echo (_pure_print_prompt $prompt_components)
end

function _pure_prompt_jobs --description "Display number of running jobs"
    set --local njobs (count (jobs -p))
    set --local jobs_color (_pure_set_color normal)
    if test "$njobs" -gt 0
        echo "$jobs_color"[$njobs]
    end
end

function _pure_prompt_symbol \
    --argument-names exit_code
    set --local prompt_symbol "❯" 
    set --local symbol_color_success (_pure_set_color magenta)
    set --local symbol_color_error (_pure_set_color red)
    set --local command_succeed 0
    set --local symbol_color $symbol_color_success # default pure symbol color
    if set --query exit_code; and test "$exit_code" -ne $command_succeed
        set symbol_color $symbol_color_error # different pure symbol color when previous command failed
    end
    echo "$symbol_color$prompt_symbol"
end

function _pure_prompt \
    --argument-names exit_code

    set --local jobs (_pure_prompt_jobs)
    set --local pure_symbol (_pure_prompt_symbol $exit_code)
    set --local space

    echo (\
        _pure_print_prompt \
        $jobs \
        $space \
        $pure_symbol \
    )
end

set --global _pure_fresh_session true
functions --query _pure_prompt_new_line

function _pure_prompt_new_line \
    --on-event fish_prompt
    set --local new_line
    if test "$_pure_fresh_session" = false
        set new_line "\n"
    end
    echo -e -n "$new_line"
end

function fish_prompt
    set --local exit_code $status  # save previous exit code

    echo -e -n "\r\033[K"  # init prompt context (clear current line, etc.)
    echo -e (_pure_prompt_first_line)

    echo -e -n (_pure_prompt $exit_code)  # print prompt
    echo -e (set_color normal)" "

    set _pure_fresh_session false
end

function bind_bang
    switch (commandline -t)[-1]
        case "!"
            commandline -t $history[1]; commandline -f repaint
        case "*"
            commandline -i !
    end
end

function bind_dollar
    switch (commandline -t)[-1]
        case "!"
            commandline -t ""
            commandline -f history-token-search-backward
        case "*"
            commandline -i '$'
    end
end

# function fish_user_key_bindings
#     bind ! bind_bang
#     bind '$' bind_dollar
# end

# function fish_prompt --description 'Informative prompt'
#     #Save the return status of the previous command
#     set -l last_pipestatus $pipestatus
#     set -lx __fish_last_status $status # set -x for __fish_print_pipestatus.
# 
#     set -l status_color (set_color $fish_color_status)
#     set -l statusb_color (set_color --bold $fish_color_status)
#     set -l pipestatus_string (__fish_print_pipestatus "[" "]" "|" "$status_color" "$statusb_color" $last_pipestatus)
#     set -g fish_prompt_pwd_dir_length 10
#     #if test $status -eq 0
#       set -l arrow_color (set_color magenta)
#     #else
#     #  set -l arrow_color (set_color red)
#     #end
# 
#     printf '%s%s%s %s%s%s \n%s❯%s ' \
#       (set_color blue) (set_color $fish_color_cwd) (prompt_pwd) \
#       $pipestatus_string (fish_git_prompt) (set_color normal) \
#       $arrow_color (set_color normal)
# end

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

test (command -v brew) && eval (brew shellenv)
test (command -v frum) && frum init | source
test (command -v fnm) && fnm env | source
test (command -v kubectl-krew) && set -x PATH (default "$KREW_ROOT" "$HOME/.krew")"/bin":$PATH
