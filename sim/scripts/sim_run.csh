#!/bin/csh

#setenv SCRIPT_PATH <scripts path>
setenv UVM_DPI_HOME /EDA_SW_64/modelsim/questa_10.5c/questasim/uvm-1.1d/linux_x86_64/

source $SCRIPT_PATH/SetEnv.cshrc

set TC_NAME=$1

if ($?BOARD_TYPE) then
else
    if ($?2) then
        set BOARD_TYPE $2
    else
        echo "Error board type not set!"
    endif
endif

if ($?3) then
    if ($3 == PRBS_TEST) then
        set PRBS_TEST=1
    else
        set PRBS_TEST=0
    endif

    if ($3 == COVER) then
        set COV=1
    else
        if ($?COVER) then
            set COV=1
        else
            set COV=0
        endif
    endif
else
    set PRBS_TEST=0

    if ($?COVER) then
        set COV=1
    else
        set COV=0
    endif
endif

if ($?VERDI_EN) then
else
    set VERDI_EN=0
endif

if ($?SEED) then
    if ($SEED == 0) then
        set SEED=`date +"%m%d%H%M%S"`
    endif
else
    set SEED=`date +"%m%d%H%M%S"`
endif
#set SEED=`date +"%y%m%d%H%M%S"`
echo "Simulation seed: $SEED"

#if ($COV == 1) then
#    vcom -2008 +cover=sbce -f $SCRIPT_PATH/filelist/rtl_filelist.f
#endif

