import uvm_pkg::*;
`include "uvm_macros.svh"
`include "transaction/tx_internal.sv"

class tx_internal_drv extends uvm_driver #(tx_internal);
    `uvm_component_utils(tx_internal_drv)
    //tx_internal ins_tx_internal_pkt ;
    virtual tx_internal_if ins_tif ;

    function new (string name = "tx_internal_drv", uvm_component parent = null) ;
        super.new(name, parent);
    endfunction

    extern virtual function void build_phase(uvm_phase phase);
    extern virtual task main_phase(uvm_phase phase) ;
    extern virtual task send_one_pkt(tx_internal pkt);
endclass

function void tx_internal_drv::build_phase(uvm_phase phase);
    super.build_phase(phase);
    `uvm_info("tx_internal_drv", "building...", UVM_LOW);
    $display ("%s", get_full_name());
    if (!uvm_config_db#(virtual tx_internal_if)::get(this, "", "ins_tif", ins_tif))
    begin
        `uvm_fatal("tx_internal_drv", "virtual interface must be set for ins_tif")
    end
endfunction

task tx_internal_drv::main_phase(uvm_phase phase);
    int send_cnt = 3 ;
    phase.raise_objection(this);

    ins_tif.data_en <= 1'b0    ;
    ins_tif.data    <= $urandom_range(0, 255)   ;
    ins_tif.sop     <= 1'b0    ;
    ins_tif.eop     <= 1'b0    ;
    ins_tif.port_id <= 'h0     ;

    req = new("req");
    #100us
    while (send_cnt > 0)
    begin
        #100us
        assert(req.randomize() with{exp_gcc.size == 64;});
        send_one_pkt(req);
        send_cnt = send_cnt - 1 ;
    end

    //assert()

    `uvm_info("tx_internal_drv", "Initial finished...", UVM_LOW);

    phase.drop_objection(this);
endtask

task tx_internal_drv::send_one_pkt(tx_internal pkt);
    bit                                             data_q[]                    ;
    int                                             data_size                   ;

    //pkt.print();
    pkt.display();
    data_size = pkt.pack(data_q) / DATA_W_INTERANL ;

    for (int i=0; i<data_size; i++)
    begin
        @(posedge ins_tif.i_clk);
        ins_tif.data_en  <= 1'b1 ;
        if (i == 0)
        begin
            ins_tif.sop <= 1'b1 ;
        end
        else
        begin
            ins_tif.sop <= 1'b0 ;
        end
        if (i == data_size-1)
        begin
            ins_tif.eop <= 1'b1 ;
        end
        else
        begin
            ins_tif.eop <= 1'b0 ;
        end
        for (int j=0; j<DATA_W_INTERANL; j++)
            ins_tif.data[DATA_W_INTERANL - j - 1] <= data_q[i * DATA_W_INTERANL + j];
    end

    @(posedge ins_tif.i_clk);
    ins_tif.data_en    <= 1'b0 ;
    ins_tif.sop        <= 1'b0 ;
    ins_tif.eop        <= 1'b0 ;
    ins_tif.data       <= 'h0  ;

endtask
