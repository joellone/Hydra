import uvm_pkg::*;
`include "uvm_macros.svh"
`include "transaction/clinkh32_xct.sv"

class clinkh32_sequencer extends uvm_sequencer #(clinkh32_xct);
    function new(string name = "clinkh32_sequencer", uvm_component parent = null);
        super.new(name, parent);
    endfunction

    `uvm_object_utils(clinkh32_sequencer)
endclass
