import uvm_pkg::*;
`include "uvm_macros.svh"
`include "transaction/ohb_eth_packet.sv"

class xgmii_monitor extends uvm_monitor;
    `uvm_component_utils(xgmii_monitor)
    virtual xgmii_if  vif_xgmii_egress ;
    ohb_eth_packet i_gcc_packet;
    mailbox mbx_xgmii_mon;

    function new (string name = "xgmii_monitor", uvm_component parent = null) ;
        super.new(name, parent);
    endfunction

    extern function void mbx_connect(mailbox input_mbx);
    extern virtual function void build_phase(uvm_phase phase);
    extern virtual task main_phase(uvm_phase phase) ;
    extern virtual task collect_one_pkt(ohb_eth_packet pkt);
endclass

function void xgmii_monitor::mbx_connect(mailbox input_mbx);
    mbx_xgmii_mon = input_mbx ;
endfunction

function void xgmii_monitor::build_phase(uvm_phase phase);
    super.build_phase(phase);
    //`uvm_info("xgmii_monitor", "building...", UVM_LOW);
    //$display ("%s", get_full_name());
    if (!uvm_config_db#(virtual xgmii_if)::get(this, "", "vif_xgmii_egress", vif_xgmii_egress))
    begin
        `uvm_fatal("xgmii_monitor", "virtual interface must be set for vif_mac_10g_out")
    end
endfunction

task xgmii_monitor::main_phase(uvm_phase phase);
    int rcv_cnt = 0 ;

    //`uvm_info("xgmii_drv", "Initial finished...", UVM_LOW);
    #100us

    while (1)
    begin
        i_gcc_packet = new("i_gcc_packet");
        collect_one_pkt(i_gcc_packet);
        if (i_gcc_packet != null) mbx_xgmii_mon.put(i_gcc_packet) ;
    end
endtask

task xgmii_monitor::collect_one_pkt(ohb_eth_packet pkt);
    byte unsigned                   data_q[]        ;
    byte                            xgmii_txd_byte  ;
    int                             pkt_size_cnt    ;
    bit                             pkt_rx_start    ;
    int                             pkt_cycle_cnt   ;
    BOOL                            rx_end          ;

    data_q = new [MAX_ETH_LEN];

    pkt_size_cnt = 0 ;
    while (1)
    begin
        @(posedge vif_xgmii_egress.i_clk);
        //if (vif_xgmii_egress.txc != {XGMII_CW{1'b1}})
        //begin
        //    $display("CW: %02x, DW: %016x", vif_xgmii_egress.txc, vif_xgmii_egress.txd);
        //end
        rx_end = FALSE ;

        for (int i=0; i<XGMII_CW; i++)
        begin
            xgmii_txd_byte = vif_xgmii_egress.txd[i * 8 +: 8] ;
            if (xgmii_txd_byte == XGMII_START && vif_xgmii_egress.txc[i] == 1'b1)
            begin
                pkt_size_cnt = 0    ;
                pkt_rx_start = 1'b1 ;
                data_q[pkt_size_cnt] = xgmii_txd_byte ;
                pkt_size_cnt ++ ;
            end
            else if (pkt_rx_start == 1'b1 && vif_xgmii_egress.txc[i] == 1'b0)
            begin
                data_q[pkt_size_cnt] = xgmii_txd_byte ;
                pkt_size_cnt ++ ;
            end
            else if (xgmii_txd_byte == XGMII_END && vif_xgmii_egress.txc[i] == 1'b1)
            begin
                pkt_rx_start = 1'b0 ;
                rx_end = TRUE ;
                break;
            end
            else ;
        end

        if (rx_end == TRUE) break ;
    end

    if (pkt_size_cnt < (ETH_HEAD_LEN + FCS_LEN + GCC_HEAD_LEN)) 
    begin
        pkt = null ;
    end
    else
    begin
        //$display ("Received a new XGMII packet, packet length: %d", pkt_size_cnt) ;
        pkt.payload= new[pkt_size_cnt-ETH_HEAD_LEN-FCS_LEN-GCC_HEAD_LEN];
        pkt_cycle_cnt = pkt.unpack_bytes(data_q);
        //pkt.display();
    end
endtask
