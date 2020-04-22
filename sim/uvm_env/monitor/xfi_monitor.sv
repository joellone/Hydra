import uvm_pkg::*;
`include "uvm_macros.svh"
`include "transaction/ohp_eth_pkt_egress.sv"

class xfi_monitor extends uvm_monitor;
    `uvm_component_utils(xfi_monitor)
    virtual mac_10g_if  vif_mac_10g_out ;
    ohp_eth_pkt_egress i_ohp_eth_pkt_egress ;

    function new (string name = "xfi_monitor", uvm_component parent = null) ;
        super.new(name, parent);
    endfunction

    extern virtual function void build_phase(uvm_phase phase);
    extern virtual task main_phase(uvm_phase phase) ;
    extern virtual task collect_one_pkt(ohp_eth_pkt_egress pkt);
endclass

function void xfi_monitor::build_phase(uvm_phase phase);
    super.build_phase(phase);
    `uvm_info("xfi_monitor", "building...", UVM_LOW);
    $display ("%s", get_full_name());
    if (!uvm_config_db#(virtual mac_10g_if)::get(this, "", "vif_mac_10g_out", vif_mac_10g_out))
    begin
        `uvm_fatal("xfi_monitor", "virtual interface must be set for vif_mac_10g_out")
    end
endfunction

task xfi_monitor::main_phase(uvm_phase phase);
    int rcv_cnt = 0 ;
    //phase.raise_objection(this);

    `uvm_info("xfi_drv", "Initial finished...", UVM_LOW);

    while (1)
    begin
        i_ohp_eth_pkt_egress = new("i_ohp_eth_pkt_egress");
        collect_one_pkt(i_ohp_eth_pkt_egress);

        rcv_cnt ++ ; 

        i_ohp_eth_pkt_egress.display();
    end

    //phase.drop_objection(this);
endtask

task xfi_monitor::collect_one_pkt(ohp_eth_pkt_egress pkt);
    bit                     data[]          ;
    int                     pkt_size        ;
    int                     pkt_cycle_cnt   ;
    byte                    b_data          ;

    pkt_cycle_cnt = 0 ;

    data = new [EG_PKT_LEN];

    while (1)
    begin
        @(posedge vif_mac_10g_out.i_clk);
        if (vif_mac_10g_out.clk_en == 1'b1 && vif_mac_10g_out.dv == 1'b1)
        begin
            if (vif_mac_10g_out.sop == 1'b1) pkt_cycle_cnt = 0 ;

            //$display ("data[%02d]: %016x", pkt_cycle_cnt, vif_mac_10g_out.data);
            for (int i=0; i<MAC_DWIDTH; i++)
            begin
                data[i + (pkt_cycle_cnt * MAC_DWIDTH)] = vif_mac_10g_out.data[MAC_DWIDTH - i - 1] ;
            end

            pkt_cycle_cnt ++ ;

            if (vif_mac_10g_out.eop == 1'b1) break;
        end
    end

    pkt.i_ohp_data = new[OH_DATA_NUM * (OH_DATA_LEN_BYTE + TX_INS_EN_LEN)];
    pkt_cycle_cnt = pkt.unpack(data);
    pkt.display();
endtask
