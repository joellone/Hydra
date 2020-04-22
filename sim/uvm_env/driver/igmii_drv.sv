import uvm_pkg::*;
`include "uvm_macros.svh"
`include "transaction/gcc_packet.sv"

class igmii_drv extends uvm_driver #(gcc_packet);
    `uvm_component_utils(igmii_drv)
    virtual igmii_if  vif_igmii_ingress ;
    //mailbox mbx_igmii_drv;

    function new (string name = "igmii_drv", uvm_component parent = null) ;
        super.new(name, parent);
    endfunction

    //extern function void mbx_connect(mailbox input_mbx);
    extern virtual function void build_phase(uvm_phase phase);
    extern virtual task main_phase(uvm_phase phase) ;
    extern virtual task send_one_pkt(gcc_packet pkt);
endclass

//function void igmii_drv::mbx_connect(mailbox input_mbx);
//    mbx_igmii_drv = input_mbx ;
//endfunction

function void igmii_drv::build_phase(uvm_phase phase);
    super.build_phase(phase);
    //`uvm_info("igmii_drv", "building...", UVM_LOW);
    //$display ("%s", get_full_name());
    if (!uvm_config_db#(virtual igmii_if)::get(this, "", "vif_igmii_ingress", vif_igmii_ingress))
    begin
        `uvm_fatal("igmii_drv", "virtual interface must be set for vif_igmii_ingress")
    end
endfunction

task igmii_drv::main_phase(uvm_phase phase);
    //`uvm_info("igmii_drv", "Initial finished...", UVM_LOW);

    vif_igmii_ingress.clk_en <= 1'b0            ;
    vif_igmii_ingress.dv     <= 1'b0            ;
    vif_igmii_ingress.er     <= 1'b0            ;
    vif_igmii_ingress.d      <= 8'h0            ;

    req = new("req");
    while (1)
    begin
        seq_item_port.try_next_item(req);
        if (req == null)
        begin
            @(posedge vif_igmii_ingress.i_clk) ;
        end
        else
        begin
            //mbx_igmii_drv.put(req);
            send_one_pkt(req);
            seq_item_port.item_done();
        end
    end

endtask

task igmii_drv::send_one_pkt(gcc_packet pkt);
    byte unsigned                                   data_q[]                    ;
    int                                             data_size                   ;

    data_size = pkt.pack_bytes(data_q) / 8 ;

    for (int i=0; i<7; i++) 
    begin
        @(posedge vif_igmii_ingress.i_clk) ;
        vif_igmii_ingress.clk_en <= 1'b1            ;
        vif_igmii_ingress.dv     <= 1'b1            ;
        vif_igmii_ingress.er     <= 1'b0            ;
        vif_igmii_ingress.d      <= 8'h55           ;
    end

    @(posedge vif_igmii_ingress.i_clk) ;
    vif_igmii_ingress.clk_en <= 1'b1                ;
    vif_igmii_ingress.dv     <= 1'b1                ;
    vif_igmii_ingress.er     <= 1'b0                ;
    vif_igmii_ingress.d      <= 8'hD5               ;

    for (int i=0; i<data_size; i++)
    begin
        @(posedge vif_igmii_ingress.i_clk) ;
        vif_igmii_ingress.clk_en <= 1'b1            ;
        vif_igmii_ingress.dv     <= 1'b1            ;
        vif_igmii_ingress.er     <= 1'b0            ;
        vif_igmii_ingress.d      <= data_q[i]       ;
    end

    @(posedge vif_igmii_ingress.i_clk) ;
    vif_igmii_ingress.clk_en <= 1'b1            ;
    vif_igmii_ingress.dv     <= 1'b0            ;
    vif_igmii_ingress.er     <= 1'b0            ;
    vif_igmii_ingress.d      <= 8'h0            ;
endtask

