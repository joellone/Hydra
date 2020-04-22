import uvm_pkg::*;
`include "uvm_macros.svh"
`include "transaction/ohp_eth_pkt_ingress.sv"

class xfi_drv extends uvm_driver #(ohp_eth_pkt_ingress);
    `uvm_component_utils(xfi_drv)
    virtual mac_10g_if  vif_mac_10g_in ;
    //ohp_eth_pkt_ingress ins_ingress_ohp_pkt ;
    mailbox mbx_xfi_drv;

    function new (string name = "xfi_drv", uvm_component parent = null) ;
        super.new(name, parent);
    endfunction

    extern function void mbx_connect(mailbox input_mbx);
    extern virtual function void build_phase(uvm_phase phase);
    extern virtual task main_phase(uvm_phase phase) ;
    extern virtual task send_one_pkt(ohp_eth_pkt_ingress pkt);
endclass

function void xfi_drv::mbx_connect(mailbox input_mbx);
    mbx_xfi_drv = input_mbx ;
endfunction

function void xfi_drv::build_phase(uvm_phase phase);
    super.build_phase(phase);
    `uvm_info("xfi_drv", "building...", UVM_LOW);
    $display ("%s", get_full_name());
    if (!uvm_config_db#(virtual mac_10g_if)::get(this, "", "vif_mac_10g_in", vif_mac_10g_in))
    begin
        `uvm_fatal("xfi_drv", "virtual interface must be set for vif_mac_10g_in")
    end
endfunction

task xfi_drv::main_phase(uvm_phase phase);
    vif_mac_10g_in.clk_en  <= 1'b0     ;
    vif_mac_10g_in.data    <= 'h0      ;
    vif_mac_10g_in.sop     <= 1'b0     ;
    vif_mac_10g_in.eop     <= 1'b0     ;
    vif_mac_10g_in.empty   <= 'h0      ;
    vif_mac_10g_in.dv      <= 1'b0     ;
    vif_mac_10g_in.error   <= 1'b0     ;

    `uvm_info("xfi_drv", "Initial finished...", UVM_LOW);

    req = new("req");
    while (1)
    begin
        //#100us
        //assert(req.randomize());
        seq_item_port.get_next_item(req);
        mbx_xfi_drv.put(req);
        send_one_pkt(req);
        seq_item_port.item_done();
    end

endtask

task xfi_drv::send_one_pkt(ohp_eth_pkt_ingress pkt);
    bit                                             data_q[]                    ;
    int                                             data_size                   ;
    int                                             data_cycle                  ;
    int                                             send_cycle_cnt              ;
    int                                             bit_index                   ;

    //pkt.display();
    //pkt.print();
    data_size = pkt.pack(data_q) ;
    data_cycle = (data_size - 1) / MAC_DWIDTH + 1 ;
    send_cycle_cnt = 0 ;

    vif_mac_10g_in.empty <= 8 - (ING_PKT_LEN_BYTE % MAC_DWIDTH_BYTE) ;
    for (int i=0; i<data_size; i++)
    begin
        if (i % MAC_DWIDTH == 0)
        begin
            @(posedge vif_mac_10g_in.i_clk);

            vif_mac_10g_in.dv       <= 1'b1 ;
            vif_mac_10g_in.clk_en   <= 1'b1 ;

            if (send_cycle_cnt == 1) vif_mac_10g_in.data_en <= 1'b1 ;
            else                     vif_mac_10g_in.data_en <= 1'b0 ;


            if (send_cycle_cnt == 0)
            begin
                vif_mac_10g_in.sop <= 1'b1 ;
            end
            else
            begin
                vif_mac_10g_in.sop <= 1'b0 ;
            end

            if (send_cycle_cnt == data_cycle - 1)
            begin
                vif_mac_10g_in.eop <= 1'b1 ;
            end
            else
            begin
                vif_mac_10g_in.eop <= 1'b0 ;
            end
        end

        bit_index = i % MAC_DWIDTH ;
        vif_mac_10g_in.data[MAC_DWIDTH - bit_index - 1] <= data_q[i];

        if (i % MAC_DWIDTH == MAC_DWIDTH - 1) send_cycle_cnt ++ ;
    end

    @(posedge vif_mac_10g_in.i_clk);
    vif_mac_10g_in.data_en    <= 1'b0 ;
    vif_mac_10g_in.dv         <= 1'b0 ;
    vif_mac_10g_in.clk_en     <= 1'b0 ;
    vif_mac_10g_in.sop        <= 1'b0 ;
    vif_mac_10g_in.eop        <= 1'b0 ;
    vif_mac_10g_in.data       <= 'h0  ;

endtask
