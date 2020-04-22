import uvm_pkg::*;
`include "uvm_macros.svh"
`include "transaction/gcc_packet.sv"
`include "registers/modReg.sv"

typedef enum {FE = 0, GE} enEthernetType ;

class cpu_fifo_drv extends uvm_driver #(gcc_packet);
    `uvm_component_utils(cpu_fifo_drv)
    modReg              cpu_fifo_tx_mod         ;

    function new (string name = "cpu_fifo_drv", uvm_component parent = null) ;
        super.new(name, parent);
    endfunction

    extern virtual function void build_phase(uvm_phase phase);
    extern virtual task main_phase(uvm_phase phase) ;
    extern virtual task send_one_pkt(gcc_packet pkt);
endclass

function void cpu_fifo_drv::build_phase(uvm_phase phase);
    super.build_phase(phase);
endfunction

task cpu_fifo_drv::main_phase(uvm_phase phase);
    req = new("req");
    while (1)
    begin
        #1us
        seq_item_port.try_next_item(req);
        if (req != null)
        begin
            send_one_pkt(req);
            seq_item_port.item_done();
        end
    end

endtask

task cpu_fifo_drv::send_one_pkt(gcc_packet pkt);
    byte unsigned                                   data_q[]                    ;
    int                                             data_size                   ;
    bit     [31                             : 0]    rdata                       ;
    bit                                             tx_fifo_no_empty            ;

    data_size = pkt.pack_bytes(data_q) / 8 ;

    cpu_fifo_tx_mod.getReg("ethernet_mode").writeReg(GE);

    cpu_fifo_tx_mod.getReg("tx_fifo_no_empty").readReg(rdata);
    tx_fifo_no_empty = rdata[0];
    while(tx_fifo_no_empty == 1'b1)
    begin
        #1us
        cpu_fifo_tx_mod.getReg("tx_fifo_no_empty").readReg(rdata);
        tx_fifo_no_empty = rdata[0];
        $display("CPU fifo is full, waiting for transmitting.");
    end

    $display("============Transmitting EXP packet: %f==============", g_timer.getUs());
    for (int i=0; i<data_size; i++)
    begin
        cpu_fifo_tx_mod.getMod("tx_buf", i).getReg("tx_buf_r").writeReg(data_q[i]);
    end

    cpu_fifo_tx_mod.getReg("tx_length").writeReg(data_size);
    cpu_fifo_tx_mod.getReg("tx_start").writeReg(1);
endtask

