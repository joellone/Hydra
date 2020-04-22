import uvm_pkg::*;
`include "uvm_macros.svh"
`include "transaction/gcc_packet.sv"
`include "stimulation/igmii_stim.sv"
`include "global_variable.sv"

class igmii_seq extends uvm_sequence #(gcc_packet);
    gcc_packet          igmii_ing_pkt   ;
    igmii_stim          ins_igmii_stim  ;
    testcase            tc              ;

    function new(string name="igmii_seq", testcase in_tc = null);
        super.new(name);
        this.tc         = in_tc     ;
        ins_igmii_stim  = new(tc)   ;
    endfunction

    virtual task body ();
        #100us
        $display("Start IGMII");
        ins_igmii_stim.clear_stage();
        while(1)
        begin
            #1ns;
            igmii_ing_pkt = ins_igmii_stim.gen_new_pkt();
            if (igmii_ing_pkt != null)
            begin
                start_item(igmii_ing_pkt);
                finish_item(igmii_ing_pkt);
            end

            if (ins_igmii_stim.is_gcc_tx_finish() == TRUE)
            begin
                if (scb_rx_hdlc_pkt >= tc.gcc_test_num)
                begin
                    $display("TX GCC packet: %d, RX HDLC packet: %d", seq_tx_gcc_pkt, scb_rx_hdlc_pkt);
                    break ;
                end
                else if (g_timer.time_elapsed(1) > 5000)
                begin
                    $display("GCC send packet: %d", seq_tx_gcc_pkt) ;
                    break ;
                end
            end
            else
            begin
                g_timer.time_start(1);
            end
        end
        $display ("End IGMII");
    endtask

    `uvm_object_utils(igmii_seq)
endclass
