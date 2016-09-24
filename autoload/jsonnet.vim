

" Options.

if !exists("g:jsonnet_command")
  let g:jsonnet_command = "jsonnet"
endif

if !exists("g:jsonnet_fmt_command")
  let g:jsonnet_fmt_command = "fmt"
endif

if !exists('g:jsonnet_fmt_fail_silently')
  let g:jsonnet_fmt_fail_silently = 0
endif

if !exists('g:jsonnet_fmt_options')
  let g:jsonnet_fmt_options = ''
endif

" System runs a shell command. It will reset the shell to /bin/sh for Unix-like
" systems if it is executable.
function! jsonnet#System(str, ...)
  let l:shell = &shell
  if executable('/bin/sh')
    let &shell = '/bin/sh'
  endif

  try
    let l:output = call("system", [a:str] + a:000)
    return l:output
  finally
    let &shell = l:shell
  endtry
endfunction


" CheckBinPath checks whether the given binary exists or not and returns the
" path of the binary. It returns an empty string doesn't exists.
function! jsonnet#CheckBinPath(binName)

    if executable(a:binName)
        if exists('*exepath')
            let binPath = exepath(a:binName)
        endif
        return binPath
    else
        echo "vim-jsonnet: could not find '" . a:binName . "'."
        return ""
    endif

endfunction

" Calls jsonnet fmt on the file and replaces the file with the auto formatted
" version.
function! jsonnet#Format()

   " Save cursor position and many other things.
   let l:curw = winsaveview()

   " Write current unsaved buffer to a temp file
   let l:tmpname = tempname()
   call writefile(getline(1, '$'), l:tmpname)

   " get the command first so we can test it
   let bin_name = g:jsonnet_command

  " check if the user has installed command binary.
   let binPath = jsonnet#CheckBinPath(bin_name)
   if empty(binPath)
     return
   endif

   " Populate the final command.
   let command = binPath . g:jsonnet_fmt_command
   " The inplace modification is default. Makes file management easier
   " Indentation spacing is 4 by default
   let command = command . ' -i -n 4'
   let command = command . g:jsonnet_fmt_options

   " Execute the compiled jsonnet fmt command
   let out = jsonnet#System(command . " " . l:tmpname)



    " FixMe: The restore of the formatted file back to the buffer is missing.



    " Restore our cursor/windows positions.
    call winrestview(l:curw)
endfunction


