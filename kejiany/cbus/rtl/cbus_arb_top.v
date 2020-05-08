//=======================================================================
// Author: Kejiany
// Date  : 2020-05-07
// Module Name: cbus_arb
// Description: Arbiter for CBUS
//-----------------------------------------------------------------------
// Date         Revision        Description
// 2020-05-07   1.0             Creation
//=======================================================================

module cbus_arb_top #(
//-----------------------------------------------------------------------------------
//  Parameter Definition
//-----------------------------------------------------------------------------------
    parameter   ADDR_W                                  = 20                                    ,
    parameter   DATA_W                                  = 32                                    ,
    parameter   CFG_BLOCK_SIZE                          = 1024                                  ,
    parameter   PORT_NUM                                = 8
) (
//-----------------------------------------------------------------------------------
//  Port Definition
//-----------------------------------------------------------------------------------
    input                                               i_clk_sys                               ,
    input                                               i_rst_sys_n                             ,

    input                                               i_cbus_req                              ,
    input                                               i_cbus_rw                               ,
    output wire                                         o_cbus_ack                              ,
    input       [ADDR_W                     - 1 : 0]    i_cbus_addr                             ,
    input       [DATA_W                     - 1 : 0]    i_cbus_wdata                            ,
    output reg  [DATA_W                     - 1 : 0]    o_cbus_rdata                            ,

    output wire [PORT_NUM                   - 1 : 0]    o_cbus_sub_req                          ,
    output wire [PORT_NUM                   - 1 : 0]    o_cbus_sub_rw                           ,
    input       [PORT_NUM                   - 1 : 0]    i_cbus_sub_ack                          ,
    output wire [PORT_NUM * ADDR_W          - 1 : 0]    o_cbus_sub_addr                         ,
    output wire [PORT_NUM * DATA_W          - 1 : 0]    o_cbus_sub_wdata                        ,
    input       [PORT_NUM * DATA_W          - 1 : 0]    i_cbus_sub_rdata                        
);
//-----------------------------------------------------------------------------------
//  Signal Definition
//-----------------------------------------------------------------------------------
wire            [PORT_NUM                   - 1 : 0]    w_cbus_ack                              ;
wire            [DATA_W                     - 1 : 0]    w_cbus_rdata  [PORT_NUM - 1 : 0]        ;
//-----------------------------------------------------------------------------------
//  Main Function
//-----------------------------------------------------------------------------------
generate
genvar i ;
    for (i=0; i<PORT_NUM; i=i+1)
    begin
        cbus_arb #(
            .ADDR_W                                 (ADDR_W                                 ),
            .DATA_W                                 (DATA_W                                 ),
            .ADDR_LB                                (i * CFG_BLOCK_SIZE                     ),
            .ADDR_UB                                (((i + 1) * CFG_BLOCK_SIZE) - 1         )
        ) u_cbus_arb (
            .i_clk_sys                              (i_clk_sys                              ),
            .i_rst_sys_n                            (i_rst_sys_n                            ),

            .i_cbus_req                             (i_cbus_req                             ),
            .i_cbus_rw                              (i_cbus_rw                              ),
            .o_cbus_ack                             (w_cbus_ack[i]                          ),
            .i_cbus_addr                            (i_cbus_addr                            ),
            .i_cbus_wdata                           (i_cbus_wdata                           ),
            .o_cbus_rdata                           (w_cbus_rdata[i]                        ),

            .o_cbus_sub_req                         (o_cbus_sub_req[i]                      ),
            .o_cbus_sub_rw                          (o_cbus_sub_rw[i]                       ),
            .i_cbus_sub_ack                         (i_cbus_sub_ack[i]                      ),
            .o_cbus_sub_addr                        (o_cbus_sub_addr[i*ADDR_W +: ADDR_W]    ),
            .o_cbus_sub_wdata                       (o_cbus_sub_wdata[i*DATA_W +: DATA_W]   ),
            .i_cbus_sub_rdata                       (i_cbus_sub_rdata[i*DATA_W +: DATA_W]   )
        );
    end
endgenerate

assign o_cbus_ack = | w_cbus_ack ;

integer j ;
always @(*)
begin
    for (j=0; j<PORT_NUM; j=j+1)
    begin
        o_cbus_rdata = o_cbus_rdata | w_cbus_rdata[j] ;
    end
end

endmodule
