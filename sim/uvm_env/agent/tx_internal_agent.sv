import uvm_pkg::*;
`include "uvm_macros.svh"
`include "driver/tx_internal_drv.sv"

class tx_internal_agent extends uvm_agent;
    tx_internal_drv ins_tx_internal_drv;
    function new (string name, uvm_component parent);
        super.new(name, parent);
    endfunction

    extern virtual function void build_phase(uvm_phase phase);
    extern virtual function void connect_phase(uvm_phase phase);

    `uvm_component_utils(tx_internal_agent)
endclass

function void tx_internal_agent::build_phase(uvm_phase phase);
    super.build_phase(phase);
    if (is_active == UVM_ACTIVE)
    begin
        ins_tx_internal_drv = new("ins_tx_internal_drv", this);
    end
endfunction

function void tx_internal_agent::connect_phase(uvm_phase phase);
    super.connect_phase(phase);
endfunction
