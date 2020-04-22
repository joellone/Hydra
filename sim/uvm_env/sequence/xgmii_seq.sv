import uvm_pkg::*;
`include "uvm_macros.svh"
`include "transaction/ohb_eth_packet.sv"
`include "parameter.sv"
`include "stimulation/xgmii_stim.sv"
`include "global_variable.sv"

class xgmii_seq extends uvm_sequence #(ohb_eth_packet);
    ohb_eth_packet      xgmii_ing_pkt   ;
    xgmii_stim          ins_xgmii_stim  ;
    testcase            tc              ;
    UINT                port_id         ;

    function new(string name="xgmii_seq", testcase in_tc = null, UINT in_port_id = 0);
        super.new(name);
        this.tc      = in_tc      ;
        this.port_id = in_port_id ;
        ins_xgmii_stim = new(tc, port_id);
        //$display("%s", get_full_name());
    endfunction

    virtual task body ();
        UINT    packet_cnt  ;
        #50us
        packet_cnt = 0 ;
        $display ("Start XGMII");
        if (port_id == 0)
        begin
            #10ns;
        end
        while (1)
        begin
            #10ns;
            //`uvm_do(xgmii_ing_pkt) ;
            xgmii_ing_pkt = ins_xgmii_stim.gen_new_pkt();
            if (xgmii_ing_pkt != null)
            begin
                //$display("----------------------PortID: %d--------------------------", this.port_id);
                //xgmii_ing_pkt.display();
                start_item(xgmii_ing_pkt);
                finish_item(xgmii_ing_pkt);
                packet_cnt ++ ;
            end

            //if (ins_xgmii_stim.is_xgmii_tx_end() == TRUE    && 
            //    scb_rx_hdlc_pkt >= tc.gcc_test_num          )
            if (ins_xgmii_stim.is_xgmii_tx_end() == TRUE && seq_tx_gcc_pkt >= tc.gcc_test_num)
            begin
                if (ins_xgmii_stim.is_scb_rx_end() == TRUE)
                begin
                    break ;
                end
                else if (g_timer.time_elapsed(0) > 10000)
                begin
                    $display("Finish time elapsed: %f", g_timer.time_elapsed(0)) ;
                    break ;
                end
            end
            else
            begin
                g_timer.time_start(0);
            end
        end
        g_add4_rm.is_aps_working = FALSE ;
        $display ("End XGMII");
    endtask

    `uvm_object_utils(xgmii_seq)
endclass
