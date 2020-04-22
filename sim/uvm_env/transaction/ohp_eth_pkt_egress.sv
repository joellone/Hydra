`ifndef OHP_ETH_PKT_EGRESS
`define OHP_ETH_PKT_EGRESS
import uvm_pkg::*;
`include "uvm_macros.svh"
`include "parameter.sv"

//typedef struct ohp_data_struct {
class ohp_data_egress extends uvm_sequence_item;
    rand bit [TX_INS_EN_W                   - 1 : 0]    tx_ins_en                                   ;
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

    `uvm_object_utils_begin(ohp_data_egress)
        `uvm_field_int(tx_ins_en  , UVM_ALL_ON)
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

    function void display();
        $write("TX_INS_EN : %010x  ", tx_ins_en);
        $write("GCC0 : %04x  ", gcc0);
        $write("GCC1 : %04x  ", gcc1);
        $write("GCC2 : %04x  ", gcc2);
        $write("EXP : %04x  ", exp3);
        $write("APS : %08x  ", aps );
        $write("\n");
    endfunction
endclass

class ohp_eth_pkt_egress extends uvm_sequence_item;
    rand bit [PREAMBLE_W                    - 1 : 0]    preamble_sfd                                ;
    rand bit [UID_W                         - 1 : 0]    dmac_uid                                    ;
    rand bit [FRAME_ID_W                    - 1 : 0]    dmac_frame_id                               ;
    rand bit [CHANNEL_ID_W                  - 1 : 0]    dmac_chnl_id                                ;
    rand bit [UID_W                         - 1 : 0]    smac_uid                                    ;
    rand bit [FRAME_ID_W                    - 1 : 0]    smac_frame_id                               ;
    rand bit [CHANNEL_ID_W                  - 1 : 0]    smac_chnl_id                                ;
    rand bit [TYPE_LEN_W                    - 1 : 0]    length_type                                 ;
    rand bit [RX_FI_LEN                     - 1 : 0]    tx_mfas                                     ;
    rand byte unsigned                                  i_ohp_data  []                              ;

    constraint preamble {preamble_sfd == PREAMBLE_VALUE;}
    constraint length   {length_type  == TYPE_LEN_VALUE;}
    constraint frameid  {dmac_frame_id <= MAX_FRAME_ID; smac_frame_id <= MAX_FRAME_ID;}
    constraint chnlid   {dmac_chnl_id <= MAX_CHANNEL_ID; smac_chnl_id <= MAX_CHANNEL_ID;}
    constraint ohp      {i_ohp_data.size == OH_DATA_NUM * (OH_DATA_LEN_BYTE + TX_INS_EN_LEN);}

    `uvm_object_utils_begin(ohp_eth_pkt_egress)
        `uvm_field_int(preamble_sfd  , UVM_ALL_ON)                              
        `uvm_field_int(dmac_uid      , UVM_ALL_ON)                              
        `uvm_field_int(dmac_frame_id , UVM_ALL_ON)                              
        `uvm_field_int(dmac_chnl_id  , UVM_ALL_ON)                              
        `uvm_field_int(smac_uid      , UVM_ALL_ON)                              
        `uvm_field_int(smac_frame_id , UVM_ALL_ON)                              
        `uvm_field_int(smac_chnl_id  , UVM_ALL_ON)                              
        `uvm_field_int(length_type   , UVM_ALL_ON)                              
        `uvm_field_int(tx_mfas       , UVM_ALL_ON)                              
        `uvm_field_array_int(i_ohp_data, UVM_ALL_ON)
    `uvm_object_utils_end

    function new (string name = "ohp_eth_pkt_egress");
        super.new(name);
    endfunction

    extern virtual function void display ();
    extern virtual function ohp_data_egress get_ohp_data(integer index);
    extern virtual function UINT get_aps_level(UINT ohp_index);
endclass

function void ohp_eth_pkt_egress::display ();
    g_timer.display();
    $display("--------------- OHP ETH PKT EGRESS ------------------");
    $display("Name                          Value                  ");
    $display("-----------------------------------------------------");
    $display("Preamble_SFD                : %08x", preamble_sfd     );
    $display("DMAC UID                    : %08x", dmac_uid         );
    $display("DMAC Frame ID               : %08x", dmac_frame_id    );
    $display("DMAC Channel ID             : %08x", dmac_chnl_id     );
    $display("SMAC UID                    : %08x", smac_uid         );
    $display("SMAC Frame ID               : %08x", smac_frame_id    );
    $display("SMAC Channel ID             : %08x", smac_chnl_id     );
    $display("Length Type                 : %08x", length_type      );
    $display("TX MFAS                     : %08x", tx_mfas          );
    $display("");
    for (int i=0; i<OH_DATA_NUM; i++)
    begin
        ohp_data_egress pkt = get_ohp_data(i);
        $write("OHP[%01d] : ", i);
        pkt.display();
    end
endfunction

function ohp_data_egress ohp_eth_pkt_egress::get_ohp_data(integer index);
    byte unsigned                                           data[]                          ;
    bit     [OH_DATA_LEN_BYTE                   - 1 : 0]    eg_insert_bit                   ;
    UINT                                                    ohp_size                        ;
    ohp_data_egress                                         r_ohp_data                      ;

    r_ohp_data = new("r_ohp_data");
    data = new[OH_DATA_LEN_BYTE+TX_INS_EN_LEN] ;

    for (int i=0; i<OH_DATA_LEN_BYTE+TX_INS_EN_LEN; i++)
    begin
        data[i] = i_ohp_data[index * (OH_DATA_LEN_BYTE+TX_INS_EN_LEN) + i] ; 
    end

    for (int i=0; i<TX_INS_EN_LEN; i++)
    begin
        for (int j=0; j<8; j++)
        begin
            eg_insert_bit[8*i + j] = data[i][7-j] ;
        end
    end
    //$display("Engress insert bit: %x", eg_insert_bit);

    for (int i=0; i<OH_DATA_LEN_BYTE; i++)
    begin
        if (eg_insert_bit[i] == 1'b0)
        begin
            data[TX_INS_EN_LEN + i] = 8'h0 ;
        end
    end

    ohp_size = r_ohp_data.unpack_bytes(data);
    //r_ohp_data.print();

    return r_ohp_data ;
endfunction

function UINT ohp_eth_pkt_egress::get_aps_level(UINT ohp_index);
    return (tx_mfas + ohp_index) % APS_LEVEL_NUM ;
endfunction

`endif
