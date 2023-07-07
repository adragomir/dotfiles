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

if status is-interactive
    # Commands to run in interactive sessions can go here
end

set -gx EDITOR /usr/local/bin/nvim
set -gx GIT_EDITOR /usr/local/bin/nvim
set -gx VISUAL '/usr/local/bin/nvim'
set -gx LANG "en_US.UTF-8"
set -gx LANGUAGE "en_US.UTF-8"
set -gx LC_ALL "en_US.UTF-8"
set -gx CLICOLOR 1
set -gx SSH_AUTH_SOCK $HOME/.ssh/.ssh-agent.sock
set -gx LESS "-rX"
set -gx PAGER less
set -gx INPUTRC $HOME/.inputrc
set -gx GOPATH $HOME/.gocode
set -gx GO111MODULE on
set -gx OS darwin
set -gx SOLARGRAPH_CACHE $HOME/.cache/solargraph
set -gx MAVEN_HOME $HOME/.cache/m2
set -gx RUSTUP_HOME $HOME/.cache/rustup
set -gx CARGO_HOME $HOME/.cache/cargo
set -gx FNM_DIR $HOME/.cache/fnm
set -gx npm_config_devdir $HOME/.cache/node-gyp
set -gx BUNDLE_USER_HOME $HOME/.cache/bundle
set -gx FRUM_DIR $HOME/.cache/frum
set -gx XDG_CONFIG_HOME $HOME/.config/
set -gx XDG_CACHE_HOME $HOME/.cache/
set -gx XDG_DATA_HOME $HOME/.local/share/
set -gx JAVA_HOME /usr/local/opt/openjdk@11/
#set -gx JAVA_HOME "/Library/Java/JavaVirtualMachines/jdk-11.0.6.jdk/Contents/Home"
set -gx CONDA_PREFIX $HOME/.conda
set -gx HOMEBREW_PREFIX "/usr/local";
set -gx HOMEBREW_CELLAR "/usr/local/Cellar";
set -gx HOMEBREW_REPOSITORY "/usr/local/Homebrew";
set -gx HOMEBREW_CASK_OPTS "--appdir $HOME/Applications"
set -gx HOMEBREW_NO_ENV_HINTS 1
set -gx PATH \
$HOME/.krew/bin:\
/usr/local/opt/bison/bin:\
$HOME/bin:\
$HOME/bin/$OS:\
$HOME/.local/bin:\
$HOME/.cache/cargo/bin:\
$GOPATH/bin:\
/usr/local/bin:\
/usr/local/sbin:\
$HOME/.platformio/penv/bin:\
/opt/X11/bin:\
/usr/local/share/dotnet:\
/usr/local/bin:/usr/local/sbin:/usr/bin:/bin:/usr/sbin:/sbin:\
$PATH

alias tmux='tmux -2'
alias history='fc -l 1'
alias k="kubectl"
if test "$TERM" = "xterm-kitty" 
  alias icat="kitty +kitten icat"
  alias hg="kitty +kitten hyperlinked_grep"
end

set -gx JAR "$HOME/.local/share/nvim/lspconfig/jdtls/plugins/org.eclipse.equinox.launcher_1.6.0.v20200915-1508.jar"
set -gx GRADLE_HOME "/usr/local/opt/gradle"
set -gx JDTLS_CONFIG "$HOME/.local/share/nvim/lspconfig/jdtls/config_mac"
set -gx WORKSPACE "$HOME/.cache/jdtls/workspace"

function __ssh_agent_is_started -d "check if ssh agent is already started"
	if begin; test -f $SSH_ENV; and test -z "$SSH_AGENT_PID"; end
		source $SSH_ENV > /dev/null
	end

	if begin; test -z "$SSH_AGENT_PID"; and test -z "$SSH_CONNECTION"; end
		return 1
	end

	/usr/local/bin/ssh-add -l > /dev/null 2>&1
	if test $status -eq 2
		return 1
	end
end

function __ssh_agent_start -d "start a new ssh agent"
  /usr/local/bin/ssh-agent -c | sed 's/^echo/#echo/' > $SSH_ENV
  chmod 600 $SSH_ENV
  source $SSH_ENV > /dev/null
end

if test -z "$SSH_ENV"
    set -xg SSH_ENV $HOME/.ssh/environment
end
if not __ssh_agent_is_started
    __ssh_agent_start
end


test (command -v frum) && frum init | source
test (command -v fnm) && fnm env | source
