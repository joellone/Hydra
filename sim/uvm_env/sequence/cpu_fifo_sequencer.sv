import uvm_pkg::*;
`include "uvm_macros.svh"
`include "transaction/gcc_packet.sv"

class cpu_fifo_sequencer extends uvm_sequencer #(gcc_packet);
    function new(string name = "cpu_fifo_sequencer", uvm_component parent = null);
        super.new(name, parent);
    endfunction

    `uvm_object_utils(cpu_fifo_sequencer)
endclass
