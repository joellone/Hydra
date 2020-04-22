`ifndef GCC_PACKET
`define GCC_PACKET

import uvm_pkg::*;
`include "uvm_macros.svh"
`include "parameter.sv"
//`include "transaction/ethernet_packet.sv"
class gcc_packet extends uvm_sequence_item;
    rand bit [DMAC_W                        - 1 : 0]    dmac                                        ;
    rand bit [SMAC_W                        - 1 : 0]    smac                                        ;
    rand bit [VLAN_W                        - 1 : 0]    vlan                                        ;
    rand bit [TYPE_LEN_W                    - 1 : 0]    length_type                                 ;
    rand bit [7                                 : 0]    gcc_chnl                                    ;
    rand bit [7                                 : 0]    gcc_type                                    ;
    rand bit [7                                 : 0]    gcc_sub_type                                ;
    rand bit [7                                 : 0]    gcc_ecc_id_0                                ;
    rand bit [7                                 : 0]    gcc_ecc_id_1                                ;
    rand byte unsigned                                  payload[]                                   ;

    constraint length   
    {
        length_type == 16'h88B7;
    }
    constraint payload_w
    {
        payload.size >= (MIN_ETH_LEN - ETH_HEAD_LEN - GCC_HEAD_LEN) ; 
        payload.size <  (MAX_ETH_LEN - ETH_HEAD_LEN - GCC_HEAD_LEN) ;
    }
    //constraint payload_w{payload.size >= (MIN_ETH_LEN - ETH_HEAD_LEN - GCC_HEAD_LEN); payload.size < (MIN_ETH_LEN - ETH_HEAD_LEN - GCC_HEAD_LEN + 1);}

    `uvm_object_utils_begin(gcc_packet)
//        `uvm_field_int(preamble      , UVM_ALL_ON)
        `uvm_field_int(dmac          , UVM_ALL_ON)                              
        `uvm_field_int(smac          , UVM_ALL_ON)                              
        `uvm_field_int(vlan          , UVM_ALL_ON)                              
        `uvm_field_int(length_type   , UVM_ALL_ON)                              
        `uvm_field_int(gcc_chnl      , UVM_ALL_ON)                              
        `uvm_field_int(gcc_type      , UVM_ALL_ON)                              
        `uvm_field_int(gcc_sub_type  , UVM_ALL_ON)                              
        `uvm_field_int(gcc_ecc_id_0  , UVM_ALL_ON)                              
        `uvm_field_int(gcc_ecc_id_1  , UVM_ALL_ON)                              
        `uvm_field_array_int(payload , UVM_ALL_ON)
    `uvm_object_utils_end

    function new (string name = "gcc_packet");
        super.new(name);
    endfunction

    extern function void post_randomize();
    extern virtual function void display ();
    extern virtual function UINT get_ethhead_len();
    extern virtual function UINT get_pkt_len();
    extern virtual function void attach_fcs();
    extern virtual function bit[FCS_W-1:0] crc_cal(byte unsigned data_in, bit[FCS_W-1:0] lfsr_q);
    extern virtual function byte byte_reverse(byte in_byte);
endclass

function void gcc_packet::post_randomize();
    attach_fcs() ;
endfunction

function void gcc_packet::display ();
    UINT ohb_num ;
    g_timer.display();
    $display("Payload length: %02d", payload.size());
    $display("-------------------- GCC Packet -----------------------");
    $display("Name                          Value                    ");
    $display("-------------------------------------------------------");
    $display("DMAC                        : %012x", dmac            );
    $display("SMAC                        : %012x", smac            );
    $display("VLAN                        : %08x" , vlan            );
    $display("Length Type                 : %04x" , length_type     );
    $display("GCC Channel                 : %02x" , gcc_chnl        );
    $display("GCC Type                    : %02x" , gcc_type        );
    $display("GCC Sub Type                : %02x" , gcc_sub_type    );
    $display("GCC ECC ID 0                : %02x" , gcc_ecc_id_0    );
    $display("GCC ECC ID 1                : %02x" , gcc_ecc_id_1    );
    for (int i=0; i<payload.size; i++)
    begin
        if (i % 16 == 0) $write("%03d: ", i/16) ;
        $write("%02x ", payload[i]) ;
        if (i % 16 == 15) $write("\n") ;
    end
    $write("\n");
endfunction

function UINT gcc_packet::get_ethhead_len();
    return DMAC_LEN + SMAC_LEN + VLAN_LEN + TYPE_LEN ;
endfunction

function UINT gcc_packet::get_pkt_len();
    return this.payload.size() ;
endfunction

function void gcc_packet::attach_fcs();
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

function bit[FCS_W-1:0] gcc_packet::crc_cal(byte unsigned data_in, bit[FCS_W-1:0] lfsr_q);
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

function byte gcc_packet::byte_reverse(byte in_byte);
    byte out_byte ;
    for (int i=0; i<8; i++)
    begin
        out_byte[i] = in_byte[7-i];
    end

    return out_byte ;
endfunction

`endif
