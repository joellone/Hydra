import uvm_pkg::*;
`include "uvm_macros.svh"
`include "driver/clinkh32_drv.sv"
`include "sequence/clinkh32_sequencer.sv"

class clinkh32_agent extends uvm_agent;
    clinkh32_drv            ins_clinkh32_drv        ;
    clinkh32_sequencer      ins_clinkh32_seqr       ;
    string                  str_ins_name            ;

    function new (string name, uvm_component parent);
        super.new(name, parent);
        str_ins_name = name;
    endfunction

    extern virtual function void build_phase(uvm_phase phase);
    extern virtual function void connect_phase(uvm_phase phase);

    `uvm_component_utils(clinkh32_agent)
endclass

function void clinkh32_agent::build_phase(uvm_phase phase);
    string seq_name ;

    super.build_phase(phase);
    //`uvm_info("clinkh32_agent", "Clinkh32 agent building...", UVM_LOW);

    seq_name = {str_ins_name, "clinkh32_sequencer"} ;

    if (is_active == UVM_ACTIVE)
    begin
        ins_clinkh32_seqr  = new(seq_name, this);
        ins_clinkh32_drv   = new("ins_clinkh32_drv", this);
    end
endfunction

function void clinkh32_agent::connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    ins_clinkh32_drv.seq_item_port.connect(ins_clinkh32_seqr.seq_item_export);
endfunction
