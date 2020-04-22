#!/bin/csh
#Befor use this compile script, first set the FALCON_SIM enviroment
#setenv FALCON_SIM /home/kejiany/00_work/00_verification/10_falcon_sim/01_falcon_repo/03_add4_sim
# test bench path
#set TB_PATH=$FALCON_SIM/testcase

echo $1
set TC_NAME=$1
echo $2
set TEST_MODE=$2
if $TEST_MODE == S4X400H then
    set TC_PATH=$TB_PATH/st_S4X400H
    set CPU_INT = PCIE_MOD
    set GTH=${TB_PATH}/env/common/XckuGth.cpp
else
    set TC_PATH=$TB_PATH/st_DFC12
    set CPU_INT = CLINKH32_MOD
    set GTH=" "
endif

# test case path
#set TC_PATH=$TB_PATH/tb3_testcase_add4
set CLINKH32_PATH=$TB_PATH/bfm/clinkh32_bfm
set BFM_PATH=$TB_PATH/bfm
set ENV_PATH=$TB_PATH/env
set TESTMODE_PATH=${ENV_PATH}/testmode
set REGGEN_PATH=$TC_PATH/reggen_hpp
# GCC input define
# Testcase include path
#set INC_PATH="-I $TB_PATH -I $TC_PATH/testcase -I $CLINKH32_PATH/c -I $SFD_BFM_C_PATH -I $CTRL_BFM_C_PATH"
set INC_PATH="-I $TB_PATH -I $TC_PATH/testcase -I $CLINKH32_PATH -I $REGGEN_PATH -I $REGGEN_PATH/facility -I ./ "
# Testbench include path
set ENV_INC_PATH="-I ${ENV_PATH}/common -I ${ENV_PATH}/packet -I ${ENV_PATH}/rm -I ${ENV_PATH}/interface -I ${ENV_PATH}/xactor -I ${ENV_PATH}/scoreboard -I ${ENV_PATH}/testmode "
set CLINKH32_BFM="$CLINKH32_PATH/clinkh32_drv.cpp $CLINKH32_PATH/clinkh32.cpp "
set IGMII_BFM="$BFM_PATH/igmii_bfm/igmii_bfm.cpp "
set XGMII_BFM="$BFM_PATH/xgmii_bfm/xgmii_bfm.cpp "
set SFD_BFM="$BFM_PATH/sfd_bfm/sfd_bfm.cpp "
set AXI_BFM="$BFM_PATH/axi_lite_bfm/axi_lite.cpp"

mkdir -p $TC_NAME
#rm libs/work/_sc/ -rf

sccom -DTEST_CASE_NAME=\"$TC_NAME\"                     \
      #-std=c++11                                        \
      #-cpppath /home/kejiany/01_personal/00_software/110_gcc/110_gcc/bina   \
      #-predefmacrofile ./predef_macro_gcc48_linux_x86_64.txt                \
      -g                                                \
      -DMTI_BIND_SC_MEMBER_FUNCTION                     \
      -D{$CPU_INT}                                      \
      $INC_PATH                                         \
      $ENV_INC_PATH                                     \
      $CLINKH32_BFM                                     \
      $IGMII_BFM                                        \
      $XGMII_BFM                                        \
      $SFD_BFM                                          \
      $AXI_BFM                                          \
      $GTH                                              \
      ${TESTMODE_PATH}/Add4TestMode.cpp                 \
      ${ENV_PATH}/common/Timer.cpp                      \
      ${ENV_PATH}/common/TestCase.cpp                   \
      ${ENV_PATH}/common/TestChannel.cpp                \
      ${ENV_PATH}/common/HdlcChannel.cpp                \
      ${ENV_PATH}/common/FlowControl.cpp                \
      ${ENV_PATH}/packet/OhbFrame.cpp                   \
      ${ENV_PATH}/packet/OhbPacket.cpp                  \
      ${ENV_PATH}/packet/EthernetPacket.cpp             \
      ${ENV_PATH}/packet/HdlcFrame.cpp                  \
      ${ENV_PATH}/packet/GccPacket.cpp                  \
      ${ENV_PATH}/packet/SfdFrame.cpp                   \
      ${ENV_PATH}/rm/RmFalcon.cpp                       \
      ${ENV_PATH}/rm/Add4Process.cpp                    \
      ${ENV_PATH}/rm/GccProcess.cpp                     \
      ${ENV_PATH}/interface/SfdInterface.cpp            \
      ${ENV_PATH}/interface/AxiLiteInterface.cpp        \
      ${ENV_PATH}/xactor/xactor.cpp                     \
      ${ENV_PATH}/xactor/SfdXactor.cpp                  \
      ${ENV_PATH}/scoreboard/ScoreBoard.cpp             \
      ${ENV_PATH}/scoreboard/SfdScoreboard.cpp          \
      $TC_PATH/testcase/$TC_NAME.cpp                    \
      $ENV_PATH/common/tb_main.cpp

sccom -link                                              
