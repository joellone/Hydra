" ==================================================
"  file name        : systemverilog.vim
"  creat time       : 2016年 08月 23日 星期二 08:41:01 CST
"  author           : gtic_wrj
"  lastest version  : v1.0
"  last modify time :
"  last modifier    :
"  descript         : Vim syntax file based on:
"                   : Systemverilog(IEEE 1800-2012)
"                   : VMM(1.2)
"                   : UVM(1.2)
"                   : Usage : put under direction $VIM/syntax/
"                   : autobuf *.sv format file
" ==================================================


if version < 600
    syntax clear
elseif exists("b:current_syntax")
    finish
endif

" Set the local value of the 'iskeyword' option
if version >= 600
    setlocal iskeyword=@,48-57,_,192-255
else
    set iskeyword=@,48-57,_,192-255
endif

" Taken from the SystemVerilog 3.1a Annex B:
syn keyword systemverilogStatement   alias always always_comb always_ff always_latch
syn keyword systemverilogStatement   and assert assign assume automatic before begin
syn keyword systemverilogStatement   bind bins binsof bit break buf bufif0 bufif1
syn keyword systemverilogStatement   byte case casex casez cell chandle class clocking
syn keyword systemverilogStatement   cmos config const constraint context continue cover
syn keyword systemverilogStatement   covergroup coverpoint cross deassign default
syn keyword systemverilogStatement   defparam design disable dist do edge else end
syn keyword systemverilogStatement   endcase endclass endclocking endconfig endfunction
syn keyword systemverilogStatement   endgenerate endgroup endinterface endmodule
syn keyword systemverilogStatement   endpackage endprimitive endprogram endproperty
syn keyword systemverilogStatement   endspecify endsequence endtable endtask enum event
syn keyword systemverilogStatement   expect export extends extern final first_match for
syn keyword systemverilogStatement   force foreach forever fork forkjoin function generate
syn keyword systemverilogStatement   genvar highz0 highz1 if iff ifnone ignore_bins
syn keyword systemverilogStatement   illegal_bins import incdir include initial inout
syn keyword systemverilogStatement   input inside instance int integer interface intersect
syn keyword systemverilogStatement   join join_any join_none large liblist library local
syn keyword systemverilogStatement   localparam logic longint macromodule matches medium
syn keyword systemverilogStatement   modport module nand negedge new nmos nor
syn keyword systemverilogStatement   noshowcancelled not notif0 notif1 null or output
syn keyword systemverilogStatement   package packed parameter pmos posedge primitive
syn keyword systemverilogStatement   priority program property protected pull0 pull1
syn keyword systemverilogStatement   pulldown pullup pulsestyle_onevent pulsestyle_ondetect
syn keyword systemverilogStatement   pure rand randc randcase randsequence rcmos
syn keyword systemverilogStatement   real realtime ref reg release repeat return
syn keyword systemverilogStatement   rnmos rpmos rtran rtranif0 rtranif1 scalared sequence
syn keyword systemverilogStatement   shortint shortreal showcancelled signed small solve
syn keyword systemverilogStatement   specify specparam static string strong0 strong1 struct
syn keyword systemverilogStatement   super supply0 supply1 table tagged task this
syn keyword systemverilogStatement   throughout time timeprecision timeunit tran
syn keyword systemverilogStatement   tranif0 tranif1 tri tri0 tri1 triand trior trireg type
syn keyword systemverilogStatement   typedef union unique unsigned use var vectored virtual
syn keyword systemverilogStatement   void wait wait_order wand weak0 weak1
syn keyword systemverilogStatement   while wildcard wire with within wor xnor xor

" LRM 3.7 String methods:
syn keyword systemverilogStatement   len getc putc toupper tolower compare
syn keyword systemverilogStatement   icompare substr
syn keyword systemverilogStatement   itoa hextoa octtoa bintoa realtoa
syn keyword systemverilogStatement   atoi atohex atooct atobin atoreal
" LRM 3.8 events:
syn keyword systemverilogStatement   triggered
" LRM 3.10 methods for enumerated types:
syn keyword systemverilogStatement   first last next prev num name
" LRM 4.6 Dynamic Arrays:
syn keyword systemverilogStatement   delete
" LRM 4.10 Associative Array methods:
syn keyword systemverilogStatement   num exists
" LRM 4.15.1 Array locator methods:
syn keyword systemverilogStatement   find find_index find_first find_first_index
syn keyword systemverilogStatement   find_last find_last_index min max unique unique_index
" LRM 4.15.2 Array ordering methods:
syn keyword systemverilogStatement   reverse sort rsort shuffle
" LRM 4.15.3 Array reduction methods:
syn keyword systemverilogStatement   sum product
" LRM 4.15.4 Array iterator query:
syn keyword systemverilogStatement   index
" LRM 7.10.1 Builtin package:
syn keyword systemverilogStatement   std
" LRM Annex C standard library
syn keyword systemverilogStatement   get put try_get try_put peek try_peek
syn keyword systemverilogStatement   status kill self await suspend resume
" LRM Annex D List methods
syn keyword systemverilogStatement   next prev eq neq data
syn keyword systemverilogStatement   size empty push_front push_back
syn keyword systemverilogStatement   front back pop_front pop_back
syn keyword systemverilogStatement   start finish insert insert_range
syn keyword systemverilogStatement   erase erase_range set swap clear purge

" New time specification:
" #1step or #1ps
syn match   systemverilogNumber "\<[0-9_]\+\([munpf]\|\)s\>"
syn match   systemverilogNumber "\<[0-9_]\+step\>"

" Original systemverilog syntax below here
syn keyword systemverilogTodo contained TODO
syn match   systemverilogOperator "[&|~><!)(*#%@+/=?:;}{,.\^\-\[\]]"
syn region  systemverilogComment start="/\*" end="\*/" contains=systemverilogTodo
syn match   systemverilogComment "//.*" contains=systemverilogTodo

syn match   systemverilogGlobal "`celldefine\>"
syn match   systemverilogGlobal "`default_nettype\>"
syn match   systemverilogGlobal "`define\>"
syn match   systemverilogGlobal "`else\>"
syn match   systemverilogGlobal "`elsif\>"
syn match   systemverilogGlobal "`endcelldefine\>"
syn match   systemverilogGlobal "`endif\>"
syn match   systemverilogGlobal "`ifdef\>"
syn match   systemverilogGlobal "`ifndef\>"
syn match   systemverilogGlobal "`include\>"
syn match   systemverilogGlobal "`line\>"
syn match   systemverilogGlobal "`nounconnected_drive\>"
syn match   systemverilogGlobal "`resetall\>"
syn match   systemverilogGlobal "`timescale\>"
syn match   systemverilogGlobal "`unconnected_drive\>"
syn match   systemverilogGlobal "`undef\>"
syn match   systemverilogGlobal "$[a-zA-Z0-9_]\+\>"

syn match   systemverilogConstant "\<[A-Z][A-Z0-9_]\+\>"

syn match   systemverilogNumber "\(\<\d\+\|\)'[bB]\s*[0-1_xXzZ?]\+\>"
syn match   systemverilogNumber "\(\<\d\+\|\)'[oO]\s*[0-7_xXzZ?]\+\>"
syn match   systemverilogNumber "\(\<\d\+\|\)'[dD]\s*[0-9_xXzZ?]\+\>"
syn match   systemverilogNumber "\(\<\d\+\|\)'[hH]\s*[0-9a-fA-F_xXzZ?]\+\>"
syn match   systemverilogNumber "\<[+-]\=[0-9_]\+\(\.[0-9_]*\|\)\(e[0-9_]*\|\)\>"

