`ifndef OHP_ETH_PKT_INGRESS_SV
`define OHP_ETH_PKT_INGRESS_SV
import uvm_pkg::*;
`include "uvm_macros.svh"
`include "parameter.sv"

//typedef struct ohp_data_struct {
class ohp_data_ingress extends uvm_sequence_item;
    rand bit [7                                 : 0]    sm_tti                                      ;
    rand bit [7                                 : 0]    sm_bw_info                                  ;
    rand bit [GCC_DW                        - 1 : 0]    gcc0                                        ;
    rand bit [7                                 : 0]    osmc                                        ;
    rand bit [7                                 : 0]    res1                                        ;
    rand bit [7                                 : 0]    jc4                                         ;
    rand bit [7                                 : 0]    rsv0                                        ;
    rand bit [15                                : 0]    res2                                        ;
    rand bit [7                                 : 0]    pm_tcm                                      ;
    rand bit [7                                 : 0]    exp1                                        ;
    rand bit [63                                : 0]    rsv1                                        ;
    rand bit [GCC_DW                        - 1 : 0]    exp3                                        ;
    rand bit [7                                 : 0]    jc6                                         ;
    rand bit [7                                 : 0]    rsv2                                        ;
    rand bit [GCC_DW                        - 1 : 0]    gcc1                                        ;
    rand bit [GCC_DW                        - 1 : 0]    gcc2                                        ;
    rand bit [APS_DW                        - 1 : 0]    aps                                         ;
    rand bit [47                            - 1 : 0]    res3                                        ;
    rand bit [7                                 : 0]    rsi                                         ;
    rand bit [7                                 : 0]    omfi                                        ;

    `uvm_object_utils_begin(ohp_data_ingress)
        `uvm_field_int(sm_tti     , UVM_ALL_ON)
        `uvm_field_int(sm_bw_info , UVM_ALL_ON)
        `uvm_field_int(gcc0       , UVM_ALL_ON)
        `uvm_field_int(osmc       , UVM_ALL_ON)
        `uvm_field_int(res1       , UVM_ALL_ON)
        `uvm_field_int(jc4        , UVM_ALL_ON)
        `uvm_field_int(rsv0       , UVM_ALL_ON)
        `uvm_field_int(res2       , UVM_ALL_ON)
        `uvm_field_int(pm_tcm     , UVM_ALL_ON)
        `uvm_field_int(exp1       , UVM_ALL_ON)
        `uvm_field_int(rsv1       , UVM_ALL_ON)
        `uvm_field_int(exp3       , UVM_ALL_ON)
        `uvm_field_int(jc6        , UVM_ALL_ON)
        `uvm_field_int(rsv2       , UVM_ALL_ON)
        `uvm_field_int(gcc1       , UVM_ALL_ON)
        `uvm_field_int(gcc2       , UVM_ALL_ON)
        `uvm_field_int(aps        , UVM_ALL_ON)
        `uvm_field_int(res3       , UVM_ALL_ON)
        `uvm_field_int(rsi        , UVM_ALL_ON)
        `uvm_field_int(omfi       , UVM_ALL_ON)
    `uvm_object_utils_end

    function new (string name = "ohp_data") ;
        super.new(name);
    endfunction
endclass

