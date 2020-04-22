//---------------------------------------------------------------------------------------------------
// Author: You Kejian
// Email:  kejian.you@nokia-sbell.com
// Date:   2019/12/16
// Description:
//      1. CPU fifo monitor, monitor for EXP interface
// Change Log:
//---------------------------------------------------------------------------------------------------

import uvm_pkg::*;
`include "uvm_macros.svh"
`include "transaction/gcc_packet.sv"
`include "registers/modReg.sv"

class cpu_fifo_monitor extends uvm_monitor;
    `uvm_component_utils(cpu_fifo_monitor)
    gcc_packet          i_gcc_packet            ;
    mailbox             mbx_cpu_fifo_mon        ;
    modReg              cpu_fifo_rx_mod         ;

    function new (string name = "cpu_fifo_monitor", uvm_component parent = null) ;
        super.new(name, parent);
    endfunction

    extern function void mbx_connect(mailbox input_mbx);
    extern virtual function void build_phase(uvm_phase phase);
    extern virtual task main_phase(uvm_phase phase) ;
    extern virtual task fifo_status(output BOOL fifo_empty);
    extern virtual task collect_one_pkt(gcc_packet pkt);
endclass

function void cpu_fifo_monitor::mbx_connect(mailbox input_mbx);
    mbx_cpu_fifo_mon = input_mbx ;
endfunction

function void cpu_fifo_monitor::build_phase(uvm_phase phase);
    super.build_phase(phase);
    //`uvm_info("cpu_fifo_monitor", "building...", UVM_LOW);
    //$display ("%s", get_full_name());
    //if (g_flexframer3_rm == null)
    //begin
    //    `uvm_fatal("cpu_fifo_monitor", "virtual interface must be set for vif_igmii_egress")
    //end
    //else
    //begin
    //    cpu_fifo_rx_mod = new g_flexframer3_rm.ins_ReadLabCtrl.regList.getMod("gcc_cpu_fifo_rx");
    //end
endfunction

task cpu_fifo_monitor::main_phase(uvm_phase phase);
    int                                     rcv_cnt = 0                 ;
    BOOL                                    rx_fifo_empty               ;

    while (1)
    begin
        #10ns
        fifo_status(rx_fifo_empty);
        if (rx_fifo_empty == FALSE)
        begin
            i_gcc_packet = new("i_gcc_packet")  ;
            collect_one_pkt(i_gcc_packet)       ;
            mbx_cpu_fifo_mon.put(i_gcc_packet)  ;
        end
    end
endtask

task cpu_fifo_monitor::fifo_status(output BOOL fifo_empty);
    bit     [31                     : 0]    rx_fifo_empty               ;

    cpu_fifo_rx_mod.getReg("rx_fifo_empty").readReg(rx_fifo_empty) ;
    if (rx_fifo_empty == 1)
    begin
        fifo_empty = TRUE ;
    end
    else                        
    begin
        $display ("CPU FIFO empty: %x", rx_fifo_empty);
        fifo_empty = FALSE;
    end
endtask

task cpu_fifo_monitor::collect_one_pkt(gcc_packet pkt);
    byte    unsigned                        data_q[]                    ;
    bit     [31                     : 0]    rx_pkt_length               ;
    bit     [31                     : 0]    rdata                       ;
    int                                     pkt_cycle_cnt               ;
    bit     [PREAMBLE_W         - 1 : 0]    i_preamble                  ;

    cpu_fifo_rx_mod.getReg("rx_start").writeReg(32'h1) ;
    cpu_fifo_rx_mod.getReg("rx_length").readReg(rx_pkt_length) ;

    data_q = new [MAX_IGMII_PKT_LEN];

    for (int i=0; i<rx_pkt_length; i++)
    begin
        cpu_fifo_rx_mod.getMod("rx_buf", i).getReg("rx_buf_r").readReg(rdata) ;
        data_q[i] = rdata[7:0] ;
    end

    pkt.payload   = new[rx_pkt_length-pkt.get_ethhead_len()-PAY_LOAD];
    pkt_cycle_cnt = pkt.unpack_bytes(data_q);
endtask
