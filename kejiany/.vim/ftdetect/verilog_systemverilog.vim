" Vim filetype plugin file
" Language:	SystemVerilog (superset extension of Verilog)

au! BufNewFile,BufRead *.vh,*.vp,*.sv,*.svi,*.svh,*.svp,*.sva setfiletype verilog_systemverilog
au! BufNewFile,BufRead *.v setfiletype verilog