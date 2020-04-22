//-----------------------------------------------------------------------------------
// Author: You Kejian
// Date:   2019/10/10
// Description:
//      1. Sync fifo logic
//-----------------------------------------------------------------------------------
`timescale 1ns/1ps

module async_cell_fifo_core #(
//-----------------------------------------------------------------------------------
//  Parameter Definition
//-----------------------------------------------------------------------------------
    parameter                           DWIDTH              = 8                     ,
    parameter                           AWIDTH              = 8                     ,
    parameter                           CWIDTH              = 2                     ,
    parameter                           H_AWIDTH            = AWIDTH - CWIDTH       ,
    parameter                           L_AWIDTH            = CWIDTH                ,
    parameter                           FULL_CNT            = {H_AWIDTH{1'b1}}      ,
    parameter                           ALFULL_TH           = 2                     ,
    parameter                           ALEMPTY_TH          = 2                     ,
    parameter                           OPEN_ADDRESS        = 1                     ,
    parameter                           U_DLY               = 1                      
) (
//-----------------------------------------------------------------------------------
//  Port Definition
//-----------------------------------------------------------------------------------
    input                                           i_wclk_sys                      ,
    input                                           i_wrst_n                        ,
    input                                           i_rclk_sys                      ,
    input                                           i_rrst_n                        ,

    input                                           i_wen                           ,   // FIFO write enable
    input                                           i_weoc                          ,   // FIFO write end of cell
    input       [CWIDTH                 - 1 : 0]    i_waddr                         ,   // FIFO internal write address of cell
    input       [DWIDTH                 - 1 : 0]    i_wdata                         ,   // FIFO write data
    output  reg                                     o_full                          ,   // FIFO full
    output  reg                                     o_alfull                        ,   // FIFO almost full, the threshold depends on the ALFULL_TH parameter

    input                                           i_ren                           ,   // FIFO read enable
    input                                           i_reoc                          ,   // FIFO read end of cell
    input       [CWIDTH                 - 1 : 0]    i_raddr                         ,   // FIFO internal read address of cell
    output      [DWIDTH                 - 1 : 0]    o_rdata                         ,   // FIFO read data
    output  reg                                     o_empty                         ,   // FIFO empty
    output  reg                                     o_alempty                       ,   // FIFO almost empty, the threshold depends on the ALEMPTY_TH parameter

    output                                          o_ram_wen                       ,
    output      [AWIDTH                 - 1 : 0]    o_ram_waddr                     ,
    output      [DWIDTH                 - 1 : 0]    o_ram_wdata                     ,
    output      [AWIDTH                 - 1 : 0]    o_ram_raddr                     ,
    input       [DWIDTH                 - 1 : 0]    i_ram_rdata                     ,

    output  reg                                     o_overflow                      ,
    output  reg                                     o_underflow                     ,
    output  reg [H_AWIDTH                   : 0]    o_debug_cnt_w                   ,
    output  reg [H_AWIDTH                   : 0]    o_debug_cnt_r                     
) ;
//-----------------------------------------------------------------------------------
//  Signal Definition
//-----------------------------------------------------------------------------------
reg     [H_AWIDTH                       - 1 : 0]    r_h_waddr                       ;
reg     [L_AWIDTH                       - 1 : 0]    r_l_waddr                       ;
reg     [H_AWIDTH                       - 1 : 0]    r_h_raddr                       ;
reg     [L_AWIDTH                       - 1 : 0]    r_l_raddr                       ;
wire    [H_AWIDTH                       - 1 : 0]    w_h_raddr                       ;
reg     [L_AWIDTH                       - 1 : 0]    rw_l_raddr                      ;

wire    [H_AWIDTH                       - 1 : 0]    w_h_waddr_rclk                  ;   // write address transfer to read side clock domain
wire    [H_AWIDTH                       - 1 : 0]    w_h_raddr_wclk                  ;   // read address transfer to write side clock domain
//-----------------------------------------------------------------------------------
//  Main Function
//-----------------------------------------------------------------------------------
assign o_ram_wen                = i_wen                                             ;
assign o_ram_waddr              = (OPEN_ADDRESS == 0) ? {r_h_waddr, r_l_waddr} : {r_h_waddr, i_waddr};
assign o_ram_wdata              = i_wdata                                           ;
assign o_ram_raddr              = (OPEN_ADDRESS == 0) ? {w_h_raddr, rw_l_raddr} : {r_h_raddr, i_raddr};    // PreRead fifo, read data comes out before ren asserts
assign o_rdata                  = i_ram_rdata                                       ;

always @(posedge i_wclk_sys or negedge i_wrst_n)
begin
    if (i_wrst_n == 1'b0)
    begin
        r_h_waddr <= {H_AWIDTH{1'b0}} ;
    end
    else
    begin
        if (i_weoc == 1'b1) 
        begin
            r_h_waddr <= #U_DLY r_h_waddr + 1'b1 ;
        end
        else ;
    end
end

always @(posedge i_wclk_sys or negedge i_wrst_n)
begin
    if (i_wrst_n == 1'b0)
    begin
        r_l_waddr <= {H_AWIDTH{1'b0}} ;
    end
    else
    begin
        if (i_weoc == 1'b1) 
        begin
            r_l_waddr <= #U_DLY {H_AWIDTH{1'b0}};
        end
        else if (i_wen == 1'b1)
        begin
            r_l_waddr <= #U_DLY r_l_waddr + 1'b1 ;
        end
        else ;
    end
end

always @(*)
begin
    if (i_reoc == 1'b1)
    begin
        rw_l_raddr = {L_AWIDTH{1'b0}} ;
    end
    else
    begin
        if (i_ren == 1'b1)
        begin
            rw_l_raddr = r_l_raddr + 1'b1 ;
        end
        else
        begin
            rw_l_raddr = r_l_raddr ;
        end
    end
end

//assign w_l_raddr = (i_ren  == 1'b1) ? (r_l_raddr + 1) : r_l_raddr ;
assign w_h_raddr = (i_reoc == 1'b1) ? (r_h_raddr + 1) : r_h_raddr ;

always @(posedge i_rclk_sys or negedge i_rrst_n)
begin
    if (i_rrst_n == 1'b0)
    begin
        r_l_raddr <= {H_AWIDTH{1'b0}} ;
        r_h_raddr <= {L_AWIDTH{1'b0}} ;
    end
    else
    begin
        r_l_raddr <= #U_DLY rw_l_raddr ;
        r_h_raddr <= #U_DLY w_h_raddr ;
    end
end

counter_async_with_gray #(
//-----------------------------------------------------------------------------------
//  Parameter Definition
//-----------------------------------------------------------------------------------
    .DWIDTH                                 (H_AWIDTH                               ), 
    .U_DLY                                  (1                                      )
) u_waddr_async (
//-----------------------------------------------------------------------------------
//  Port Definition
//-----------------------------------------------------------------------------------
    .i_clk_a                                (i_wclk_sys                             ),
    .i_rst_a_n                              (i_wrst_n                               ),
    .i_clk_b                                (i_rclk_sys                             ),
    .i_rst_b_n                              (i_rrst_n                               ),

    .i_input                                (r_h_waddr                              ),
    .o_output                               (w_h_waddr_rclk                         )
) ;

counter_async_with_gray #(
//-----------------------------------------------------------------------------------
//  Parameter Definition
//-----------------------------------------------------------------------------------
    .DWIDTH                                 (H_AWIDTH                               ), 
    .U_DLY                                  (1                                      )
) u_raddr_async (
//-----------------------------------------------------------------------------------
//  Port Definition
//-----------------------------------------------------------------------------------
    .i_clk_a                                (i_rclk_sys                             ),
    .i_rst_a_n                              (i_rrst_n                               ),
    .i_clk_b                                (i_wclk_sys                             ),
    .i_rst_b_n                              (i_wrst_n                               ),

    .i_input                                (r_h_raddr                              ),
    .o_output                               (w_h_raddr_wclk                         )
) ;

always @(*)
begin
    if (r_h_waddr >= w_h_raddr_wclk)
    begin
        o_debug_cnt_w = #U_DLY r_h_waddr - w_h_raddr_wclk ;
    end
    else
    begin
        o_debug_cnt_w = #U_DLY {1'b1, {H_AWIDTH{1'b0}}} + r_h_waddr - w_h_raddr_wclk ;
    end
end

always @(*)
begin
    if (w_h_waddr_rclk >= r_h_raddr)
    begin
        o_debug_cnt_r = #U_DLY w_h_waddr_rclk - r_h_raddr ;
    end
    else
    begin
        o_debug_cnt_r = #U_DLY {1'b1, {H_AWIDTH{1'b0}}} + w_h_waddr_rclk - r_h_raddr ;
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
        if (i_weoc == 1'b1 && o_debug_cnt_w == (FULL_CNT - 1))
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
        if (i_weoc == 1'b1 && o_debug_cnt_w >= (FULL_CNT - ALFULL_TH - 1))
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
        if (i_reoc == 1'b1 && o_debug_cnt_r == 1)
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
        if (i_reoc == 1'b1 && o_debug_cnt_r <= (ALEMPTY_TH + 1 ))
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
        if (i_weoc == 1'b1 && o_debug_cnt_w == FULL_CNT)
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
        if (i_reoc == 1'b1 && o_debug_cnt_r <= 0)
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
