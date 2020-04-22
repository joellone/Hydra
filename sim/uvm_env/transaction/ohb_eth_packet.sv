`ifndef OHB_ETH_PACKET
`define OHB_ETH_PACKET

import uvm_pkg::*;
`include "uvm_macros.svh"
`include "parameter.sv"

class ohb extends uvm_sequence_item;
    rand bit [PORT_ID_W                     - 1 : 0]    id                                          ;
    rand bit [SZ_DW                         - 1 : 0]    sz                                          ;
    rand bit [MFAS_DW                       - 1 : 0]    rf                                          ;
    rand bit [AG_DW                         - 1 : 0]    ag                                          ;
    rand bit [MFAS_DW                       - 1 : 0]    mfas                                        ;
    rand bit [7                                 : 0]    rsv0                                        ;
    rand bit [GCC_DW                        - 1 : 0]    gcc0                                        ;
    rand bit [GCC_DW                        - 1 : 0]    exp                                         ;
    rand bit [GCC_DW                        - 1 : 0]    gcc1                                        ;
    rand bit [GCC_DW                        - 1 : 0]    gcc2                                        ;
    rand bit [APS_DW                        - 1 : 0]    aps                                         ;
    rand bit [15                                : 0]    rsv1                                        ;

    `uvm_object_utils_begin(ohb)
        `uvm_field_int(id         , UVM_ALL_ON)
        `uvm_field_int(sz         , UVM_ALL_ON)
        `uvm_field_int(rf         , UVM_ALL_ON)
        `uvm_field_int(ag         , UVM_ALL_ON)
        `uvm_field_int(mfas       , UVM_ALL_ON)
        `uvm_field_int(rsv0       , UVM_ALL_ON)
        `uvm_field_int(gcc0       , UVM_ALL_ON)
        `uvm_field_int(exp        , UVM_ALL_ON)
        `uvm_field_int(gcc1       , UVM_ALL_ON)
        `uvm_field_int(gcc2       , UVM_ALL_ON)
        `uvm_field_int(aps        , UVM_ALL_ON)
        `uvm_field_int(rsv1       , UVM_ALL_ON)
    `uvm_object_utils_end

    function new (string name = "ohb") ;
        super.new(name);
    endfunction

    function void display();
        $write("ag   : %02x  ", ag  );
        $write("rf   : %04x  ", rf  );
        $write("sz   : %04x  ", sz  );
        $write("id   : %04x  ", id  );
        $write("mfas : %02x  ", mfas);
        $write("GCC0 : %04x  ", gcc0);
        $write("EXP  : %04x  ", exp );
        $write("GCC1 : %04x  ", gcc1);
        $write("GCC2 : %04x  ", gcc2);
        $write("APS  : %08x  ", aps );
        $write("\n");
    endfunction
endclass

