package testcase;

import uvm_pkg::*;
`include "uvm_macros.svh"
`include "falcon_test.sv"
`include "sequence/xfi_seq.sv"
`include "sequence/xgmii_seq.sv"
`include "sequence/igmii_seq.sv"
`include "sequence/clinkh32_seq.sv"
`include "testcase/testcase.sv"
`include "rm/flexframer3_rm.sv"

class falcon_test1 extends falcon_test;
    //falcon_env ins_18p400_env ;
    `uvm_component_utils(falcon_test1) ;
    testcase            ins_tc                      ;
    flexframer3_rm      ins_flexframer3_rm          ;

    function new (string name = "falcon_test1", uvm_component parent = null);
        super.new(name, parent);
        $display("%s", get_full_name());
    endfunction

    extern virtual task main_phase (uvm_phase phase);
endclass

task falcon_test1::main_phase(uvm_phase phase);
    xgmii_seq       ins_xgmii_seq_0     ;
    xgmii_seq       ins_xgmii_seq_1     ;
    igmii_seq       ins_igmii_seq       ;
    clinkh32_seq    ins_clinkh32_seq    ;

    phase.raise_objection(this);
    ins_tc = new(1);
    ins_tc.hdlc_test_num = 10 ;
    ins_tc.display();
    ins_flexframer3_rm  = new(ins_tc)   ;

    ins_xgmii_seq_0 = new("ins_xgmii_seq_0", ins_tc, 0);
    ins_xgmii_seq_1 = new("ins_xgmii_seq_1", ins_tc, 1);
    ins_igmii_seq   = new("ins_igmii_seq")  ;
    ins_clinkh32_seq= new("ins_clinkh32_seq");

    fork
        ins_clinkh32_seq.start(ins_18p400_env.ins_clinkh32_agent.ins_clinkh32_seqr);
        ins_flexframer3_rm.flexframer3_init();
        ins_xgmii_seq_0.start(ins_18p400_env.ins_xgmii_agent_0.ins_xgmii_seqr);
        ins_xgmii_seq_1.start(ins_18p400_env.ins_xgmii_agent_1.ins_xgmii_seqr);
        ins_igmii_seq.start(ins_18p400_env.ins_igmii_agent.ins_igmii_seqr);
    join
    $display ("Current time: %d, all sequence finished", g_timer.ns);

    phase.drop_objection(this);
endtask

endpackage
