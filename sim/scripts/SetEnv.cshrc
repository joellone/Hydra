#!/bin/csh

#start necessary views
ct startview cc_view 
ct startview jinglonl_ip_rxaui_prj_int 
ct startview liudalin_ip_eth10g_prj_int 
ct startview rbhuang_view 
ct startview tndwq_shanghai_common_int_new_update

#configure environment parameter
#TB file path configure
setenv TB_PATH /home/kejiany/00_work/00_verify/01_falcon_repo/06_S4X400H/testbench_systemv
setenv SCRIPT_PATH ${TB_PATH}/scripts
setenv TC_PATH $TB_PATH/verification/testcase
#RTL file path configure
setenv FALCON_ROOT ~/00_work/00_verify/01_falcon_repo/02_falcon_prj
setenv XGMII_MAC_PATH /view/liudalin_ip_eth10g_prj_int/vobs/oam_vob/ip_eth10g/rtl/xgmii_mac
setenv RXAUI_PATH /view/jinglonl_ip_rxaui_prj_int/vobs/oam_vob/ip_rxaui/rtl/rxaui
setenv SHANGHAI_COMMON /view/tndwq_shanghai_common_int_new_update/vobs/oam_vob/shanghai_common_v2/rtl
setenv ODUSNCP /view/rbhuang_view/vobs/imt_vob/global_reuse_modules/ftp_reuse/odusncp/modules/rtl

setenv LIB_PATH /opt/fpga/simLib_v002/questa10.7c/vivado_2018.2
setenv ALT_LIB_PATH /opt/fpga/altera_v002/15.1/quartus/eda/sim_lib

#project command
alias lstc 'ls $TB_PATH/verification/testcase'
alias sprj 'source $SCRIPT_PATH/SetEnv.cshrc'
