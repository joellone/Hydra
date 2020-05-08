//=======================================================================
// Author: Kejiany
// Date  : 2020-05-07
// Module Name: cbus_arb
// Description: Arbiter for CBUS
//-----------------------------------------------------------------------
// Date         Revision        Description
// 2020-05-07   1.0             Creation
//=======================================================================

module cbus_arb #(
//-----------------------------------------------------------------------------------
//  Parameter Definition
//-----------------------------------------------------------------------------------
    parameter   ADDR_W                                  = 20                                    ,
    parameter   DATA_W                                  = 32                                    ,
    parameter   ADDR_LB                                 = 0                                     ,   // Lower bound of address
    parameter   ADDR_UB                                 = 1024                                      // Upper bound of address
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
    output wire [DATA_W                     - 1 : 0]    o_cbus_rdata                            ,

    output wire                                         o_cbus_sub_req                          ,
    output wire                                         o_cbus_sub_rw                           ,
    input                                               i_cbus_sub_ack                          ,
    output wire [ADDR_W                     - 1 : 0]    o_cbus_sub_addr                         ,
    output wire [DATA_W                     - 1 : 0]    o_cbus_sub_wdata                        ,
    input       [DATA_W                     - 1 : 0]    i_cbus_sub_rdata                        
);
//-----------------------------------------------------------------------------------
//  Signal Definition
//-----------------------------------------------------------------------------------
reg                                                     r_addr_match                            ;
//-----------------------------------------------------------------------------------
//  Main Function
//-----------------------------------------------------------------------------------
always @(*)
begin
    if (i_cbus_addr >= ADDR_LB && i_cbus_addr <= ADDR_UB)
    begin
        r_addr_match = i_cbus_req ;
    end
end

assign o_cbus_sub_req   = i_cbus_req & r_addr_match ;
assign o_cbus_sub_rw    = i_cbus_rw                 ;
assign o_cbus_sub_addr  = i_cbus_addr               ;
assign o_cbus_sub_wdata = i_cbus_wdata              ;

assign o_cbus_ack       = r_addr_match & i_cbus_sub_ack ;
assign o_cbus_rdata     = (r_addr_match == 1'b1) ? i_cbus_sub_rdata : {DATA_W{1'b0}} ;

endmodule
