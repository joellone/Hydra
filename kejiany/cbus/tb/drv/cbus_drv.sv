`ifndef CBUS_DRV_SV
`define CBUS_DRV_SV

import uvm_pkg::*;
`include "uvm_macros.svh"
`include "transaction/cbus_xct.sv"
`include "registers/regReadWrite.sv"

class cbus_drv extends uvm_driver #(cbus_xct);
    `uvm_component_utils(cbus_drv)
    virtual cbus_if  vif_cbus_if ;
    mailbox mbx_cbus_drv;

    function new (string name = "cbus_drv", uvm_component parent = null) ;
        super.new(name, parent);
    endfunction

    extern function void mbx_connect(mailbox input_mbx);
    extern virtual function void build_phase(uvm_phase phase);
    extern virtual task main_phase(uvm_phase phase) ;
    extern virtual task send_one_pkt(ref cbus_xct pkt);
endclass

function void cbus_drv::mbx_connect(mailbox input_mbx);
    mbx_cbus_drv = input_mbx ;
endfunction

function void cbus_drv::build_phase(uvm_phase phase);
    super.build_phase(phase);
    //`uvm_info("cbus_drv", "building...", UVM_LOW);
    //$display ("%s", get_full_name());
    if (!uvm_config_db#(virtual cbus_if)::get(this, "", "vif_cbus_if", vif_cbus_if))
    begin
        `uvm_fatal("cbus_drv", "virtual interface must be set for vif_xgmii_ingress")
    end
endfunction

task cbus_drv::main_phase(uvm_phase phase);
    regReadWrite ins_regReadWrite ;

    `uvm_info("cbus_drv", "CBUS start...", UVM_LOW);
    vif_cbus_if.rw      <= 1'b0 ; 
    vif_cbus_if.req     <= 1'b0 ;
    vif_cbus_if.addr    <= 'h0  ;
    vif_cbus_if.wdata   <= 'h0  ;

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

task cbus_drv::send_one_pkt(ref cbus_xct pkt);
    if (pkt == null)
    begin
        @(posedge vif_cbus_if.i_clk) ;
        return ;
    end

    if (pkt.rw == 1'b0)
    begin
        @(posedge vif_cbus_if.i_clk) ;
        //pkt.display();
        vif_cbus_if.req   <= 1'b1       ;
        vif_cbus_if.rw    <= 1'b0       ;
        vif_cbus_if.addr  <= pkt.addr   ;
        vif_cbus_if.wdata <= pkt.wdata  ;
        while (1)
        begin
            if (vif_cbus_if.ack == 1'b1)
            begin
                break ;
            end
            @(posedge vif_cbus_if.i_clk) ;
            vif_cbus_if.req <= 1'b0 ;
        end
    end
    else
    begin
        @(posedge vif_cbus_if.i_clk) ;
        vif_cbus_if.req  <= 1'b1      ;
        vif_cbus_if.rw   <= 1'b1      ;
        vif_cbus_if.addr <= pkt.addr  ;
        while (1)
        begin
            if (vif_cbus_if.ack == 1'b1)
            begin
                pkt.rdata = vif_cbus_if.rdata ;
                //mbx_cbus_drv.put(pkt) ;
                break ;
            end
            @(posedge vif_cbus_if.i_clk) ;
            vif_cbus_if.req <= 1'b0 ;
        end
    end
endtask

`endif

