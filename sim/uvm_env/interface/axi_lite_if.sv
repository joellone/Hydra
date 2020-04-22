`include "parameter.sv"

interface axi_lite_if(
    input               i_clk                   ,
    input               i_rst_n                 
);


// AXI_LITE address write channel
logic   [AXI_LITE_AW            - 1 : 0]    o_axi_awaddr                ;
logic                                       o_axi_awvalid               ;
logic                                       i_axi_awready               ;
// AXI_LITE data write channel
logic   [AXI_LITE_DW            - 1 : 0]    o_axi_wdata                 ;
logic   [AXI_LITE_STRB          - 1 : 0]    o_axi_wstrb                 ;
logic                                       o_axi_wvalid                ;
logic                                       i_axi_wready                ;
// AXI_LITE data write response channel
logic   [AXI_LITE_RSPW          - 1 : 0]    i_axi_bresp                 ;
logic                                       i_axi_bvalid                ;
logic                                       o_axi_bready                ;
// AXI_LITE read address channel
logic   [AXI_LITE_AW            - 1 : 0]    o_axi_araddr                ;
logic                                       o_axi_arvalid               ;
logic                                       i_axi_arready               ;
// AXI_LITE read data channel
logic   [AXI_LITE_DW            - 1 : 0]    i_axi_rdata                 ;
logic   [AXI_LITE_RSPW          - 1 : 0]    i_axi_rresp                 ;
logic                                       i_axi_rvalid                ;
logic                                       o_axi_rready                ;

assign o_axi_bready = i_axi_bvalid ;

endinterface


