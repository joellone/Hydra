import uvm_pkg::*;
`include "uvm_macros.svh"
`include "agent/xgmii_agent.sv"
`include "agent/igmii_agent.sv"
`include "agent/axi_lite_agent.sv"
`include "agent/cpu_fifo_agent.sv"
`include "scoreboard/falcon_scb.sv"
`include "registers/readLabCtrl.sv"
`include "testcase/testcase.sv"

class falcon_env extends uvm_env;
    // Agents & Drviers
    xgmii_agent         ins_xgmii_agent_0           ;
    xgmii_agent         ins_xgmii_agent_1           ;
    igmii_agent         ins_igmii_agent             ;
    cpu_fifo_agent      ins_cpu_fifo_agent          ;
    axi_lite_agent      ins_axi_lite_agent          ;
    // Scoreboard
    falcon_scb          ins_falcon_scb              ;
    // Mailbox for data transaction
    mailbox             mbx_xgmii_0_mon             ;
    mailbox             mbx_xgmii_1_mon             ;
    mailbox             mbx_igmii_mon               ;
    mailbox             mbx_cpu_fifo_mon            ;
    mailbox             mbx_clinkh32_drv            ;

    `uvm_component_utils(falcon_env)
    function new(string name = "falcon_env", uvm_component parent);
        super.new(name, parent);
        mbx_xgmii_0_mon     = new()         ;
        mbx_xgmii_1_mon     = new()         ;
        mbx_igmii_mon       = new()         ;
        mbx_cpu_fifo_mon    = new()         ;
        //$display("%s", get_full_name());
    endfunction

    extern virtual function void build_phase(uvm_phase phase);
    extern virtual function void connect_phase(uvm_phase phase);
    extern virtual task main_phase (uvm_phase phase);
endclass

task falcon_env::main_phase(uvm_phase phase);
    g_timer.tik();
endtask

function void falcon_env::build_phase(uvm_phase phase);
    super.build_phase(phase);

    //ins_xgmii_agent_0 = xgmii_agent::type_id::create("ins_xgmii_agent_0", this);
    ins_xgmii_agent_0 = new("ins_xgmii_agent_0", this);
    ins_xgmii_agent_0.is_active = UVM_ACTIVE;
    //ins_xgmii_agent_1 = xgmii_agent::type_id::create("ins_xgmii_agent_1", this);
    ins_xgmii_agent_1 = new("ins_xgmii_agent_1", this);
    ins_xgmii_agent_1.is_active = UVM_ACTIVE;

    //ins_igmii_agent = igmii_agent::type_id::create("ins_igmii_agent", this);
    ins_igmii_agent = new("ins_igmii_agent", this);
    ins_igmii_agent.is_active = UVM_ACTIVE;

    ins_axi_lite_agent = new("ins_axi_lite_agent", this);
    ins_axi_lite_agent.is_active = UVM_ACTIVE ;
    ins_cpu_fifo_agent = new("cpu_fifo_agent", this);
    ins_cpu_fifo_agent.is_active = UVM_ACTIVE ;

    ins_falcon_scb = new("ins_falcon_scb", this);
endfunction

function void falcon_env::connect_phase(uvm_phase phase);
    // Connect XGMII interface mailbox
    ins_xgmii_agent_0.ins_xgmii_mon.mbx_connect(mbx_xgmii_0_mon) ;
    ins_xgmii_agent_1.ins_xgmii_mon.mbx_connect(mbx_xgmii_1_mon) ;
    ins_falcon_scb.mbx_xgmii_0_mon_connect(mbx_xgmii_0_mon);
    ins_falcon_scb.mbx_xgmii_1_mon_connect(mbx_xgmii_1_mon);

    // Connect IGMII interface mailbox
    ins_igmii_agent.ins_igmii_mon.mbx_connect(mbx_igmii_mon) ;
    ins_falcon_scb.mbx_igmii_mon_connect(mbx_igmii_mon);

    // Connect Clinkh32 interface mailbox
    ins_axi_lite_agent.ins_axi_lite_drv.mbx_connect(mbx_clinkh32_drv) ;
    ins_falcon_scb.mbx_clinkh32_drv_connect(mbx_clinkh32_drv) ;

    // Connect CPU fifo interface mailbox
    ins_cpu_fifo_agent.ins_cpu_fifo_mon.mbx_connect(mbx_cpu_fifo_mon) ;
    ins_falcon_scb.mbx_cpu_fifo_mon_connect(mbx_cpu_fifo_mon) ;
endfunction
