`include "parameter.sv"

interface tx_internal_if (
    input               i_clk                   ,
    input               i_rst_n                 
);

logic                                               data_en                 ;
logic   [TX_DATA_W                      - 1 : 0]    data                    ;
logic                                               sop                     ;
logic                                               eop                     ;
logic   [PORT_ID_W                      - 1 : 0]    port_id                 ;

endinterface
