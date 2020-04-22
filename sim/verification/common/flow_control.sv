`ifndef FLOW_CONTROL_SV
`define FLOW_CONTROL_SV

import uvm_pkg::*;
`include "uvm_macros.svh"
`include "parameter.sv"
`include "common/timer.sv"

class flow_control;
    UINT            band_width                  ;   // Mbps
    UINT            burst_band_width            ;   // Mbps
    UINT            remain_token                ;
    real            pre_time_us                 ;
    BOOL            debug_en                    ;
    string          name       = "flow_control" ;

    extern function new(UINT band_width, string name = "flow_control");
    extern function BOOL is_tx_en(UINT packet_length);
    extern function UINT get_token();
    extern function void packet_send(UINT packet_length);
    extern function void clear_flow();
    extern function void display(UINT packet_len);
endclass

function flow_control::new(UINT band_width, string name = "flow_control");
    this.band_width       = band_width       ;
    this.burst_band_width = 4 * band_width   ;
    this.pre_time_us      = g_timer.getUs()  ;
    this.debug_en         = FALSE            ;
    this.name             = name             ;
    $display("Band width: %d", band_width) ;
    $display("Burst band width: %d", burst_band_width) ;
    $display("Name: %s", name) ;
endfunction

function BOOL flow_control::is_tx_en(UINT packet_length);
    UINT            flow_token          ;
    flow_token = get_token();

    if (debug_en == TRUE)
        $display("%s is tx en: flow token: %d, Packet length: %d", name, flow_token, packet_length);
    if (flow_token > packet_length * 8)
    begin
        return TRUE ;
    end
    else
    begin
        return FALSE ;
    end
endfunction

function UINT flow_control::get_token();
    real            current_us          ;
    real            time_gap            ;
    UINT            flow_cnt            ;

    current_us = g_timer.getUs();
    time_gap = current_us - pre_time_us ;
    flow_cnt = time_gap * band_width    ;

    if (debug_en == TRUE)
        $display("%s get token: current time: %fus, time_gap: %fus, bandwidth: %d, flow_cnt: %d", name, current_us, time_gap, band_width, flow_cnt);

    if (remain_token + flow_cnt > burst_band_width)
    begin
        flow_cnt = burst_band_width ;
    end
    else
    begin
        flow_cnt = remain_token + flow_cnt ;
    end

    return flow_cnt ;
endfunction

function void flow_control::packet_send(UINT packet_length);
    UINT    flow_token_remain       ;
    flow_token_remain = get_token() ;
    if (debug_en == TRUE)
    begin
        $display("%s packet send: remain token: %d, packet length: %d", name, flow_token_remain, packet_length * 8);
    end

    if (flow_token_remain > 8 * packet_length)
    begin
        this.remain_token = flow_token_remain - (8 * packet_length) ;
    end
    else
    begin
        `uvm_warning("Packet send: flow control", "Send packet length exceed remain token.");
        this.remain_token = 0 ;
    end

    this.pre_time_us = g_timer.getUs();
endfunction

function void flow_control::clear_flow();
    this.remain_token = 0               ;
    this.pre_time_us  = g_timer.getUs() ;
endfunction

function void flow_control::display(UINT packet_len);
    $display("%s current: %fus, time_gap: %fus, token: %d, packet length: %d", name, g_timer.getUs(), g_timer.getUs()-pre_time_us, remain_token, packet_len) ;
endfunction

`endif //FLOW_CONTROL_SV

