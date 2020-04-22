import uvm_pkg::*;
`include "uvm_macros.svh"
`include "driver/xfi_drv.sv"
`include "monitor/xfi_monitor.sv"
`include "sequence/xfi_sequencer.sv"

class xfi_agent extends uvm_agent;
    xfi_drv         ins_xfi_drv     ;
    xfi_monitor     ins_xfi_monitor ;
    xfi_sequencer   ins_xfi_seqr    ;
    function new (string name, uvm_component parent);
        super.new(name, parent);
    endfunction

    extern virtual function void build_phase(uvm_phase phase);
    extern virtual function void connect_phase(uvm_phase phase);

    `uvm_component_utils(xfi_agent)
endclass

function void xfi_agent::build_phase(uvm_phase phase);
    super.build_phase(phase);
    `uvm_info("xfi_agent", "XFI agent building...", UVM_LOW);
    if (is_active == UVM_ACTIVE)
    begin
        //ins_xfi_seqr    = xfi_sequencer::type_id::create("ins_xfi_seqr", this);
        ins_xfi_seqr    = new;
        ins_xfi_drv     = xfi_drv::type_id::create("ins_xfi_drv", this);
        ins_xfi_monitor = xfi_monitor::type_id::create("ins_xfi_monitor", this);
    end
endfunction

function void xfi_agent::connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    ins_xfi_drv.seq_item_port.connect(ins_xfi_seqr.seq_item_export);
endfunction
