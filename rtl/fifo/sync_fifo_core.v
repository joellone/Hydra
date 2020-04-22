//-----------------------------------------------------------------------------------
// Author: You Kejian
// Date:   2019/10/10
// Description:
//      1. Sync fifo logic
//-----------------------------------------------------------------------------------
`timescale 1ns/1ps

module sync_fifo_core #(
    parameter                           DWIDTH              = 8                     ,
    parameter                           AWIDTH              = 8                     ,
    parameter                           FULL_CNT            = {AWIDTH{1'b1}}        ,
    parameter                           ALFULL_TH           = 2                     ,
    parameter                           ALEMPTY_TH          = 2                     ,
    parameter                           U_DLY               = 1                      
) (
    input                                           i_clk_sys                       ,
    input                                           i_rst_n                         ,

    input                                           i_wen                           ,
    input       [DWIDTH                 - 1 : 0]    i_wdata                         ,
    output  reg                                     o_alfull                        ,
    output  reg                                     o_full                          ,

    input                                           i_ren                           ,
    output      [DWIDTH                 - 1 : 0]    o_rdata                         ,
    output  reg                                     o_alempty                       ,
    output  reg                                     o_empty                         ,

    output                                          o_ram_wen                       ,
    output      [AWIDTH                 - 1 : 0]    o_ram_waddr                     ,
    output      [DWIDTH                 - 1 : 0]    o_ram_wdata                     ,
    output      [AWIDTH                 - 1 : 0]    o_ram_raddr                     ,
    input       [DWIDTH                 - 1 : 0]    i_ram_rdata                     ,

    output  reg                                     o_overflow                      ,
    output  reg                                     o_underflow                     ,
    output  reg [AWIDTH                     : 0]    o_debug_cnt                       
) ;
//-----------------------------------------------------------------------------------
//  Signal Definition
//-----------------------------------------------------------------------------------
reg     [AWIDTH                         - 1 : 0]    r_waddr                         ;
wire    [AWIDTH                         - 1 : 0]    w_waddr                         ;
reg     [AWIDTH                         - 1 : 0]    r_raddr                         ;
wire    [AWIDTH                         - 1 : 0]    w_raddr                         ;
//-----------------------------------------------------------------------------------
//  Main Function
//-----------------------------------------------------------------------------------
assign o_ram_wen                = i_wen                                             ;
assign o_ram_waddr              = r_waddr                                           ;
assign o_ram_wdata              = i_wdata                                           ;
//assign o_ram_raddr              = (o_debug_cnt == 0) ? r_waddr : (r_raddr + 1)      ;    // PreRead fifo, read data comes out before ren asserts
assign o_ram_raddr              = w_raddr                                           ;    // PreRead fifo, read data comes out before ren asserts
assign o_rdata                  = i_ram_rdata                                       ;

always @(posedge i_clk_sys or negedge i_rst_n)
begin
    if (i_rst_n == 1'b0)
    begin
        r_waddr <= {AWIDTH{1'b0}} ;
    end
    else
    begin
        if (i_wen == 1'b1) 
        begin
            r_waddr <= #U_DLY r_waddr + 1'b1 ;
        end
        else ;
    end
end

assign w_raddr = (i_ren == 1'b1) ? r_raddr + 1 : r_raddr ;

always @(posedge i_clk_sys or negedge i_rst_n)
begin
    if (i_rst_n == 1'b0)
    begin
        r_raddr <= {AWIDTH{1'b0}} ;
    end
    else
    begin
        r_raddr <= #U_DLY w_raddr ;
    end
end

always @(*)
begin
    if (r_waddr >= r_raddr)
    begin
        o_debug_cnt = #U_DLY r_waddr - r_raddr ;
    end
    else
    begin
        o_debug_cnt = #U_DLY {1'b1, {AWIDTH{1'b0}}} + r_waddr - r_raddr ;
    end
end

always @(posedge i_clk_sys or negedge i_rst_n)
begin
    if (i_rst_n == 1'b0)
    begin
        o_full <= 1'b0;
    end
    else
    begin
        if (i_wen == 1'b1 && o_debug_cnt == (FULL_CNT - 1))
        begin
            o_full <= #U_DLY 1'b1 ;
        end
        else if (o_debug_cnt < FULL_CNT)
        begin
            o_full <= #U_DLY 1'b0 ;
        end
        else ;
    end
end

always @(posedge i_clk_sys or negedge i_rst_n)
begin
    if (i_rst_n == 1'b0)
    begin
        o_alfull <= 1'b0;
    end
    else
    begin
        if (i_wen == 1'b1 && o_debug_cnt >= (FULL_CNT - ALFULL_TH - 1))
        begin
            o_alfull <= #U_DLY 1'b1 ;
        end
        else if (o_debug_cnt < (FULL_CNT - ALFULL_TH))
        begin
            o_alfull <= #U_DLY 1'b0 ;
        end
        else ;
    end
end

always @(posedge i_clk_sys or negedge i_rst_n)
begin
    if (i_rst_n == 1'b0)
    begin
        o_empty <= 1'b1;
    end
    else
    begin
        if (i_ren == 1'b1 && o_debug_cnt == 1)
        begin
            o_empty <= #U_DLY 1'b1 ;
        end
        else if (o_debug_cnt > 0)
        begin
            o_empty <= #U_DLY 1'b0 ;
        end
        else ;
    end
end

always @(posedge i_clk_sys or negedge i_rst_n)
begin
    if (i_rst_n == 1'b0)
    begin
        o_alempty <= 1'b1;
    end
    else
    begin
        if (i_ren == 1'b1 && o_debug_cnt <= (ALEMPTY_TH + 1 ))
        begin
            o_alempty <= #U_DLY 1'b1 ;
        end
        else if (o_debug_cnt > ALEMPTY_TH)
        begin
            o_alempty <= #U_DLY 1'b0 ;
        end
        else ;
    end
end

always @(posedge i_clk_sys or negedge i_rst_n)
begin
    if (i_rst_n == 1'b0)
    begin
        o_overflow <= 1'b0 ;
    end
    else
    begin
        if (i_wen == 1'b1 && o_debug_cnt == FULL_CNT)
        begin
            o_overflow <= #U_DLY 1'b1 ;
            `ifdef SIM_ON
                $display ("%t, FIFO %m, over flow.", $time);
            `endif
        end
        else ;
    end
end

always @(posedge i_clk_sys or negedge i_rst_n)
begin
    if (i_rst_n == 1'b0)
    begin
        o_underflow <= 1'b0;
    end
    else
    begin
        if (i_ren == 1'b1 && o_debug_cnt <= 0)
        begin
            o_underflow <= #U_DLY 1'b1;
            `ifdef SIM_ON
                $display ("%t, FIFO %m, under flow.", $time);
            `endif
        end
        else ;
    end
end

endmodule
