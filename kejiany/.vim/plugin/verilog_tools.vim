map <C-\>z :call <SID>insert_always()<CR>

function s:insert_always()
    let line = line(".")
    call append(line, "always @(posedge  or negedge )")
    let line = line + 1
    call append(line, "begin")
    let line = line + 1
    call append(line, "    if ()")
    let line = line + 1
    call append(line, "    begin")
    let line = line + 1
    call append(line, "    end")
    let line = line + 1
    call append(line, "    else")
    let line = line + 1
    call append(line, "    begin")
    let line = line + 1
    call append(line, "    end")
    let line = line + 1
    call append(line, "end")
endfunction

