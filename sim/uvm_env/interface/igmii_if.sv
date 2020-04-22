`include "parameter.sv"

interface igmii_if(
    input               i_clk                   ,
    input               i_rst_n                 
);

logic                                               clk_en                  ;
logic                                               dv                      ;
logic   [IGMII_DW                       - 1 : 0]    d                       ;
logic                                               er                      ;

endinterface

