`include "parameter.sv"

interface mac_10g_if(
    input               i_clk                   ,
    input               i_rst_n                 
);

logic                                               clk_en                  ;
logic                                               dv                      ;
logic                                               data_en                 ;
logic   [MAC_DWIDTH                     - 1 : 0]    data                    ;
logic                                               sop                     ;
logic                                               eop                     ;
logic   [MAC_MOD_WIDTH                  - 1 : 0]    empty                   ;
logic                                               error                   ;

endinterface

