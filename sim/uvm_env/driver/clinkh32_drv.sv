import uvm_pkg::*;
`include "uvm_macros.svh"
`include "transaction/clinkh32_xct.sv"
`include "registers/regReadWrite.sv"

class clinkh32_drv extends uvm_driver #(clinkh32_xct);
    `uvm_component_utils(clinkh32_drv)
    virtual clinkh32_if  vif_clinkh32_if ;
    mailbox mbx_clinkh32_drv;

    function new (string name = "clinkh32_drv", uvm_component parent = null) ;
        super.new(name, parent);
    endfunction

    extern function void mbx_connect(mailbox input_mbx);
    extern virtual function void build_phase(uvm_phase phase);
    extern virtual task main_phase(uvm_phase phase) ;
    extern virtual task send_one_pkt(ref clinkh32_xct pkt);
endclass

function void clinkh32_drv::mbx_connect(mailbox input_mbx);
    mbx_clinkh32_drv = input_mbx ;
endfunction

function void clinkh32_drv::build_phase(uvm_phase phase);
    super.build_phase(phase);
    //`uvm_info("clinkh32_drv", "building...", UVM_LOW);
    //$display ("%s", get_full_name());
    if (!uvm_config_db#(virtual clinkh32_if)::get(this, "", "vif_clinkh32_if", vif_clinkh32_if))
    begin
        `uvm_fatal("clinkh32_drv", "virtual interface must be set for vif_xgmii_ingress")
    end
endfunction

task clinkh32_drv::main_phase(uvm_phase phase);
    regReadWrite ins_regReadWrite ;

    `uvm_info("clinkh32_drv", "Clinkh32 start...", UVM_LOW);
    vif_clinkh32_if.rh_wl   <= 1'b0 ; 
    vif_clinkh32_if.exec    <= 1'b0 ;
    vif_clinkh32_if.address <= 'h0  ;
    vif_clinkh32_if.wr_data <= 'h0  ;

    ins_regReadWrite = new();

    #1us

    req = new("req");
    while (1)
    begin
        #10ns
        req = ins_regReadWrite.getReq() ;
        if (req != null)
        begin
            send_one_pkt(req) ;
            ins_regReadWrite.putAck(req) ;
        end
    end

endtask

task clinkh32_drv::send_one_pkt(ref clinkh32_xct pkt);
    if (pkt == null)
    begin
        @(posedge vif_clinkh32_if.i_clk) ;
        return ;
    end

    if (pkt.rh_wl == 1'b0)
    begin
        @(posedge vif_clinkh32_if.i_clk) ;
        //pkt.display();
        vif_clinkh32_if.exec    <= 1'b1         ;
        vif_clinkh32_if.rh_wl   <= 1'b0         ;
        vif_clinkh32_if.address <= pkt.address  ;
        vif_clinkh32_if.wr_data <= pkt.wdata    ;
        while (1)
        begin
            if (vif_clinkh32_if.op_done == 1'b1)
            begin
                break ;
            end
            @(posedge vif_clinkh32_if.i_clk) ;
            vif_clinkh32_if.exec <= 1'b0 ;
        end
    end
    else
    begin
        @(posedge vif_clinkh32_if.i_clk) ;
        vif_clinkh32_if.exec    <= 1'b1         ;
        vif_clinkh32_if.rh_wl   <= 1'b1         ;
        vif_clinkh32_if.address <= pkt.address  ;
        while (1)
        begin
            if (vif_clinkh32_if.op_done == 1'b1)
            begin
                pkt.rdata = vif_clinkh32_if.rd_data ;
                //mbx_clinkh32_drv.put(pkt) ;
                break ;
            end
            @(posedge vif_clinkh32_if.i_clk) ;
            vif_clinkh32_if.exec <= 1'b0 ;
        end
    end
endtask

