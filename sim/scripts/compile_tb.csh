#!/bin/csh

#Testbench environment paths
source $SCRIPT_PATH/SetEnv.cshrc
set comp_type=$1

if ($1 == dut) then
    # Just compile dut VHDL code
    #Testbench vhdl code compile
    echo "========================================================================"
    echo "                      Compiling all VHDL code                           "
    echo "========================================================================"
    
    # Compile DUT
    source $SCRIPT_PATH/dut_comp.sh $2 | tee dut_comp_log
    grep Error dut_comp_log | tee -a dut_comp_log

    if ($status == 0) then
        gv dut_comp_log
    endif
else if ($1 == rtl) then
    echo "========================================================================"
    echo "                      Compiling rtl code                                "
    echo "========================================================================"
    # Just compile rtl VHDL code
    vcom -2008 -f $SCRIPT_PATH/filelist/rtl_filelist.f | tee dut_comp_log
    grep Error dut_comp_log | tee -a dut_comp_log

    #if ($status == 0) then
    #    gv dut_comp_log
    #endif
else if ($1 == cov) then
    echo "========================================================================"
    echo "                      Compiling coverage code                           "
    echo "========================================================================"
    # Compiling coverage code
    source $SCRIPT_PATH/dut_comp.sh | tee dut_comp_log
    vcom -2008 +cover=bcefsx -f $SCRIPT_PATH/filelist/rtl_filelist.f | tee -a dut_comp_log
    grep Error dut_comp_log | tee -a dut_comp_log

    if ($status == 0) then
        gv dut_comp_log
    endif
else
    #Testbench vhdl code compile
    # Compile DUT
    source $SCRIPT_PATH/dut_comp.sh $2 | tee dut_comp_log
    grep Error dut_comp_log | tee -a dut_comp_log

    if ($status == 0) then
        gv dut_comp_log
    endif
endif
echo "----Compile finished----"
