//-----------------------------------------------------------------------------------
// Author: You Kejian
// Date:   2019/10/10
// Description:
//      1. Asynchronous fifo top
//      2. module: sync_fifo_core + RAM
//-----------------------------------------------------------------------------------

module async_fifo_top #(
//-----------------------------------------------------------------------------------
//  Parameter Definition
//-----------------------------------------------------------------------------------
    parameter                           VENDOR              = "ALTERA"              ,
    parameter                           RAM_TYPE            = "MRAM"                ,
    parameter                           DWIDTH              = 8                     ,
    parameter                           AWIDTH              = 8                     ,
    parameter                           ALFULL_TH           = 2                     ,
    parameter                           ALEMPTY_TH          = 2                     ,
    parameter                           REG_OUT             = 0                 
) (
//-----------------------------------------------------------------------------------
//  Port Definition
//-----------------------------------------------------------------------------------
    input                                           i_wclk_sys                      ,   // Write side clock
    input                                           i_wrst_n                        ,   // Write side reset
    input                                           i_rclk_sys                      ,   // Read side clock
    input                                           i_rrst_n                        ,   // Read side reset

    input                                           i_wen                           ,   // FIFO write enable
    input   [DWIDTH                     - 1 : 0]    i_wdata                         ,   // FIFO write data
    output                                          o_full                          ,   // FIFO full
    output                                          o_alfull                        ,   // FIFO almost full, the threshold depends on the ALFULL_TH parameter

    input                                           i_ren                           ,   // FIFO read enable
    output  [DWIDTH                     - 1 : 0]    o_rdata                         ,   // FIFO read data
    output                                          o_empty                         ,   // FIFO empty
    output                                          o_alempty                       ,   // FIFO almost empty, the threshold depends on the ALEMPTY_TH parameter

    output                                          o_overflow                      ,   // FIFO write overflow in write side clock doamin
    output                                          o_underflow                     ,   // FIFO read underflow in read side clock domain
    output  [AWIDTH                         : 0]    o_debug_cnt_w                   ,                       
    output  [AWIDTH                         : 0]    o_debug_cnt_r                                          
) ;
//-----------------------------------------------------------------------------------
//  Signal Definition
//-----------------------------------------------------------------------------------
wire                                                w_ram_wen                       ;
wire    [AWIDTH                         - 1 : 0]    w_ram_waddr                     ;
wire    [DWIDTH                         - 1 : 0]    w_ram_wdata                     ;
wire    [AWIDTH                         - 1 : 0]    w_ram_raddr                     ;
wire    [DWIDTH                         - 1 : 0]    w_ram_rdata                     ;
//-----------------------------------------------------------------------------------
//  Module Instantiation
//-----------------------------------------------------------------------------------
async_fifo_core #(
    .DWIDTH                         (DWIDTH                         ),
    .AWIDTH                         (AWIDTH                         ),
    .ALFULL_TH                      (ALFULL_TH                      ),
    .ALEMPTY_TH                     (ALEMPTY_TH                     ) 
) u_sync_fifo_core (
    .i_wclk_sys                     (i_wclk_sys                     ),
    .i_wrst_n                       (i_wrst_n                       ),
    .i_rclk_sys                     (i_rclk_sys                     ),
    .i_rrst_n                       (i_rrst_n                       ),

    .i_wen                          (i_wen                          ),
    .i_wdata                        (i_wdata                        ),
    .o_full                         (o_full                         ),
    .o_alfull                       (o_alfull                       ),

    .i_ren                          (i_ren                          ),
    .o_rdata                        (o_rdata                        ),
    .o_empty                        (o_empty                        ),
    .o_alempty                      (o_alempty                      ),

    .o_ram_wen                      (w_ram_wen                      ),
    .o_ram_waddr                    (w_ram_waddr                    ),
    .o_ram_wdata                    (w_ram_wdata                    ),
    .o_ram_raddr                    (w_ram_raddr                    ),
    .i_ram_rdata                    (w_ram_rdata                    ),

    .o_overflow                     (o_overflow                     ),
    .o_underflow                    (o_underflow                    ),
    .o_debug_cnt_w                  (o_debug_cnt_w                  ),  
    .o_debug_cnt_r                  (o_debug_cnt_r                  )  
) ;

Simple_dual_port_RAM #(
    .addr_bits                      (AWIDTH                         ),
    .data_bits                      (DWIDTH                         ),
    .rd_data_reg_enable             (REG_OUT                        ),          
    .ramstyle                       (RAM_TYPE                       )           
) u_Simple_dual_port_RAM (
    .aclk                           (i_wclk_sys                     ),
    .awr_en                         (w_ram_wen                      ),
    .awr_addr                       (w_ram_waddr                    ),
    .awr_data                       (w_ram_wdata                    ),

    .bclk                           (i_rclk_sys                     ),
    .brd_addr                       (w_ram_raddr                    ),
    .brd_data                       (w_ram_rdata                    )
) ; 

endmodule
