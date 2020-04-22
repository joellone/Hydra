import uvm_pkg::*;
`include "uvm_macros.svh"
`include "transaction/gcc_packet.sv"

class igmii_sequencer extends uvm_sequencer #(gcc_packet);
    function new(string name = "igmii_sequencer", uvm_component parent = null);
        super.new(name, parent);
    endfunction

    `uvm_object_utils(igmii_sequencer)
endclass
