import uvm_pkg::*;
`include "uvm_macros.svh"
`include "transaction/ohb_eth_packet.sv"

class xgmii_drv extends uvm_driver #(ohb_eth_packet);
    `uvm_component_utils(xgmii_drv)
    virtual xgmii_if  vif_xgmii_ingress ;
    //mailbox mbx_xgmii_drv;

    function new (string name = "xgmii_drv", uvm_component parent = null) ;
        super.new(name, parent);
    endfunction

    //extern function void mbx_connect(mailbox input_mbx);
    extern virtual function void build_phase(uvm_phase phase);
    extern virtual task main_phase(uvm_phase phase) ;
    extern virtual task send_one_pkt(ohb_eth_packet pkt);
    extern virtual task send_idle();    
    extern virtual task send_start();
    extern virtual task send_end();
endclass

//function void xgmii_drv::mbx_connect(mailbox input_mbx);
//    mbx_xgmii_drv = input_mbx ;
//endfunction

function void xgmii_drv::build_phase(uvm_phase phase);
    super.build_phase(phase);
    //`uvm_info("xgmii_drv", "building...", UVM_LOW);
    //$display ("%s", get_full_name());
    if (!uvm_config_db#(virtual xgmii_if)::get(this, "", "vif_xgmii_ingress", vif_xgmii_ingress))
    begin
        `uvm_fatal("xgmii_drv", "virtual interface must be set for vif_xgmii_ingress")
    end
endfunction

task xgmii_drv::main_phase(uvm_phase phase);
    //`uvm_info("xgmii_drv", "Initial finished...", UVM_LOW);

    vif_xgmii_ingress.txc    <= {XGMII_CW{1'b0}};
    vif_xgmii_ingress.txd    <= {XGMII_DW{1'b0}};
    vif_xgmii_ingress.clk_en <= 1'b0            ;

    req = new("req");
    while (1)
    begin
        //#100us
        //assert(req.randomize());
        seq_item_port.try_next_item(req);
        if (req == null)
        begin
            send_idle();
        end
        else
        begin
            //req.display();
            //mbx_xgmii_drv.put(req);
            send_one_pkt(req);
            seq_item_port.item_done();
        end
    end

endtask

task xgmii_drv::send_one_pkt(ohb_eth_packet pkt);
    byte unsigned                                   data_q[]                    ;
    int                                             data_size                   ;
    int                                             cycle_cnt                   ;
    int                                             byte_index                  ;

    //$display("XGMII driver sending packet!");
    //pkt.display();

    data_size = (pkt.pack_bytes(data_q) / 8) + 2 ;
    cycle_cnt = (data_size + 1) / XGMII_CW + 1 ;
    //for (int i=0; i<data_size; i++)
    //begin
    //    $write("%02x", data_q[i]);
    //    if (i%8 == 7)
    //    begin
    //        $write("\n");
    //    end
    //end

    for (int i=0; i<cycle_cnt; i++)
    begin
        @(posedge vif_xgmii_ingress.i_clk) ;
        vif_xgmii_ingress.clk_en <= 1'b1            ;

        for (int j=0; j<XGMII_CW; j++)
        begin
            byte_index = i * XGMII_CW + j ;
            if (byte_index == 0)
            begin
                vif_xgmii_ingress.txc[j]        <= 1'b1                 ;
                vif_xgmii_ingress.txd[j*8 +: 8] <= XGMII_START          ;
            end
            else if (byte_index < data_size)
            begin
                vif_xgmii_ingress.txc[j]        <= 1'b0                 ;
                vif_xgmii_ingress.txd[j*8 +: 8] <= data_q[byte_index]   ;
                //$display("TXC: %01x, TXD: %02x", vif_xgmii_ingress.txc[j], vif_xgmii_ingress.txd[j*8 +: 8]);
            end
            else if (byte_index == data_size)
            begin
                vif_xgmii_ingress.txc[j]        <= 1'b1                 ;
                vif_xgmii_ingress.txd[j*8 +: 8] <= XGMII_END            ;
            end
            else
            begin
                vif_xgmii_ingress.txc[j]        <= 1'b1                 ;
                vif_xgmii_ingress.txd[j*8 +: 8] <= XGMII_IDLE           ;
            end
        end
    end
endtask

task xgmii_drv::send_idle();
    @(posedge vif_xgmii_ingress.i_clk) ;
    vif_xgmii_ingress.clk_en <= 1'b1                ;
    vif_xgmii_ingress.txc <= {XGMII_CW{1'b1}}       ;
    vif_xgmii_ingress.txd <= {XGMII_CW{XGMII_IDLE}} ;
endtask

task xgmii_drv::send_start();
    @(posedge vif_xgmii_ingress.i_clk) ;
    vif_xgmii_ingress.clk_en <= 1'b1                ;
    vif_xgmii_ingress.txc <= {XGMII_CW{1'b1}}       ;
    vif_xgmii_ingress.txd <= {XGMII_START, {(XGMII_CW-1){XGMII_IDLE}}};
endtask

task xgmii_drv::send_end();
    @(posedge vif_xgmii_ingress.i_clk) ;
    vif_xgmii_ingress.clk_en <= 1'b1                ;
    vif_xgmii_ingress.txc <= {XGMII_CW{1'b1}}       ;
    vif_xgmii_ingress.txd <= {XGMII_END, {(XGMII_CW-1){XGMII_IDLE}}};
endtask

