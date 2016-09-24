

" Options.

if !exists("g:jsonnet_fmt_command")
  let g:jsonnet_fmt_command = "jsonnet fmt"
endif

if !exists('g:jsonnet_fmt_fail_silently')
  let g:jsonnet_fmt_fail_silently = 0
endif

if !exists('g:jsonnet_fmt_options')
  let g:jsonnet_fmt_options = ''
endif


" Calls jsonnet fmt on the file and replaces the file with the auto formatted
" version.
function! jsonnet#Format()


endfunction


