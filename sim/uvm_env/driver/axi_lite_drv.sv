import uvm_pkg::*;
`include "uvm_macros.svh"
`include "transaction/clinkh32_xct.sv"
`include "registers/regReadWrite.sv"

class axi_lite_drv extends uvm_driver #(clinkh32_xct);
    `uvm_component_utils(axi_lite_drv)
    virtual axi_lite_if vif_axi_lite_if;
    mailbox mbx_axi_lite_drv;

    function new (string name = "axi_lite_drv", uvm_component parent = null) ;
        super.new(name, parent);
    endfunction

    extern function void mbx_connect(mailbox input_mbx);
    extern virtual function void build_phase(uvm_phase phase);
    extern virtual task main_phase(uvm_phase phase) ;
    extern virtual task send_one_pkt(ref clinkh32_xct pkt);
endclass

function void axi_lite_drv::mbx_connect(mailbox input_mbx);
    mbx_axi_lite_drv = input_mbx ;
endfunction

function void axi_lite_drv::build_phase(uvm_phase phase);
    super.build_phase(phase);
    if (!uvm_config_db#(virtual axi_lite_if)::get(this, "", "vif_axi_lite_if", vif_axi_lite_if))
    begin
        `uvm_fatal("axi_lite_drv", "virtual interface must be set for vif_axi_lite_if")
    end
endfunction

task axi_lite_drv::main_phase(uvm_phase phase);
    regReadWrite ins_regReadWrite ;

    `uvm_info("axi_lite_drv", "Axi lite start...", UVM_LOW);
    vif_axi_lite_if.o_axi_awaddr                <= 'h0                  ;
    vif_axi_lite_if.o_axi_awvalid               <= 'h0                  ;
    vif_axi_lite_if.o_axi_wdata                 <= 'h0                  ;
    vif_axi_lite_if.o_axi_wstrb                 <= 'h0                  ;
    vif_axi_lite_if.o_axi_wvalid                <= 'h0                  ;
    vif_axi_lite_if.o_axi_bready                <= 'h0                  ;
    vif_axi_lite_if.o_axi_araddr                <= 'h0                  ;
    vif_axi_lite_if.o_axi_arvalid               <= 'h0                  ;
    vif_axi_lite_if.o_axi_rready                <= 'h0                  ;

    ins_regReadWrite = new();

    #1us

    req = new("req");
    while (1)
    begin
        #10ns
        req = ins_regReadWrite.getReq() ;
        if (req != null)
        begin
            send_one_pkt(req) ;
            ins_regReadWrite.putAck(req) ;
        end
    end

endtask

task axi_lite_drv::send_one_pkt(ref clinkh32_xct pkt);
    if (pkt == null)
    begin
        @(posedge vif_axi_lite_if.i_clk) ;
        return ;
    end

    if (pkt.rh_wl == 1'b0)
    // Write operation
    begin
        // AXI_LITE address write
        //pkt.display();
        @(posedge vif_axi_lite_if.i_clk) ;
        vif_axi_lite_if.o_axi_awaddr  <= pkt.address    ;
        vif_axi_lite_if.o_axi_wdata   <= pkt.wdata      ;
        // Waiting for ready
        while (vif_axi_lite_if.i_axi_awready == 1'b0 || vif_axi_lite_if.i_axi_wready == 1'b0)
        begin
            @(posedge vif_axi_lite_if.i_clk) ;
            vif_axi_lite_if.o_axi_awvalid <= 1'b1           ;
            vif_axi_lite_if.o_axi_wvalid  <= 1'b1           ;
        end
        // Desert valid
        vif_axi_lite_if.o_axi_awvalid <= 1'b0 ;
        vif_axi_lite_if.o_axi_wvalid  <= 1'b0 ;
        // Waiting for ready to desert
        while (vif_axi_lite_if.i_axi_awready == 1'b1 || vif_axi_lite_if.i_axi_wready == 1'b1)
        begin
            @(posedge vif_axi_lite_if.i_clk) ;
            vif_axi_lite_if.o_axi_awvalid <= 1'b0           ;
            vif_axi_lite_if.o_axi_wvalid  <= 1'b0           ;
        end
    end
    else
    // Read operation
    begin
        @(posedge vif_axi_lite_if.i_clk) ;
        vif_axi_lite_if.o_axi_araddr  <= pkt.address ;
        vif_axi_lite_if.o_axi_arvalid <= 1'b1        ;
        // Waiting for ready
        while (vif_axi_lite_if.i_axi_arready == 1'b0)
        begin
            @(posedge vif_axi_lite_if.i_clk) ;
            vif_axi_lite_if.o_axi_arvalid <= 1'b1 ;
        end
        // Desert valid
        vif_axi_lite_if.o_axi_arvalid <= 1'b0 ;

        // Waiting response data
        while (vif_axi_lite_if.i_axi_rvalid == 1'b0)
        begin
            @(posedge vif_axi_lite_if.i_clk) ;
        end
        //$display ("i_axi_rvalid: %x", vif_axi_lite_if.i_axi_rvalid);
        pkt.rdata = vif_axi_lite_if.i_axi_rdata ;
        vif_axi_lite_if.o_axi_rready = vif_axi_lite_if.i_axi_rvalid ;

        // Waiting for desert arready
        while (vif_axi_lite_if.i_axi_arready == 1'b1)
        begin
            @(posedge vif_axi_lite_if.i_clk) ;
        end
    end
endtask

