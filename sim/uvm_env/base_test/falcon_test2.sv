package testcase;

import uvm_pkg::*;
`include "uvm_macros.svh"
`include "falcon_test.sv"

class falcon_test2 extends falcon_test;
    //falcon_env ins_18p400_env ;
    `uvm_component_utils(falcon_test2) ;

    function new (string name = "falcon_test2", uvm_component parent = null);
        super.new(name, parent);
    endfunction

    //extern virtual function void build_phase (uvm_phase phase);
    extern virtual function void report_phase (uvm_phase phase);
endclass

//function void falcon_test1::build_phase(uvm_phase phase);
//    super.build_phase(phase);
//
//    ins_18p400_env = falcon_env::type_id::create("ins_18p400_env", this);
//endfunction

function void falcon_test2::report_phase(uvm_phase phase);
    uvm_report_server rpt_server;
    int err_num;
    super.report_phase(phase);

    rpt_server = get_report_server();
    err_num = rpt_server.get_severity_count(UVM_ERROR);

    if (err_num != 0)
    begin
        $display ("=====================================================================");
        $display ("                 FALCON_TEST2 SIMULATION FAILED                      ");
        $display ("=====================================================================");
    end
    else
    begin
        $display ("=====================================================================");
        $display ("                 FALCON_TEST2 SIMULATION PASSED                      ");
        $display ("=====================================================================");
    end
endfunction

endpackage
