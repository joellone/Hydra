import uvm_pkg::*;
`include "uvm_macros.svh"
`include "transaction/ohp_eth_pkt_ingress.sv"

class xfi_sequencer extends uvm_sequencer #(ohp_eth_pkt_ingress);
    function new(string name = "xfi_sequencer", uvm_component parent = null);
        super.new(name, parent);
    endfunction

    `uvm_object_utils(xfi_sequencer)
endclass
