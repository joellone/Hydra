import uvm_pkg::*;
`include "uvm_macros.svh"
`include "transaction/gcc_packet.sv"
`include "transaction/ohb_eth_packet.sv"
`include "packets/hdlc_packet.sv"
`include "checker/gcc_pkt_check.sv"
`include "checker/hdlc_pkt_check.sv"

class falcon_scb extends uvm_scoreboard;
    `uvm_component_utils(falcon_scb)
    UINT                            gcc_pkt_cnt         = 0         ;
    mailbox                         mbx_xgmii_0_mon                 ;
    mailbox                         mbx_xgmii_1_mon                 ;
    mailbox                         mbx_igmii_mon                   ;
    mailbox                         mbx_cpu_fifo_mon                ;
    mailbox                         mbx_clinkh32_drv                ;

    function new (string name = "falcon_scb", uvm_component parent = null) ;
        super.new(name, parent);
    endfunction

    extern function void mbx_xgmii_0_mon_connect(mailbox input_mbx) ;
    extern function void mbx_xgmii_1_mon_connect(mailbox input_mbx) ;
    extern function void mbx_igmii_mon_connect(mailbox input_mbx) ;
    extern function void mbx_cpu_fifo_mon_connect(mailbox input_mbx) ;
    extern function void mbx_clinkh32_drv_connect(mailbox input_mbx) ;
    extern virtual task main_phase (uvm_phase phase);
    //extern function BOOL is_egress_check_pass(gcc_packet igmii_rx_pkt, hdlc_packet hdlc_pkt) ;
endclass

function void falcon_scb::mbx_xgmii_0_mon_connect(mailbox input_mbx) ;
    mbx_xgmii_0_mon = input_mbx ;
endfunction

function void falcon_scb::mbx_xgmii_1_mon_connect(mailbox input_mbx) ;
    mbx_xgmii_1_mon = input_mbx ;
endfunction

function void falcon_scb::mbx_igmii_mon_connect(mailbox input_mbx) ;
    mbx_igmii_mon = input_mbx ;
endfunction

function void falcon_scb::mbx_cpu_fifo_mon_connect(mailbox input_mbx) ;
    mbx_cpu_fifo_mon = input_mbx ;
endfunction

function void falcon_scb::mbx_clinkh32_drv_connect(mailbox input_mbx) ;
    mbx_clinkh32_drv = input_mbx ;
endfunction

task falcon_scb::main_phase(uvm_phase phase);
    ohb_eth_packet                  tr_xgmii_0                      ;
    ohb_eth_packet                  tr_xgmii_1                      ;
    gcc_packet                      tr_igmii                        ;
    gcc_packet                      tr_exp_pkt                      ;
    hdlc_packet                     tr_hdlc_pkt                     ;
    UINT                            gcc_chnl                        ;
    gcc_pkt_check                   ins_gcc_pkt_chk                 ;
    gcc_pkt_check                   ins_exp_pkt_chk                 ;
    hdlc_pkt_check                  ins_hdlc_pkt_chk_0              ;
    hdlc_pkt_check                  ins_hdlc_pkt_chk_1              ;
    BOOL                            xgmii_chk_pass                  ;

    ins_gcc_pkt_chk = new(GCC);
    ins_exp_pkt_chk = new(EXP);
    ins_hdlc_pkt_chk_0 = new(0) ;
    ins_hdlc_pkt_chk_1 = new(1) ;
    //phase.raise_objection(this);
    while (1)
    begin
        #10ns
        if (0 != mbx_igmii_mon.try_get(tr_igmii))
        begin
            if (ins_gcc_pkt_chk.check_pass(tr_igmii) == TRUE)
            begin
                $display("Scoreboard received GCC packet: %d", gcc_pkt_cnt) ;
            end
        end

        if (0 != mbx_cpu_fifo_mon.try_get(tr_exp_pkt))
        begin
            if (ins_exp_pkt_chk.check_pass(tr_exp_pkt) == TRUE)
            begin
                $display("Scoreboard received GCC packet: %d", gcc_pkt_cnt) ;
            end
        end

        if (0 != mbx_xgmii_0_mon.try_get(tr_xgmii_0))
        begin
            //tr_xgmii_0.display();
            if (tr_xgmii_0 != null) xgmii_chk_pass = ins_hdlc_pkt_chk_0.check_pass(tr_xgmii_0) ;
            //xgmii_chk_pass = ins_hdlc_pkt_chk_0.check_pass(tr_xgmii_0) ;
        end

        if (0 != mbx_xgmii_1_mon.try_get(tr_xgmii_1))
        begin
            //tr_xgmii_1.display();
            if (tr_xgmii_1 != null) xgmii_chk_pass = ins_hdlc_pkt_chk_1.check_pass(tr_xgmii_1) ;
            //xgmii_chk_pass = ins_hdlc_pkt_chk_1.check_pass(tr_xgmii_1) ;
        end

        if (scb_rx_gcc_pkt  >= g_add4_rm.ins_testcase.hdlc_test_num  &&
            scb_rx_hdlc_pkt >= g_add4_rm.ins_testcase.gcc_test_num   &&
            scb_rx_aps      >= g_add4_rm.ins_testcase.aps_test_num    )
        begin
            break ;
        end
    end
    $display("Scoreboard finished");
    //phase.drop_objection(this);
endtask

