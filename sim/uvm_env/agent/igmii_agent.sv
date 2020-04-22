import uvm_pkg::*;
`include "uvm_macros.svh"
`include "driver/igmii_drv.sv"
`include "monitor/igmii_monitor.sv"
`include "sequence/igmii_sequencer.sv"

class igmii_agent extends uvm_agent;
    igmii_drv         ins_igmii_drv     ;
    igmii_monitor     ins_igmii_mon     ;
    igmii_sequencer   ins_igmii_seqr    ;
    function new (string name, uvm_component parent);
        super.new(name, parent);
    endfunction

    extern virtual function void build_phase(uvm_phase phase);
    extern virtual function void connect_phase(uvm_phase phase);

    `uvm_component_utils(igmii_agent)
endclass

function void igmii_agent::build_phase(uvm_phase phase);
    super.build_phase(phase);
    //`uvm_info("igmii_agent", "XGMII agent building...", UVM_LOW);
    if (is_active == UVM_ACTIVE)
    begin
        //ins_igmii_seqr    = igmii_sequencer::type_id::create("ins_igmii_seqr", this);
        ins_igmii_seqr  = new;
        ins_igmii_drv   = new("ins_igmii_drv", this);
        ins_igmii_mon   = new("ins_igmii_mon", this);
    end
endfunction

function void igmii_agent::connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    ins_igmii_drv.seq_item_port.connect(ins_igmii_seqr.seq_item_export);
endfunction