class ohb_eth_packet extends uvm_sequence_item;
    rand bit [PREAMBLE_W                    - 1 : 0]    preamble_sfd                                ;
    rand bit [DMAC_W                        - 1 : 0]    dmac                                        ;
    rand bit [SMAC_W                        - 1 : 0]    smac                                        ;
    rand bit [VLAN_W                        - 1 : 0]    vlan                                        ;
    rand bit [TYPE_LEN_W                    - 1 : 0]    length_type                                 ;
    rand bit [15                                : 0]    pad_byte                                    ;
    rand byte unsigned                                  payload[]                                   ;

    constraint preamble {preamble_sfd == PREAMBLE_VALUE;}
    constraint length   
    {
        length_type == 16'h05DD;
        pad_byte    == 16'hFFFF;
    }
    //constraint payload_w
    //{
    //    payload.size >= (MIN_ETH_LEN - ETH_HEAD_LEN - GCC_HEAD_LEN); 
    //    payload.size <  (MAX_ETH_LEN - ETH_HEAD_LEN - GCC_HEAD_LEN) ;
    //}
    //constraint payload_w{payload.size >= (MIN_ETH_LEN - ETH_HEAD_LEN - GCC_HEAD_LEN); payload.size < (MIN_ETH_LEN - ETH_HEAD_LEN - GCC_HEAD_LEN + 1);}

    `uvm_object_utils_begin(ohb_eth_packet)
        `uvm_field_int(preamble_sfd  , UVM_ALL_ON)                              
        `uvm_field_int(dmac          , UVM_ALL_ON)                              
        `uvm_field_int(smac          , UVM_ALL_ON)                              
        `uvm_field_int(vlan          , UVM_ALL_ON)                              
        `uvm_field_int(length_type   , UVM_ALL_ON)                              
        `uvm_field_int(pad_byte      , UVM_ALL_ON)                              
        `uvm_field_array_int(payload , UVM_ALL_ON)
    `uvm_object_utils_end

    function new (string name = "ohb_eth_packet");
        super.new(name);
    endfunction

    extern function void post_randomize();
    extern virtual function void display ();
    extern virtual function UINT get_ethhead_len();
    extern virtual function UINT get_pkt_len();
    extern virtual function void attach_fcs();
    extern virtual function bit[FCS_W-1:0] crc_cal(byte unsigned data_in, bit[FCS_W-1:0] lfsr_q);
    extern virtual function byte byte_reverse(byte in_byte);
    extern virtual function UINT get_ohb_num();
    extern virtual function ohb get_ohb(UINT ohb_index);
    extern virtual function void set_gcc(bit  [GCC_DW-1:0]    gcc0    , 
                                         bit  [GCC_DW-1:0]    gcc1    ,
                                         bit  [GCC_DW-1:0]    gcc2    ,
                                         bit  [GCC_DW-1:0]    exp     ,
                                         bit  [APS_DW-1:0]    aps     ,
                                         bit  [MFAS_DW-1:0]   mfas    ,
                                         bit  [PORT_ID_W:0]   port_id ,
                                         UINT                 idx     );
endclass

function void ohb_eth_packet::post_randomize();
    attach_fcs() ;
endfunction

function UINT ohb_eth_packet::get_ohb_num();
    UINT                        ag_index = AG                       ;
    UINT                        rf_index = RF                       ;
    UINT                        sz_index = SZ                       ;
    UINT                        id_index = ID                       ;
    UINT                        ohb_num  = 0                        ;

    if (payload[sz_index] != OHBU_DATA_LEN)
    begin
        `uvm_warning ("ohb_eth_packet", "Error packet, without OHBU");
        for (int i=0; i<payload.size; i++)
        begin
            if (i % 20 == 0) $write("%03d: ", i/16) ;
            $write("%02x ", payload[i]) ;
            if (i % 20 == 19) $write("\n") ;
        end
        $write("\n");
        return 0 ;
    end

    while (sz_index < payload.size && (sz_index + OHBU_DATA_LEN) < payload.size)
    begin
        //$display("id_index: ", id_index);
        if (payload[sz_index] == OHBU_DATA_LEN)
        begin
            ohb_num ++ ;
            sz_index = sz_index + OH_DATA_LEN ;
        end
        else
        begin
            break ;
        end
    end

    return ohb_num ;
endfunction

function ohb ohb_eth_packet::get_ohb(UINT ohb_index);
    byte unsigned           data[]                  ;
    UINT                    ohb_start               ;
    UINT                    ohb_size                ;
    ohb                     r_ohb                   ;

    r_ohb   = new("r_ohb")  ;
    data    = new[OH_DATA_LEN]  ;

    ohb_start = OH_DATA_LEN * ohb_index ;
    for (UINT i=0; i<OH_DATA_LEN; i++)
    begin
        data[i] = payload[ohb_start + i] ;
    end

    ohb_size = r_ohb.unpack_bytes(data);

    return r_ohb ;
endfunction

