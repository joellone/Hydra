`ifndef CLINKH32_XCT
`define CLINKH32_XCT
import uvm_pkg::*;
`include "uvm_macros.svh"
`include "parameter.sv"

class clinkh32_xct extends uvm_sequence_item;
    rand bit                                            rh_wl                                       ;
    rand bit [CPU_IF_AW                     - 1 : 0]    address                                     ;
    rand bit [CPU_IF_DW                     - 1 : 0]    wdata                                       ;
    rand bit [CPU_IF_DW                     - 1 : 0]    rdata                                       ;
         UINT                                           req_act_index                               ;
         UINT                                           ack_act_index                               ;

    `uvm_object_utils_begin(clinkh32_xct)
        `uvm_field_int(rh_wl  , UVM_ALL_ON)
        `uvm_field_int(address, UVM_ALL_ON)
        `uvm_field_int(wdata  , UVM_ALL_ON)
        `uvm_field_int(rdata  , UVM_ALL_ON)
    `uvm_object_utils_end

    function new (string name = "clinkh32_xct") ;
        super.new(name);
        req_act_index = 0 ;
        ack_act_index = 0 ;
    endfunction

    extern virtual function void display ();
endclass

function void clinkh32_xct::display ();
    if (rh_wl == 1'b0)
    begin
        $display ("Write register Address: %08x, Data: %08x", address, wdata) ;
    end
    else
    begin
        $display ("Read register Address: %08x, Data: %08x", address, rdata) ;
    end
endfunction

`endif
