" pyclewn run time file
" Maintainer:   <xdegaye at users dot sourceforge dot net>
"
" Configure VIM to be used with pyclewn and netbeans
"

" The following variables define how pyclewn is started when
" the ':Pyclewn' vim command is run.
" They may be changed to match your preferences.
let s:pgm = "pyclewn"
let s:args = "--gdb= --pgm=gdb --args= --window=top --maxlines=10000"
let s:connection = "localhost:3219:changeme"
" Uncomment the following line to print full traces in a file named 'logfile'
" for debugging purpose.
" let s:args .= " --level=nbdebug --file=logfile"

if exists("s:did_pyclewn")
    finish
endif
let s:did_pyclewn = 1

" pyclewn version
let g:pyclewn_version = "pyclewn-1.3"

" enable balloon_eval
if has("balloon_eval")
    set ballooneval
    set balloondelay=100
endif

" The 'Pyclewn' command starts pyclewn and vim netbeans interface.
command -nargs=0 Pyclewn call s:startclewn()
let s:fixed = "--daemon --editor= --netbeans=" . s:connection . " --cargs="

" Start pyclewn and vim netbeans interface.
function s:start()
    if !exists(":nbstart")
        throw "Error: the ':nbstart' vim command does not exist."
    endif
    if has("netbeans_enabled")
        throw "Error: netbeans is already enabled and connected."
    endif
    if !executable(s:pgm)
        throw "Error: '" . s:pgm . "' cannot be found or is not an executable."
    endif

    " the pyclewn generated vim script is sourced only once
    if exists("s:tmpfile")
        let s:tmpfile = ""
    else
        let s:tmpfile = tempname()
    endif

    " remove console and dbgvar buffers from previous session
    if bufexists("(clewn)_console")
        bwipeout (clewn)_console
    endif
    if bufexists("(clewn)_dbgvar")
        bwipeout (clewn)_dbgvar
    endif

    " start pyclewn and netbeans
    call s:info("Starting pyclewn, please wait...\n")
    exe "silent !" . s:pgm . " " . s:args . " " . s:fixed . s:tmpfile . " &"
    call s:info("'pyclewn' has been started.\n")
    call s:info("Running nbstart, <C-C> to interrupt.\n")
    " allow pyclewn to start its dispatch loop, otherwise we will have to
    " wait 5 seconds for the second connection attempt by vim
    sleep 500m
    exe "nbstart :" . s:connection

    " source vim script
    if has("netbeans_enabled")
        if s:tmpfile != ""
            if !filereadable(s:tmpfile)
                unlet s:tmpfile
                throw "Error: pyclewn failed to start."
            endif
            exe "source " . s:tmpfile
        endif
        call s:info("The netbeans socket is connected.\n")
    else
        throw "Error: the netbeans socket could not be connected."
    endif
endfunction

function s:startclewn()
    try
        call s:start()
    catch /.*/
        if exists("s:tmpfile") && s:tmpfile != ""
            unlet s:tmpfile
        endif
        call s:info("The 'Pyclewn' command has been aborted.\n")
        call s:error(v:exception)
        " vim console screen is garbled, redraw the screen
        if !has("gui_running")
            redraw!
        endif
        " clear the command line
        echo "\n"
    endtry
endfunction

function s:info(msg)
    echohl WarningMsg
    echo a:msg
    echohl None
endfunction

function s:error(msg)
    echohl ErrorMsg
    echo a:msg
    call inputsave()
    call input("Press the <Enter> key to continue.")
    call inputrestore()
    echohl None
endfunction
