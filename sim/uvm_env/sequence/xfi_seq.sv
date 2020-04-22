import uvm_pkg::*;
`include "uvm_macros.svh"
`include "transaction/ohp_eth_pkt_ingress.sv"

class xfi_seq extends uvm_sequence #(ohp_eth_pkt_ingress);
    ohp_eth_pkt_ingress xfi_ing_pkt ;

    function new(string name="xfi_seq");
        super.new(name);
    endfunction

    virtual task body ();
        #100us
        repeat (10) begin
            #100us;
            `uvm_do(xfi_ing_pkt) ;
        end
    endtask

    `uvm_object_utils(xfi_seq)
endclass
