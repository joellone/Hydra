import uvm_pkg::*;
`include "uvm_macros.svh"
`include "transaction/gcc_packet.sv"

class igmii_monitor extends uvm_monitor;
    `uvm_component_utils(igmii_monitor)
    virtual igmii_if  vif_igmii_egress ;
    gcc_packet i_gcc_packet ;
    mailbox mbx_igmii_mon;

    function new (string name = "igmii_monitor", uvm_component parent = null) ;
        super.new(name, parent);
    endfunction

    extern function void mbx_connect(mailbox input_mbx);
    extern virtual function void build_phase(uvm_phase phase);
    extern virtual task main_phase(uvm_phase phase) ;
    extern virtual task collect_one_pkt(gcc_packet pkt);
endclass

function void igmii_monitor::mbx_connect(mailbox input_mbx);
    mbx_igmii_mon = input_mbx ;
endfunction

function void igmii_monitor::build_phase(uvm_phase phase);
    super.build_phase(phase);
    //`uvm_info("igmii_monitor", "building...", UVM_LOW);
    //$display ("%s", get_full_name());
    if (!uvm_config_db#(virtual igmii_if)::get(this, "", "vif_igmii_egress", vif_igmii_egress))
    begin
        `uvm_fatal("igmii_monitor", "virtual interface must be set for vif_igmii_egress")
    end
endfunction

task igmii_monitor::main_phase(uvm_phase phase);
    int rcv_cnt = 0 ;

    //`uvm_info("igmii_drv", "Initial finished...", UVM_LOW);

    while (1)
    begin
        i_gcc_packet = new("i_gcc_packet");
        collect_one_pkt(i_gcc_packet);
        mbx_igmii_mon.put(i_gcc_packet) ;
    end
endtask

task igmii_monitor::collect_one_pkt(gcc_packet pkt);
    byte unsigned                           data_q[]        ;
    bit  [PREAMBLE_W            - 1 : 0]    i_preamble      ;
    byte                                    igmii_txd_byte  ;
    int                                     pkt_size_cnt    ;
    int                                     preamble_cnt    ;
    bit                                     pkt_rx_start    ;
    bit                                     igmii_dv_ff1    ;
    int                                     pkt_cycle_cnt   ;

    data_q = new [MAX_IGMII_PKT_LEN];

    while (1)
    begin
        @(posedge vif_igmii_egress.i_clk);

        if (vif_igmii_egress.clk_en == 1'b1)
        begin
            if (vif_igmii_egress.dv == 1'b0)
            begin
                if (igmii_dv_ff1 == 1'b1)
                begin
                    pkt.payload = new[pkt_size_cnt-pkt.get_ethhead_len()-PAY_LOAD];
                    pkt_cycle_cnt = pkt.unpack_bytes(data_q);
                    //pkt.display();

                    preamble_cnt = 0    ;
                    pkt_size_cnt = 0    ;
                    pkt_rx_start = 1'b0 ;
                    break ;
                end
            end
            else
            begin
                //$display("Data: %02x", vif_igmii_egress.d) ;
                if (pkt_rx_start == 1'b0)
                begin
                    i_preamble = {i_preamble[PREAMBLE_W - 9 : 0], vif_igmii_egress.d} ;
                    preamble_cnt ++ ;
                end
                else
                begin
                    data_q[pkt_size_cnt] = vif_igmii_egress.d ;
                    pkt_size_cnt ++ ;
                end

                if (i_preamble == PREAMBLE_VALUE && preamble_cnt == PREAMBLE_LEN)
                begin
                    pkt_rx_start = 1'b1 ;
                end
            end
        end

        igmii_dv_ff1 = vif_igmii_egress.dv ;
    end

endtask
