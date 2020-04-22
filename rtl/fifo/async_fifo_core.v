//-----------------------------------------------------------------------------------
// Author: You Kejian
// Date:   2019/10/15
// Description:
//      1. Async fifo logic
//      2. Latency is 7
//      3. Min alfull parameter is 9
//      4. Min AWIDTH is 4
//-----------------------------------------------------------------------------------
`timescale 1ns/1ps

module async_fifo_core #(
//-----------------------------------------------------------------------------------
//  Parameter Definition
//-----------------------------------------------------------------------------------
    parameter                           DWIDTH              = 8                     ,
    parameter                           AWIDTH              = 8                     ,
    parameter                           FULL_CNT            = {AWIDTH{1'b1}}        ,
    parameter                           ALFULL_TH           = 2                     ,
    parameter                           ALEMPTY_TH          = 2                     ,
    parameter                           U_DLY               = 1                      
) (
//-----------------------------------------------------------------------------------
//  Port Definition
//-----------------------------------------------------------------------------------
    input                                           i_wclk_sys                      ,
    input                                           i_wrst_n                        ,
    input                                           i_rclk_sys                      ,
    input                                           i_rrst_n                        ,

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
    output  reg [AWIDTH                     : 0]    o_debug_cnt_w                   ,
    output  reg [AWIDTH                     : 0]    o_debug_cnt_r                     
) ;
//-----------------------------------------------------------------------------------
//  Signal Definition
//-----------------------------------------------------------------------------------
reg     [AWIDTH                         - 1 : 0]    r_waddr                         ;
wire    [AWIDTH                         - 1 : 0]    w_waddr                         ;
reg     [AWIDTH                         - 1 : 0]    r_raddr                         ;
wire    [AWIDTH                         - 1 : 0]    w_raddr                         ;

wire    [AWIDTH                         - 1 : 0]    w_waddr_rclk                    ;   // write address transfer to read side clock domain
wire    [AWIDTH                         - 1 : 0]    w_raddr_wclk                    ;   // read address transfer to write side clock domain
//-----------------------------------------------------------------------------------
//  Main Function
//-----------------------------------------------------------------------------------
assign o_ram_wen                = i_wen                                             ;
assign o_ram_waddr              = r_waddr                                           ;
assign o_ram_wdata              = i_wdata                                           ;
//assign o_ram_raddr              = (o_debug_cnt == 0) ? r_waddr : (r_raddr + 1)      ;    // PreRead fifo, read data comes out before ren asserts
assign o_ram_raddr              = w_raddr                                           ;    // PreRead fifo, read data comes out before ren asserts
assign o_rdata                  = i_ram_rdata                                       ;

always @(posedge i_wclk_sys or negedge i_wrst_n)
begin
    if (i_wrst_n == 1'b0)
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

always @(posedge i_rclk_sys or negedge i_rrst_n)
begin
    if (i_rrst_n == 1'b0)
    begin
        r_raddr <= {AWIDTH{1'b0}} ;
    end
    else
    begin
        r_raddr <= #U_DLY w_raddr ;
    end
end

counter_async_with_gray #(
//-----------------------------------------------------------------------------------
//  Parameter Definition
//-----------------------------------------------------------------------------------
    .DWIDTH                                 (AWIDTH                                 ), 
    .U_DLY                                  (1                                      )
) u_waddr_async (
//-----------------------------------------------------------------------------------
//  Port Definition
//-----------------------------------------------------------------------------------
    .i_clk_a                                (i_wclk_sys                             ),
    .i_rst_a_n                              (i_wrst_n                               ),
    .i_clk_b                                (i_rclk_sys                             ),
    .i_rst_b_n                              (i_rrst_n                               ),

    .i_input                                (r_waddr                                ),
    .o_output                               (w_waddr_rclk                           )
) ;

counter_async_with_gray #(
//-----------------------------------------------------------------------------------
//  Parameter Definition
//-----------------------------------------------------------------------------------
    .DWIDTH                                 (AWIDTH                                 ), 
    .U_DLY                                  (1                                      )
) u_raddr_async (
//-----------------------------------------------------------------------------------
//  Port Definition
//-----------------------------------------------------------------------------------
    .i_clk_a                                (i_rclk_sys                             ),
    .i_rst_a_n                              (i_rrst_n                               ),
    .i_clk_b                                (i_wclk_sys                             ),
    .i_rst_b_n                              (i_wrst_n                               ),

    .i_input                                (r_raddr                                ),
    .o_output                               (w_raddr_wclk                           )
) ;

always @(*)
begin
    if (w_waddr_rclk >= r_raddr)
    begin
        o_debug_cnt_r = #U_DLY w_waddr_rclk - r_raddr ;
    end
    else
    begin
        o_debug_cnt_r = #U_DLY {1'b1, {AWIDTH{1'b0}}} + w_waddr_rclk - r_raddr ;
    end
end

always @(*)
begin
    if (r_waddr >= w_raddr_wclk)
    begin
        o_debug_cnt_w = #U_DLY r_waddr - w_raddr_wclk;
    end
    else
    begin
        o_debug_cnt_w = #U_DLY {1'b1, {AWIDTH{1'b0}}} + r_waddr - w_raddr_wclk ;
    end
end

always @(posedge i_wclk_sys or negedge i_wrst_n)
begin
    if (i_wrst_n == 1'b0)
    begin
        o_full <= 1'b0;
    end
    else
    begin
        if (i_wen == 1'b1 && o_debug_cnt_w == (FULL_CNT - 1))
        begin
            o_full <= #U_DLY 1'b1 ;
        end
        else if (o_debug_cnt_w < FULL_CNT)
        begin
            o_full <= #U_DLY 1'b0 ;
        end
        else ;
    end
end

always @(posedge i_wclk_sys or negedge i_wrst_n)
begin
    if (i_wrst_n == 1'b0)
    begin
        o_alfull <= 1'b0;
    end
    else
    begin
        if (i_wen == 1'b1 && o_debug_cnt_w >= (FULL_CNT - ALFULL_TH - 1))
        begin
            o_alfull <= #U_DLY 1'b1 ;
        end
        else if (o_debug_cnt_w < (FULL_CNT - ALFULL_TH))
        begin
            o_alfull <= #U_DLY 1'b0 ;
        end
        else ;
    end
end

always @(posedge i_rclk_sys or negedge i_rrst_n)
begin
    if (i_rrst_n == 1'b0)
    begin
        o_empty <= 1'b1;
    end
    else
    begin
        if (i_ren == 1'b1 && o_debug_cnt_r == 1)
        begin
            o_empty <= #U_DLY 1'b1 ;
        end
        else if (o_debug_cnt_r > 0)
        begin
            o_empty <= #U_DLY 1'b0 ;
        end
        else ;
    end
end

always @(posedge i_rclk_sys or negedge i_rrst_n)
begin
    if (i_rrst_n == 1'b0)
    begin
        o_alempty <= 1'b1;
    end
    else
    begin
        if (i_ren == 1'b1 && o_debug_cnt_r <= (ALEMPTY_TH + 1 ))
        begin
            o_alempty <= #U_DLY 1'b1 ;
        end
        else if (o_debug_cnt_r > ALEMPTY_TH)
        begin
            o_alempty <= #U_DLY 1'b0 ;
        end
        else ;
    end
end

always @(posedge i_wclk_sys or negedge i_wrst_n)
begin
    if (i_wrst_n == 1'b0)
    begin
        o_overflow <= 1'b0 ;
    end
    else
    begin
        if (i_wen == 1'b1 && o_debug_cnt_w == FULL_CNT)
        begin
            o_overflow <= #U_DLY 1'b1 ;
            `ifdef SIM_ON
                $display ("%t, FIFO %m, over flow.", $time);
            `endif
        end
        else ;
    end
end

always @(posedge i_rclk_sys or negedge i_rrst_n)
begin
    if (i_rrst_n == 1'b0)
    begin
        o_underflow <= 1'b0;
    end
    else
    begin
        if (i_ren == 1'b1 && o_debug_cnt_r <= 0)
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
