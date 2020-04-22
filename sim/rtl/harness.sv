`timescale 1ns/100ps
`include "parameter.sv"
import uvm_pkg::*;
`include "uvm_macros.svh"
import testcase::*;

module harness
#(
    parameter   PRBS_TEST                       = 0                                             ,
    parameter   RXAUI_NUM                       = 2                                             ,
    parameter   SEED                            = 1                                             ,
    parameter   VERDI_ENABLE                    = 0                                             ,
    parameter   SFD_NUM                         = 1
)
();
//===========================================================================================================
// Signal definition
//===========================================================================================================
wire                                            w_sys_clk_125m                                  ;
wire                                            w_sys_rst_125m_n                                ;

// AXI_LITE address write channel
wire    [20                         : 0]        m_axi_awaddr                                    ;
wire                                            m_axi_awvalid                                   ;
wire                                            m_axi_awready                                   ;
// AXI_LITE data write channel
wire    [31                         : 0]        m_axi_wdata                                     ;
wire    [3                          : 0]        m_axi_wstrb                                     ;
wire                                            m_axi_wvalid                                    ;
wire                                            m_axi_wready                                    ;
// AXI_LITE data write response channel
wire    [1                          : 0]        m_axi_bresp                                     ;
wire                                            m_axi_bvalid                                    ;
wire                                            m_axi_bready                                    ;
// AXI_LITE read address channel
wire    [20                         : 0]        m_axi_araddr                                    ;
wire                                            m_axi_arvalid                                   ;
wire                                            m_axi_arready                                   ;
// AXI_LITE read data channel
wire    [31                         : 0]        m_axi_rdata                                     ;
wire    [1                          : 0]        m_axi_rresp                                     ;
wire                                            m_axi_rvalid                                    ;
wire                                            m_axi_rready                                    ;

wire                                            gcc_bfm_igmii_rxclk_en                          ;
wire    [7                          : 0]        gcc_bfm_igmii_rxd                               ;
wire                                            gcc_bfm_igmii_rxdv                              ;
wire                                            gcc_bfm_igmii_txclk_en                          ;
wire    [7                          : 0]        gcc_bfm_igmii_txd                               ;
wire                                            gcc_bfm_igmii_txdv                              ;

wire                                            w_slow_clk_50m                                  ;
wire                                            w_sys_clk_156m                                ;
wire                                            w_sys_rst_n_156m                              ;
wire                                            w_clk_rxaui_156m_out                            ;
wire                                            rxaui_oh1_ad_in0                                ;
wire                                            rxaui_oh1_ad_in0_n                              ;
wire                                            rxaui_oh2_ad_in0                                ;
wire                                            rxaui_oh2_ad_in0_n                              ;
wire                                            rxaui_oh1_ad_in1                                ;
wire                                            rxaui_oh1_ad_in1_n                              ;
wire                                            rxaui_oh2_ad_in1                                ;
wire                                            rxaui_oh2_ad_in1_n                              ;
wire                                            rxaui_oh1_ad_out0                               ;
wire                                            rxaui_oh1_ad_out0_n                             ;
wire                                            rxaui_oh2_ad_out1                               ;
wire                                            rxaui_oh2_ad_out1_n                             ;
wire                                            rxaui_oh1_ad_out1                               ;
wire                                            rxaui_oh1_ad_out1_n                             ;
wire                                            rxaui_oh2_ad_out0                               ;
wire                                            rxaui_oh2_ad_out0_n                             ;

wire    [RXAUI_NUM              - 1 : 0]        rxaui_tx_l0_p                                   ;
wire    [RXAUI_NUM              - 1 : 0]        rxaui_tx_l0_n                                   ;
wire    [RXAUI_NUM              - 1 : 0]        rxaui_tx_l1_p                                   ;
wire    [RXAUI_NUM              - 1 : 0]        rxaui_tx_l1_n                                   ;
wire    [RXAUI_NUM              - 1 : 0]        rxaui_rx_l0_p                                   ;
wire    [RXAUI_NUM              - 1 : 0]        rxaui_rx_l0_n                                   ;
wire    [RXAUI_NUM              - 1 : 0]        rxaui_rx_l1_p                                   ;
wire    [RXAUI_NUM              - 1 : 0]        rxaui_rx_l1_n                                   ;

wire    [RXAUI_NUM * 64         - 1 : 0]        xgmii_txd                                       ;
wire    [RXAUI_NUM * 8          - 1 : 0]        xgmii_txc                                       ;
wire    [RXAUI_NUM * 64         - 1 : 0]        xgmii_rxd                                       ;
wire    [RXAUI_NUM * 8          - 1 : 0]        xgmii_rxc                                       ;

//OHI
wire                                            w_bp_ms_ohi_n1_u_tx_p                           ;
wire                                            w_bp_ms_ohi_n1_u_tx_n                           ;
wire                                            w_bp_ms_ohi_n1_u_rx_c_p                         ;
wire                                            w_bp_ms_ohi_n1_u_rx_c_n                         ;
wire                                            w_bp_ms_ohi_n1_l_tx_p                           ;
wire                                            w_bp_ms_ohi_n1_l_tx_n                           ;
wire                                            w_bp_ms_ohi_n1_l_rx_c_p                         ;
wire                                            w_bp_ms_ohi_n1_l_rx_c_n                         ;

wire                                            w_ls_ohi_2_5_dt1                                ;
wire                                            w_ls_ohi_5_2_dt1                                ;
wire                                            w_ls_ohi_2_4_dt1                                ;
wire                                            w_ls_ohi_4_2_dt1                                ;
wire                                            w_ls_ohi_2_3_dt1                                ;
wire                                            w_ls_ohi_3_2_dt1                                ;

// SFD
wire                                            w_clk_155_52m                                   ;
wire                                            w_rst_155_52m                                   ;
wire    [7                          : 0]        w_ad_toh_sfd                                    ;

//===========================================================================================================
// Instance
//===========================================================================================================
initial
begin
    //`uvm_info ("harness", "Begin...", UVM_LOW);
    $display("Random seed: %08d", SEED);
    $random(SEED);
    run_test();
    #100us
    $finish();
