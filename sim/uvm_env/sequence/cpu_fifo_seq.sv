import uvm_pkg::*;
`include "uvm_macros.svh"
`include "transaction/gcc_packet.sv"
`include "stimulation/exp_stim.sv"
`include "global_variable.sv"

class cpu_fifo_seq extends uvm_sequence #(gcc_packet);
    exp_stim            ins_exp_stim    ;
    gcc_packet          exp_ing_pkt     ;
    testcase            tc              ;

    function new(string name="cpu_fifo_seq", testcase in_tc = null);
        super.new(name);
        this.tc         = in_tc     ;
        ins_exp_stim    = new(tc)   ;
    endfunction

    virtual task body ();
        #50us
        $display("Start CPU FIFO");
        ins_exp_stim.clear_stage();
        while(1)
        begin
            #250ns;
            exp_ing_pkt = ins_exp_stim.gen_new_pkt();
            if (exp_ing_pkt != null)
            begin
                start_item(exp_ing_pkt);
                finish_item(exp_ing_pkt);
            end

            if (ins_exp_stim.is_exp_tx_finish() == TRUE)
            begin
                if (scb_rx_hdlc_pkt >= tc.gcc_test_num)
                begin
                    $display("TX GCC packet: %d, RX HDLC packet: %d", seq_tx_gcc_pkt, scb_rx_hdlc_pkt);
                    break ;
                end
                else if (g_timer.time_elapsed(2) > 5000)
                begin
                    $display("GCC send packet: %d", seq_tx_gcc_pkt) ;
                    break ;
                end
            end
            else
            begin
                g_timer.time_start(2);
            end
        end
        $display ("End CPU FIFO");
    endtask

    `uvm_object_utils(cpu_fifo_seq)
endclass
