import uvm_pkg::*;
`include "uvm_macros.svh"
`include "transaction/ohb_eth_packet.sv"

class xgmii_sequencer extends uvm_sequencer #(ohb_eth_packet);
    function new(string name = "xgmii_sequencer", uvm_component parent = null);
        super.new(name, parent);
    endfunction

    `uvm_object_utils(xgmii_sequencer)
endclass
