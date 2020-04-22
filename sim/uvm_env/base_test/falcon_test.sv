//package testcase;

import uvm_pkg::*;
`include "uvm_macros.svh"
`include "env/falcon_env.sv"
`include "common/timer.sv"
`include "testcase/testcase.sv"
`include "rm/add4_rm.sv"
`include "global_variable.sv"

class falcon_test extends uvm_test;
    falcon_env          ins_18p400_env              ;
    testcase            ins_tc                      ;
    int                 seed          = 123456      ;

    `uvm_component_utils(falcon_test) ;

    extern function new (string name = "falcon_test", uvm_component parent = null);
    extern virtual function void build_phase (uvm_phase phase);
    extern virtual function void report_phase (uvm_phase phase);
    extern virtual task main_phase (uvm_phase phase);
endclass

function falcon_test::new (string name = "falcon_test", uvm_component parent = null);
    super.new(name, parent);
    //$display("%s", get_full_name());
    `uvm_info("falcon_test", "g_timer builded...", UVM_LOW);
    g_timer = new();
endfunction

function void falcon_test::build_phase(uvm_phase phase);
    super.build_phase(phase);

    //$display("Random seed: %08d", seed);
    //this.srandom(seed);
    //ins_18p400_env = falcon_env::type_id::create("ins_18p400_env", this);
    `uvm_info("falcon_test", "Falcon_test build start", UVM_LOW);
    ins_18p400_env = new("ins_18p400_env", this) ;
endfunction

task falcon_test::main_phase(uvm_phase phase);
    //`uvm_info("falcon_test", "g_timer start", UVM_LOW);
    //fork
    //    g_timer.tik();
    //join
endtask

function void falcon_test::report_phase(uvm_phase phase);
    uvm_report_server               rpt_server                      ;
    int                             err_num                         ;
    UINT                            aps_chnl                        ;
    int                             j                               ;

    super.report_phase(phase);

    rpt_server = get_report_server();
    err_num = rpt_server.get_severity_count(UVM_ERROR);

    if (seq_tx_hdlc_pkt != scb_rx_gcc_pkt)
    begin
        for (int i=0; i<MAX_GCC_CHNL_NO; i++)
        begin
            g_add4_rm.disp_chnl(i, GCC);
        end
        for (int i=0; i<MAX_EXP_CHNL_NO; i++)
        begin
            g_add4_rm.disp_chnl(i, EXP);
        end

        err_num ++ ;
    end

    if (seq_tx_gcc_pkt != scb_rx_hdlc_pkt)
    begin
        for (int i=0; i<MAX_GCC_CHNL_NO; i++)
        begin
            g_add4_rm.disp_gcc_chnl(i, GCC);
        end
        for (int i=0; i<MAX_EXP_CHNL_NO; i++)
        begin
            g_add4_rm.disp_gcc_chnl(i, EXP);
        end

        err_num ++ ;
    end

    for (int i=0; i<ins_tc.test_chnl_num; i++)
    begin
        aps_chnl = ins_tc.ins_test_chnl[i].aps_chnl ;
        if (scb_rx_aps_chnl[aps_chnl] < ins_tc.aps_test_num)
        begin
            $display ("Channel: %d Send APS packet  : %d, Receive APS packet   : %d", aps_chnl, seq_tx_aps_chnl[aps_chnl], scb_rx_aps_chnl[aps_chnl]);
            err_num ++ ;
        end
    end

    foreach(xfi_latency[j])
    begin
        while (xfi_latency[j].size() > 0)
        begin
            $display("Channel %d latency: %d", j, xfi_latency[j].pop_front());
        end
    end

    if (ins_tc.latency_test_en == 1'b1)
    begin
        $display("MAX latency: %d, MIN latency: %d", max_latency, min_latency);
        if (max_latency > 40_000) 
        begin
            err_num ++ ;
            $display("Latency error, exceed the expect latency: %d", max_latency);
        end
    end

    if (err_num != 0)
    begin
        $display ("=====================================================================");
        $display ("                          SIMULATION FAILED                          ");
        $display ("=====================================================================");
    end
    else
    begin
        $display ("=====================================================================");
        $display ("                          SIMULATION PASSED                          ");
        $display ("=====================================================================");
    end
endfunction

//endpackage
