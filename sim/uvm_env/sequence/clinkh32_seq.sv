import uvm_pkg::*;
`include "uvm_macros.svh"
`include "transaction/clinkh32_xct.sv"
`include "registers/readLabCtrl.sv"

//extern readLabCtrl insReadLabCtrl;

class clinkh32_seq extends uvm_sequence #(clinkh32_xct);
    clinkh32_xct    clinkh32_pkt    ;

    function new(string name="clinkh32_seq");
        super.new(name);
    endfunction

    virtual task body ();
        #5us
        repeat (1) begin
            #1us;
            //`uvm_do(clinkh32_pkt) ;
            //clinkh32_pkt = new ("clinkh32_pkt") ;
            //clinkh32_pkt.rh_wl      = 0 ; 
            //clinkh32_pkt.address    = insReadLabCtrl.regList.getMod("flexframer3_ohp").getReg("ohp_rx_enable").address ;
            //clinkh32_pkt.wdata      = 32'h1 ;
            //start_item(clinkh32_pkt);
            //finish_item(clinkh32_pkt);
        end
    endtask

    `uvm_object_utils(clinkh32_seq)
endclass