class ohp_eth_pkt_ingress extends uvm_sequence_item;
         bit [PREAMBLE_W                    - 1 : 0]    preamble_sfd                                ;
    rand bit [UID_W                         - 1 : 0]    dmac_uid                                    ;
    rand bit [FRAME_ID_W                    - 1 : 0]    dmac_frame_id                               ;
    rand bit [CHANNEL_ID_W                  - 1 : 0]    dmac_chnl_id                                ;
    rand bit [UID_W                         - 1 : 0]    smac_uid                                    ;
    rand bit [FRAME_ID_W                    - 1 : 0]    smac_frame_id                               ;
    rand bit [CHANNEL_ID_W                  - 1 : 0]    smac_chnl_id                                ;
         bit [TYPE_LEN_W                    - 1 : 0]    length_type                                 ;
    rand bit [TX_FI_REQ_W                   - 1 : 0]    tx_fi_req                                   ;
         bit [RX_STAT_LEN                   - 1 : 0]    rx_stat                                     ;
    rand bit [RX_FI_LEN                     - 1 : 0]    rx_mfas                                     ;
    rand byte unsigned                                  i_ohp_data  []                              ;

    constraint ohp      
    {
        rx_stat[2:1] == DATA_ONLY[1:0] -> i_ohp_data.size == OHP_DAT_LEN ;
        rx_stat[2:1] == REQ_ONLY[1:0]  -> i_ohp_data.size == REQ_PAD_LEN ;
        rx_stat[2:1] == DATA_REQ[1:0]  -> i_ohp_data.size == OHP_DAT_LEN ;
    }

    `uvm_object_utils_begin(ohp_eth_pkt_ingress)
        `uvm_field_int(preamble_sfd  , UVM_ALL_ON)                              
        `uvm_field_int(dmac_uid      , UVM_ALL_ON)                              
        `uvm_field_int(dmac_frame_id , UVM_ALL_ON)                              
        `uvm_field_int(dmac_chnl_id  , UVM_ALL_ON)                              
        `uvm_field_int(smac_uid      , UVM_ALL_ON)                              
        `uvm_field_int(smac_frame_id , UVM_ALL_ON)                              
        `uvm_field_int(smac_chnl_id  , UVM_ALL_ON)                              
        `uvm_field_int(length_type   , UVM_ALL_ON)                              
        `uvm_field_int(tx_fi_req     , UVM_ALL_ON)                              
        `uvm_field_int(rx_stat       , UVM_ALL_ON)                              
        `uvm_field_int(rx_mfas       , UVM_ALL_ON)                              
        `uvm_field_array_int(i_ohp_data, UVM_ALL_ON)
    `uvm_object_utils_end

    function new (string name = "ohp_eth_pkt_ingress", bit [RX_STAT_LEN-1:0] in_stat = {RX_STAT_LEN{1'b0}});
        super.new(name);
        preamble_sfd = PREAMBLE_VALUE ;
        length_type  = TYPE_LEN_VALUE ;
        rx_stat      = in_stat        ;
    endfunction

    extern virtual function void display ();
    extern virtual function void display_ohp_data(int index);
    extern virtual function ohp_data_ingress get_ohp_data(integer index);
    extern virtual function void set_gcc(bit  [GCC_DW-1:0]    gcc0    , 
                                         bit  [GCC_DW-1:0]    gcc1    ,
                                         bit  [GCC_DW-1:0]    gcc2    ,
                                         bit  [GCC_DW-1:0]    exp     ,
                                         bit  [APS_DW-1:0]    aps     ,
                                         UINT                 idx     );
endclass

function void ohp_eth_pkt_ingress::display ();
    g_timer.display();
    $display("OHP packet length: %d", i_ohp_data.size());
    $display("--------------- OHP ETH PKT INGRESS -----------------");
    $display("Name                          Value                  ");
    $display("-----------------------------------------------------");
    $display("Preamble_SFD                : %08x", preamble_sfd     );
    $display("DMAC UID                    : %08x", dmac_uid         );
    $display("DMAC Frame ID               : %08x", dmac_frame_id[FF3_FRAME_ID_W-1:0]  );
    $display("DMAC Channel ID             : %08x", dmac_chnl_id     );
    $display("SMAC UID                    : %08x", smac_uid         );
    $display("SMAC Frame ID               : %08x", smac_frame_id[FF3_FRAME_ID_W-1:0]  );
    $display("SMAC Channel ID             : %08x", smac_chnl_id     );
    $display("Length Type                 : %08x", length_type      );
    $display("TX FI REQ                   : %08x", tx_fi_req        );
    $display("RX STAT                     : %08x", rx_stat          );
    $display("RX MFAS                     : %08x", rx_mfas          );
    $display("");
    for (int i=0; i<OH_DATA_NUM; i++)
    begin
        ohp_data_ingress pkt = get_ohp_data(i);
        //pkt.print();
        $write("OHP[%04d]: ", i);
        //display_ohp_data(i);
        $write("GCC0 : %04x  ", pkt.gcc0);
        $write("GCC1 : %04x  ", pkt.gcc1);
        $write("GCC2 : %04x  ", pkt.gcc2);
        $write("EXP  : %04x  ", pkt.exp3);
        $write("APS  : %08x  ", pkt.aps );
        $write("\n");
    end
endfunction

function ohp_data_ingress ohp_eth_pkt_ingress::get_ohp_data(integer index);
    byte unsigned data[];
    int ohp_size ;
    ohp_data_ingress r_ohp_data ;

    r_ohp_data = new("r_ohp_data");
    data = new[OH_DATA_LEN_BYTE] ;

    for (int i=0; i<OH_DATA_LEN_BYTE; i++)
    begin
        data[i] = i_ohp_data[index * OH_DATA_LEN_BYTE + i] ; 
    end

    ohp_size = r_ohp_data.unpack_bytes(data);
    //r_ohp_data.print();

    return r_ohp_data ;
endfunction

function void ohp_eth_pkt_ingress::display_ohp_data(int index);
    byte unsigned data;

    for (int i=0; i<OH_DATA_LEN_BYTE; i++)
    begin
        data = i_ohp_data[index * OH_DATA_LEN_BYTE + i] ; 
        $write("%02x", data);
    end
        $write("\n");

endfunction

function void ohp_eth_pkt_ingress::set_gcc(bit  [GCC_DW-1:0]    gcc0    , 
                                           bit  [GCC_DW-1:0]    gcc1    ,
                                           bit  [GCC_DW-1:0]    gcc2    ,
                                           bit  [GCC_DW-1:0]    exp     ,
                                           bit  [APS_DW-1:0]    aps     ,
                                           UINT                 idx     );
    byte unsigned       data[]          ;
    UINT                ohp_size        ;
    ohp_data_ingress    r_ohp_data      ;
    r_ohp_data = new("r_ohp_data") ;
    data = new[OH_DATA_LEN_BYTE] ;

    r_ohp_data.gcc0 = gcc0 ;
    r_ohp_data.gcc1 = gcc1 ;
    r_ohp_data.gcc2 = gcc2 ;
    r_ohp_data.exp3 = exp  ;
    r_ohp_data.aps  = aps  ;

    ohp_size = r_ohp_data.pack_bytes(data);
    for (int i=0; i<OH_DATA_LEN_BYTE; i++)
    begin
        this.i_ohp_data[idx * OH_DATA_LEN_BYTE + i] = data[i] ;
    end
endfunction

`endif
