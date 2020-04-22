`ifndef FALCON_PARAMETERS
`define FALCON_PARAMETERS

parameter   CPU_IF_AW                               = 21                            ;
parameter   CPU_IF_DW                               = 32                            ;

parameter   MAC_DWIDTH                              = 64                            ;
parameter   MAC_DWIDTH_BYTE                         = MAC_DWIDTH / 8                ;
parameter   MAC_MOD_WIDTH                           = 3                             ;

parameter   PREAMBLE_LEN                            = 8                             ;   // Preamble length
parameter   PREAMBLE_W                              = 64                            ;
parameter   PREAMBLE_VALUE                          = 64'h55_55_55_55_55_55_55_D5   ;
parameter   DMAC_LEN                                = 6                             ;   // DMAC length
parameter   SMAC_LEN                                = 6                             ;   // DMAC length
parameter   VLAN_LEN                                = 4                             ;
parameter   TYPE_LEN                                = 2                             ;   // Type/length field length
parameter   TYPE_LEN_VALUE                          = 16'h05_DD                     ;   // Fixed type 0x05DD
parameter   OHBU_CTRL_LEN                           = 4                             ;
parameter   OHBU_DATA_LEN                           = 16                            ;
parameter   OH_DATA_LEN                             = OHBU_CTRL_LEN + OHBU_DATA_LEN ;   // Bit length of sigle OHB Data
parameter   FCS_LEN                                 = 4                             ;
parameter   FCS_W                                   = FCS_LEN * 8                   ;
parameter   FCS_POLY                                = 32'h4c11db7                   ;
parameter   ETH_HEAD_LEN                            = DMAC_LEN                      + 
                                                      SMAC_LEN                      + 
                                                      VLAN_LEN                      +
                                                      TYPE_LEN                      ;

parameter   MAX_ETH_LEN                             = 1024                          ;
parameter   MIN_ETH_LEN                             = 64                            ;
parameter   GCC_HEAD_LEN                            = 5                             ;
parameter   MAX_HDLC_LEN                            = 1024                         ;
parameter   MIN_HDLC_LEN                            = 64                            ;

parameter   DMAC_W                                  = DMAC_LEN * 8                  ;   // DMAC field width
parameter   SMAC_W                                  = SMAC_LEN * 8                  ;   // SMAC field width
parameter   VLAN_W                                  = VLAN_LEN * 8                  ;   // VLAN field width
parameter   TYPE_LEN_W                              = TYPE_LEN * 8                  ;   // Type/length field width 
parameter   PORT_ID_W                               = 8                             ;
parameter   MFAS_DW                                 = 8                             ;
parameter   AG_DW                                   = 8                             ;
parameter   SZ_DW                                   = 8                             ;
parameter   GCC_DW                                  = 16                            ;
parameter   EXP_DW                                  = GCC_DW                        ;
parameter   APS_DW                                  = 32                            ;

parameter   RXAUI_NUM                               = 2                             ;
parameter   MAX_ADD4_NUM                            = 1                             ;
parameter   MAX_PORT_ID                             = 64                            ;
parameter   MAX_PORT_NO                             = 8                             ;
parameter   MAX_GCC_CHNL_NO                         = 1                             ;
parameter   MAX_EXP_CHNL_NO                         = 8                             ;
parameter   MAX_APS_CHNL_NO                         = 32                            ;
parameter   MAX_CHNL_NO                             = 8                             ;
parameter   MAX_CHANNEL_ID                          = 8                             ;
parameter   GCC_TYPE_NUM                            = 3                             ;
parameter   GCC_CHNL_NUM_W                          = 7                             ;
parameter   EXP_CHNL_NUM_W                          = 7                             ;
parameter   CHANNEL_ID_W                            = 8                             ;
parameter   PORT_NO_W                               = 5                             ;

parameter   XGMII_DW                                = 64                            ;
parameter   XGMII_CW                                = XGMII_DW / 8                  ;
parameter   XGMII_IDLE                              = 8'h07                         ;
parameter   XGMII_START                             = 8'hFB                         ;
parameter   XGMII_END                               = 8'hFD                         ;
parameter   IGMII_DW                                = 8                             ;

parameter   HDLC_IDLE                               = 8'h7E                         ;
parameter   HDLC_IDLE_IDLE                          = {HDLC_IDLE, HDLC_IDLE}        ;
parameter   HDLC_IDLE_LEN                           = 8                             ;
parameter   HDLC_CRC_POLY                           = 16'h1021                      ;
parameter   HDLC_CRC_W                              = 16                            ;

parameter   GCC_DW_B                                = 2                             ;   // 2 Byte
parameter   APS_LEVEL_NUM                           = 8                             ;
parameter   APS_CHNL_W                              = 10                            ;
parameter   APS_LEVEL_W                             = 3                             ;
parameter   APS_IDLE                                = 32'hFFFF_FFFF                 ;

parameter   GCC_BW                                  = 64                            ;
parameter   XGMII_BW                                = 4000                          ;   // Mbps
parameter   IGMII_BW                                = 500                           ;   // Mbps
parameter   CPU_FIFO_BW                             = 100                           ;   // Mbps
parameter   HDLC_BW                                 = GCC_BW                        ;   // Mbps

parameter   MAX_IGMII_PKT_LEN                       = 2048                          ;
parameter   IGMII_TYPE_VALUE                        = 16'h88B7                      ;

//AXI lite interface
parameter   AXI_LITE_AW                             = 21                            ;
parameter   AXI_LITE_DW                             = 32                            ;
parameter   AXI_LITE_STRB                           = AXI_LITE_DW / 8               ;
parameter   AXI_LITE_RSPW                           = 2                             ;

typedef     enum {FALSE = -1, TRUE = 0}             BOOL                            ;
typedef     enum {ORIGIN, INSERTED}                 enHdlcType                      ;
typedef     enum {  GCC_CHNL    = 0     ,
                    GCC_TYPE            ,
                    GCC_SUB_TYPE        ,
                    GCC_ECC_ID_0        ,
                    GCC_ECC_ID_1        ,
                    PAY_LOAD            }           enGccChnl                       ;
typedef     enum {  GCC0        = 0     , 
                    GCC1                , 
                    GCC2                , 
                    EXP                 , 
                    APS                 , 
                    GCC                 }           enChnlType                      ;
typedef     enum {READ, WRITE}                      enOpMod                         ;
typedef     enum {DATA_ONLY = 1 , 
                  REQ_ONLY  = 2 , 
                  DATA_REQ  = 3 }                   enPktType                       ;
//typedef     enum {AG = 0, RF, SZ, ID}               enOhbCtrl                       ;
typedef     enum {ID, SZ, RF, AG}               enOhbCtrl                       ;

typedef     int unsigned                            UINT                            ;

typedef enum {G2M_DA        = 0     , 
              G2M_DA_SA             , 
              G2M_SA                , 
              G2M_VLAN              , 
              G2M_TYPE_CHNL         , 
              G2M_ECCID             ,
              M2G_DA        = 16    ,
              M2G_DA_SA             , 
              M2G_SA                , 
              M2G_VLAN              , 
              M2G_TYPE_CHNL         , 
              M2G_ECCID             } enGccProvRam ;

`endif
