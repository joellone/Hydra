`include "parameter.sv"

interface clinkh32_if(
    input               i_clk                   ,
    input               i_rst_n                 
);


logic                                       rh_wl                           ; 
logic                                       exec                            ; 
logic                                       op_done                         ; 
logic   [CPU_IF_AW              - 1 : 0]    address                         ; 
logic   [CPU_IF_DW              - 1 : 0]    wr_data                         ; 
logic   [CPU_IF_DW              - 1 : 0]    rd_data                         ; 

endinterface


