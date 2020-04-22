//-----------------------------------------------------------------------------------
// Author: You Kejian
// Date:   2019/10/10
// Description:
//      1. Sync fifo top
//      2. module: sync_cell_fifo_core + RAM
//-----------------------------------------------------------------------------------

module sync_cell_fifo_top #(
//-----------------------------------------------------------------------------------
//  Parameter Definition
//-----------------------------------------------------------------------------------
    parameter                           VENDOR              = "ALTERA"              ,
    parameter                           RAM_TYPE            = "MRAM"                ,
    parameter                           DWIDTH              = 8                     ,   // Data width
    parameter                           AWIDTH              = 8                     ,   // Address width
    parameter                           CWIDTH              = 2                     ,   // Cell number width
    parameter                           ALFULL_TH           = 2                     ,
    parameter                           ALEMPTY_TH          = 2                     ,
    parameter                           OPEN_ADDRESS        = 0                     ,   // 1 = cell addresses are accessable by user
    parameter                           REG_OUT             = 0                 
) (
//-----------------------------------------------------------------------------------
//  Port Definition
//-----------------------------------------------------------------------------------
    input                                           i_clk_sys                       ,
    input                                           i_rst_n                         ,

    input                                           i_wen                           ,   // FIFO write enable
    input                                           i_weoc                          ,   // FIFO write end of cell
    input   [CWIDTH                     - 1 : 0]    i_waddr                         ,   // FIFO internal write address of cell
    input   [DWIDTH                     - 1 : 0]    i_wdata                         ,   // FIFO write data
    output                                          o_full                          ,   // FIFO full
    output                                          o_alfull                        ,   // FIFO almost full, the threshold depends on the ALFULL_TH parameter

    input                                           i_ren                           ,   // FIFO read enable
    input                                           i_reoc                          ,   // FIFO read end of cell
    input   [CWIDTH                     - 1 : 0]    i_raddr                         ,   // FIFO internal read address of cell
    output  [DWIDTH                     - 1 : 0]    o_rdata                         ,   // FIFO read data
    output                                          o_empty                         ,   // FIFO empty
    output                                          o_alempty                       ,   // FIFO almost empty, the threshold depends on the ALEMPTY_TH parameter

    output                                          o_overflow                      ,
    output                                          o_underflow                     ,
    output  [AWIDTH                         : 0]    o_debug_cnt                       
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
sync_cell_fifo_core #(
    .DWIDTH                         (DWIDTH                         ),
    .AWIDTH                         (AWIDTH                         ),
    .CWIDTH                         (CWIDTH                         ),
    .ALFULL_TH                      (ALFULL_TH                      ),
    .ALEMPTY_TH                     (ALFULL_TH                      ),
    .OPEN_ADDRESS                   (OPEN_ADDRESS                   ),
    .U_DLY                          (1                              ) 
) u_sync_cell_fifo_core (
    .i_clk_sys                      (i_clk_sys                      ),
    .i_rst_n                        (i_rst_n                        ),

    .i_wen                          (i_wen                          ),   // FIFO write enable
    .i_weoc                         (i_weoc                         ),   // FIFO write end of cell
    .i_waddr                        (i_waddr                        ),   // FIFO internal write address of cell
    .i_wdata                        (i_wdata                        ),   // FIFO write data
    .o_full                         (o_full                         ),   // FIFO full
    .o_alfull                       (o_alfull                       ),   // FIFO almost full, the threshold depends on the ALFULL_TH parameter

    .i_ren                          (i_ren                          ),   // FIFO read enable
    .i_reoc                         (i_reoc                         ),   // FIFO read end of cell
    .i_raddr                        (i_raddr                        ),   // FIFO internal read address of cell
    .o_rdata                        (o_rdata                        ),   // FIFO read data
    .o_empty                        (o_empty                        ),   // FIFO empty
    .o_alempty                      (o_alempty                      ),   // FIFO almost empty, the threshold depends on the ALEMPTY_TH parameter

    .o_ram_wen                      (w_ram_wen                      ),
    .o_ram_waddr                    (w_ram_waddr                    ),
    .o_ram_wdata                    (w_ram_wdata                    ),
    .o_ram_raddr                    (w_ram_raddr                    ),
    .i_ram_rdata                    (w_ram_rdata                    ),

    .o_overflow                     (o_overflow                     ),
    .o_underflow                    (o_underflow                    ),
    .o_debug_cnt                    (o_debug_cnt                    )  
) ;

Simple_dual_port_RAM #(
    .addr_bits                      (AWIDTH                         ),
    .data_bits                      (DWIDTH                         ),
    .rd_data_reg_enable             (REG_OUT                        ),          
    .ramstyle                       (RAM_TYPE                       )           
) u_Simple_dual_port_RAM (
    .aclk                           (i_clk_sys                      ),
    .awr_en                         (w_ram_wen                      ),
    .awr_addr                       (w_ram_waddr                    ),
    .awr_data                       (w_ram_wdata                    ),

    .bclk                           (i_clk_sys                      ),
    .brd_addr                       (w_ram_raddr                    ),
    .brd_data                       (w_ram_rdata                    )
) ; 

endmodule
