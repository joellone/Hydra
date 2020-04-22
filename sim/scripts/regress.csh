#!/bin/csh

source $SCRIPT_PATH/SetEnv.cshrc

if ($1 == DFC12) then
    make dut comp=DFC12

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
else if ($1 == TESTMOD) then
    make dut comp=DFC12

    set testcases = (svf_testmod_8byte                          \
                     svf_testmod_9byte                          \
                     svf_testmod_67byte                         \
                     svf_testmod_68byte                         \
                     svf_testmod_all_cover                      \
                     svf_testmod_bandw                          \
                     svf_testmod_mix                            \
                     svf_testmod_rand_byte                      \
                     svf_testmod_robust                         )
else if ($1 == 18P400) then
    make dut comp=18P400

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
                     svp_ff3_req_only_latency                   )
else
    make dut comp=S4X400H

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

#foreach tc ($testcases)
#    echo "Making $tc"
#    make tb tc=$tc cmd=DFC12
#    if ($status != 0) then
#        exit 1
#    endif
#end

echo "Running regression" > regression_log
foreach tc ($testcases)
    date                                                                    >> regression_log
    echo "=====================Regression: ${tc}======================"     >> regression_log
    make sim tc=$tc cmd=$1 | tee compile_log
    grep "PASSED" ./${tc}/${tc}_log                                         >> regression_log
    grep "FAILED" ./${tc}/${tc}_log                                         >> regression_log
    echo "log_file: ./${tc}/${tc}_log"                                      >> regression_log

    #save fadb file
    if ($?VERDI_EN) then
        if ($VERDI_EN == 1) then
            mv tb2_falcon_aps_oh_top.fsdb ./${tc}/${tc}.fsdb
        endif
    endif
end
date                                                    >> regression_log
