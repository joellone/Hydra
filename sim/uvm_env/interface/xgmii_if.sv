`include "parameter.sv"

interface xgmii_if(
    input               i_clk                   ,
    input               i_rst_n                 
);

logic                                               clk_en                  ;
logic   [XGMII_CW                       - 1 : 0]    txc                     ;
logic   [XGMII_DW                       - 1 : 0]    txd                     ;

endinterface