end

//===========================================================================================================
// Clocks
//===========================================================================================================
clk_gen #(
    .CLK_PERIOD                             ( 8                                                 )                      
) u_sys_clk_125m (
    .o_clk                                  ( w_sys_clk_125m                                    ),
    .o_rst_n                                ( w_sys_rst_125m_n                                  )                                          
);

clk_gen #(
    .CLK_PERIOD                             ( 20                                                )                      
) u_slow_clk_50m (
    .o_clk                                  ( w_slow_clk_50m                                    ),
    .o_rst_n                                ( /*nc*/                                            )                                          
);

clk_gen #(
    .CLK_PERIOD                             ( 6.4                                               )                      
) u_slow_clk_156m (
    .o_clk                                  ( w_sys_clk_156m                                  ),
    .o_rst_n                                ( w_sys_rst_n_156m                                )                                          
);

clk_gen #(
    .CLK_PERIOD                             ( 6.43                                              )                      
) u_slow_clk_155_52m (
    .o_clk                                  ( w_clk_155_52m                                     ),
    .o_rst_n                                ( w_rst_155_52m                                     )                                          
);

//===========================================================================================================
// Interfaces
//===========================================================================================================
igmii_if igmii_if_ing(
    .i_clk              (w_sys_clk_125m         ),
    .i_rst_n            (w_sys_rst_125m_n       )
) ;

igmii_if igmii_if_eg(
    .i_clk              (w_sys_clk_125m         ),
    .i_rst_n            (w_sys_rst_125m_n       )
) ;

xgmii_if xgmii_if_ing_0(
    .i_clk              (w_clk_rxaui_156m_out   ),
    .i_rst_n            (w_sys_rst_125m_n       )
);

