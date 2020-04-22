import uvm_pkg::*;
`include "uvm_macros.svh"
`include "parameter.sv"

class tx_internal extends uvm_sequence_item;
    // Cycle 0
    rand bit [RSV0_CYC0                     - 1 : 0]    rsv0_cyc0                   ;
    rand bit [GCC_INSERT_EN_W               - 1 : 0]    gcc_insert_en               ;
    rand bit [RSV1_CYC0                     - 1 : 0]    rsv1_cyc0                   ;
    rand bit [TX_FI_REQ_W                   - 1 : 0]    tx_fi_req                   ;
    rand bit [CHANNEL_ID_W                  - 1 : 0]    channel_id                  ;
    rand bit [FRAME_ID_W                    - 1 : 0]    frame_id                    ;
    // Cycle 1
    rand bit [RSV0_CYC1                     - 1 : 0]    rsv0_cyc1                   ;
    rand bit [APS_DW                        - 1 : 0]    aps                         ;
    rand bit [RSV1_CYC1                     - 1 : 0]    rsv1_cyc1                   ;
    rand bit                                            aps_map_en                  ;
    rand bit [RSV2_CYC1                     - 1 : 0]    rsv2_cyc1                   ;
    rand bit [APS_LEVEL_W                   - 1 : 0]    aps_rx_level                ;
    // Cycle 2~9
    rand byte                                           exp_gcc[]                   ;

    `uvm_object_utils_begin(tx_internal)
        // Cycle 0
        `uvm_field_int(rsv0_cyc0    , UVM_ALL_ON) 
        `uvm_field_int(gcc_insert_en, UVM_ALL_ON) 
        `uvm_field_int(rsv1_cyc0    , UVM_ALL_ON) 
        `uvm_field_int(tx_fi_req    , UVM_ALL_ON) 
        `uvm_field_int(channel_id   , UVM_ALL_ON) 
        `uvm_field_int(frame_id     , UVM_ALL_ON) 
        // Cycle 1
        `uvm_field_int(rsv0_cyc1    , UVM_ALL_ON) 
        `uvm_field_int(aps          , UVM_ALL_ON) 
        `uvm_field_int(rsv1_cyc1    , UVM_ALL_ON) 
        `uvm_field_int(aps_map_en   , UVM_ALL_ON) 
        `uvm_field_int(rsv2_cyc1    , UVM_ALL_ON) 
        `uvm_field_int(aps_rx_level , UVM_ALL_ON) 
        // Cycle 2~9
        `uvm_field_array_int(exp_gcc, UVM_ALL_ON)
    `uvm_object_utils_end

    function new (string name = "tx_internal");
        super.new(name);
    endfunction

    extern function void display();
endclass

function void tx_internal::display();
    this.print();
    for (int i=0; i<OH_DATA_NUM; i++)
    begin
        $display("EXP: %02x%02x, GCC2: %02x%02x, GCC1: %02x%02x, GCC0: %02x%02x", exp_gcc[8*i + 0], 
                                                                                  exp_gcc[8*i + 1], 
                                                                                  exp_gcc[8*i + 2], 
                                                                                  exp_gcc[8*i + 3], 
                                                                                  exp_gcc[8*i + 4], 
                                                                                  exp_gcc[8*i + 5], 
                                                                                  exp_gcc[8*i + 6], 
                                                                                  exp_gcc[8*i + 7]);
    end
endfunction
