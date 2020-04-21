":map <c-c> I//\<Esc>
:map <c-c> :call AddComment()<cr>

:function AddComment()
:   normal I//
:endfunction
