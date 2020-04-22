`ifndef TIMER_SV 
`define TIMER_SV

`timescale 1ns/10ps

`include "parameter.sv"

class timer;
    UINT                    ns                  ;    
    real                    us                  ;
    real                    ms                  ;
    real                    s                   ;
    UINT                    time_record [10]    ;

    extern function new();
    extern task tik() ;
    extern function real getUs();
    extern function real getMs();
    extern function real getS() ;
    extern function void display() ;
    extern function void time_start(UINT chnl) ;
    extern function real time_elapsed(UINT chnl) ;
endclass

function timer::new();
    ns = 0 ;
    us = 0 ;
    ms = 0 ;
    s  = 0 ;
endfunction

task timer::tik();
    $display("g_timer start");
    while (1)
    begin
        #1ns
        ns ++ ;
        if ((ns%100_000) == 99_999)
        begin
            $display("Current time: %fus", getUs());
        end
    end
endtask

function real timer::getUs();
    us = ns / 1000.0 ;
    return us ;
endfunction

function real timer::getMs();
    ms = ns / 1000_000.0 ;
    return ms ;
endfunction

function real timer::getS();
    s = ns / 1000_000_000.0 ;
    return s ;
endfunction

function void timer::time_start(UINT chnl);
    time_record[chnl] = ns ;
    //$display("Record time: %dus, channel: %d", ns/1000.0, chnl);
endfunction

function real timer::time_elapsed(UINT chnl);
    real    t_elapsed   ;
    t_elapsed = (ns - time_record[chnl]) / 1000.0 ;
    //$display("Time elapsed: %f, channel: %d", t_elapsed, chnl);
    return t_elapsed ;
endfunction

function void timer::display();
    $display("Current time: %tns", $time/10);
endfunction

`endif //TIMER_SV