syn region  systemverilogString start=+"+ skip=+\\"+ end=+"+ contains=systemverilogEscape
syn match   systemverilogEscape +\\[nt"\\]+ contained
syn match   systemverilogEscape "\\\o\o\=\o\=" contained

" Directives
syn match   systemverilogDirective   "//\s*synopsys\>.*$"
syn region  systemverilogDirective   start="/\*\s*synopsys\>" end="\*/"
syn region  systemverilogDirective   start="//\s*synopsys dc_script_begin\>" end="//\s*synopsys dc_script_end\>"

syn match   systemverilogDirective   "//\s*\$s\>.*$"
syn region  systemverilogDirective   start="/\*\s*\$s\>" end="\*/"
syn region  systemverilogDirective   start="//\s*\$s dc_script_begin\>" end="//\s*\$s dc_script_end\>"

" IEEE 1800-2012 annexes keywords,removed reduplicative keywords
syn keyword systemverilog1800Keyword accept_on
" syn keyword systemverilog1800Keyword alias
" syn keyword systemverilog1800Keyword always
" syn keyword systemverilog1800Keyword always_comb
" syn keyword systemverilog1800Keyword always_ff
" syn keyword systemverilog1800Keyword always_latch
" syn keyword systemverilog1800Keyword and
" syn keyword systemverilog1800Keyword assert
" syn keyword systemverilog1800Keyword assign
" syn keyword systemverilog1800Keyword assume
" syn keyword systemverilog1800Keyword automatic
" syn keyword systemverilog1800Keyword before
" syn keyword systemverilog1800Keyword begin
" syn keyword systemverilog1800Keyword bind
" syn keyword systemverilog1800Keyword bins
" syn keyword systemverilog1800Keyword binsof
" syn keyword systemverilog1800Keyword bit
" syn keyword systemverilog1800Keyword break
" syn keyword systemverilog1800Keyword buf
" syn keyword systemverilog1800Keyword bufif0
" syn keyword systemverilog1800Keyword bufif1
" syn keyword systemverilog1800Keyword byte
" syn keyword systemverilog1800Keyword case
" syn keyword systemverilog1800Keyword casex
" syn keyword systemverilog1800Keyword casez
" syn keyword systemverilog1800Keyword cell
" syn keyword systemverilog1800Keyword chandle
syn keyword systemverilog1800Keyword checker
" syn keyword systemverilog1800Keyword class
" syn keyword systemverilog1800Keyword clocking
" syn keyword systemverilog1800Keyword cmos
" syn keyword systemverilog1800Keyword config
" syn keyword systemverilog1800Keyword const
" syn keyword systemverilog1800Keyword constraint
" syn keyword systemverilog1800Keyword context
" syn keyword systemverilog1800Keyword continue
" syn keyword systemverilog1800Keyword cover
" syn keyword systemverilog1800Keyword covergroup
" syn keyword systemverilog1800Keyword coverpoint
" syn keyword systemverilog1800Keyword cross
" syn keyword systemverilog1800Keyword deassign
" syn keyword systemverilog1800Keyword default
" syn keyword systemverilog1800Keyword defparam
" syn keyword systemverilog1800Keyword design
" syn keyword systemverilog1800Keyword disable
" syn keyword systemverilog1800Keyword dist
" syn keyword systemverilog1800Keyword do
" syn keyword systemverilog1800Keyword edge
" syn keyword systemverilog1800Keyword else
" syn keyword systemverilog1800Keyword end
" syn keyword systemverilog1800Keyword endcase
syn keyword systemverilog1800Keyword endchecker
" syn keyword systemverilog1800Keyword endclass
" syn keyword systemverilog1800Keyword endclocking
" syn keyword systemverilog1800Keyword endconfig
" syn keyword systemverilog1800Keyword endfunction
" syn keyword systemverilog1800Keyword endgenerate
" syn keyword systemverilog1800Keyword endgroup
" syn keyword systemverilog1800Keyword endinterface
" syn keyword systemverilog1800Keyword endmodule
" syn keyword systemverilog1800Keyword endpackage
" syn keyword systemverilog1800Keyword endprimitive
" syn keyword systemverilog1800Keyword endprogram
" syn keyword systemverilog1800Keyword endproperty
" syn keyword systemverilog1800Keyword endspecify
" syn keyword systemverilog1800Keyword endsequence
" syn keyword systemverilog1800Keyword endtable
" syn keyword systemverilog1800Keyword endtask
" syn keyword systemverilog1800Keyword enum
" syn keyword systemverilog1800Keyword event
syn keyword systemverilog1800Keyword eventually
" syn keyword systemverilog1800Keyword expect
" syn keyword systemverilog1800Keyword export
" syn keyword systemverilog1800Keyword extends
" syn keyword systemverilog1800Keyword extern
" syn keyword systemverilog1800Keyword final
" syn keyword systemverilog1800Keyword first_match
" syn keyword systemverilog1800Keyword for
" syn keyword systemverilog1800Keyword force
" syn keyword systemverilog1800Keyword foreach
" syn keyword systemverilog1800Keyword forever
" syn keyword systemverilog1800Keyword fork
" syn keyword systemverilog1800Keyword forkjoin
" syn keyword systemverilog1800Keyword function
" syn keyword systemverilog1800Keyword generate
" syn keyword systemverilog1800Keyword genvar
syn keyword systemverilog1800Keyword global
" syn keyword systemverilog1800Keyword highz0
" syn keyword systemverilog1800Keyword highz1
" syn keyword systemverilog1800Keyword if
" syn keyword systemverilog1800Keyword iff
" syn keyword systemverilog1800Keyword ifnone
" syn keyword systemverilog1800Keyword ignore_bins
" syn keyword systemverilog1800Keyword illegal_bins
syn keyword systemverilog1800Keyword implements
syn keyword systemverilog1800Keyword implies
" syn keyword systemverilog1800Keyword import
" syn keyword systemverilog1800Keyword incdir
" syn keyword systemverilog1800Keyword include
" syn keyword systemverilog1800Keyword initial
" syn keyword systemverilog1800Keyword inout
" syn keyword systemverilog1800Keyword input
" syn keyword systemverilog1800Keyword inside
" syn keyword systemverilog1800Keyword instance
" syn keyword systemverilog1800Keyword int
" syn keyword systemverilog1800Keyword integer
syn keyword systemverilog1800Keyword interconnect
" syn keyword systemverilog1800Keyword interface
" syn keyword systemverilog1800Keyword intersect
" syn keyword systemverilog1800Keyword join
" syn keyword systemverilog1800Keyword join_any
" syn keyword systemverilog1800Keyword join_none
" syn keyword systemverilog1800Keyword large
syn keyword systemverilog1800Keyword let
" syn keyword systemverilog1800Keyword liblist
" syn keyword systemverilog1800Keyword library
" syn keyword systemverilog1800Keyword local
" syn keyword systemverilog1800Keyword localparam
" syn keyword systemverilog1800Keyword logic
" syn keyword systemverilog1800Keyword longint
" syn keyword systemverilog1800Keyword macromodule
" syn keyword systemverilog1800Keyword matches
" syn keyword systemverilog1800Keyword medium
" syn keyword systemverilog1800Keyword modport
" syn keyword systemverilog1800Keyword module
" syn keyword systemverilog1800Keyword nand
" syn keyword systemverilog1800Keyword negedge
syn keyword systemverilog1800Keyword nettype
" syn keyword systemverilog1800Keyword new
syn keyword systemverilog1800Keyword nexttime
" syn keyword systemverilog1800Keyword nmos
" syn keyword systemverilog1800Keyword nor
" syn keyword systemverilog1800Keyword noshowcancelled
" syn keyword systemverilog1800Keyword not
" syn keyword systemverilog1800Keyword notif0
" syn keyword systemverilog1800Keyword notif1
" syn keyword systemverilog1800Keyword null
" syn keyword systemverilog1800Keyword or
" syn keyword systemverilog1800Keyword output
" syn keyword systemverilog1800Keyword package
" syn keyword systemverilog1800Keyword packed
" syn keyword systemverilog1800Keyword parameter
" syn keyword systemverilog1800Keyword pmos
" syn keyword systemverilog1800Keyword posedge
" syn keyword systemverilog1800Keyword primitive
" syn keyword systemverilog1800Keyword priority
" syn keyword systemverilog1800Keyword program
" syn keyword systemverilog1800Keyword property
" syn keyword systemverilog1800Keyword protected
" syn keyword systemverilog1800Keyword pull0
" syn keyword systemverilog1800Keyword pull1
" syn keyword systemverilog1800Keyword pulldown
" syn keyword systemverilog1800Keyword pullup
" syn keyword systemverilog1800Keyword pulsestyle_ondetect
" syn keyword systemverilog1800Keyword pulsestyle_onevent
" syn keyword systemverilog1800Keyword pure
" syn keyword systemverilog1800Keyword rand
" syn keyword systemverilog1800Keyword randc
" syn keyword systemverilog1800Keyword randcase
" syn keyword systemverilog1800Keyword randsequence
" syn keyword systemverilog1800Keyword rcmos
" syn keyword systemverilog1800Keyword real
" syn keyword systemverilog1800Keyword realtime
" syn keyword systemverilog1800Keyword ref
" syn keyword systemverilog1800Keyword reg
syn keyword systemverilog1800Keyword reject_on
" syn keyword systemverilog1800Keyword release
" syn keyword systemverilog1800Keyword repeat
syn keyword systemverilog1800Keyword restrict
" syn keyword systemverilog1800Keyword return
" syn keyword systemverilog1800Keyword rnmos
" syn keyword systemverilog1800Keyword rpmos
" syn keyword systemverilog1800Keyword rtran
" syn keyword systemverilog1800Keyword rtranif0
" syn keyword systemverilog1800Keyword rtranif1
syn keyword systemverilog1800Keyword s_always
syn keyword systemverilog1800Keyword s_eventually
syn keyword systemverilog1800Keyword s_nexttime
syn keyword systemverilog1800Keyword s_until
syn keyword systemverilog1800Keyword s_until_with
" syn keyword systemverilog1800Keyword scalared
" syn keyword systemverilog1800Keyword sequence
" syn keyword systemverilog1800Keyword shortint
" syn keyword systemverilog1800Keyword shortreal
" syn keyword systemverilog1800Keyword showcancelled
" syn keyword systemverilog1800Keyword signed
" syn keyword systemverilog1800Keyword small
syn keyword systemverilog1800Keyword soft
" syn keyword systemverilog1800Keyword solve
" syn keyword systemverilog1800Keyword specify
" syn keyword systemverilog1800Keyword specparam
" syn keyword systemverilog1800Keyword static
" syn keyword systemverilog1800Keyword string
syn keyword systemverilog1800Keyword strong
" syn keyword systemverilog1800Keyword strong0
" syn keyword systemverilog1800Keyword strong1
" syn keyword systemverilog1800Keyword struct
" syn keyword systemverilog1800Keyword super
" syn keyword systemverilog1800Keyword supply0
" syn keyword systemverilog1800Keyword supply1
syn keyword systemverilog1800Keyword sync_accept_on
syn keyword systemverilog1800Keyword sync_reject_on
" syn keyword systemverilog1800Keyword table
" syn keyword systemverilog1800Keyword tagged
" syn keyword systemverilog1800Keyword task
" syn keyword systemverilog1800Keyword this
" syn keyword systemverilog1800Keyword throughout
" syn keyword systemverilog1800Keyword time
" syn keyword systemverilog1800Keyword timeprecision
" syn keyword systemverilog1800Keyword timeunit
" syn keyword systemverilog1800Keyword tran
" syn keyword systemverilog1800Keyword tranif0
" syn keyword systemverilog1800Keyword tranif1
" syn keyword systemverilog1800Keyword tri
" syn keyword systemverilog1800Keyword tri0
" syn keyword systemverilog1800Keyword tri1
" syn keyword systemverilog1800Keyword triand
" syn keyword systemverilog1800Keyword trior
" syn keyword systemverilog1800Keyword trireg
" syn keyword systemverilog1800Keyword type
" syn keyword systemverilog1800Keyword typedef
" syn keyword systemverilog1800Keyword union
" syn keyword systemverilog1800Keyword unique
syn keyword systemverilog1800Keyword unique0
" syn keyword systemverilog1800Keyword unsigned
syn keyword systemverilog1800Keyword until
syn keyword systemverilog1800Keyword until_with
syn keyword systemverilog1800Keyword untyped
" syn keyword systemverilog1800Keyword use
syn keyword systemverilog1800Keyword uwire
" syn keyword systemverilog1800Keyword var
" syn keyword systemverilog1800Keyword vectored
" syn keyword systemverilog1800Keyword virtual
" syn keyword systemverilog1800Keyword void
" syn keyword systemverilog1800Keyword wait
" syn keyword systemverilog1800Keyword wait_order
" syn keyword systemverilog1800Keyword wand
" syn keyword systemverilog1800Keyword weak
" syn keyword systemverilog1800Keyword weak0
" syn keyword systemverilog1800Keyword weak1
" syn keyword systemverilog1800Keyword while
" syn keyword systemverilog1800Keyword wildcard
" syn keyword systemverilog1800Keyword wire
" syn keyword systemverilog1800Keyword with
" syn keyword systemverilog1800Keyword within
" syn keyword systemverilog1800Keyword wor
" syn keyword systemverilog1800Keyword xnor
" syn keyword systemverilog1800Keyword xor

" IEEE 1800-2012 annexes systemtask
syn match   systemverilog1800Systemtask "\$countdrivers\>"
syn match   systemverilog1800Systemtask "\$getpattern\>"
syn match   systemverilog1800Systemtask "\$incsave\>"
syn match   systemverilog1800Systemtask "\$input\>"
syn match   systemverilog1800Systemtask "\$key\>"
syn match   systemverilog1800Systemtask "\$list\>"
syn match   systemverilog1800Systemtask "\$log\>"
syn match   systemverilog1800Systemtask "\$nokey\>"
syn match   systemverilog1800Systemtask "\$nolog\>"
syn match   systemverilog1800Systemtask "\$reset\>"
syn match   systemverilog1800Systemtask "\$reset_count\>"
syn match   systemverilog1800Systemtask "\$reset_value\>"
syn match   systemverilog1800Systemtask "\$restart\>"
syn match   systemverilog1800Systemtask "\$save\>"
syn match   systemverilog1800Systemtask "\$scale\>"
syn match   systemverilog1800Systemtask "\$scope\>"
syn match   systemverilog1800Systemtask "\$showscopes\>"
syn match   systemverilog1800Systemtask "\$showvars\>"
syn match   systemverilog1800Systemtask "\$sreadmemb\>"
syn match   systemverilog1800Systemtask "\$sreadmemh\>"

" Base on VMM1.2
" VMM classes with wildcard
syn match   VMMClassSeries "\<\w\+_atomic_gen_callbacks\>"
syn match   VMMClassSeries "\<\w\+_atomic_scenario\>"
syn match   VMMClassSeries "\<\w\+_scenario\>"
syn match   VMMClassSeries "\<\w\+_scenario_election\>"
syn match   VMMClassSeries "\<\w\+_scenario_gen_callbacks\>"

" VMM class
syn match   VMMClass "\<factory\>"
syn match   VMMClass "\<vmm_atomic_gen\>"
syn match   VMMClass "\<vmm_atomic_scenario\>"
syn match   VMMClass "\<vmm_broadcast\>"
syn match   VMMClass "\<vmm_channel\>"
syn match   VMMClass "\<vmm_connect\>"
syn match   VMMClass "\<vmm_consensus\>"
syn match   VMMClass "\<vmm_data\>"
syn match   VMMClass "\<vmm_env\>"
syn match   VMMClass "\<vmm_group\>"
syn match   VMMClass "\<vmm_group_callbacks\>"
syn match   VMMClass "\<vmm_log\>"
syn match   VMMClass "\<vmm_log_callback\>"
syn match   VMMClass "\<vmm_log_catcher\>"
syn match   VMMClass "\<vmm_log_format\>"
syn match   VMMClass "\<vmm_log_msg\>"
syn match   VMMClass "\<vmm_ms_scenario\>"
syn match   VMMClass "\<vmm_ms_scenario_gen\>"
syn match   VMMClass "\<vmm_notification\>"
syn match   VMMClass "\<vmm_notify\>"
syn match   VMMClass "\<vmm_notify_callbacks\>"
syn match   VMMClass "\<vmm_notify_observer\>"
syn match   VMMClass "\<vmm_object\>"
syn match   VMMClass "\<vmm_object_iter\>"
syn match   VMMClass "\<vmm_opts\>"
syn match   VMMClass "\<vmm_phase\>"
syn match   VMMClass "\<vmm_phase_def\>"
syn match   VMMClass "\<vmm_rtl_config\>"
syn match   VMMClass "\<vmm_rtl_config_DW_format\>"
syn match   VMMClass "\<vmm_rtl_config_file_format\>"
syn match   VMMClass "\<vmm_scenario\>"
syn match   VMMClass "\<vmm_scenario_gen\>"
syn match   VMMClass "\<vmm_scheduler\>"
syn match   VMMClass "\<vmm_scheduler_election\>"
syn match   VMMClass "\<vmm_simulation\>"
syn match   VMMClass "\<vmm_ss_scenario\>"
syn match   VMMClass "\<vmm_subenv\>"
syn match   VMMClass "\<vmm_test\>"
syn match   VMMClass "\<vmm_test_registry\>"
syn match   VMMClass "\<vmm_timeline\>"
syn match   VMMClass "\<vmm_timeline_callbacks\>"
syn match   VMMClass "\<vmm_tlm\>"
syn match   VMMClass "\<vmm_tlm_analysis_export\>"
syn match   VMMClass "\<vmm_tlm_analysis_port\>"
syn match   VMMClass "\<vmm_tlm_b_transport_export\>"
syn match   VMMClass "\<vmm_tlm_b_transport_port\>"
syn match   VMMClass "\<vmm_tlm_export_base\>"
syn match   VMMClass "\<vmm_tlm_generic_payload\>"
syn match   VMMClass "\<vmm_tlm_initiator_socket\>"
syn match   VMMClass "\<vmm_tlm_nb_transport_port\>"
syn match   VMMClass "\<vmm_tlm_nb_transport_bw_export\>"
syn match   VMMClass "\<vmm_tlm_nb_transport_bw_port\>"
syn match   VMMClass "\<vmm_tlm_nb_transport_export\>"
syn match   VMMClass "\<vmm_tlm_nb_transport_fw_export\>"
syn match   VMMClass "\<vmm_tlm_nb_transport_fw_port\>"
syn match   VMMClass "\<vmm_tlm_port_base\>"
syn match   VMMClass "\<vmm_tlm_target_socket\>"
syn match   VMMClass "\<vmm_unit\>"
syn match   VMMClass "\<vmm_version\>"
syn match   VMMClass "\<vmm_voter\>"
syn match   VMMClass "\<vmm_xactor\>"
syn match   VMMClass "\<vmm_xactor_callbacks\>"
syn match   VMMClass "\<vmm_xactor_iter\>"

" VMM macro
syn match   VMMMacro "`vmm_tlm_analysis_export\>"
syn match   VMMMacro "`AVT_VMM_OVM_ENV_BASE\>"
syn match   VMMMacro "`AVT_VMM_UVM_ENV_BASE\>"
syn match   VMMMacro "`VMM12_XACTOR_BASE\>"
syn match   VMMMacro "`VMM12_XACTOR_NEW_ARGS\>"
syn match   VMMMacro "`VMM12_XACTOR_NEW_CALL\>"
syn match   VMMMacro "`VMM12_XACTOR_NEW_EXTERN_ARGS\>"
syn match   VMMMacro "`VMM_AA_INT\>"
syn match   VMMMacro "`VMM_CHANNEL\>"
syn match   VMMMacro "`VMM_CHANNEL_BASE\>"
syn match   VMMMacro "`VMM_CHANNEL_BASE_METHODS\>"
syn match   VMMMacro "`VMM_CHANNEL_BASE_NEW_ARGS\>"
syn match   VMMMacro "`VMM_CHANNEL_BASE_NEW_CALL\>"
syn match   VMMMacro "`VMM_CHANNEL_BASE_NEW_EXTERN_ARGS\>"
syn match   VMMMacro "`VMM_CHANNEL_TYPED_BASE_NEW_CALL\>"
syn match   VMMMacro "`VMM_CONSENSUS\>"
syn match   VMMMacro "`VMM_CONSENSUS_BASE\>"
syn match   VMMMacro "`VMM_CONSENSUS_BASE_NEW_CALL\>"
syn match   VMMMacro "`VMM_DATA\>"
syn match   VMMMacro "`VMM_DATA_BASE\>"
syn match   VMMMacro "`VMM_DATA_BASE_NEW_ARGS\>"
syn match   VMMMacro "`VMM_DATA_BASE_NEW_CALL\>"
syn match   VMMMacro "`VMM_DATA_BASE_NEW_EXTERN_ARGS\>"
syn match   VMMMacro "`VMM_DEBUG\>"
syn match   VMMMacro "`VMM_DOSFILE_CHECK\>"
syn match   VMMMacro "`VMM_ENV\>"
syn match   VMMMacro "`VMM_ENV_BASE\>"
syn match   VMMMacro "`VMM_ENV_BASE_METHODS\>"
syn match   VMMMacro "`VMM_ENV_BASE_NEW_CALL\>"
syn match   VMMMacro "`VMM_ERROR\>"
syn match   VMMMacro "`VMM_FATAL\>"
syn match   VMMMacro "`VMM_FILE_MESSAGE\>"
syn match   VMMMacro "`VMM_GROUP_BASE\>"
syn match   VMMMacro "`VMM_LOG\>"
syn match   VMMMacro "`VMM_MACRO_TO_STRING\>"
syn match   VMMMacro "`VMM_NOTE\>"
syn match   VMMMacro "`VMM_NOTIFY\>"
syn match   VMMMacro "`VMM_NOTIFY_BASE\>"
syn match   VMMMacro "`VMM_NOTIFY_BASE_NEW_CALL\>"
syn match   VMMMacro "`VMM_OBJECT\>"
syn match   VMMMacro "`VMM_OBJECT_BASE_NEW_ARGS\>"
syn match   VMMMacro "`VMM_OBJECT_SET_PARENT\>"
syn match   VMMMacro "`VMM_PATH_MATCH\>"
syn match   VMMMacro "`VMM_RAL_BASE\>"
syn match   VMMMacro "`VMM_RAL_BASE_NEW_ARGS\>"
syn match   VMMMacro "`VMM_RAL_BASE_NEW_EXTERN_ARGS\>"
syn match   VMMMacro "`VMM_RW_ADDR_WIDTH\>"
syn match   VMMMacro "`VMM_RW_BYTENABLE_WIDTH\>"
syn match   VMMMacro "`VMM_RW_DATA_WIDTH\>"
syn match   VMMMacro "`VMM_SCENARIO\>"
syn match   VMMMacro "`VMM_SCENARIO_BASE\>"
syn match   VMMMacro "`VMM_SCENARIO_BASE_NEW_ARGS\>"
syn match   VMMMacro "`VMM_SCENARIO_BASE_NEW_CALL\>"
syn match   VMMMacro "`VMM_SCENARIO_BASE_NEW_EXTERN_ARGS\>"
syn match   VMMMacro "`VMM_SCENARIO_NEW_ARGS\>"
syn match   VMMMacro "`VMM_SCENARIO_NEW_CALL\>"
syn match   VMMMacro "`VMM_SCENARIO_NEW_EXTERN_ARGS\>"
syn match   VMMMacro "`VMM_SOLVE_BEFORE_OPT\>"
syn match   VMMMacro "`VMM_STATIC_M\>"
syn match   VMMMacro "`VMM_SUBENV\>"
syn match   VMMMacro "`VMM_SUBENV_BASE\>"
syn match   VMMMacro "`VMM_SUBENV_BASE_METHODS\>"
syn match   VMMMacro "`VMM_SUBENV_BASE_NEW_ARGS\>"
syn match   VMMMacro "`VMM_SUBENV_BASE_NEW_CALL\>"
syn match   VMMMacro "`VMM_SUBENV_BASE_NEW_EXTERN_ARGS\>"
syn match   VMMMacro "`VMM_TEST_BASE\>"
syn match   VMMMacro "`VMM_TRACE\>"
syn match   VMMMacro "`VMM_VERBOSE\>"
syn match   VMMMacro "`VMM_WARN\>"
syn match   VMMMacro "`VMM_XACTOR\>"
syn match   VMMMacro "`VMM_XACTOR_BASE\>"
syn match   VMMMacro "`VMM_XACTOR_BASE_METHODS\>"
syn match   VMMMacro "`VMM_XACTOR_BASE_NEW_ARGS\>"
syn match   VMMMacro "`VMM_XACTOR_BASE_NEW_CALL\>"
syn match   VMMMacro "`VMM_XACTOR_BASE_NEW_EXTERN_ARGS\>"
syn match   VMMMacro "`VMM_XVC_ACTION_BASE_NEW_ARGS\>"
syn match   VMMMacro "`VMM_XVC_ACTION_BASE_NEW_CALL\>"
syn match   VMMMacro "`_TO_CAST_TO_STRING\>"
syn match   VMMMacro "`foreach_vmm_object\>"
syn match   VMMMacro "`foreach_vmm_object_in_namespace\>"
syn match   VMMMacro "`foreach_vmm_xactor\>"
syn match   VMMMacro "`vmm_atomic_gen\>"
syn match   VMMMacro "`vmm_atomic_gen_\>"
syn match   VMMMacro "`vmm_atomic_gen_callbacks_\>"
syn match   VMMMacro "`vmm_atomic_gen_using\>"
syn match   VMMMacro "`vmm_atomic_scenario_\>"
syn match   VMMMacro "`vmm_callback\>"
syn match   VMMMacro "`vmm_channel\>"
syn match   VMMMacro "`vmm_channel_\>"
syn match   VMMMacro "`vmm_class_factory\>"
syn match   VMMMacro "`vmm_command\>"
syn match   VMMMacro "`vmm_command_FL\>"
syn match   VMMMacro "`vmm_create_callback\>"
syn match   VMMMacro "`vmm_cycle\>"
syn match   VMMMacro "`vmm_cycle_FL\>"
syn match   VMMMacro "`vmm_data_byte_size\>"
syn match   VMMMacro "`vmm_data_byte_size_used\>"
syn match   VMMMacro "`vmm_data_member_begin\>"
syn match   VMMMacro "`vmm_data_member_end\>"
syn match   VMMMacro "`vmm_data_member_enum\>"
syn match   VMMMacro "`vmm_data_member_enum_aa_scalar\>"
syn match   VMMMacro "`vmm_data_member_enum_aa_string\>"
syn match   VMMMacro "`vmm_data_member_enum_array\>"
syn match   VMMMacro "`vmm_data_member_enum_da\>"
syn match   VMMMacro "`vmm_data_member_enum_queue\>"
syn match   VMMMacro "`vmm_data_member_enum_set_name\>"
syn match   VMMMacro "`vmm_data_member_handle\>"
syn match   VMMMacro "`vmm_data_member_handle_aa_scalar\>"
syn match   VMMMacro "`vmm_data_member_handle_aa_string\>"
syn match   VMMMacro "`vmm_data_member_handle_array\>"
syn match   VMMMacro "`vmm_data_member_handle_da\>"
syn match   VMMMacro "`vmm_data_member_handle_queue\>"
syn match   VMMMacro "`vmm_data_member_rand_enum\>"
syn match   VMMMacro "`vmm_data_member_rand_enum_aa_scalar\>"
syn match   VMMMacro "`vmm_data_member_rand_enum_aa_string\>"
syn match   VMMMacro "`vmm_data_member_rand_enum_array\>"
syn match   VMMMacro "`vmm_data_member_rand_enum_da\>"
syn match   VMMMacro "`vmm_data_member_rand_enum_queue\>"
syn match   VMMMacro "`vmm_data_member_rand_handle\>"
syn match   VMMMacro "`vmm_data_member_rand_handle_aa_scalar\>"
syn match   VMMMacro "`vmm_data_member_rand_handle_aa_string\>"
syn match   VMMMacro "`vmm_data_member_rand_handle_array\>"
syn match   VMMMacro "`vmm_data_member_rand_handle_da\>"
syn match   VMMMacro "`vmm_data_member_rand_handle_queue\>"
syn match   VMMMacro "`vmm_data_member_rand_scalar\>"
syn match   VMMMacro "`vmm_data_member_rand_scalar_aa_scalar\>"
syn match   VMMMacro "`vmm_data_member_rand_scalar_aa_string\>"
syn match   VMMMacro "`vmm_data_member_rand_scalar_array\>"
syn match   VMMMacro "`vmm_data_member_rand_scalar_da\>"
syn match   VMMMacro "`vmm_data_member_rand_scalar_queue\>"
syn match   VMMMacro "`vmm_data_member_rand_vmm_data\>"
syn match   VMMMacro "`vmm_data_member_rand_vmm_data_aa_scalar\>"
syn match   VMMMacro "`vmm_data_member_rand_vmm_data_aa_string\>"
syn match   VMMMacro "`vmm_data_member_rand_vmm_data_array\>"
syn match   VMMMacro "`vmm_data_member_rand_vmm_data_da\>"
syn match   VMMMacro "`vmm_data_member_rand_vmm_data_queue\>"
syn match   VMMMacro "`vmm_data_member_scalar\>"
syn match   VMMMacro "`vmm_data_member_scalar_aa_scalar\>"
syn match   VMMMacro "`vmm_data_member_scalar_aa_string\>"
syn match   VMMMacro "`vmm_data_member_scalar_array\>"
syn match   VMMMacro "`vmm_data_member_scalar_count\>"
syn match   VMMMacro "`vmm_data_member_scalar_da\>"
syn match   VMMMacro "`vmm_data_member_scalar_pack\>"
syn match   VMMMacro "`vmm_data_member_scalar_packint\>"
syn match   VMMMacro "`vmm_data_member_scalar_queue\>"
syn match   VMMMacro "`vmm_data_member_scalar_unpack\>"
syn match   VMMMacro "`vmm_data_member_scalar_unpackint\>"
syn match   VMMMacro "`vmm_data_member_string\>"
syn match   VMMMacro "`vmm_data_member_string_aa_scalar\>"
syn match   VMMMacro "`vmm_data_member_string_aa_string\>"
syn match   VMMMacro "`vmm_data_member_string_array\>"
syn match   VMMMacro "`vmm_data_member_string_da\>"
syn match   VMMMacro "`vmm_data_member_string_queue\>"
syn match   VMMMacro "`vmm_data_member_update_offset\>"
syn match   VMMMacro "`vmm_data_member_user_defined\>"
syn match   VMMMacro "`vmm_data_member_vmm_data\>"
syn match   VMMMacro "`vmm_data_member_vmm_data_aa_scalar\>"
syn match   VMMMacro "`vmm_data_member_vmm_data_aa_string\>"
syn match   VMMMacro "`vmm_data_member_vmm_data_array\>"
syn match   VMMMacro "`vmm_data_member_vmm_data_da\>"
syn match   VMMMacro "`vmm_data_member_vmm_data_queue\>"
syn match   VMMMacro "`vmm_data_methods\>"
syn match   VMMMacro "`vmm_data_new\>"
syn match   VMMMacro "`vmm_data_new_used\>"
syn match   VMMMacro "`vmm_debug\>"
syn match   VMMMacro "`vmm_debug_FL\>"
syn match   VMMMacro "`vmm_delQ\>"
syn match   VMMMacro "`vmm_env_member_begin\>"
syn match   VMMMacro "`vmm_env_member_channel\>"
syn match   VMMMacro "`vmm_env_member_channel_aa_scalar\>"
syn match   VMMMacro "`vmm_env_member_channel_aa_string\>"
syn match   VMMMacro "`vmm_env_member_channel_array\>"
syn match   VMMMacro "`vmm_env_member_end\>"
syn match   VMMMacro "`vmm_env_member_enum\>"
syn match   VMMMacro "`vmm_env_member_enum_aa_scalar\>"
syn match   VMMMacro "`vmm_env_member_enum_aa_string\>"
syn match   VMMMacro "`vmm_env_member_enum_array\>"
syn match   VMMMacro "`vmm_env_member_scalar\>"
syn match   VMMMacro "`vmm_env_member_scalar_aa_scalar\>"
syn match   VMMMacro "`vmm_env_member_scalar_aa_string\>"
syn match   VMMMacro "`vmm_env_member_scalar_array\>"
syn match   VMMMacro "`vmm_env_member_string\>"
syn match   VMMMacro "`vmm_env_member_string_aa_scalar\>"
syn match   VMMMacro "`vmm_env_member_string_aa_string\>"
syn match   VMMMacro "`vmm_env_member_string_array\>"
syn match   VMMMacro "`vmm_env_member_subenv\>"
syn match   VMMMacro "`vmm_env_member_subenv_aa_scalar\>"
syn match   VMMMacro "`vmm_env_member_subenv_aa_string\>"
syn match   VMMMacro "`vmm_env_member_subenv_array\>"
syn match   VMMMacro "`vmm_env_member_user_defined\>"
syn match   VMMMacro "`vmm_env_member_vmm_data\>"
syn match   VMMMacro "`vmm_env_member_vmm_data_aa_scalar\>"
syn match   VMMMacro "`vmm_env_member_vmm_data_aa_string\>"
syn match   VMMMacro "`vmm_env_member_vmm_data_array\>"
syn match   VMMMacro "`vmm_env_member_xactor\>"
syn match   VMMMacro "`vmm_env_member_xactor_aa_scalar\>"
syn match   VMMMacro "`vmm_env_member_xactor_aa_string\>"
syn match   VMMMacro "`vmm_env_member_xactor_array\>"
syn match   VMMMacro "`vmm_error\>"
syn match   VMMMacro "`vmm_error_FL\>"
syn match   VMMMacro "`vmm_fatal\>"
syn match   VMMMacro "`vmm_fatal_FL\>"
syn match   VMMMacro "`vmm_inject_item_scenario_\>"
syn match   VMMMacro "`vmm_note\>"
syn match   VMMMacro "`vmm_note_FL\>"
syn match   VMMMacro "`vmm_notify_observer\>"
syn match   VMMMacro "`vmm_path_compiled\>"
syn match   VMMMacro "`vmm_path_regexp\>"
syn match   VMMMacro "`vmm_protocol\>"
syn match   VMMMacro "`vmm_protocol_FL\>"
syn match   VMMMacro "`vmm_report\>"
syn match   VMMMacro "`vmm_report_FL\>"
syn match   VMMMacro "`vmm_rtl_config_begin\>"
syn match   VMMMacro "`vmm_rtl_config_boolean\>"
syn match   VMMMacro "`vmm_rtl_config_end\>"
syn match   VMMMacro "`vmm_rtl_config_int\>"
syn match   VMMMacro "`vmm_rtl_config_obj\>"
syn match   VMMMacro "`vmm_rtl_config_string\>"
syn match   VMMMacro "`vmm_scenario_\>"
syn match   VMMMacro "`vmm_scenario_election_\>"
syn match   VMMMacro "`vmm_scenario_election_valid_\>"
syn match   VMMMacro "`vmm_scenario_gen\>"
syn match   VMMMacro "`vmm_scenario_gen_\>"
syn match   VMMMacro "`vmm_scenario_gen_callbacks_\>"
syn match   VMMMacro "`vmm_scenario_gen_using\>"
syn match   VMMMacro "`vmm_scenario_member_begin\>"
syn match   VMMMacro "`vmm_scenario_member_end\>"
syn match   VMMMacro "`vmm_scenario_member_enum\>"
syn match   VMMMacro "`vmm_scenario_member_enum_aa_scalar\>"
syn match   VMMMacro "`vmm_scenario_member_enum_aa_string\>"
syn match   VMMMacro "`vmm_scenario_member_enum_array\>"
syn match   VMMMacro "`vmm_scenario_member_enum_da\>"
syn match   VMMMacro "`vmm_scenario_member_handle\>"
syn match   VMMMacro "`vmm_scenario_member_handle_aa_scalar\>"
syn match   VMMMacro "`vmm_scenario_member_handle_aa_string\>"
syn match   VMMMacro "`vmm_scenario_member_handle_array\>"
syn match   VMMMacro "`vmm_scenario_member_handle_da\>"
syn match   VMMMacro "`vmm_scenario_member_scalar\>"
syn match   VMMMacro "`vmm_scenario_member_scalar_aa_scalar\>"
syn match   VMMMacro "`vmm_scenario_member_scalar_aa_string\>"
syn match   VMMMacro "`vmm_scenario_member_scalar_array\>"
syn match   VMMMacro "`vmm_scenario_member_scalar_da\>"
syn match   VMMMacro "`vmm_scenario_member_string\>"
syn match   VMMMacro "`vmm_scenario_member_string_aa_scalar\>"
syn match   VMMMacro "`vmm_scenario_member_string_aa_string\>"
syn match   VMMMacro "`vmm_scenario_member_string_array\>"
syn match   VMMMacro "`vmm_scenario_member_string_da\>"
syn match   VMMMacro "`vmm_scenario_member_user_defined\>"
syn match   VMMMacro "`vmm_scenario_member_vmm_data\>"
syn match   VMMMacro "`vmm_scenario_member_vmm_data_aa_scalar\>"
syn match   VMMMacro "`vmm_scenario_member_vmm_data_aa_string\>"
syn match   VMMMacro "`vmm_scenario_member_vmm_data_array\>"
syn match   VMMMacro "`vmm_scenario_member_vmm_data_da\>"
syn match   VMMMacro "`vmm_scenario_member_vmm_scenario\>"
syn match   VMMMacro "`vmm_scenario_new\>"
syn match   VMMMacro "`vmm_scenario_valid_\>"
syn match   VMMMacro "`vmm_sformatf\>"
syn match   VMMMacro "`vmm_str_backref\>"
syn match   VMMMacro "`vmm_str_match\>"
syn match   VMMMacro "`vmm_str_postmatch\>"
syn match   VMMMacro "`vmm_str_prematch\>"
syn match   VMMMacro "`vmm_subenv_member_begin\>"
syn match   VMMMacro "`vmm_subenv_member_channel\>"
syn match   VMMMacro "`vmm_subenv_member_channel_aa_scalar\>"
syn match   VMMMacro "`vmm_subenv_member_channel_aa_string\>"
syn match   VMMMacro "`vmm_subenv_member_channel_array\>"
syn match   VMMMacro "`vmm_subenv_member_end\>"
syn match   VMMMacro "`vmm_subenv_member_enum\>"
syn match   VMMMacro "`vmm_subenv_member_enum_aa_scalar\>"
syn match   VMMMacro "`vmm_subenv_member_enum_aa_string\>"
syn match   VMMMacro "`vmm_subenv_member_enum_array\>"
syn match   VMMMacro "`vmm_subenv_member_scalar\>"
syn match   VMMMacro "`vmm_subenv_member_scalar_aa_scalar\>"
syn match   VMMMacro "`vmm_subenv_member_scalar_aa_string\>"
syn match   VMMMacro "`vmm_subenv_member_scalar_array\>"
syn match   VMMMacro "`vmm_subenv_member_string\>"
syn match   VMMMacro "`vmm_subenv_member_string_aa_scalar\>"
syn match   VMMMacro "`vmm_subenv_member_string_aa_string\>"
syn match   VMMMacro "`vmm_subenv_member_string_array\>"
syn match   VMMMacro "`vmm_subenv_member_subenv\>"
syn match   VMMMacro "`vmm_subenv_member_subenv_aa_scalar\>"
syn match   VMMMacro "`vmm_subenv_member_subenv_aa_string\>"
syn match   VMMMacro "`vmm_subenv_member_subenv_array\>"
syn match   VMMMacro "`vmm_subenv_member_user_defined\>"
syn match   VMMMacro "`vmm_subenv_member_vmm_data\>"
syn match   VMMMacro "`vmm_subenv_member_vmm_data_aa_scalar\>"
syn match   VMMMacro "`vmm_subenv_member_vmm_data_aa_string\>"
syn match   VMMMacro "`vmm_subenv_member_vmm_data_array\>"
syn match   VMMMacro "`vmm_subenv_member_xactor\>"
syn match   VMMMacro "`vmm_subenv_member_xactor_aa_scalar\>"
syn match   VMMMacro "`vmm_subenv_member_xactor_aa_string\>"
syn match   VMMMacro "`vmm_subenv_member_xactor_array\>"
syn match   VMMMacro "`vmm_test_begin\>"
syn match   VMMMacro "`vmm_test_concatenate\>"
syn match   VMMMacro "`vmm_test_end\>"
syn match   VMMMacro "`vmm_tlm_analysis_export\>"
syn match   VMMMacro "`vmm_tlm_b_transport_export\>"
syn match   VMMMacro "`vmm_tlm_initiator_socket\>"
syn match   VMMMacro "`vmm_tlm_nb_transport_bw_export\>"
syn match   VMMMacro "`vmm_tlm_nb_transport_export\>"
syn match   VMMMacro "`vmm_tlm_nb_transport_fw_export\>"
syn match   VMMMacro "`vmm_tlm_nb_transport_port\>"
syn match   VMMMacro "`vmm_tlm_target_socket\>"
syn match   VMMMacro "`vmm_trace\>"
syn match   VMMMacro "`vmm_trace_FL\>"
syn match   VMMMacro "`vmm_transaction\>"
syn match   VMMMacro "`vmm_transaction_FL\>"
syn match   VMMMacro "`vmm_typename\>"
syn match   VMMMacro "`vmm_unit_config_begin\>"
syn match   VMMMacro "`vmm_unit_config_boolean\>"
syn match   VMMMacro "`vmm_unit_config_end\>"
syn match   VMMMacro "`vmm_unit_config_int\>"
syn match   VMMMacro "`vmm_unit_config_obj\>"
syn match   VMMMacro "`vmm_unit_config_rand_boolean\>"
syn match   VMMMacro "`vmm_unit_config_rand_int\>"
syn match   VMMMacro "`vmm_unit_config_rand_obj\>"
syn match   VMMMacro "`vmm_unit_config_string\>"
syn match   VMMMacro "`vmm_user\>"
syn match   VMMMacro "`vmm_user_FL\>"
syn match   VMMMacro "`vmm_verbose\>"
syn match   VMMMacro "`vmm_verbose_FL\>"
syn match   VMMMacro "`vmm_warning\>"
syn match   VMMMacro "`vmm_warning_FL\>"
syn match   VMMMacro "`vmm_xactor_member_begin\>"
syn match   VMMMacro "`vmm_xactor_member_channel\>"
syn match   VMMMacro "`vmm_xactor_member_channel_aa_scalar\>"
syn match   VMMMacro "`vmm_xactor_member_channel_aa_string\>"
syn match   VMMMacro "`vmm_xactor_member_channel_array\>"
syn match   VMMMacro "`vmm_xactor_member_end\>"
syn match   VMMMacro "`vmm_xactor_member_enum\>"
syn match   VMMMacro "`vmm_xactor_member_enum_aa_scalar\>"
syn match   VMMMacro "`vmm_xactor_member_enum_aa_string\>"
syn match   VMMMacro "`vmm_xactor_member_enum_array\>"
syn match   VMMMacro "`vmm_xactor_member_scalar\>"
syn match   VMMMacro "`vmm_xactor_member_scalar_aa_scalar\>"
syn match   VMMMacro "`vmm_xactor_member_scalar_aa_string\>"
syn match   VMMMacro "`vmm_xactor_member_scalar_array\>"
syn match   VMMMacro "`vmm_xactor_member_string\>"
syn match   VMMMacro "`vmm_xactor_member_string_aa_scalar\>"
syn match   VMMMacro "`vmm_xactor_member_string_aa_string\>"
syn match   VMMMacro "`vmm_xactor_member_string_array\>"
syn match   VMMMacro "`vmm_xactor_member_user_defined\>"
syn match   VMMMacro "`vmm_xactor_member_vmm_data\>"
syn match   VMMMacro "`vmm_xactor_member_vmm_data_aa_scalar\>"
syn match   VMMMacro "`vmm_xactor_member_vmm_data_aa_string\>"
syn match   VMMMacro "`vmm_xactor_member_vmm_data_array\>"
syn match   VMMMacro "`vmm_xactor_member_xactor\>"
syn match   VMMMacro "`vmm_xactor_member_xactor_aa_scalar\>"
syn match   VMMMacro "`vmm_xactor_member_xactor_aa_string\>"
syn match   VMMMacro "`vmm_xactor_member_xactor_array\>"

" VMM method
syn match   VMMMethod "\<X_getX\>"
syn match   VMMMethod "\<XgetX\>"
syn match   VMMMethod "\<Xget_scenarioX\>"
syn match   VMMMethod "\<Xrecord_to_fileX\>"
syn match   VMMMethod "\<Xregister_testX\>"
syn match   VMMMethod "\<Xset_allocate_idX\>"
syn match   VMMMethod "\<Xset_context_genX\>"
syn match   VMMMethod "\<Xset_log_instanceX\>"
syn match   VMMMethod "\<XvoteX\>"
syn match   VMMMethod "\<__default_name\>"
syn match   VMMMethod "\<__vmm_byte_size\>"
syn match   VMMMethod "\<abort_child_phase_waiting\>"
syn match   VMMMethod "\<abort_on_error\>"
syn match   VMMMethod "\<abort_phase\>"
syn match   VMMMethod "\<activate\>"
syn match   VMMMethod "\<active_slot\>"
syn match   VMMMethod "\<add_action\>"
syn match   VMMMethod "\<add_phase\>"
syn match   VMMMethod "\<add_specified_option\>"
syn match   VMMMethod "\<add_stop_on\>"
syn match   VMMMethod "\<add_to_output\>"
syn match   VMMMethod "\<add_watchpoint\>"
syn match   VMMMethod "\<add_xvc\>"
syn match   VMMMethod "\<allocate\>"
syn match   VMMMethod "\<allocate_scenario\>"
syn match   VMMMethod "\<allow_new_phases\>"
syn match   VMMMethod "\<append_callback\>"
syn match   VMMMethod "\<apply\>"
syn match   VMMMethod "\<bcast_off\>"
syn match   VMMMethod "\<bcast_on\>"
syn match   VMMMethod "\<bcast_on_off\>"
syn match   VMMMethod "\<bcast_to_output\>"
syn match   VMMMethod "\<block_consumer\>"
syn match   VMMMethod "\<block_producer\>"
syn match   VMMMethod "\<broadcast\>"
syn match   VMMMethod "\<broadcast_mode\>"
syn match   VMMMethod "\<build\>"
syn match   VMMMethod "\<build_config_ph\>"
syn match   VMMMethod "\<build_ph\>"
syn match   VMMMethod "\<byte_pack\>"
syn match   VMMMethod "\<byte_size\>"
syn match   VMMMethod "\<byte_unpack\>"
syn match   VMMMethod "\<catch\>"
syn match   VMMMethod "\<cfdisplay\>"
syn match   VMMMethod "\<cfg_dut\>"
syn match   VMMMethod "\<channel\>"
syn match   VMMMethod "\<channel_exists\>"
syn match   VMMMethod "\<check_all_grab_owners\>"
syn match   VMMMethod "\<check_all_threads_stopped\>"
syn match   VMMMethod "\<check_bindings\>"
syn match   VMMMethod "\<check_grab_owners\>"
syn match   VMMMethod "\<check_options_usage\>"
syn match   VMMMethod "\<cleanup\>"
syn match   VMMMethod "\<cleanup_ph\>"
syn match   VMMMethod "\<close_stream\>"
syn match   VMMMethod "\<collect_root_objects\>"
syn match   VMMMethod "\<compare\>"
syn match   VMMMethod "\<compile_path\>"
syn match   VMMMethod "\<compile_pattern\>"
syn match   VMMMethod "\<complete\>"
syn match   VMMMethod "\<concatenate_test_n_reset_phase\>"
syn match   VMMMethod "\<config_dut_ph\>"
syn match   VMMMethod "\<configure\>"
syn match   VMMMethod "\<configured\>"
syn match   VMMMethod "\<configure_ph\>"
syn match   VMMMethod "\<configure_test_ph\>"
syn match   VMMMethod "\<connect\>"
syn match   VMMMethod "\<connect_ph\>"
syn match   VMMMethod "\<consensus_force_thru\>"
syn match   VMMMethod "\<consensus_requested\>"
syn match   VMMMethod "\<consent\>"
syn match   VMMMethod "\<continue_msg\>"
syn match   VMMMethod "\<copy\>"
syn match   VMMMethod "\<copy_data\>"
syn match   VMMMethod "\<create_namespace\>"
syn match   VMMMethod "\<create_watchpoint\>"
syn match   VMMMethod "\<default_handling\>"
syn match   VMMMethod "\<define_scenario\>"
syn match   VMMMethod "\<delay_task\>"
syn match   VMMMethod "\<delete_phase\>"
syn match   VMMMethod "\<disable_child_unit\>"
syn match   VMMMethod "\<disable_types\>"
syn match   VMMMethod "\<disable_unit\>"
syn match   VMMMethod "\<disabled_ph\>"
syn match   VMMMethod "\<display\>"
syn match   VMMMethod "\<display_known_tests\>"
syn match   VMMMethod "\<display_phase_info\>"
syn match   VMMMethod "\<display_phases\>"
syn match   VMMMethod "\<do_allocate\>"
syn match   VMMMethod "\<do_byte_pack\>"
syn match   VMMMethod "\<do_byte_size\>"
syn match   VMMMethod "\<do_byte_unpack\>"
syn match   VMMMethod "\<do_compare\>"
syn match   VMMMethod "\<do_copy\>"
syn match   VMMMethod "\<do_is_valid\>"
syn match   VMMMethod "\<do_kill_xactor\>"
syn match   VMMMethod "\<do_max_byte_size\>"
syn match   VMMMethod "\<do_psdisplay\>"
syn match   VMMMethod "\<do_reset\>"
syn match   VMMMethod "\<do_reset_xactor\>"
syn match   VMMMethod "\<do_start\>"
syn match   VMMMethod "\<do_start_xactor\>"
syn match   VMMMethod "\<do_stop\>"
syn match   VMMMethod "\<do_stop_xactor\>"
syn match   VMMMethod "\<do_vote\>"
syn match   VMMMethod "\<emit\>"
syn match   VMMMethod "\<empty_level\>"
syn match   VMMMethod "\<enable_child_unit\>"
syn match   VMMMethod "\<enable_types\>"
syn match   VMMMethod "\<end_msg\>"
syn match   VMMMethod "\<end_tr\>"
syn match   VMMMethod "\<execute\>"
syn match   VMMMethod "\<execute_action\>"
syn match   VMMMethod "\<execute_actions\>"
syn match   VMMMethod "\<execute_burst\>"
syn match   VMMMethod "\<execute_interruptions\>"
syn match   VMMMethod "\<execute_post_test\>"
syn match   VMMMethod "\<execute_pre_test\>"
syn match   VMMMethod "\<execute_scenario\>"
syn match   VMMMethod "\<execute_single\>"
syn match   VMMMethod "\<execute_top_test\>"
syn match   VMMMethod "\<exp_vmm_sb_ds\>"
syn match   VMMMethod "\<extend_tr\>"
syn match   VMMMethod "\<extract_opts_info\>"
syn match   VMMMethod "\<fill_scenario\>"
syn match   VMMMethod "\<filter\>"
syn match   VMMMethod "\<final_ph\>"
syn match   VMMMethod "\<find_child_by_name\>"
syn match   VMMMethod "\<find_object_by_name\>"
syn match   VMMMethod "\<find_phases\>"
syn match   VMMMethod "\<find_timelines\>"
syn match   VMMMethod "\<first\>"
syn match   VMMMethod "\<flow\>"
syn match   VMMMethod "\<flush\>"
syn match   VMMMethod "\<flush_child_timelines\>"
syn match   VMMMethod "\<flush_msg\>"
syn match   VMMMethod "\<fname\>"
syn match   VMMMethod "\<for_each\>"
syn match   VMMMethod "\<for_each_offset\>"
syn match   VMMMethod "\<for_reset\>"
syn match   VMMMethod "\<force_thru\>"
syn match   VMMMethod "\<forced\>"
syn match   VMMMethod "\<forcing\>"
syn match   VMMMethod "\<format_msg\>"
syn match   VMMMethod "\<full_level\>"
syn match   VMMMethod "\<gen_cfg\>"
syn match   VMMMethod "\<get\>"
syn match   VMMMethod "\<get_all_channel_names\>"
syn match   VMMMethod "\<get_all_ms_scenario_gen_names\>"
syn match   VMMMethod "\<get_all_ms_scenario_names\>"
syn match   VMMMethod "\<get_all_scenario_names\>"
syn match   VMMMethod "\<get_bit\>"
syn match   VMMMethod "\<get_channel\>"
syn match   VMMMethod "\<get_channel_name\>"
syn match   VMMMethod "\<get_child_log\>"
syn match   VMMMethod "\<get_child_ready_for_phase\>"
syn match   VMMMethod "\<get_config\>"
syn match   VMMMethod "\<get_config_ph\>"
syn match   VMMMethod "\<get_consensus\>"
syn match   VMMMethod "\<get_consumer\>"
syn match   VMMMethod "\<get_context_gen\>"
syn match   VMMMethod "\<get_current_phase_index\>"
syn match   VMMMethod "\<get_current_phase_name\>"
syn match   VMMMethod "\<get_doc\>"
syn match   VMMMethod "\<get_forced\>"
syn match   VMMMethod "\<get_help\>"
syn match   VMMMethod "\<get_hier_inst_name\>"
syn match   VMMMethod "\<get_input_channels\>"
syn match   VMMMethod "\<get_instance\>"
syn match   VMMMethod "\<get_int\>"
syn match   VMMMethod "\<get_log\>"
syn match   VMMMethod "\<get_max_length\>"
syn match   VMMMethod "\<get_message_count\>"
syn match   VMMMethod "\<get_ms_scenario\>"
syn match   VMMMethod "\<get_ms_scenario_gen\>"
syn match   VMMMethod "\<get_ms_scenario_gen_name\>"
syn match   VMMMethod "\<get_ms_scenario_index\>"
syn match   VMMMethod "\<get_ms_scenario_name\>"
syn match   VMMMethod "\<get_n_insts\>"
syn match   VMMMethod "\<get_n_scenarios\>"
syn match   VMMMethod "\<get_name\>"
syn match   VMMMethod "\<get_names_by_channel\>"
syn match   VMMMethod "\<get_names_by_ms_scenario\>"
syn match   VMMMethod "\<get_names_by_ms_scenario_gen\>"
syn match   VMMMethod "\<get_names_by_scenario\>"
syn match   VMMMethod "\<get_namespaces\>"
syn match   VMMMethod "\<get_next_cmd\>"
syn match   VMMMethod "\<get_next_phase_name\>"
syn match   VMMMethod "\<get_notification\>"
syn match   VMMMethod "\<get_notify\>"
syn match   VMMMethod "\<get_nth_child\>"
syn match   VMMMethod "\<get_nth_root\>"
syn match   VMMMethod "\<get_num_children\>"
syn match   VMMMethod "\<get_num_roots\>"
syn match   VMMMethod "\<get_obj\>"
syn match   VMMMethod "\<get_object\>"
syn match   VMMMethod "\<get_object_bit\>"
syn match   VMMMethod "\<get_object_hiername\>"
syn match   VMMMethod "\<get_object_int\>"
syn match   VMMMethod "\<get_object_name\>"
syn match   VMMMethod "\<get_object_obj\>"
syn match   VMMMethod "\<get_object_range\>"
syn match   VMMMethod "\<get_object_string\>"
syn match   VMMMethod "\<get_opts_by_name\>"
syn match   VMMMethod "\<get_output_channels\>"
syn match   VMMMethod "\<get_parent\>"
syn match   VMMMethod "\<get_parent_log\>"
syn match   VMMMethod "\<get_parent_object\>"
syn match   VMMMethod "\<get_parent_scenario\>"
syn match   VMMMethod "\<get_phase\>"
syn match   VMMMethod "\<get_phase_index\>"
syn match   VMMMethod "\<get_post_timeline\>"
syn match   VMMMethod "\<get_pre_timeline\>"
syn match   VMMMethod "\<get_previous_phase_name\>"
syn match   VMMMethod "\<get_producer\>"
syn match   VMMMethod "\<get_range\>"
syn match   VMMMethod "\<get_ready_for_function_phase\>"
syn match   VMMMethod "\<get_ready_for_phase\>"
syn match   VMMMethod "\<get_real\>"
syn match   VMMMethod "\<get_reason\>"
syn match   VMMMethod "\<get_root_object\>"
syn match   VMMMethod "\<get_scenario_index\>"
syn match   VMMMethod "\<get_scenario_name\>"
syn match   VMMMethod "\<get_sim\>"
syn match   VMMMethod "\<get_stop_on_event\>"
syn match   VMMMethod "\<get_string\>"
syn match   VMMMethod "\<get_tests_to_run\>"
syn match   VMMMethod "\<get_timeline\>"
syn match   VMMMethod "\<get_top_timeline\>"
syn match   VMMMethod "\<get_verbosity\>"
syn match   VMMMethod "\<get_vmm_log\>"
syn match   VMMMethod "\<get_vote\>"
syn match   VMMMethod "\<get_xactor\>"
syn match   VMMMethod "\<grab\>"
syn match   VMMMethod "\<grab_channels\>"
syn match   VMMMethod "\<handling_image\>"
syn match   VMMMethod "\<has_config_done\>"
syn match   VMMMethod "\<help\>"
syn match   VMMMethod "\<hw_reset\>"
syn match   VMMMethod "\<implicit_phasing\>"
syn match   VMMMethod "\<index\>"
syn match   VMMMethod "\<indicate\>"
syn match   VMMMethod "\<inject\>"
syn match   VMMMethod "\<inject_obj\>"
syn match   VMMMethod "\<inp_vmm_sb_ds\>"
syn match   VMMMethod "\<insert_phase\>"
syn match   VMMMethod "\<insert_phase_internal\>"
syn match   VMMMethod "\<is_aborted\>"
syn match   VMMMethod "\<is_above\>"
syn match   VMMMethod "\<is_active\>"
syn match   VMMMethod "\<is_allowed_new_phases\>"
syn match   VMMMethod "\<is_configured\>"
syn match   VMMMethod "\<is_done\>"
syn match   VMMMethod "\<is_forced\>"
syn match   VMMMethod "\<is_full\>"
syn match   VMMMethod "\<is_function_phase\>"
syn match   VMMMethod "\<is_grabbed\>"
syn match   VMMMethod "\<is_implicitly_phased\>"
syn match   VMMMethod "\<is_in_namespace\>"
syn match   VMMMethod "\<is_locked\>"
syn match   VMMMethod "\<is_not_above\>"
syn match   VMMMethod "\<is_on\>"
syn match   VMMMethod "\<is_parent_of\>"
syn match   VMMMethod "\<is_phase_done\>"
syn match   VMMMethod "\<is_reached\>"
syn match   VMMMethod "\<is_register_consensus\>"
syn match   VMMMethod "\<is_running\>"
syn match   VMMMethod "\<is_skipped\>"
syn match   VMMMethod "\<is_stop_for_phase_set\>"
syn match   VMMMethod "\<is_task_phase\>"
syn match   VMMMethod "\<is_unit_enabled\>"
syn match   VMMMethod "\<is_valid\>"
syn match   VMMMethod "\<is_waited_for\>"
syn match   VMMMethod "\<issue\>"
syn match   VMMMethod "\<jump_child_to_phase\>"
syn match   VMMMethod "\<jump_to_phase\>"
syn match   VMMMethod "\<kill\>"
syn match   VMMMethod "\<kill_object\>"
syn match   VMMMethod "\<kill_voter\>"
syn match   VMMMethod "\<level\>"
syn match   VMMMethod "\<list\>"
syn match   VMMMethod "\<load\>"
syn match   VMMMethod "\<load_save_config\>"
syn match   VMMMethod "\<lock\>"
syn match   VMMMethod "\<log_start\>"
syn match   VMMMethod "\<log_stop\>"
syn match   VMMMethod "\<lookup_scenario\>"
syn match   VMMMethod "\<main\>"
syn match   VMMMethod "\<major\>"
syn match   VMMMethod "\<make_hier_inst_name\>"
syn match   VMMMethod "\<map_name\>"
syn match   VMMMethod "\<map_to_name\>"
syn match   VMMMethod "\<match\>"
syn match   VMMMethod "\<max_byte_size\>"
syn match   VMMMethod "\<minor\>"
syn match   VMMMethod "\<modify\>"
syn match   VMMMethod "\<move_iterator\>"
syn match   VMMMethod "\<ms_scenario_exists\>"
syn match   VMMMethod "\<ms_scenario_gen_exists\>"
syn match   VMMMethod "\<name_and_inst_exists\>"
syn match   VMMMethod "\<nays\>"
syn match   VMMMethod "\<new\>"
syn match   VMMMethod "\<new_output\>"
syn match   VMMMethod "\<new_source\>"
syn match   VMMMethod "\<next\>"
syn match   VMMMethod "\<next_phase\>"
syn match   VMMMethod "\<notify\>"
syn match   VMMMethod "\<notify_request\>"
syn match   VMMMethod "\<observe_single\>"
syn match   VMMMethod "\<open_stream\>"
syn match   VMMMethod "\<open_sub_stream\>"
syn match   VMMMethod "\<oppose\>"
syn match   VMMMethod "\<override_phase\>"
syn match   VMMMethod "\<parse\>"
syn match   VMMMethod "\<parse_opts_file\>"
syn match   VMMMethod "\<pass_or_fail\>"
syn match   VMMMethod "\<patch\>"
syn match   VMMMethod "\<peek\>"
syn match   VMMMethod "\<phase_wait_finish\>"
syn match   VMMMethod "\<playback\>"
syn match   VMMMethod "\<post_randomize\>"
syn match   VMMMethod "\<post_scenario_gen\>"
syn match   VMMMethod "\<power_on_reset\>"
syn match   VMMMethod "\<power_up\>"
syn match   VMMMethod "\<pre_randomize\>"
syn match   VMMMethod "\<pre_scenario_randomize\>"
syn match   VMMMethod "\<pre_test\>"
syn match   VMMMethod "\<prepend_callback\>"
syn match   VMMMethod "\<previous_phase\>"
syn match   VMMMethod "\<print_bindings\>"
syn match   VMMMethod "\<print_hierarchy\>"
syn match   VMMMethod "\<print_tree\>"
syn match   VMMMethod "\<process_catch\>"
syn match   VMMMethod "\<process_cmd\>"
syn match   VMMMethod "\<promote\>"
syn match   VMMMethod "\<psdisplay\>"
syn match   VMMMethod "\<put\>"
syn match   VMMMethod "\<reconfigure\>"
syn match   VMMMethod "\<record\>"
syn match   VMMMethod "\<redefine_scenario\>"
syn match   VMMMethod "\<register_channel\>"
syn match   VMMMethod "\<register_consensus\>"
syn match   VMMMethod "\<register_ms_scenario\>"
syn match   VMMMethod "\<register_ms_scenario_gen\>"
syn match   VMMMethod "\<register_no_notification\>"
syn match   VMMMethod "\<register_notification\>"
syn match   VMMMethod "\<register_object\>"
syn match   VMMMethod "\<register_scenario\>"
syn match   VMMMethod "\<register_unit_consensus\>"
syn match   VMMMethod "\<register_vmm_sb_ds\>"
syn match   VMMMethod "\<register_voter\>"
syn match   VMMMethod "\<register_xactor\>"
syn match   VMMMethod "\<remove\>"
syn match   VMMMethod "\<remove_watchpoint\>"
syn match   VMMMethod "\<remove_xvc\>"
syn match   VMMMethod "\<rename_phase\>"
syn match   VMMMethod "\<replace_channel\>"
syn match   VMMMethod "\<replace_ms_scenario\>"
syn match   VMMMethod "\<replace_ms_scenario_gen\>"
syn match   VMMMethod "\<replace_scenario\>"
syn match   VMMMethod "\<report\>"
syn match   VMMMethod "\<report_ph\>"
syn match   VMMMethod "\<report_unbound\>"
syn match   VMMMethod "\<request\>"
syn match   VMMMethod "\<request_consensus\>"
syn match   VMMMethod "\<reset\>"
syn match   VMMMethod "\<reset_children_to_phase\>"
syn match   VMMMethod "\<reset_done\>"
syn match   VMMMethod "\<reset_dut\>"
syn match   VMMMethod "\<reset_env\>"
syn match   VMMMethod "\<reset_grabbers\>"
syn match   VMMMethod "\<reset_message_count\>"
syn match   VMMMethod "\<reset_ph\>"
syn match   VMMMethod "\<reset_running\>"
syn match   VMMMethod "\<reset_to_phase\>"
syn match   VMMMethod "\<reset_xactor\>"
syn match   VMMMethod "\<restart\>"
syn match   VMMMethod "\<restart_test\>"
syn match   VMMMethod "\<restore_rng_state\>"
syn match   VMMMethod "\<run\>"
syn match   VMMMethod "\<run_function_phase\>"
syn match   VMMMethod "\<run_ph\>"
syn match   VMMMethod "\<run_phase\>"
syn match   VMMMethod "\<run_phase_impl\>"
syn match   VMMMethod "\<run_phase_internal\>"
syn match   VMMMethod "\<run_pre_test_phase\>"
syn match   VMMMethod "\<run_task_phase\>"
syn match   VMMMethod "\<run_tests\>"
syn match   VMMMethod "\<save\>"
syn match   VMMMethod "\<save_config_ph\>"
syn match   VMMMethod "\<save_rng_state\>"
syn match   VMMMethod "\<save_scenario\>"
syn match   VMMMethod "\<scenario_exists\>"
syn match   VMMMethod "\<scenario_name\>"
syn match   VMMMethod "\<sched_from_input\>"
syn match   VMMMethod "\<schedule\>"
syn match   VMMMethod "\<schedule_cycle\>"
syn match   VMMMethod "\<send_opts\>"
syn match   VMMMethod "\<set_abort_done_for_child\>"
syn match   VMMMethod "\<set_bit\>"
syn match   VMMMethod "\<set_child_unit_executed\>"
syn match   VMMMethod "\<set_config\>"
syn match   VMMMethod "\<set_consumer\>"
syn match   VMMMethod "\<set_emit\>"
syn match   VMMMethod "\<set_format\>"
syn match   VMMMethod "\<set_input\>"
syn match   VMMMethod "\<set_instance\>"
syn match   VMMMethod "\<set_int\>"
syn match   VMMMethod "\<set_log\>"
syn match   VMMMethod "\<set_mode\>"
syn match   VMMMethod "\<set_name\>"
syn match   VMMMethod "\<set_notification\>"
syn match   VMMMethod "\<set_object\>"
syn match   VMMMethod "\<set_object_name\>"
syn match   VMMMethod "\<set_output\>"
syn match   VMMMethod "\<set_parent\>"
syn match   VMMMethod "\<set_parent_object\>"
syn match   VMMMethod "\<set_parent_scenario\>"
syn match   VMMMethod "\<set_producer\>"
syn match   VMMMethod "\<set_range\>"
syn match   VMMMethod "\<set_register_consensus\>"
syn match   VMMMethod "\<set_running\>"
syn match   VMMMethod "\<set_sc2sv_interop\>"
syn match   VMMMethod "\<set_sev_image\>"
syn match   VMMMethod "\<set_simulation\>"
syn match   VMMMethod "\<set_string\>"
syn match   VMMMethod "\<set_sv2sc_interop\>"
syn match   VMMMethod "\<set_timeout_done_for_child\>"
syn match   VMMMethod "\<set_top_timeline\>"
syn match   VMMMethod "\<set_typ_image\>"
syn match   VMMMethod "\<set_verbosity\>"
syn match   VMMMethod "\<set_wait\>"
syn match   VMMMethod "\<sev_image\>"
syn match   VMMMethod "\<shutdown_ph\>"
syn match   VMMMethod "\<sink\>"
syn match   VMMMethod "\<sink_if_outs\>"
syn match   VMMMethod "\<size\>"
syn match   VMMMethod "\<sneak\>"
syn match   VMMMethod "\<split\>"
syn match   VMMMethod "\<split_hiername\>"
syn match   VMMMethod "\<start\>"
syn match   VMMMethod "\<start_msg\>"
syn match   VMMMethod "\<start_of_sim_ph\>"
syn match   VMMMethod "\<start_of_test_ph\>"
syn match   VMMMethod "\<start_ph\>"
syn match   VMMMethod "\<start_stop_on\>"
syn match   VMMMethod "\<start_tr\>"
syn match   VMMMethod "\<start_xactor\>"
syn match   VMMMethod "\<status\>"
syn match   VMMMethod "\<step_function_phase\>"
syn match   VMMMethod "\<stop\>"
syn match   VMMMethod "\<stop_after_n_errors\>"
syn match   VMMMethod "\<stop_xactor\>"
syn match   VMMMethod "\<sub_consensus\>"
syn match   VMMMethod "\<supports_byte_enable\>"
syn match   VMMMethod "\<sync_sc_phase_with_sv\>"
syn match   VMMMethod "\<sync_sv2sc_interop\>"
syn match   VMMMethod "\<task_phase_timeout\>"
syn match   VMMMethod "\<tblog\>"
syn match   VMMMethod "\<tee\>"
syn match   VMMMethod "\<tee_mode\>"
syn match   VMMMethod "\<terminate_stop_on\>"
syn match   VMMMethod "\<terminated\>"
syn match   VMMMethod "\<text\>"
syn match   VMMMethod "\<this_class_name\>"
syn match   VMMMethod "\<throw\>"
syn match   VMMMethod "\<timestamp\>"
syn match   VMMMethod "\<training_ph\>"
syn match   VMMMethod "\<try_action\>"
syn match   VMMMethod "\<try_covfile\>"
syn match   VMMMethod "\<try_event\>"
syn match   VMMMethod "\<try_execute\>"
syn match   VMMMethod "\<try_grab\>"
syn match   VMMMethod "\<try_interrupt\>"
syn match   VMMMethod "\<try_log\>"
syn match   VMMMethod "\<try_mapevent\>"
syn match   VMMMethod "\<try_peek\>"
syn match   VMMMethod "\<try_scenario\>"
syn match   VMMMethod "\<try_stoponerror\>"
syn match   VMMMethod "\<try_stoponevent\>"
syn match   VMMMethod "\<try_verbosity\>"
syn match   VMMMethod "\<try_xvctrace\>"
syn match   VMMMethod "\<typ_image\>"
syn match   VMMMethod "\<unblock_producer\>"
syn match   VMMMethod "\<uncatch\>"
syn match   VMMMethod "\<uncatch_all\>"
syn match   VMMMethod "\<ungrab\>"
syn match   VMMMethod "\<unlock\>"
syn match   VMMMethod "\<unmodify\>"
syn match   VMMMethod "\<unput\>"
syn match   VMMMethod "\<unregister_all\>"
syn match   VMMMethod "\<unregister_callback\>"
syn match   VMMMethod "\<unregister_channel\>"
syn match   VMMMethod "\<unregister_channel_by_name\>"
syn match   VMMMethod "\<unregister_consensus\>"
syn match   VMMMethod "\<unregister_ms_scenario\>"
syn match   VMMMethod "\<unregister_ms_scenario_by_name\>"
syn match   VMMMethod "\<unregister_ms_scenario_gen\>"
syn match   VMMMethod "\<unregister_ms_scenario_gen_by_name\>"
syn match   VMMMethod "\<unregister_notification\>"
syn match   VMMMethod "\<unregister_object\>"
syn match   VMMMethod "\<unregister_scenario\>"
syn match   VMMMethod "\<unregister_vmm_sb_ds\>"
syn match   VMMMethod "\<unregister_voter\>"
syn match   VMMMethod "\<unregister_xactor\>"
syn match   VMMMethod "\<update_for_current_phase_counter\>"
syn match   VMMMethod "\<update_vote\>"
syn match   VMMMethod "\<update_xactor_notifications\>"
syn match   VMMMethod "\<use_hier_inst_name\>"
syn match   VMMMethod "\<use_orig_inst_name\>"
syn match   VMMMethod "\<uses_hier_inst_name\>"
syn match   VMMMethod "\<vendor\>"
syn match   VMMMethod "\<vmt_hook\>"
syn match   VMMMethod "\<wait_for\>"
syn match   VMMMethod "\<wait_for_child_phase_finish\>"
syn match   VMMMethod "\<wait_for_consensus\>"
syn match   VMMMethod "\<wait_for_end\>"
syn match   VMMMethod "\<wait_for_msg\>"
syn match   VMMMethod "\<wait_for_no_consensus\>"
syn match   VMMMethod "\<wait_for_off\>"
syn match   VMMMethod "\<wait_for_request\>"
syn match   VMMMethod "\<wait_for_run_phase_impl_finish\>"
syn match   VMMMethod "\<wait_for_watchpoint\>"
syn match   VMMMethod "\<wait_if_interrupted\>"
syn match   VMMMethod "\<wait_if_stopped\>"
syn match   VMMMethod "\<wait_if_stopped_or_empty\>"
syn match   VMMMethod "\<wait_object_to_finish_phase\>"
syn match   VMMMethod "\<xactor\>"
syn match   VMMMethod "\<xactor_status\>"
syn match   VMMMethod "\<yeas\>"

" VMM type
syn match   VMMType "\<METHOD_TYPE\>"
syn match   VMMType "\<active_status_e\>"
syn match   VMMType "\<arg_type_e\>"
syn match   VMMType "\<bcast_mode_e\>"
syn match   VMMType "\<do_how_e\>"
syn match   VMMType "\<do_what_e\>"
syn match   VMMType "\<endpoints_e\>"
syn match   VMMType "\<fact_type_e\>"
syn match   VMMType "\<handling_e\>"
syn match   VMMType "\<interop_dir\>"
syn match   VMMType "\<intf_e\>"
syn match   VMMType "\<kind_e\>"
syn match   VMMType "\<m_method_e\>"
syn match   VMMType "\<mode_e\>"
syn match   VMMType "\<namespace_typ_e\>"
syn match   VMMType "\<notifications_e\>"
syn match   VMMType "\<notify_e\>"
syn match   VMMType "\<phase_e\>"
syn match   VMMType "\<reset_e\>"
syn match   VMMType "\<restart_e\>"
syn match   VMMType "\<severities_e\>"
syn match   VMMType "\<src_type_e\>"
syn match   VMMType "\<status_e\>"
syn match   VMMType "\<stdout_e\>"
syn match   VMMType "\<symbols_e\>"
syn match   VMMType "\<sync_e\>"
syn match   VMMType "\<tlm_command\>"
syn match   VMMType "\<tlm_response_status\>"
syn match   VMMType "\<type_e\>"
syn match   VMMType "\<types_e\>"
syn match   VMMType "\<verbosity_e\>"


" Base on UVM1.2
" UVM classes with wildcard
syn match   UVMClassSeries "\<uvm_\w\+_export\>"
syn match   UVMClassSeries "\<uvm_\w\+_imp\>"
syn match   UVMClassSeries "\<uvm_\w\+_port\>"

" UVM classes
syn keyword UVMClass uvm_agent
syn keyword UVMClass uvm_algorithmic_comparator
syn keyword UVMClass uvm_analysis_export
syn keyword UVMClass uvm_analysis_imp
syn keyword UVMClass uvm_analysis_port
syn keyword UVMClass uvm_barrier
syn keyword UVMClass uvm_bottom_up_visitor_adapter
syn keyword UVMClass uvm_bottomup_phase
syn keyword UVMClass uvm_build_phase
syn keyword UVMClass uvm_built_in_clone
syn keyword UVMClass uvm_built_in_comp
syn keyword UVMClass uvm_built_in_converter
syn keyword UVMClass uvm_built_in_pair
syn keyword UVMClass uvm_by_level_visitor_adapter
syn keyword UVMClass uvm_callback
syn keyword UVMClass uvm_callback_iter
syn keyword UVMClass uvm_callbacks
syn keyword UVMClass uvm_cause_effect_link
syn keyword UVMClass uvm_check_phase
syn keyword UVMClass UVMClass_clone
syn keyword UVMClass UVMClass_comp
syn keyword UVMClass UVMClass_converter
syn keyword UVMClass UVMClass_pair
syn keyword UVMClass uvm_cmdline_processor
syn keyword UVMClass uvm_comparer
syn keyword UVMClass uvm_component
syn keyword UVMClass uvm_component_name_check_visitor
syn keyword UVMClass uvm_component_proxy
syn keyword UVMClass uvm_component_registry
syn keyword UVMClass uvm_config_db
syn keyword UVMClass uvm_config_db_options
syn keyword UVMClass uvm_configure_phase
syn keyword UVMClass uvm_connect_phase
syn keyword UVMClass uvm_coreservice_t
syn keyword UVMClass uvm_default_coreservice_t
syn keyword UVMClass uvm_default_factory
syn keyword UVMClass uvm_default_report_server
syn keyword UVMClass uvm_domain
syn keyword UVMClass uvm_driver
syn keyword UVMClass uvm_end_of_elaboration_phase
syn keyword UVMClass uvm_enum_wrapper
syn keyword UVMClass uvm_env
syn keyword UVMClass uvm_event
syn keyword UVMClass uvm_event_base
syn keyword UVMClass uvm_event_callback
syn keyword UVMClass uvm_extract_phase
syn keyword UVMClass uvm_factory
syn keyword UVMClass uvm_final_phase
syn keyword UVMClass uvm_get_to_lock_dap
syn keyword UVMClass uvm_hdl_path_concat
syn keyword UVMClass uvm_heartbeat
syn keyword UVMClass uvm_in_order_built_in_comparator
syn keyword UVMClass uvm_in_order_class_comparator
syn keyword UVMClass uvm_in_order_comparator
syn keyword UVMClass uvm_line_printer
syn keyword UVMClass uvm_link_base
syn keyword UVMClass uvm_main_phase
syn keyword UVMClass uvm_mem
syn keyword UVMClass uvm_mem_access_seq
syn keyword UVMClass uvm_mem_mam
syn keyword UVMClass uvm_mem_mam_cfg
syn keyword UVMClass uvm_mem_mam_policy
syn keyword UVMClass uvm_mem_region
syn keyword UVMClass uvm_mem_shared_access_seq
syn keyword UVMClass uvm_mem_single_access_seq
syn keyword UVMClass uvm_mem_single_walk_seq
syn keyword UVMClass uvm_mem_walk_seq
syn keyword UVMClass uvm_monitor
syn keyword UVMClass uvm_object
syn keyword UVMClass uvm_object_registry
syn keyword UVMClass uvm_object_string_pool
syn keyword UVMClass uvm_object_wrapper
syn keyword UVMClass uvm_objection
syn keyword UVMClass uvm_objection_callback
syn keyword UVMClass uvm_packer
syn keyword UVMClass uvm_parent_child_link
syn keyword UVMClass uvm_phase
syn keyword UVMClass uvm_phase_cb
syn keyword UVMClass uvm_phase_cb_pool
syn keyword UVMClass uvm_phase_state_change
syn keyword UVMClass uvm_pool
syn keyword UVMClass uvm_port_base
syn keyword UVMClass uvm_port_component
syn keyword UVMClass uvm_port_component_base
syn keyword UVMClass uvm_post_configure_phase
syn keyword UVMClass uvm_post_main_phase
syn keyword UVMClass uvm_post_reset_phase
syn keyword UVMClass uvm_post_shutdown_phase
syn keyword UVMClass uvm_pre_configure_phase
syn keyword UVMClass uvm_pre_main_phase
syn keyword UVMClass uvm_pre_reset_phase
syn keyword UVMClass uvm_pre_shutdown_phase
syn keyword UVMClass uvm_printer
syn keyword UVMClass uvm_printer_knobs
syn keyword UVMClass uvm_push_driver
syn keyword UVMClass uvm_push_sequencer
syn keyword UVMClass uvm_queue
syn keyword UVMClass uvm_random_stimulus
syn keyword UVMClass uvm_recorder
syn keyword UVMClass uvm_reg
syn keyword UVMClass uvm_reg_access_seq
syn keyword UVMClass uvm_reg_adapter
syn keyword UVMClass uvm_reg_backdoor
syn keyword UVMClass uvm_reg_bit_bash_seq
syn keyword UVMClass uvm_reg_block
syn keyword UVMClass uvm_reg_bus_op
syn keyword UVMClass uvm_reg_cbs
syn keyword UVMClass uvm_reg_field
syn keyword UVMClass uvm_reg_fifo
syn keyword UVMClass uvm_reg_file
syn keyword UVMClass uvm_reg_frontdoor
syn keyword UVMClass uvm_reg_hw_reset_seq
syn keyword UVMClass uvm_reg_indirect_data
syn keyword UVMClass uvm_reg_item
syn keyword UVMClass uvm_reg_map
syn keyword UVMClass uvm_reg_mem_access_seq
syn keyword UVMClass uvm_reg_mem_built_in_seq
syn keyword UVMClass uvm_reg_mem_hdl_paths_seq
syn keyword UVMClass uvm_reg_mem_shared_access_seq
syn keyword UVMClass uvm_reg_predictor
syn keyword UVMClass uvm_reg_read_only_cbs
syn keyword UVMClass uvm_reg_sequence
syn keyword UVMClass uvm_reg_shared_access_seq
syn keyword UVMClass uvm_reg_single_access_seq
syn keyword UVMClass uvm_reg_single_bit_bash_seq
syn keyword UVMClass uvm_reg_tlm_adapter
syn keyword UVMClass uvm_reg_transaction_order_policy
syn keyword UVMClass uvm_reg_write_only_cbs
syn keyword UVMClass uvm_related_link
syn keyword UVMClass uvm_report_catcher
syn keyword UVMClass uvm_report_handler
syn keyword UVMClass uvm_report_message
syn keyword UVMClass uvm_report_message_element_base
syn keyword UVMClass uvm_report_message_element_container
syn keyword UVMClass uvm_report_message_int_element
syn keyword UVMClass uvm_report_message_object_element
syn keyword UVMClass uvm_report_message_string_element
syn keyword UVMClass uvm_report_object
syn keyword UVMClass uvm_report_phase
syn keyword UVMClass uvm_report_server
syn keyword UVMClass uvm_reset_phase
syn keyword UVMClass uvm_resource
syn keyword UVMClass uvm_resource_base
syn keyword UVMClass uvm_resource_db
syn keyword UVMClass uvm_resource_db_options
syn keyword UVMClass uvm_resource_options
syn keyword UVMClass uvm_resource_pool
syn keyword UVMClass uvm_resource_types
syn keyword UVMClass uvm_root
syn keyword UVMClass uvm_run_phase
syn keyword UVMClass uvm_scoreboard
syn keyword UVMClass uvm_seq_item_pull_export
syn keyword UVMClass uvm_seq_item_pull_imp
syn keyword UVMClass uvm_seq_item_pull_port
syn keyword UVMClass uvm_sequence
syn keyword UVMClass uvm_sequence_base
syn keyword UVMClass uvm_sequence_item
syn keyword UVMClass uvm_sequence_library
syn keyword UVMClass uvm_sequence_library_cfg
syn keyword UVMClass uvm_sequencer
syn keyword UVMClass uvm_sequencer_base
syn keyword UVMClass uvm_sequencer_param_base
syn keyword UVMClass uvm_set_before_get_dap
syn keyword UVMClass uvm_set_get_dap_base
syn keyword UVMClass uvm_shutdown_phase
syn keyword UVMClass uvm_simple_lock_dap
syn keyword UVMClass uvm_sqr_if_base
syn keyword UVMClass uvm_start_of_simulation_phase
syn keyword UVMClass uvm_structure_proxy
syn keyword UVMClass uvm_subscriber
syn keyword UVMClass uvm_table_printer
syn keyword UVMClass uvm_task_phase
syn keyword UVMClass uvm_test
syn keyword UVMClass uvm_text_recorder
syn keyword UVMClass uvm_text_tr_database
syn keyword UVMClass uvm_text_tr_stream
syn keyword UVMClass uvm_tlm_analysis_fifo
syn keyword UVMClass uvm_tlm_b_initiator_socket
syn keyword UVMClass uvm_tlm_b_initiator_socket_base
syn keyword UVMClass uvm_tlm_b_passthrough_initiator_socket
syn keyword UVMClass uvm_tlm_b_passthrough_initiator_socket_base
syn keyword UVMClass uvm_tlm_b_passthrough_target_socket
syn keyword UVMClass uvm_tlm_b_passthrough_target_socket_base
syn keyword UVMClass uvm_tlm_b_target_socket
syn keyword UVMClass uvm_tlm_b_target_socket_base
syn keyword UVMClass uvm_tlm_b_transport_export
syn keyword UVMClass uvm_tlm_b_transport_imp
syn keyword UVMClass uvm_tlm_b_transport_port
syn keyword UVMClass uvm_tlm_extension
syn keyword UVMClass uvm_tlm_extension_base
syn keyword UVMClass uvm_tlm_fifo
syn keyword UVMClass uvm_tlm_fifo_base
syn keyword UVMClass uvm_tlm_generic_payload
syn keyword UVMClass uvm_tlm_gp
syn keyword UVMClass uvm_tlm_if
syn keyword UVMClass uvm_tlm_if_base
syn keyword UVMClass uvm_tlm_nb_initiator_socket
syn keyword UVMClass uvm_tlm_nb_initiator_socket_base
syn keyword UVMClass uvm_tlm_nb_passthrough_initiator_socket
syn keyword UVMClass uvm_tlm_nb_passthrough_initiator_socket_base
syn keyword UVMClass uvm_tlm_nb_passthrough_target_socket
syn keyword UVMClass uvm_tlm_nb_passthrough_target_socket_base
syn keyword UVMClass uvm_tlm_nb_target_socket
syn keyword UVMClass uvm_tlm_nb_target_socket_base
syn keyword UVMClass uvm_tlm_nb_transport_bw_export
syn keyword UVMClass uvm_tlm_nb_transport_bw_imp
syn keyword UVMClass uvm_tlm_nb_transport_bw_port
syn keyword UVMClass uvm_tlm_nb_transport_fw_export
syn keyword UVMClass uvm_tlm_nb_transport_fw_imp
syn keyword UVMClass uvm_tlm_nb_transport_fw_port
syn keyword UVMClass uvm_tlm_req_rsp_channel
syn keyword UVMClass uvm_tlm_time
syn keyword UVMClass uvm_tlm_transport_channel
syn keyword UVMClass uvm_top_down_visitor_adapter
syn keyword UVMClass uvm_topdown_phase
syn keyword UVMClass uvm_tr_database
syn keyword UVMClass uvm_tr_stream
syn keyword UVMClass uvm_transaction
syn keyword UVMClass uvm_tree_printer
syn keyword UVMClass uvm_utils
syn keyword UVMClass uvm_visitor
syn keyword UVMClass uvm_visitor_adapter
syn keyword UVMClass uvm_void
syn keyword UVMClass uvm_vreg
syn keyword UVMClass uvm_vreg_cbs
syn keyword UVMClass uvm_vreg_field
syn keyword UVMClass uvm_vreg_field_cbs

" UVM macros
syn match   UVMMacro "`uvm_add_to_sequence_library\>"
syn match   UVMMacro "`uvm_analysis_imp_decl\>"
syn match   UVMMacro "`uvm_blocking_get_imp_decl\>"
syn match   UVMMacro "`uvm_blocking_get_peek_imp_decl\>"
syn match   UVMMacro "`uvm_blocking_master_imp_decl\>"
syn match   UVMMacro "`uvm_blocking_peek_imp_decl\>"
syn match   UVMMacro "`uvm_blocking_put_imp_decl\>"
syn match   UVMMacro "`uvm_blocking_slave_imp_decl\>"
syn match   UVMMacro "`uvm_blocking_transport_imp_decl\>"
syn match   UVMMacro "`uvm_component_end\>"
syn match   UVMMacro "`uvm_component_param_utils\>"
syn match   UVMMacro "`uvm_component_param_utils_begin\>"
syn match   UVMMacro "`uvm_component_registry\>"
syn match   UVMMacro "`uvm_component_utils\>"
syn match   UVMMacro "`uvm_component_utils_begin\>"
syn match   UVMMacro "`uvm_create\>"
syn match   UVMMacro "`uvm_create_on\>"
syn match   UVMMacro "`uvm_declare_p_sequencer\>"
syn match   UVMMacro "`UVM_DEFAULT_TIMEOUT\>"
syn match   UVMMacro "`uvm_do\>"
syn match   UVMMacro "`uvm_do_callbacks\>"
syn match   UVMMacro "`uvm_do_callbacks_exit_on\>"
syn match   UVMMacro "`uvm_do_obj_callbacks\>"
syn match   UVMMacro "`uvm_do_obj_callbacks_exit_on\>"
syn match   UVMMacro "`uvm_do_on\>"
syn match   UVMMacro "`uvm_do_on_pri\>"
syn match   UVMMacro "`uvm_do_on_pri_with\>"
syn match   UVMMacro "`uvm_do_on_with\>"
syn match   UVMMacro "`uvm_do_pri\>"
syn match   UVMMacro "`uvm_do_pri_with\>"
syn match   UVMMacro "`uvm_do_with\>"
syn match   UVMMacro "`uvm_error\>"
syn match   UVMMacro "`uvm_error_begin\>"
syn match   UVMMacro "`uvm_error_context\>"
syn match   UVMMacro "`uvm_error_context_begin\>"
syn match   UVMMacro "`uvm_error_context_end\>"
syn match   UVMMacro "`uvm_error_end\>"
syn match   UVMMacro "`uvm_fatal\>"
syn match   UVMMacro "`uvm_fatal_begin\>"
syn match   UVMMacro "`uvm_fatal_context\>"
syn match   UVMMacro "`uvm_fatal_context_begin\>"
syn match   UVMMacro "`uvm_fatal_context_end\>"
syn match   UVMMacro "`uvm_fatal_end\>"
syn match   UVMMacro "`uvm_field_aa_int_byte\>"
syn match   UVMMacro "`uvm_field_aa_int_byte_unsigned\>"
syn match   UVMMacro "`uvm_field_aa_int_enumkey\>"
syn match   UVMMacro "`uvm_field_aa_int_int\>"
syn match   UVMMacro "`uvm_field_aa_int_int_unsigned\>"
syn match   UVMMacro "`uvm_field_aa_int_integer\>"
syn match   UVMMacro "`uvm_field_aa_int_integer_unsigned\>"
syn match   UVMMacro "`uvm_field_aa_int_key\>"
syn match   UVMMacro "`uvm_field_aa_int_longint\>"
syn match   UVMMacro "`uvm_field_aa_int_longint_unsigned\>"
syn match   UVMMacro "`uvm_field_aa_int_shortint\>"
syn match   UVMMacro "`uvm_field_aa_int_shortint_unsigned\>"
syn match   UVMMacro "`uvm_field_aa_int_string\>"
syn match   UVMMacro "`uvm_field_aa_object_int\>"
syn match   UVMMacro "`uvm_field_aa_object_string\>"
syn match   UVMMacro "`uvm_field_aa_string_string\>"
syn match   UVMMacro "`uvm_field_array_enum\>"
syn match   UVMMacro "`uvm_field_array_int\>"
syn match   UVMMacro "`uvm_field_array_object\>"
syn match   UVMMacro "`uvm_field_array_string\>"
syn match   UVMMacro "`uvm_field_enum\>"
syn match   UVMMacro "`uvm_field_event\>"
syn match   UVMMacro "`uvm_field_int\>"
syn match   UVMMacro "`uvm_field_object\>"
syn match   UVMMacro "`uvm_field_queue_enum\>"
syn match   UVMMacro "`uvm_field_queue_int\>"
syn match   UVMMacro "`uvm_field_queue_object\>"
syn match   UVMMacro "`uvm_field_queue_string\>"
syn match   UVMMacro "`uvm_field_real\>"
syn match   UVMMacro "`uvm_field_sarray_enum\>"
syn match   UVMMacro "`uvm_field_sarray_int\>"
syn match   UVMMacro "`uvm_field_sarray_object\>"
syn match   UVMMacro "`uvm_field_sarray_string\>"
syn match   UVMMacro "`uvm_field_string\>"
syn match   UVMMacro "`uvm_field_utils_begin\>"
syn match   UVMMacro "`uvm_field_utils_end\>"
syn match   UVMMacro "`uvm_get_imp_decl\>"
syn match   UVMMacro "`uvm_get_peek_imp_decl\>"
syn match   UVMMacro "`uvm_info\>"
syn match   UVMMacro "`uvm_info_begin\>"
syn match   UVMMacro "`uvm_info_context\>"
syn match   UVMMacro "`uvm_info_context_begin\>"
syn match   UVMMacro "`uvm_info_context_end\>"
syn match   UVMMacro "`uvm_info_end\>"
syn match   UVMMacro "`uvm_master_imp_decl\>"
syn match   UVMMacro "`UVM_MAX_STREAMBITS\>"
syn match   UVMMacro "`uvm_message_add_int\>"
syn match   UVMMacro "`uvm_message_add_object\>"
syn match   UVMMacro "`uvm_message_add_string\>"
syn match   UVMMacro "`uvm_message_add_tag\>"
syn match   UVMMacro "`uvm_nonblocking_get_imp_decl\>"
syn match   UVMMacro "`uvm_nonblocking_get_peek_imp_decl\>"
syn match   UVMMacro "`uvm_nonblocking_master_imp_decl\>"
syn match   UVMMacro "`uvm_nonblocking_peek_imp_decl\>"
syn match   UVMMacro "`uvm_nonblocking_put_imp_decl\>"
syn match   UVMMacro "`uvm_nonblocking_slave_imp_decl\>"
syn match   UVMMacro "`uvm_nonblocking_transport_imp_decl\>"
syn match   UVMMacro "`uvm_object_param_utils\>"
syn match   UVMMacro "`uvm_object_param_utils_begin\>"
syn match   UVMMacro "`uvm_object_registry\>"
syn match   UVMMacro "`uvm_object_utils\>"
syn match   UVMMacro "`uvm_object_utils_begin\>"
syn match   UVMMacro "`uvm_object_utils_end\>"
syn match   UVMMacro "`uvm_pack_array\>"
syn match   UVMMacro "`uvm_pack_arrayN\>"
syn match   UVMMacro "`uvm_pack_enum\>"
syn match   UVMMacro "`uvm_pack_enumN\>"
syn match   UVMMacro "`uvm_pack_int\>"
syn match   UVMMacro "`uvm_pack_intN\>"
syn match   UVMMacro "`uvm_pack_queue\>"
syn match   UVMMacro "`uvm_pack_queueN\>"
syn match   UVMMacro "`uvm_pack_real\>"
syn match   UVMMacro "`uvm_pack_sarray\>"
syn match   UVMMacro "`uvm_pack_sarrayN\>"
syn match   UVMMacro "`uvm_pack_string\>"
syn match   UVMMacro "`UVM_PACKER_MAX_BYTES\>"
syn match   UVMMacro "`uvm_peek_imp_decl\>"
syn match   UVMMacro "`uvm_put_imp_decl\>"
syn match   UVMMacro "`uvm_rand_send\>"
syn match   UVMMacro "`uvm_rand_send_pri\>"
syn match   UVMMacro "`uvm_rand_send_pri_with\>"
syn match   UVMMacro "`uvm_rand_send_with\>"
syn match   UVMMacro "`uvm_record_attribute\>"
syn match   UVMMacro "`uvm_record_field\>"
syn match   UVMMacro "`uvm_record_int\>"
syn match   UVMMacro "`uvm_record_real\>"
syn match   UVMMacro "`uvm_record_string\>"
syn match   UVMMacro "`uvm_record_time\>"
syn match   UVMMacro "`UVM_REG_ADDR_WIDTH\>"
syn match   UVMMacro "`UVM_REG_BYTENABLE_WIDTH\>"
syn match   UVMMacro "`UVM_REG_CVR_WIDTH\>"
syn match   UVMMacro "`UVM_REG_DATA_WIDTH\>"
syn match   UVMMacro "`uvm_register_cb\>"
syn match   UVMMacro "`uvm_send\>"
syn match   UVMMacro "`uvm_send_pri\>"
syn match   UVMMacro "`uvm_sequence_library_utils\>"
syn match   UVMMacro "`uvm_set_super_type\>"
syn match   UVMMacro "`uvm_slave_imp_decl\>"
syn match   UVMMacro "`UVM_TLM_B_MASK\>"
syn match   UVMMacro "`UVM_TLM_B_TRANSPORT_IMP\>"
syn match   UVMMacro "`UVM_TLM_FUNCTION_ERROR\>"
syn match   UVMMacro "`UVM_TLM_NB_BW_MASK\>"
syn match   UVMMacro "`UVM_TLM_NB_FW_MASK\>"
syn match   UVMMacro "`UVM_TLM_NB_TRANSPORT_BW_IMP\>"
syn match   UVMMacro "`UVM_TLM_NB_TRANSPORT_FW_IMP\>"
syn match   UVMMacro "`UVM_TLM_TASK_ERROR\>"
syn match   UVMMacro "`uvm_transport_imp_decl\>"
syn match   UVMMacro "`uvm_unpack_array\>"
syn match   UVMMacro "`uvm_unpack_arrayN\>"
syn match   UVMMacro "`uvm_unpack_enum\>"
syn match   UVMMacro "`uvm_unpack_enumN\>"
syn match   UVMMacro "`uvm_unpack_int\>"
syn match   UVMMacro "`uvm_unpack_intN\>"
syn match   UVMMacro "`uvm_unpack_queue\>"
syn match   UVMMacro "`uvm_unpack_queueN\>"
syn match   UVMMacro "`uvm_unpack_real\>"
syn match   UVMMacro "`uvm_unpack_sarray\>"
syn match   UVMMacro "`uvm_unpack_sarrayN\>"
syn match   UVMMacro "`uvm_unpack_string\>"
syn match   UVMMacro "`uvm_warning\>"
syn match   UVMMacro "`uvm_warning_begin\>"
syn match   UVMMacro "`uvm_warning_context\>"
syn match   UVMMacro "`uvm_warning_context_begin\>"
syn match   UVMMacro "`uvm_warning_context_end\>"
syn match   UVMMacro "`uvm_warning_end\>"
syn match   UVMMacro "\<UVM_FIX_REV\>"
syn match   UVMMacro "\<UVM_MAJOR_REV\>"
syn match   UVMMacro "\<UVM_MAJOR_REV_1\>"
syn match   UVMMacro "\<UVM_MINOR_REV\>"
syn match   UVMMacro "\<UVM_MINOR_REV_2\>"
syn match   UVMMacro "\<UVM_NAME\>"
syn match   UVMMacro "\<UVM_POST_VERSION_1_1\>"
syn match   UVMMacro "\<uvm_sequence_library_utils\>"
syn match   UVMMacro "\<UVM_VERSION_1_2\>"
syn match   UVMMacro "\<UVM_VERSION_STRING\>"

" UVM method
syn match   UVMMethod "\<Connect\>"
syn match   UVMMethod "\<accept\>"
syn match   UVMMethod "\<accept_tr\>"
syn match   UVMMethod "\<add\>"
syn match   UVMMethod "\<add_by_name\>"
syn match   UVMMethod "\<add_callback\>"
syn match   UVMMethod "\<add_coverage\>"
syn match   UVMMethod "\<add_hdl_path\>"
syn match   UVMMethod "\<add_hdl_path_slice\>"
syn match   UVMMethod "\<add_int\>"
syn match   UVMMethod "\<add_mem\>"
syn match   UVMMethod "\<add_object\>"
syn match   UVMMethod "\<add_path\>"
syn match   UVMMethod "\<add_reg\>"
syn match   UVMMethod "\<add_sequence\>"
syn match   UVMMethod "\<add_sequences\>"
syn match   UVMMethod "\<add_slice\>"
syn match   UVMMethod "\<add_string\>"
syn match   UVMMethod "\<add_submap\>"
syn match   UVMMethod "\<add_typewide_sequence\>"
syn match   UVMMethod "\<add_typewide_sequences\>"
syn match   UVMMethod "\<add_uvm_phases\>"
syn match   UVMMethod "\<adjust_name\>"
syn match   UVMMethod "\<all_dropped\>"
syn match   UVMMethod "\<allocate\>"
syn match   UVMMethod "\<apply_config_settings\>"
syn match   UVMMethod "\<b_transport\>"
syn match   UVMMethod "\<backdoor\>"
syn match   UVMMethod "\<backdoor_read\>"
syn match   UVMMethod "\<backdoor_read_func\>"
syn match   UVMMethod "\<backdoor_watch\>"
syn match   UVMMethod "\<backdoor_write\>"
syn match   UVMMethod "\<begin_child_tr\>"
syn match   UVMMethod "\<begin_tr\>"
syn match   UVMMethod "\<begin_v\>"
syn match   UVMMethod "\<body\>"
syn match   UVMMethod "\<build_coverage\>"
syn match   UVMMethod "\<build_phase\>"
syn match   UVMMethod "\<burst_read\>"
syn match   UVMMethod "\<burst_write\>"
syn match   UVMMethod "\<bus2reg\>"
syn match   UVMMethod "\<callback_mode\>"
syn match   UVMMethod "\<can_get\>"
syn match   UVMMethod "\<can_peek\>"
syn match   UVMMethod "\<can_put\>"
syn match   UVMMethod "\<cancel\>"
syn match   UVMMethod "\<capacity\>"
syn match   UVMMethod "\<catch\>"
syn match   UVMMethod "\<check_config_usage\>"
syn match   UVMMethod "\<check_data_width\>"
syn match   UVMMethod "\<check_phase\>"
syn match   UVMMethod "\<clear\>"
syn match   UVMMethod "\<clear_extension\>"
syn match   UVMMethod "\<clear_extensions\>"
syn match   UVMMethod "\<clear_hdl_path\>"
syn match   UVMMethod "\<clear_response_queue\>"
syn match   UVMMethod "\<clone\>"
syn match   UVMMethod "\<close\>"
syn match   UVMMethod "\<close_db\>"
syn match   UVMMethod "\<compare\>"
syn match   UVMMethod "\<compare_field\>"
syn match   UVMMethod "\<compare_field_int\>"
syn match   UVMMethod "\<compare_field_real\>"
syn match   UVMMethod "\<compare_object\>"
syn match   UVMMethod "\<compare_string\>"
syn match   UVMMethod "\<compose_report_message\>"
syn match   UVMMethod "\<configure\>"
syn match   UVMMethod "\<configure_phase\>"
syn match   UVMMethod "\<connect\>"
syn match   UVMMethod "\<connect_phase\>"
syn match   UVMMethod "\<convert2string\>"
syn match   UVMMethod "\<copy\>"
syn match   UVMMethod "\<create\>"
syn match   UVMMethod "\<create_component\>"
syn match   UVMMethod "\<create_component_by_name\>"
syn match   UVMMethod "\<create_component_by_type\>"
syn match   UVMMethod "\<create_item\>"
syn match   UVMMethod "\<create_map\>"
syn match   UVMMethod "\<create_object\>"
syn match   UVMMethod "\<create_object_by_name\>"
syn match   UVMMethod "\<create_object_by_type\>"
syn match   UVMMethod "\<current_grabber\>"

" UVM types
syn match   UVMType "\<alloc_mode_e\>"
syn match   UVMType "\<locality_e\>"
syn match   UVMType "\<uvm_access_e\>"
syn match   UVMType "\<uvm_action\>"
syn match   UVMType "\<uvm_active_passive_enum\>"
syn match   UVMType "\<uvm_bitstream_t\>"
syn match   UVMType "\<uvm_check_e\>"
syn match   UVMType "\<uvm_coverage_model_e\>"
syn match   UVMType "\<uvm_elem_kind_e\>"
syn match   UVMType "\<uvm_endianness_e\>"
syn match   UVMType "\<uvm_hdl_path_slice\>"
syn match   UVMType "\<uvm_hier_e\>"
syn match   UVMType "\<uvm_integral_t\>"
syn match   UVMType "\<uvm_mem_cb\>"
syn match   UVMType "\<uvm_mem_cb_iter\>"
syn match   UVMType "\<uvm_objection_event\>"
syn match   UVMType "\<uvm_path_e\>"
syn match   UVMType "\<uvm_phase_state\>"
syn match   UVMType "\<uvm_phase_type\>"
syn match   UVMType "\<uvm_port_type_e\>"
syn match   UVMType "\<uvm_predict_e\>"
syn match   UVMType "\<uvm_radix_enum\>"
syn match   UVMType "\<uvm_recursion_policy_enum\>"
syn match   UVMType "\<uvm_reg_addr_logic_t\>"
syn match   UVMType "\<uvm_reg_addr_t\>"
syn match   UVMType "\<uvm_reg_bd_cb\>"
syn match   UVMType "\<uvm_reg_bd_cb_iter\>"
syn match   UVMType "\<uvm_reg_byte_en_t\>"
syn match   UVMType "\<uvm_reg_cb\>"
syn match   UVMType "\<uvm_reg_cb_iter\>"
syn match   UVMType "\<uvm_reg_cvr_t\>"
syn match   UVMType "\<uvm_reg_data_logic_t\>"
syn match   UVMType "\<uvm_reg_data_t\>"
syn match   UVMType "\<uvm_reg_field_cb\>"
syn match   UVMType "\<uvm_reg_field_cb_iter\>"
syn match   UVMType "\<uvm_reg_mem_tests_e\>"
syn match   UVMType "\<uvm_sequence_lib_mode\>"
syn match   UVMType "\<uvm_sequence_state_enum\>"
syn match   UVMType "\<uvm_sequencer_arb_mode\>"
syn match   UVMType "\<uvm_severity\>"
syn match   UVMType "\<uvm_status_e\>"
syn match   UVMType "\<uvm_tlm_command_e\>"
syn match   UVMType "\<uvm_tlm_phase_e\>"
syn match   UVMType "\<uvm_tlm_response_status_e\>"
syn match   UVMType "\<uvm_tlm_sync_e\>"
syn match   UVMType "\<uvm_verbosity\>"
syn match   UVMType "\<uvm_vreg_cb\>"
syn match   UVMType "\<uvm_vreg_cb_iter\>"
syn match   UVMType "\<uvm_vreg_field_cb\>"
syn match   UVMType "\<uvm_vreg_field_cb_iter\>"
syn match   UVMType "\<uvm_wait_op\>"

" UVM Variables
syn match   UVMVariable "\<abstract\>"
syn match   UVMVariable "\<abstractions\>"
syn match   UVMVariable "\<adapter\>"
syn match   UVMVariable "\<addr\>"
syn match   UVMVariable "\<bd_kind\>"
syn match   UVMVariable "\<begin_elements\>"
syn match   UVMVariable "\<begin_event\>"
syn match   UVMVariable "\<big_endian\>"
syn match   UVMVariable "\<bin_radix\>"
syn match   UVMVariable "\<body\>"
syn match   UVMVariable "\<bus_in\>"
syn match   UVMVariable "\<byte_en\>"
syn match   UVMVariable "\<check_type\>"
syn match   UVMVariable "\<data\>"
syn match   UVMVariable "\<dec_radix\>"
syn match   UVMVariable "\<default_alloc\>"
syn match   UVMVariable "\<default_map\>"
syn match   UVMVariable "\<default_path\>"
syn match   UVMVariable "\<default_precedence\>"
syn match   UVMVariable "\<default_radix\>"
syn match   UVMVariable "\<depth\>"
syn match   UVMVariable "\<do_not_randomize\>"
syn match   UVMVariable "\<element\>"
syn match   UVMVariable "\<element_kind\>"
syn match   UVMVariable "\<enable_print_topology\>"
syn match   UVMVariable "\<enable_report_id_count_summary\>"
syn match   UVMVariable "\<end_elements\>"
syn match   UVMVariable "\<end_event\>"
syn match   UVMVariable "\<end_offset\>"
syn match   UVMVariable "\<events\>"
syn match   UVMVariable "\<extension\>"
syn match   UVMVariable "\<fifo\>"
syn match   UVMVariable "\<finish_on_completion\>"
syn match   UVMVariable "\<fname\>"
syn match   UVMVariable "\<footer\>"
syn match   UVMVariable "\<full_name\>"
syn match   UVMVariable "\<header\>"
syn match   UVMVariable "\<hex_radix\>"
syn match   UVMVariable "\<identifier\>"
syn match   UVMVariable "\<in_use\>"
syn match   UVMVariable "\<indent\>"
syn match   UVMVariable "\<kind\>"
syn match   UVMVariable "\<knobs\>"
syn match   UVMVariable "\<len\>"
syn match   UVMVariable "\<lineno\>"
syn match   UVMVariable "\<local_map\>"
syn match   UVMVariable "\<locality\>"
syn match   UVMVariable "\<m_address\>"
syn match   UVMVariable "\<m_byte_enable\>"
syn match   UVMVariable "\<m_byte_enable_length\>"
syn match   UVMVariable "\<m_command\>"
syn match   UVMVariable "\<m_data\>"
syn match   UVMVariable "\<m_dmi\>"
syn match   UVMVariable "\<m_length\>"
syn match   UVMVariable "\<m_response_status\>"
syn match   UVMVariable "\<m_streaming_width\>"
syn match   UVMVariable "\<mam\>"
syn match   UVMVariable "\<map\>"
syn match   UVMVariable "\<max_offset\>"
syn match   UVMVariable "\<max_random_count\>"
syn match   UVMVariable "\<mcd\>"
syn match   UVMVariable "\<mem\>"
syn match   UVMVariable "\<mem_seq\>"
syn match   UVMVariable "\<min_offset\>"
syn match   UVMVariable "\<min_random_count\>"
syn match   UVMVariable "\<miscompares\>"
syn match   UVMVariable "\<mode\>"
syn match   UVMVariable "\<model\>"
syn match   UVMVariable "\<n_bits\>"
syn match   UVMVariable "\<n_bytes\>"
syn match   UVMVariable "\<new\>"
syn match   UVMVariable "\<oct_radix\>"
syn match   UVMVariable "\<offset\>"
syn match   UVMVariable "\<parent\>"
syn match   UVMVariable "\<parent_sequence\>"
syn match   UVMVariable "\<path\>"
syn match   UVMVariable "\<physical\>"
syn match   UVMVariable "\<policy\>"
syn match   UVMVariable "\<precedence\>"
syn match   UVMVariable "\<prefix\>"
syn match   UVMVariable "\<print_config_matches\>"
syn match   UVMVariable "\<print_enabled\>"
syn match   UVMVariable "\<prior\>"
syn match   UVMVariable "\<provides_responses\>"
syn match   UVMVariable "\<record_all_messages\>"
syn match   UVMVariable "\<recursion_policy\>"
syn match   UVMVariable "\<reference\>"
syn match   UVMVariable "\<reg_ap\>"
syn match   UVMVariable "\<reg_seq\>"
syn match   UVMVariable "\<reg_seqr\>"
syn match   UVMVariable "\<req\>"
syn match   UVMVariable "\<result\>"
syn match   UVMVariable "\<rg\>"
syn match   UVMVariable "\<rsp\>"
syn match   UVMVariable "\<rw_info\>"
syn match   UVMVariable "\<select_rand\>"
syn match   UVMVariable "\<select_randc\>"
syn match   UVMVariable "\<selection_mode\>"
syn match   UVMVariable "\<separator\>"
syn match   UVMVariable "\<seq_item_export\>"
syn match   UVMVariable "\<sequence_count\>"
syn match   UVMVariable "\<sequencer\>"
syn match   UVMVariable "\<sequences_executed\>"
syn match   UVMVariable "\<sev\>"
syn match   UVMVariable "\<show_max\>"
syn match   UVMVariable "\<show_radix\>"
syn match   UVMVariable "\<show_root\>"
syn match   UVMVariable "\<show_terminator\>"
syn match   UVMVariable "\<show_verbosity\>"
syn match   UVMVariable "\<size\>"
syn match   UVMVariable "\<slices\>"
syn match   UVMVariable "\<start_offset\>"
syn match   UVMVariable "\<status\>"
syn match   UVMVariable "\<supports_byte_enable\>"
syn match   UVMVariable "\<T1 first\>"
syn match   UVMVariable "\<T2 second\>"
syn match   UVMVariable "\<tests\>"
syn match   UVMVariable "\<top_levels\>"
syn match   UVMVariable "\<tr_database\>"
syn match   UVMVariable "\<type_name\>"
syn match   UVMVariable "\<unsigned_radix\>"
syn match   UVMVariable "\<use_metadata\>"
syn match   UVMVariable "\<use_uvm_seeding\>"
syn match   UVMVariable "\<uvm_default_comparer\>"
syn match   UVMVariable "\<uvm_default_line_printer\>"
syn match   UVMVariable "\<uvm_default_packer\>"
syn match   UVMVariable "\<uvm_default_printer\>"
syn match   UVMVariable "\<uvm_default_table_printer\>"
syn match   UVMVariable "\<uvm_default_tree_printer\>"
syn match   UVMVariable "\<UVM_HDL_MAX_WIDTH\>"
syn match   UVMVariable "\<uvm_top\>"
syn match   UVMVariable "\<value\>"
syn match   UVMVariable "\<verbosity\>"

" UVM constant
syn match   UVMConstant "\<BEGIN_REQ\>"
syn match   UVMConstant "\<BEGIN_RESP\>"
syn match   UVMConstant "\<END_REQ\>"
syn match   UVMConstant "\<END_RESP\>"
syn match   UVMConstant "\<UNINITIALIZED_PHASE\>"
syn match   UVMConstant "\<UVM_ACTIVE\>"
syn match   UVMConstant "\<UVM_ALL_DROPPED\>"
syn match   UVMConstant "\<UVM_BACKDOOR\>"
syn match   UVMConstant "\<UVM_BIG_ENDIAN\>"
syn match   UVMConstant "\<UVM_BIG_FIFO\>"
syn match   UVMConstant "\<UVM_BIN\>"
syn match   UVMConstant "\<UVM_BODY\>"
syn match   UVMConstant "\<UVM_CALL_HOOK\>"
syn match   UVMConstant "\<UVM_CHECK\>"
syn match   UVMConstant "\<UVM_COUNT\>"
syn match   UVMConstant "\<UVM_CREATED\>"
syn match   UVMConstant "\<UVM_CVR_ADDR_MAP\>"
syn match   UVMConstant "\<UVM_CVR_ALL\>"
syn match   UVMConstant "\<UVM_CVR_FIELD_VALS\>"
syn match   UVMConstant "\<UVM_CVR_REG_BITS\>"
syn match   UVMConstant "\<UVM_DEC\>"
syn match   UVMConstant "\<UVM_DEEP\>"
syn match   UVMConstant "\<UVM_DEFAULT_PATH\>"
syn match   UVMConstant "\<UVM_DISPLAY\>"
syn match   UVMConstant "\<UVM_DO_ALL_REG_MEM_TESTS\>"
syn match   UVMConstant "\<UVM_DO_MEM_ACCESS\>"
syn match   UVMConstant "\<UVM_DO_MEM_WALK\>"
syn match   UVMConstant "\<UVM_DO_REG_ACCESS\>"
syn match   UVMConstant "\<UVM_DO_REG_BIT_BASH\>"
syn match   UVMConstant "\<UVM_DO_REG_HW_RESET\>"
syn match   UVMConstant "\<UVM_DO_SHARED_ACCESS\>"
syn match   UVMConstant "\<UVM_DROPPED\>"
syn match   UVMConstant "\<UVM_ENDED\>"
syn match   UVMConstant "\<UVM_ENUM\>"
syn match   UVMConstant "\<UVM_EQ\>"
syn match   UVMConstant "\<UVM_ERROR\>"
syn match   UVMConstant "\<UVM_EXIT\>"
syn match   UVMConstant "\<UVM_EXPORT\>"
syn match   UVMConstant "\<UVM_FATAL\>"
syn match   UVMConstant "\<UVM_FIELD\>"
syn match   UVMConstant "\<UVM_FINISHED\>"
syn match   UVMConstant "\<UVM_FRONTDOOR\>"
syn match   UVMConstant "\<UVM_FULL\>"
syn match   UVMConstant "\<UVM_GT\>"
syn match   UVMConstant "\<UVM_GTE\>"
syn match   UVMConstant "\<UVM_HAS_X\>"
syn match   UVMConstant "\<UVM_HEX\>"
syn match   UVMConstant "\<UVM_HIER\>"
syn match   UVMConstant "\<UVM_HIGH\>"
syn match   UVMConstant "\<UVM_IMPLEMENTATION\>"
syn match   UVMConstant "\<UVM_INFO\>"
syn match   UVMConstant "\<UVM_IS_OK\>"
syn match   UVMConstant "\<UVM_LITTLE_ENDIAN\>"
syn match   UVMConstant "\<UVM_LITTLE_FIFO\>"
syn match   UVMConstant "\<UVM_LOG\>"
syn match   UVMConstant "\<UVM_LOW\>"
syn match   UVMConstant "\<UVM_LT\>"
syn match   UVMConstant "\<UVM_LTE\>"
syn match   UVMConstant "\<UVM_MEDIUM\>"
syn match   UVMConstant "\<UVM_MEM\>"
syn match   UVMConstant "\<UVM_NE\>"
syn match   UVMConstant "\<UVM_NO_ACTION\>"
syn match   UVMConstant "\<UVM_NO_CHECK\>"
syn match   UVMConstant "\<UVM_NO_COVERAGE\>"
syn match   UVMConstant "\<UVM_NO_ENDIAN\>"
syn match   UVMConstant "\<UVM_NO_HIER\>"
syn match   UVMConstant "\<UVM_NONE\>"
syn match   UVMConstant "\<UVM_NOT_OK\>"
syn match   UVMConstant "\<UVM_OCT\>"
syn match   UVMConstant "\<UVM_PASSIVE\>"
syn match   UVMConstant "\<UVM_PHASE_CLEANUP\>"
syn match   UVMConstant "\<UVM_PHASE_DOMAIN\>"
syn match   UVMConstant "\<UVM_PHASE_DONE\>"
syn match   UVMConstant "\<UVM_PHASE_DORMANT\>"
syn match   UVMConstant "\<UVM_PHASE_ENDED\>"
syn match   UVMConstant "\<UVM_PHASE_EXECUTING\>"
syn match   UVMConstant "\<UVM_PHASE_IMP\>"
syn match   UVMConstant "\<UVM_PHASE_JUMPING\>"
syn match   UVMConstant "\<UVM_PHASE_NODE\>"
syn match   UVMConstant "\<UVM_PHASE_READY_TO_END\>"
syn match   UVMConstant "\<UVM_PHASE_SCHEDULE\>"
syn match   UVMConstant "\<UVM_PHASE_SCHEDULED\>"
syn match   UVMConstant "\<UVM_PHASE_STARTED\>"
syn match   UVMConstant "\<UVM_PHASE_SYNCING\>"
syn match   UVMConstant "\<UVM_PHASE_TERMINAL\>"
syn match   UVMConstant "\<UVM_PHASE_UNINITIALIZED\>"
syn match   UVMConstant "\<UVM_PORT\>"
syn match   UVMConstant "\<UVM_POST_BODY\>"
syn match   UVMConstant "\<UVM_POST_START\>"
syn match   UVMConstant "\<UVM_PRE_BODY\>"
syn match   UVMConstant "\<UVM_PRE_START\>"
syn match   UVMConstant "\<UVM_PREDICT\>"
syn match   UVMConstant "\<UVM_PREDICT_DIRECT\>"
syn match   UVMConstant "\<UVM_PREDICT_READ\>"
syn match   UVMConstant "\<UVM_PREDICT_WRITE\>"
syn match   UVMConstant "\<UVM_RAISED\>"
syn match   UVMConstant "\<UVM_READ\>"
syn match   UVMConstant "\<UVM_REAL\>"
syn match   UVMConstant "\<UVM_REAL_DEC\>"
syn match   UVMConstant "\<UVM_REAL_EXP\>"
syn match   UVMConstant "\<UVM_REFERENCE\>"
syn match   UVMConstant "\<UVM_REG\>"
syn match   UVMConstant "\<UVM_RM_RECORD\>"
syn match   UVMConstant "\<UVM_SEQ_ARB_FIFO\>"
syn match   UVMConstant "\<UVM_SEQ_ARB_RANDOM\>"
syn match   UVMConstant "\<UVM_SEQ_ARB_STRICT_FIFO\>"
syn match   UVMConstant "\<UVM_SEQ_ARB_STRICT_RANDOM\>"
syn match   UVMConstant "\<UVM_SEQ_ARB_USER\>"
syn match   UVMConstant "\<UVM_SEQ_ARB_WEIGHTED\>"
syn match   UVMConstant "\<UVM_SEQ_LIB_ITEM\>"
syn match   UVMConstant "\<UVM_SEQ_LIB_RAND\>"
syn match   UVMConstant "\<UVM_SEQ_LIB_RANDC\>"
syn match   UVMConstant "\<UVM_SEQ_LIB_USER\>"
syn match   UVMConstant "\<UVM_SHALLOW\>"
syn match   UVMConstant "\<UVM_STOP\>"
syn match   UVMConstant "\<UVM_STOPPED\>"
syn match   UVMConstant "\<UVM_STRING\>"
syn match   UVMConstant "\<UVM_TIME\>"
syn match   UVMConstant "\<UVM_TLM_ACCEPTED\>"
syn match   UVMConstant "\<UVM_TLM_ADDRESS_ERROR_RESPONSE\>"
syn match   UVMConstant "\<UVM_TLM_BURST_ERROR_RESPONSE\>"
syn match   UVMConstant "\<UVM_TLM_BYTE_ENABLE_ERROR_RESPONSE\>"
syn match   UVMConstant "\<UVM_TLM_COMMAND_ERROR_RESPONSE\>"
syn match   UVMConstant "\<UVM_TLM_COMPLETED\>"
syn match   UVMConstant "\<UVM_TLM_GENERIC_ERROR_RESPONSE\>"
syn match   UVMConstant "\<UVM_TLM_IGNORE_COMMAND\>"
syn match   UVMConstant "\<UVM_TLM_INCOMPLETE_RESPONSE\>"
syn match   UVMConstant "\<UVM_TLM_OK_RESPONSE\>"
syn match   UVMConstant "\<UVM_TLM_READ_COMMAND\>"
syn match   UVMConstant "\<UVM_TLM_UPDATED\>"
syn match   UVMConstant "\<UVM_TLM_WRITE_COMMAND\>"
syn match   UVMConstant "\<UVM_UNFORMAT2\>"
syn match   UVMConstant "\<UVM_UNFORMAT4\>"
syn match   UVMConstant "\<UVM_UNSIGNED\>"
syn match   UVMConstant "\<UVM_WARNING\>"
syn match   UVMConstant "\<UVM_WRITE\>"

" UVM port
syn match   UVMPort "\<after_export\>"
syn match   UVMPort "\<analysis_export\>"
syn match   UVMPort "\<analysis_export\>"
syn match   UVMPort "\<before_export\>"
syn match   UVMPort "\<blocking_put_port\>"
syn match   UVMPort "\<get_ap\>"
syn match   UVMPort "\<get_peek_export\>"
syn match   UVMPort "\<get_peek_request_export\>"
syn match   UVMPort "\<get_peek_response_export\>"
syn match   UVMPort "\<master_export\>"
syn match   UVMPort "\<pair_ap\>"
syn match   UVMPort "\<put_ap\>"
syn match   UVMPort "\<put_export\>"
syn match   UVMPort "\<put_request_export\>"
syn match   UVMPort "\<put_response_export\>"
syn match   UVMPort "\<req_export\>"
syn match   UVMPort "\<req_port\>"
syn match   UVMPort "\<request_ap\>"
syn match   UVMPort "\<response_ap\>"
syn match   UVMPort "\<rsp_export\>"
syn match   UVMPort "\<rsp_port\>"
syn match   UVMPort "\<seq_item_port\>"
syn match   UVMPort "\<slave_export\>"
syn match   UVMPort "\<transport_export\>"

" UVM Root Method
syn match   UVMRootMethod "\<die\>"
syn match   UVMRootMethod "\<enable_print_topology\>"
syn match   UVMRootMethod "\<find\>"
syn match   UVMRootMethod "\<find_all\>"
syn match   UVMRootMethod "\<finish_on_completion\>"
syn match   UVMRootMethod "\<get\>"
syn match   UVMRootMethod "\<print_topology\>"
syn match   UVMRootMethod "\<run_test\>"
syn match   UVMRootMethod "\<set_timeout\>"
syn match   UVMRootMethod "\<top_levels\>"
syn match   UVMRootMethod "\<uvm_top\>"

" Modify the following as needed.  The trade-off is performance versus functionality.
syn sync lines=80

" Define the default highlighting.
" For version 5.7 and earlier: only when not done already
" For version 5.8 and later: only when an item doesn't have highlighting yet
if version >= 508 || !exists("did_systemverilog_syn_inits")
    if version < 508
        let did_systemverilog_syn_inits = 1
        command -nargs=+ HiLink hi link <args>
    else
        command -nargs=+ HiLink hi def link <args>
    endif

    " The default highlighting.
    hi link systemverilogCharacter       Character
    hi link systemverilogConditional     Conditional
    hi link systemverilogRepeat          Repeat
    hi link systemverilogString          String
    hi link systemverilogTodo            Todo
    hi link systemverilogComment         Comment
    hi link systemverilogConstant        Constant
    hi link systemverilogLabel           Label
    hi link systemverilogNumber          Number
    hi link systemverilogOperator        Special
    hi link systemverilogStatement       Statement
    hi link systemverilogGlobal          Define
    hi link systemverilogDirective       SpecialComment
    hi link systemverilogEscape          Special
    hi link systemverilog1800Keyword     Keyword
    hi link systemverilog1800Systemtask  Function
    hi link VMMClassSeries               Structure
    hi link VMMClass                     Structure
    hi link VMMMacro                     Define
    hi link VMMMethod                    Function
    hi link VMMType                      Type
    hi link UVMClassSeries               Structure
    hi link UVMClass                     Structure
    hi link UVMMacro                     Define
    hi link UVMMethod                    Function
    hi link UVMType                      Type
    hi link UVMVariable                  Identifier
    hi link UVMConstant                  Constant
    hi link UVMPort                      Keyword
    hi link UVMRootMethod                Delimiter

    delcommand HiLink
endif

let b:current_syntax = "uvm"

" vim: ts=4