#rm work/_sc -rf
#source $SCRIPT_PATH/tc_compile.sh $TC_NAME $BOARD_TYPE
# status 0: success
#        1: fail
if ($status == 0) then
    if ($BOARD_TYPE == S4X400H) then
        echo "############################################################################"
        echo "                          Simulating S4X400H                                "
        echo "############################################################################"

        mkdir -p ${TC_NAME}

        vlog +incdir+$TB_PATH/uvm_env                                                               \
             +incdir+$TB_PATH/verification                                                          \
             +incdir+/EDA_SW_64/modelsim/questa_10.5c/questasim/verilog_src/uvm-1.1d/src/           \
             -L mtiAvm -L mtiOvm -L mtiUvm -L mtiUPF -f $SCRIPT_PATH/filelist/uvm_env.f

        vlog +incdir+$TB_PATH/uvm_env                                                               \
             +incdir+$TB_PATH/verification                                                          \
             +incdir+/EDA_SW_64/modelsim/questa_10.5c/questasim/verilog_src/uvm-1.1d/src/           \
             -L mtiAvm -L mtiOvm -L mtiUvm -L mtiUPF $TB_PATH/verification/testcase/${TC_NAME}.sv

        vlog +incdir+$TB_PATH/uvm_env $TB_PATH/rtl/harness.sv

        if ($VERDI_EN == 1) then
            vsim    -t 1ps                          \
                    harness                         \
                    +UVM_TESTNAME=${TC_NAME}        \
                    -pli $NOVAS_HOME/share/PLI/MODELSIM/LINUX64/novas_fli.so    \
                    -L unisims_ver                  \
                    -L secureip                     \
                    glbl                            \
                    -voptargs="+acc"                \
                    -keepstdout                     \
                    -c                              \
                    #-sv_lib                         \
                    #$UVM_DPI_HOME/uvm_dpi           \
                    -gSEED=$SEED                    \
                    -gVERDI_ENABLE=1\
                    -do ${SCRIPT_PATH}/run_vsim.do
        else if ($COV == 1) then
            vsim    -t 1ps                          \
                    harness                         \
                    +UVM_TESTNAME=${TC_NAME}        \
                    -L unisims_ver                  \
                    -L secureip                     \
                    glbl                            \
                    -keepstdout                     \
                    #-batch                          \
                    -c                              \
                    -coverage                       \
                    -gSEED=$SEED                    \
                    -gTC_NAME=${TC_NAME}            \
                    -do ${SCRIPT_PATH}/run_vsim_cov.do
        else
            vsim    -t 1ps                          \
                    harness                         \
                    +UVM_TESTNAME=${TC_NAME}        \
                    -L unisims_ver                  \
                    -L secureip                     \
                    glbl                            \
                    -voptargs="+acc"                \
                    -keepstdout                     \
                    -batch                          \
                    -gSEED=$SEED                    \
                    -gVERDI_ENABLE=0\
                    -do ${SCRIPT_PATH}/run_vsim.do
        endif

        cp harness.fsdb ./${TC_NAME}/${TC_NAME}.fsdb
        cp compile_log ./${TC_NAME}/${TC_NAME}.log
    else if ($BOARD_TYPE == 18P400) then
        echo "############################################################################"
        echo "                          Simulating 18P400                                 "
        echo "                          TestCase: $TC_NAME                                "
        echo "############################################################################"

        mkdir -p ${TC_NAME}

        vlog +incdir+$TB_PATH/uvm_env                                                               \
             +incdir+$TB_PATH/verification                                                          \
             +incdir+/EDA_SW_64/modelsim/questa_10.5c/questasim/verilog_src/uvm-1.1d/src/           \
             -L mtiAvm -L mtiOvm -L mtiUvm -L mtiUPF -f $SCRIPT_PATH/filelist/uvm_env.f

        vlog +incdir+$TB_PATH/uvm_env                                                               \
             +incdir+$TB_PATH/verification                                                          \
             +incdir+/EDA_SW_64/modelsim/questa_10.5c/questasim/verilog_src/uvm-1.1d/src/           \
             -L mtiAvm -L mtiOvm -L mtiUvm -L mtiUPF $TB_PATH/verification/testcase/${TC_NAME}.sv

             #-L mtiAvm -L mtiOvm -L mtiUvm -L mtiUPF $TB_PATH/uvm_env/base_test/$TC_NAME.sv

        vlog +incdir+$TB_PATH/uvm_env $TB_PATH/rtl/harness.sv

        if ($VERDI_EN == 1) then
            vsim    -t 100ps                        \
                    harness                         \
                    +UVM_TESTNAME=${TC_NAME}        \
                    -pli $NOVAS_HOME/share/PLI/MODELSIM/LINUX64/novas_fli.so    \
                    -keepstdout                     \
                    -c                              \
                    -sv_lib                         \
                    $UVM_DPI_HOME/uvm_dpi           \
                    -gSEED=$SEED                    \
                    -gVERDI_ENABLE=1\
                    -do ${SCRIPT_PATH}/run_vsim.do
        else if ($COV == 1) then
            vsim    -t 100ps                        \
                    harness                         \
                    +UVM_TESTNAME=${TC_NAME}        \
                    -keepstdout                     \
                    #-batch                          \
                    -c                              \
                    -coverage                       \
                    -gSEED=$SEED                    \
                    -gTC_NAME=${TC_NAME}            \
                    -do ${SCRIPT_PATH}/run_vsim_cov.do
        else
            vsim    -t 100ps                        \
                    harness                         \
                    +UVM_TESTNAME=${TC_NAME}        \
                    -keepstdout                     \
                    -batch                          \
                    -gSEED=$SEED                    \
                    -gVERDI_ENABLE=0\
                    -do ${SCRIPT_PATH}/run_vsim.do
        endif

        cp harness.fsdb ./${TC_NAME}/${TC_NAME}.fsdb
        cp compile_log ./${TC_NAME}/${TC_NAME}.log
    else
        echo "############################################################################"
        echo "                          Simulating DFC12                                  "
        echo "############################################################################"

        vlog $TB_PATH/st_DFC12/rtl/harness_test_mode.sv
        if ($VERDI_EN == 1) then
            vsim    -t 100ps                        \
                    harness                         \
                    -pli $NOVAS_HOME/share/PLI/MODELSIM/LINUX64/novas_fli.so   \
                    -keepstdout                     \
                    -c                              \
                    -gVERDI_ENABLE=1\
                    -do ${SCRIPT_PATH}/run_vsim.do
        else if ($COV == 1) then
            vsim    -t 100ps                        \
                    harness                         \
                    -keepstdout                     \
                    #-batch                          \
                    -c                              \
                    -coverage                       \
                    -gTC_NAME=$TC_NAME              \
                    -do ${SCRIPT_PATH}/run_vsim_cov.do
        else
            vsim    -t 100ps                        \
                    harness                         \
                    -keepstdout                     \
                    -batch                          \
                    -gVERDI_ENABLE=0\
                    -do ${SCRIPT_PATH}/run_vsim.do
        endif
    endif
    #vsim harness novas -c -do run_vsim.do
    #source $SCRIPT_PATH/run_sim.sh $TC_NAME $BOARD_TYPE
    cp verification_log ${TC_NAME}/${TC_NAME}.log
endif
