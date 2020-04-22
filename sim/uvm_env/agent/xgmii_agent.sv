import uvm_pkg::*;
`include "uvm_macros.svh"
`include "driver/xgmii_drv.sv"
`include "monitor/xgmii_monitor.sv"
`include "sequence/xgmii_sequencer.sv"

class xgmii_agent extends uvm_agent;
    xgmii_drv           ins_xgmii_drv       ;
    xgmii_monitor       ins_xgmii_mon       ;
    xgmii_sequencer     ins_xgmii_seqr      ;
    string              str_ins_name        ;
    function new (string name, uvm_component parent);
        super.new(name, parent);
        str_ins_name = name;
    endfunction

    extern virtual function void build_phase(uvm_phase phase);
    extern virtual function void connect_phase(uvm_phase phase);

    `uvm_component_utils(xgmii_agent)
endclass

function void xgmii_agent::build_phase(uvm_phase phase);
    string seq_name ;

    super.build_phase(phase);
    //`uvm_info("xgmii_agent", "XGMII agent building...", UVM_LOW);

    seq_name = {str_ins_name, "xgmii_sequencer"} ;

    if (is_active == UVM_ACTIVE)
    begin
        //ins_xgmii_seqr    = xgmii_sequencer::type_id::create("ins_xgmii_seqr", this);
        ins_xgmii_seqr  = new(seq_name, this);
        ins_xgmii_drv   = new("ins_xgmii_drv", this);
        ins_xgmii_mon   = new("ins_xgmii_mon", this);
    end
endfunction

function void xgmii_agent::connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    ins_xgmii_drv.seq_item_port.connect(ins_xgmii_seqr.seq_item_export);
endfunction