xgmii_if xgmii_if_eg_0(
    .i_clk              (w_clk_rxaui_156m_out   ),
    .i_rst_n            (w_sys_rst_125m_n       )
);

xgmii_if xgmii_if_ing_1(
    .i_clk              (w_clk_rxaui_156m_out   ),
    .i_rst_n            (w_sys_rst_125m_n       )
);

xgmii_if xgmii_if_eg_1(
    .i_clk              (w_clk_rxaui_156m_out   ),
    .i_rst_n            (w_sys_rst_125m_n       )
);

axi_lite_if u_axi_lite_if(
    .i_clk              (w_sys_clk_125m         ),
    .i_rst_n            (w_sys_rst_125m_n       )
);


initial
begin
    uvm_config_db#(virtual igmii_if)::set(null, "uvm_test_top.ins_18p400_env.ins_igmii_agent.ins_igmii_drv"  , "vif_igmii_ingress", igmii_if_ing);
    uvm_config_db#(virtual igmii_if)::set(null, "uvm_test_top.ins_18p400_env.ins_igmii_agent.ins_igmii_mon"  , "vif_igmii_egress" , igmii_if_eg );
    uvm_config_db#(virtual xgmii_if)::set(null, "uvm_test_top.ins_18p400_env.ins_xgmii_agent_0.ins_xgmii_drv", "vif_xgmii_ingress", xgmii_if_ing_0);
    uvm_config_db#(virtual xgmii_if)::set(null, "uvm_test_top.ins_18p400_env.ins_xgmii_agent_0.ins_xgmii_mon", "vif_xgmii_egress" , xgmii_if_eg_0 );
    uvm_config_db#(virtual xgmii_if)::set(null, "uvm_test_top.ins_18p400_env.ins_xgmii_agent_1.ins_xgmii_drv", "vif_xgmii_ingress", xgmii_if_ing_1);
    uvm_config_db#(virtual xgmii_if)::set(null, "uvm_test_top.ins_18p400_env.ins_xgmii_agent_1.ins_xgmii_mon", "vif_xgmii_egress" , xgmii_if_eg_1 );
    uvm_config_db#(virtual axi_lite_if)::set(null, "uvm_test_top.ins_18p400_env.ins_axi_lite_agent.ins_axi_lite_drv", "vif_axi_lite_if" , u_axi_lite_if);
    uvm_config_db#(int)::set(null, "uvm_test_top", "seed", SEED);
end

assign xgmii_if_eg_0.txd = xgmii_rxd[0*64 +: 64] ; 
assign xgmii_if_eg_0.txc = xgmii_rxc[0*08 +: 08] ; 
assign xgmii_if_eg_1.txd = xgmii_rxd[1*64 +: 64] ; 
assign xgmii_if_eg_1.txc = xgmii_rxc[1*08 +: 08] ; 

assign xgmii_txd[0*64 +: 64] = xgmii_if_ing_0.txd  ;
assign xgmii_txc[0*08 +: 08] = xgmii_if_ing_0.txc  ;
assign xgmii_txd[1*64 +: 64] = xgmii_if_ing_1.txd  ;
assign xgmii_txc[1*08 +: 08] = xgmii_if_ing_1.txc  ;

