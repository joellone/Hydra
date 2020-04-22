`ifndef ETHERNET_PACKET
`define ETHERNET_PACKET

import uvm_pkg::*;
`include "uvm_macros.svh"
`include "parameter.sv"

class ethernet_packet extends uvm_sequence_item;
    rand bit [DMAC_W                        - 1 : 0]    dmac                                        ;
    rand bit [SMAC_W                        - 1 : 0]    smac                                        ;
    rand bit [VLAN_W                        - 1 : 0]    vlan                                        ;
    rand bit [TYPE_LEN_W                    - 1 : 0]    length_type                                 ;
    rand byte unsigned                                  payload[]                                   ;

    constraint length   {length_type == 16'h88B7;}
    constraint payload_w{payload.size >= 64; payload.size < 2048;}

    `uvm_object_utils_begin(ethernet_packet)
        `uvm_field_int(dmac          , UVM_ALL_ON)                              
        `uvm_field_int(smac          , UVM_ALL_ON)                              
        `uvm_field_int(length_type   , UVM_ALL_ON)                              
        `uvm_field_array_int(payload , UVM_ALL_ON)
    `uvm_object_utils_end

    function new (string name = "ethernet_packet");
        super.new(name);
    endfunction

    extern virtual function void display ();
endclass

function void ethernet_packet::display ();
    $display("-----------------Ethernet Packet-------------------");
    $display("  Name                          Value              ");
    $display("---------------------------------------------------");
    $display("  DMAC                        : %012x", dmac      );
    $display("  SMAC                        : %012x", smac      );
    $display("  Length Type                 : %08x" , length_type);
    for (int i=0; i<payload.size; i++)
    begin
        if (i / 16 == 0) $write("%04d: ", i/16) ;
        $write("%02x", payload[i]) ;
        if (i % 16 == 15) $write("\n") ;
    end
endfunction

`endif
