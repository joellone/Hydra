#!/bin/csh

set LOG_FILE = cover_log
set CMD = $1

echo "=========================================================================================="
echo "                          Collecting coverage: $CMD                                       "
echo "=========================================================================================="

if ($CMD == DFC12) then
    set testcases = (svf_add4_multi_chnl_rand                   \
                     svf_add4_one_chnl_rand                     \
                     svf_ohb_ag                                 \
                     svf_ohb_ag_multi_chnl                      \
                     svp_add4_igmii_signl_chnl_2048byte         \
                     svp_add4_igmii_signl_chnl_64byte           \
                     svf_pcc_multi_chnl                         \
                     svf_sfd_interrupt                          \
                     svf_sfd_map                                \
                     svf_sfd_sanity                             \
                     svf_xgmii_loopback                         )
else if ($CMD == TESTMOD) then
    set testcases = (svf_testmod_8byte                          \
                     svf_testmod_9byte                          \
                     svf_testmod_67byte                         \
                     svf_testmod_68byte                         \
                     svf_testmod_all_cover                      \
                     svf_testmod_bandw                          \
                     svf_testmod_mix                            \
                     svf_testmod_rand_byte                      \
                     svf_testmod_robust                         )
else if ($CMD == 18P400) then
    set testcases = (svf_aps_sanity                             \
                     svf_aps_multi_chnl                         \
                     svf_fixed_chnl_data_only                   \
                     svf_rand_chnl_data_only                    \
                     svf_fixed_chnl_req_only                    \
                     svf_rand_chnl_req_only                     \
                     svf_fixed_chnl_req_data                    \
                     svf_rand_chnl_req_data                     \
                     svf_rand_chnl_mix                          \
                     svf_ohp_tx_gap                             \
                     svp_ff3_data_only                          \
                     svp_ff3_req_data                           \
                     svp_ff3_req_data_latency                   \
                     svp_ff3_req_only                           \
                     svp_ff3_req_only_latency                   \
                     svr_da_check                               \
                     svr_fifo_full                              )
else
    set testcases = (svf_add4_multi_chnl_rand                   \
                     svf_add4_one_chnl_rand                     \
                     svf_ohb_ag                                 \
                     svf_ohb_ag_multi_chnl                      \
                     svp_add4_igmii_signl_chnl_2048byte         \
                     svp_add4_igmii_signl_chnl_64byte           \
                     svf_pcc_multi_chnl                         \
                     svf_sfd_interrupt                          \
                     svf_sfd_map                                \
                     svf_sfd_sanity                             \
                     svf_xgmii_loopback                         )
endif

make dut comp=cov type=$CMD

set MERGE_FILE = harness.ucdb

echo "Running regression" > $LOG_FILE
foreach tc ($testcases)
    date                                                >> $LOG_FILE
    echo "==========================================="  >> $LOG_FILE
    echo "Regressing: $tc"                              >> $LOG_FILE     
    make sim tc=$tc cmd=$CMD type=COVER
    grep "PASSED" ./$tc/$tc.log                         >> $LOG_FILE     
    grep "FAILED" ./$tc/$tc.log                         >> $LOG_FILE    
    echo "log_file: ./$tc/$tc.log"                      >> $LOG_FILE     

    #save fadb file
    #mv tb2_falcon_aps_oh_top.fsdb ./$tc/$tc.fsdb
    mv ${tc}.ucdb ${tc}

    set MERGE_FILE = ($MERGE_FILE $tc/$tc.ucdb)
end
date                                                    >> $LOG_FILE

echo ${MERGE_FILE}
vcover merge ${MERGE_FILE}
vcover report -details -source -html harness.ucdb