function void ohb_eth_packet::display ();
    UINT ohb_num ;
    g_timer.display();
    $display("Payload length: %02d", payload.size());
    $display("------------------ OHB ETH Packet -------------------");
    $display("Name                          Value                  ");
    $display("-----------------------------------------------------");
    $display("DMAC                        : %012x", dmac            );
    $display("SMAC                        : %012x", smac            );
    $display("VLAN                        : %08x" , vlan            );
    $display("Length Type                 : %04x" , length_type     );
    $display("Padding Byte                : %04x" , pad_byte        );
    for (int i=0; i<payload.size; i++)
    begin
        if (i % 20 == 0) $write("%03d: ", i/16) ;
        $write("%02x ", payload[i]) ;
        if (i % 20 == 19) $write("\n") ;
    end
    $write("\n");
    //ohb_num = get_ohb_num() ;
    //for (UINT i=0; i<ohb_num; i++)
    //begin
    //    get_ohb(i).display();
    //end
endfunction

function UINT ohb_eth_packet::get_ethhead_len();
    return DMAC_LEN + SMAC_LEN + VLAN_LEN + TYPE_LEN ;
endfunction

function UINT ohb_eth_packet::get_pkt_len();
    return this.payload.size() ;
endfunction

function void ohb_eth_packet::attach_fcs();
    bit     [FCS_W      - 1 : 0]    crc_data                ;
    bit     [FCS_W      - 1 : 0]    poly                    ;
    byte unsigned                   data_pack[]             ;
    bit                             in_data                 ;
    UINT                            pkt_len                 ;

    //$display("Calculating GCC packet FCS, payload size: %d", payload.size());
    if (payload.size() <= MIN_ETH_LEN - ETH_HEAD_LEN - GCC_HEAD_LEN - FCS_LEN)
    begin
        `uvm_error("GCC Packet", "Payload is not initialized.");
    end

    crc_data = {FCS_W{1'b1}} ;
    pkt_len  = this.pack_bytes(data_pack) / 8 - FCS_LEN;
    
    for (int i=0; i<pkt_len; i++)
    begin
        //$display("CRC: %04x, in bit: %x", crc_data, original_data[i]) ;
        //in_data = data_pack[i] ^ crc_data[FCS_W-1];
        //poly = FCS_POLY & {{(FCS_W-1){in_data}}, 1'b0};
        //crc_data = {crc_data[FCS_W-2:0], in_data} ^ poly ;
        crc_data = crc_cal(byte_reverse(data_pack[i]), crc_data) ;
        //$display("%02d, in: %x, FCS: %08x", i, data_pack[i], crc_data);
    end

    crc_data = crc_data ^ {32{1'b1}};

    //$display("FCS: %08x", crc_data);

    for (int i=0; i<FCS_LEN; i++)
    begin
        payload[payload.size() - FCS_LEN + i] = byte_reverse(crc_data[8*(FCS_LEN-i-1) +: 8]) ;
        //$display("%02d, in: %x", payload.size() - FCS_LEN + i, payload[payload.size() - FCS_LEN + i]);
    end
endfunction

function bit[FCS_W-1:0] ohb_eth_packet::crc_cal(byte unsigned data_in, bit[FCS_W-1:0] lfsr_q);
    bit [FCS_W-1:0] lfsr_c ;

    lfsr_c[0]  = lfsr_q[24] ^ lfsr_q[30] ^ data_in[0] ^ data_in[6];
    lfsr_c[1]  = lfsr_q[24] ^ lfsr_q[25] ^ lfsr_q[30] ^ lfsr_q[31] ^ data_in[0] ^ data_in[1] ^ data_in[6] ^ data_in[7];
    lfsr_c[2]  = lfsr_q[24] ^ lfsr_q[25] ^ lfsr_q[26] ^ lfsr_q[30] ^ lfsr_q[31] ^ data_in[0] ^ data_in[1] ^ data_in[2] ^ data_in[6] ^ data_in[7];
    lfsr_c[3]  = lfsr_q[25] ^ lfsr_q[26] ^ lfsr_q[27] ^ lfsr_q[31] ^ data_in[1] ^ data_in[2] ^ data_in[3] ^ data_in[7];
    lfsr_c[4]  = lfsr_q[24] ^ lfsr_q[26] ^ lfsr_q[27] ^ lfsr_q[28] ^ lfsr_q[30] ^ data_in[0] ^ data_in[2] ^ data_in[3] ^ data_in[4] ^ data_in[6];
    lfsr_c[5]  = lfsr_q[24] ^ lfsr_q[25] ^ lfsr_q[27] ^ lfsr_q[28] ^ lfsr_q[29] ^ lfsr_q[30] ^ lfsr_q[31] ^ data_in[0] ^ data_in[1] ^ data_in[3] ^ data_in[4] ^ data_in[5] ^ data_in[6] ^ data_in[7];
    lfsr_c[6]  = lfsr_q[25] ^ lfsr_q[26] ^ lfsr_q[28] ^ lfsr_q[29] ^ lfsr_q[30] ^ lfsr_q[31] ^ data_in[1] ^ data_in[2] ^ data_in[4] ^ data_in[5] ^ data_in[6] ^ data_in[7];
    lfsr_c[7]  = lfsr_q[24] ^ lfsr_q[26] ^ lfsr_q[27] ^ lfsr_q[29] ^ lfsr_q[31] ^ data_in[0] ^ data_in[2] ^ data_in[3] ^ data_in[5] ^ data_in[7];
    lfsr_c[8]  = lfsr_q[0]  ^ lfsr_q[24] ^ lfsr_q[25] ^ lfsr_q[27] ^ lfsr_q[28] ^ data_in[0] ^ data_in[1] ^ data_in[3] ^ data_in[4];
    lfsr_c[9]  = lfsr_q[1]  ^ lfsr_q[25] ^ lfsr_q[26] ^ lfsr_q[28] ^ lfsr_q[29] ^ data_in[1] ^ data_in[2] ^ data_in[4] ^ data_in[5];
    lfsr_c[10] = lfsr_q[2]  ^ lfsr_q[24] ^ lfsr_q[26] ^ lfsr_q[27] ^ lfsr_q[29] ^ data_in[0] ^ data_in[2] ^ data_in[3] ^ data_in[5];
    lfsr_c[11] = lfsr_q[3]  ^ lfsr_q[24] ^ lfsr_q[25] ^ lfsr_q[27] ^ lfsr_q[28] ^ data_in[0] ^ data_in[1] ^ data_in[3] ^ data_in[4];
    lfsr_c[12] = lfsr_q[4]  ^ lfsr_q[24] ^ lfsr_q[25] ^ lfsr_q[26] ^ lfsr_q[28] ^ lfsr_q[29] ^ lfsr_q[30] ^ data_in[0] ^ data_in[1] ^ data_in[2] ^ data_in[4] ^ data_in[5] ^ data_in[6];
    lfsr_c[13] = lfsr_q[5]  ^ lfsr_q[25] ^ lfsr_q[26] ^ lfsr_q[27] ^ lfsr_q[29] ^ lfsr_q[30] ^ lfsr_q[31] ^ data_in[1] ^ data_in[2] ^ data_in[3] ^ data_in[5] ^ data_in[6] ^ data_in[7];
    lfsr_c[14] = lfsr_q[6]  ^ lfsr_q[26] ^ lfsr_q[27] ^ lfsr_q[28] ^ lfsr_q[30] ^ lfsr_q[31] ^ data_in[2] ^ data_in[3] ^ data_in[4] ^ data_in[6] ^ data_in[7];
    lfsr_c[15] = lfsr_q[7]  ^ lfsr_q[27] ^ lfsr_q[28] ^ lfsr_q[29] ^ lfsr_q[31] ^ data_in[3] ^ data_in[4] ^ data_in[5] ^ data_in[7];
    lfsr_c[16] = lfsr_q[8]  ^ lfsr_q[24] ^ lfsr_q[28] ^ lfsr_q[29] ^ data_in[0] ^ data_in[4] ^ data_in[5];
    lfsr_c[17] = lfsr_q[9]  ^ lfsr_q[25] ^ lfsr_q[29] ^ lfsr_q[30] ^ data_in[1] ^ data_in[5] ^ data_in[6];
    lfsr_c[18] = lfsr_q[10] ^ lfsr_q[26] ^ lfsr_q[30] ^ lfsr_q[31] ^ data_in[2] ^ data_in[6] ^ data_in[7];
    lfsr_c[19] = lfsr_q[11] ^ lfsr_q[27] ^ lfsr_q[31] ^ data_in[3] ^ data_in[7];
    lfsr_c[20] = lfsr_q[12] ^ lfsr_q[28] ^ data_in[4];
    lfsr_c[21] = lfsr_q[13] ^ lfsr_q[29] ^ data_in[5];
    lfsr_c[22] = lfsr_q[14] ^ lfsr_q[24] ^ data_in[0];
    lfsr_c[23] = lfsr_q[15] ^ lfsr_q[24] ^ lfsr_q[25] ^ lfsr_q[30] ^ data_in[0] ^ data_in[1] ^ data_in[6];
    lfsr_c[24] = lfsr_q[16] ^ lfsr_q[25] ^ lfsr_q[26] ^ lfsr_q[31] ^ data_in[1] ^ data_in[2] ^ data_in[7];
    lfsr_c[25] = lfsr_q[17] ^ lfsr_q[26] ^ lfsr_q[27] ^ data_in[2] ^ data_in[3];
    lfsr_c[26] = lfsr_q[18] ^ lfsr_q[24] ^ lfsr_q[27] ^ lfsr_q[28] ^ lfsr_q[30] ^ data_in[0] ^ data_in[3] ^ data_in[4] ^ data_in[6];
    lfsr_c[27] = lfsr_q[19] ^ lfsr_q[25] ^ lfsr_q[28] ^ lfsr_q[29] ^ lfsr_q[31] ^ data_in[1] ^ data_in[4] ^ data_in[5] ^ data_in[7];
    lfsr_c[28] = lfsr_q[20] ^ lfsr_q[26] ^ lfsr_q[29] ^ lfsr_q[30] ^ data_in[2] ^ data_in[5] ^ data_in[6];
    lfsr_c[29] = lfsr_q[21] ^ lfsr_q[27] ^ lfsr_q[30] ^ lfsr_q[31] ^ data_in[3] ^ data_in[6] ^ data_in[7];
    lfsr_c[30] = lfsr_q[22] ^ lfsr_q[28] ^ lfsr_q[31] ^ data_in[4] ^ data_in[7];
    lfsr_c[31] = lfsr_q[23] ^ lfsr_q[29] ^ data_in[5];

    return lfsr_c ;
endfunction

function byte ohb_eth_packet::byte_reverse(byte in_byte);
    byte out_byte ;
    for (int i=0; i<8; i++)
    begin
        out_byte[i] = in_byte[7-i];
    end

    return out_byte ;
endfunction

function void ohb_eth_packet::set_gcc(bit  [GCC_DW-1:0]    gcc0    , 
                                      bit  [GCC_DW-1:0]    gcc1    ,
                                      bit  [GCC_DW-1:0]    gcc2    ,
                                      bit  [GCC_DW-1:0]    exp     ,
                                      bit  [APS_DW-1:0]    aps     ,
                                      bit  [MFAS_DW-1:0]   mfas    ,
                                      bit  [PORT_ID_W:0]   port_id ,
                                      UINT                 idx     );
    byte unsigned       data[]          ;
    UINT                ohp_size        ;
    ohb                 r_ohb_data      ;

    r_ohb_data = new("r_ohb_data") ;
    data = new[OH_DATA_LEN] ;

    r_ohb_data.id   = port_id ;
    r_ohb_data.ag   = 0    ;
    r_ohb_data.rf   = mfas ;
    r_ohb_data.sz   = OHBU_DATA_LEN ;
    r_ohb_data.mfas = mfas ;
    r_ohb_data.gcc0 = gcc0 ;
    r_ohb_data.gcc1 = gcc1 ;
    r_ohb_data.gcc2 = gcc2 ;
    r_ohb_data.exp  = exp  ;
    r_ohb_data.aps  = aps  ;
    //r_ohb_data.display();

    ohp_size = r_ohb_data.pack_bytes(data);
    for (int i=0; i<OH_DATA_LEN; i++)
    begin
        this.payload[idx * OH_DATA_LEN + i] = data[i] ;
    end
endfunction
`endif