ip_falcon_aps_oh_s4x400h_wrapper u_ip_falcon_pas_oh_s4x400h_wrapper
(
    .reset_l                                ( w_sys_rst_125m_n                                  ),
    .clk                                    ( w_sys_clk_125m                                    ),       // 125MHz system clock
    .slow_clk                               ( w_slow_clk_50m                                    ),       // 50MHz system clock
    .clk156_out                             ( /* nc */                                          ),       // 156.25MHz from RXAUI

    .m_axi_clock                            ( w_sys_clk_125m                                    ),
    .m_axi_reset_l                          ( w_sys_rst_125m_n                                  ),
    .m_axi_awaddr                           ( u_axi_lite_if.o_axi_awaddr                        ),
    .m_axi_awvalid                          ( u_axi_lite_if.o_axi_awvalid                       ),
    .m_axi_awready                          ( u_axi_lite_if.i_axi_awready                       ),
    .m_axi_wdata                            ( u_axi_lite_if.o_axi_wdata                         ),
    .m_axi_wstrb                            ( u_axi_lite_if.o_axi_wstrb                         ),
    .m_axi_wvalid                           ( u_axi_lite_if.o_axi_wvalid                        ),
    .m_axi_wready                           ( u_axi_lite_if.i_axi_wready                        ),
    .m_axi_bresp                            ( u_axi_lite_if.i_axi_bresp                         ),
    .m_axi_bvalid                           ( u_axi_lite_if.i_axi_bvalid                        ),
    .m_axi_bready                           ( u_axi_lite_if.o_axi_bready                        ),
    .m_axi_araddr                           ( u_axi_lite_if.o_axi_araddr                        ),
    .m_axi_arvalid                          ( u_axi_lite_if.o_axi_arvalid                       ),
    .m_axi_arready                          ( u_axi_lite_if.i_axi_arready                       ),
    .m_axi_rdata                            ( u_axi_lite_if.i_axi_rdata                         ),
    .m_axi_rresp                            ( u_axi_lite_if.i_axi_rresp                         ),
    .m_axi_rvalid                           ( u_axi_lite_if.i_axi_rvalid                        ),
    .m_axi_rready                           ( u_axi_lite_if.o_axi_rready                        ),

    .external_pm_1sec                       ( /*in  std_logic := '0'            */              ),
    .pm_interrupt                           ( /*out std_logic                   */              ),

    .lo_lower                               ( /*in std_logic                    */              ),
    .lo_upper                               ( /*in std_logic                    */              ),
    .cold_reset                             ( 1'b0                                              ),  // '1' : cold reset     '0': no cold reset

    .switch_result_interrupt                ( /*out std_logic                   */              ),
    .exp_cpu_fifo_rx_interrupt              ( /*out std_logic                   */              ),

    //MS OHI
    .bp_ms_ohi_n1_u_tx_p                    ( w_bp_ms_ohi_n1_u_tx_p                             ),
    .bp_ms_ohi_n1_u_tx_n                    ( w_bp_ms_ohi_n1_u_tx_n                             ),
    .bp_ms_ohi_n1_u_rx_c_p                  ( w_bp_ms_ohi_n1_u_tx_p                             ),
    .bp_ms_ohi_n1_u_rx_c_n                  ( w_bp_ms_ohi_n1_u_tx_n                             ),
    .bp_ms_ohi_n1_l_tx_p                    ( w_bp_ms_ohi_n1_l_tx_p                             ),
    .bp_ms_ohi_n1_l_tx_n                    ( w_bp_ms_ohi_n1_l_tx_n                             ),
    .bp_ms_ohi_n1_l_rx_c_p                  ( w_bp_ms_ohi_n1_l_tx_p                             ),
    .bp_ms_ohi_n1_l_rx_c_n                  ( w_bp_ms_ohi_n1_l_tx_n                             ),

    //LS OHI
    .ls_ohi_2_5_dt1                         ( w_ls_ohi_2_5_dt1                                  ),
    .ls_ohi_5_2_dt1                         ( w_ls_ohi_2_5_dt1                                  ),
    .ls_ohi_2_4_dt1                         ( w_ls_ohi_2_4_dt1                                  ),
    .ls_ohi_4_2_dt1                         ( w_ls_ohi_2_4_dt1                                  ),
    .ls_ohi_2_3_dt1                         ( w_ls_ohi_2_3_dt1                                  ),
    .ls_ohi_3_2_dt1                         ( w_ls_ohi_2_3_dt1                                  ),

    //optical module
    .cl_modprsl                             ( /*in std_logic_vector(3 downto 0) */              ),  // '1': alarm  , '0': no alarm
    .cl_laseroff                            ( /*in std_logic_vector(3 downto 0) */              ),  // '1': alarm  , '0': no alarm
    .ad_rxs_out                             ( /*in std_logic_vector(3 downto 0) */              ),  // '1': alarm  , '0': no alarm   

    //RXAUI interface
    .clk_reconfig                           ( w_slow_clk_50m                                    ),  // 50MHz,Stable clock in transceiver and also as control clock for IDELAYCTRL
    .rxaui_clk0_125m                        ( w_sys_clk_125m                                    ),
    .rxaui_clk0_125m_n                      ( ~w_sys_clk_125m                                   ),
    .rxaui_oh1_ad_in0                       ( rxaui_oh1_ad_in0                                  ),
    .rxaui_oh1_ad_in0_n                     ( rxaui_oh1_ad_in0_n                                ),
    .rxaui_oh2_ad_in0                       ( rxaui_oh2_ad_in0                                  ),
    .rxaui_oh2_ad_in0_n                     ( rxaui_oh2_ad_in0_n                                ),
    .rxaui_oh1_ad_in1                       ( rxaui_oh1_ad_in1                                  ),
    .rxaui_oh1_ad_in1_n                     ( rxaui_oh1_ad_in1_n                                ),
    .rxaui_oh2_ad_in1                       ( rxaui_oh2_ad_in1                                  ),
    .rxaui_oh2_ad_in1_n                     ( rxaui_oh2_ad_in1_n                                ),
    .rxaui_oh1_ad_out0                      ( rxaui_oh1_ad_out0                                 ),
    .rxaui_oh1_ad_out0_n                    ( rxaui_oh1_ad_out0_n                               ),
    .rxaui_oh2_ad_out0                      ( rxaui_oh2_ad_out0                                 ),
    .rxaui_oh2_ad_out0_n                    ( rxaui_oh2_ad_out0_n                               ),
    .rxaui_oh1_ad_out1                      ( rxaui_oh1_ad_out1                                 ),
    .rxaui_oh1_ad_out1_n                    ( rxaui_oh1_ad_out1_n                               ),
    .rxaui_oh2_ad_out1                      ( rxaui_oh2_ad_out1                                 ),
    .rxaui_oh2_ad_out1_n                    ( rxaui_oh2_ad_out1_n                               ),

    //add4 SFD data interface
    .clk_155m52                             ( w_clk_155_52m                                     ),  // 155.52MHz for SFD parallel data
    .ad_toh_sfd                             ( w_ad_toh_sfd                                      ),  // connect to 1:8 ISERDES

    //igmii interface, converted from MII at top level
    .sys_clk                                ( w_sys_clk_125m                                    ),  // 125MHz 
    .igmii_rxd                              ( igmii_if_ing.d                                    ),
    .igmii_rxdv                             ( igmii_if_ing.dv                                   ),
    .igmii_rxer                             ( igmii_if_ing.er                                   ),
    .igmii_txd                              ( igmii_if_eg.d                                     ),
    .igmii_txdv                             ( igmii_if_eg.dv                                    ),
    .igmii_txer                             ( igmii_if_eg.er                                    )
);
assign igmii_if_eg.clk_en = 1'b1 ;

ip_rxaui_xilinx_vivado201604_xcku040_wrapper #(
    .rxaui_num                              ( 2                                                 )
) u_rxaui_bfm (
    .reset_l                                ( w_sys_rst_125m_n                                  ),
    .ck_mp                                  ( w_sys_clk_125m                                    ),
    .refclk_p                               ( w_sys_clk_125m                                    ),
    .refclk_n                               ( ~w_sys_clk_125m                                   ),
    .dclk                                   ( w_slow_clk_50m                                    ),
    .sys_clk_156m                           ( w_clk_rxaui_156m_out                              ),
    .clk_rxaui_156m_out                     ( w_clk_rxaui_156m_out                              ),
    .signal_detect                          ( {(RXAUI_NUM*2){1'b1}}                             ),
    .xgmii_tx_data                          ( xgmii_txd                                         ),
    .xgmii_tx_control                       ( xgmii_txc                                         ),
    .xgmii_rx_data                          ( xgmii_rxd                                         ),
    .xgmii_rx_control                       ( xgmii_rxc                                         ),
    .rxaui_tx_l0_p                          ( rxaui_tx_l0_p                                     ),
    .rxaui_tx_l0_n                          ( rxaui_tx_l0_n                                     ),
    .rxaui_tx_l1_p                          ( rxaui_tx_l1_p                                     ),
    .rxaui_tx_l1_n                          ( rxaui_tx_l1_n                                     ),
    .rxaui_rx_l0_p                          ( rxaui_rx_l0_p                                     ),
    .rxaui_rx_l0_n                          ( rxaui_rx_l0_n                                     ),
    .rxaui_rx_l1_p                          ( rxaui_rx_l1_p                                     ),
    .rxaui_rx_l1_n                          ( rxaui_rx_l1_n                                     ),
    .rh_wl                                  (                                                   ),
    .exec                                   (                                                   ),
    .op_done                                (                                                   ),
    .address                                (                                                   ),
    .wr_data                                (                                                   ),
    .rd_data                                (                                                   )
);

generate
if (PRBS_TEST == 0)
begin
    assign rxaui_rx_l0_p       = {rxaui_oh2_ad_out0   , rxaui_oh1_ad_out0  }  ;
    assign rxaui_rx_l0_n       = {rxaui_oh2_ad_out0_n , rxaui_oh1_ad_out0_n}  ;
    assign rxaui_rx_l1_p       = {rxaui_oh2_ad_out1   , rxaui_oh1_ad_out1  }  ;
    assign rxaui_rx_l1_n       = {rxaui_oh2_ad_out1_n , rxaui_oh1_ad_out1_n}  ;
    assign rxaui_oh1_ad_in0    = rxaui_tx_l0_p[0]                           ;
    assign rxaui_oh1_ad_in0_n  = rxaui_tx_l0_n[0]                           ;
    assign rxaui_oh1_ad_in1    = rxaui_tx_l1_p[0]                           ;
    assign rxaui_oh1_ad_in1_n  = rxaui_tx_l1_n[0]                           ;
    assign rxaui_oh2_ad_in0    = rxaui_tx_l0_p[1]                           ;
    assign rxaui_oh2_ad_in0_n  = rxaui_tx_l0_n[1]                           ;
    assign rxaui_oh2_ad_in1    = rxaui_tx_l1_p[1]                           ;
    assign rxaui_oh2_ad_in1_n  = rxaui_tx_l1_n[1]                           ;
end
else
begin
    assign rxaui_oh1_ad_in0    = rxaui_oh1_ad_out0                          ;
    assign rxaui_oh1_ad_in0_n  = rxaui_oh1_ad_out0_n                        ;
    assign rxaui_oh1_ad_in1    = rxaui_oh1_ad_out1                          ;
    assign rxaui_oh1_ad_in1_n  = rxaui_oh1_ad_out1_n                        ;
    assign rxaui_oh2_ad_in0    = rxaui_oh2_ad_out0                          ;
    assign rxaui_oh2_ad_in0_n  = rxaui_oh2_ad_out0_n                        ;
    assign rxaui_oh2_ad_in1    = rxaui_oh2_ad_out1                          ;
    assign rxaui_oh2_ad_in1_n  = rxaui_oh2_ad_out1_n                        ;
end
endgenerate

fix_period_pulse_gen #(
    .target_div_m                           ( 125*1000*16                                       ),  // 16 ms
    .target_div_n                           ( 1                                                 )
) u_fix_period_pulse_gen (
    .clock                                  ( w_sys_clk_125m                                    ),
    .clken                                  ( 1'b1                                              ),
    .reset_l                                ( reset_l                                           ),
    .pulse                                  ( external_pm_1sec                                  )
);

endmodule
