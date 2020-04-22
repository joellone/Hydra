//---------------------------------------------------------------------------------------------------
// Author: You Kejian
// Email:  kejian.you@nokia-sbell.com
// Date:   2019/12/16
// Description:
//      1. CPU fifo agent
// Change Log:
//---------------------------------------------------------------------------------------------------

import uvm_pkg::*;
`include "uvm_macros.svh"
`include "driver/cpu_fifo_drv.sv"
`include "monitor/cpu_fifo_monitor.sv"
`include "sequence/cpu_fifo_sequencer.sv"
`include "registers/modReg.sv"
`include "rm/add4_rm.sv"
`include "global_variable.sv"

class cpu_fifo_agent extends uvm_agent;
    cpu_fifo_drv         ins_cpu_fifo_drv     ;
    cpu_fifo_monitor     ins_cpu_fifo_mon     ;
    cpu_fifo_sequencer   ins_cpu_fifo_seqr    ;
    modReg               cpu_fifo_mod_list    ;
    function new (string name, uvm_component parent);
        super.new(name, parent);
    endfunction

    extern virtual function void build_phase(uvm_phase phase);
    extern virtual function void connect_phase(uvm_phase phase);
    extern virtual task main_phase (uvm_phase phase);

    `uvm_component_utils(cpu_fifo_agent)
endclass

function void cpu_fifo_agent::build_phase(uvm_phase phase);
    super.build_phase(phase);
    //`uvm_info("cpu_fifo_agent", "XGMII agent building...", UVM_LOW);
    if (is_active == UVM_ACTIVE)
    begin
        //ins_cpu_fifo_seqr    = cpu_fifo_sequencer::type_id::create("ins_cpu_fifo_seqr", this);
        ins_cpu_fifo_seqr  = new;
        ins_cpu_fifo_drv   = new("ins_cpu_fifo_drv", this);
        ins_cpu_fifo_mon   = new("ins_cpu_fifo_mon", this);
    end
endfunction

function void cpu_fifo_agent::connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    ins_cpu_fifo_drv.seq_item_port.connect(ins_cpu_fifo_seqr.seq_item_export);
endfunction

task cpu_fifo_agent::main_phase(uvm_phase phase);
    if (g_add4_rm == null)
    begin
        `uvm_fatal("cpu_fifo_agent", "g_add4_rm is not initailed");
    end
    cpu_fifo_mod_list = new g_add4_rm.ins_ReadLabCtrl.regList;
    ins_cpu_fifo_drv.cpu_fifo_tx_mod = new cpu_fifo_mod_list.getMod("gcc_cpu_fifo_tx");
    ins_cpu_fifo_mon.cpu_fifo_rx_mod = new cpu_fifo_mod_list.getMod("gcc_cpu_fifo_rx");

    //ins_cpu_fifo_drv.cpu_fifo_tx_mod.display();
endtask
