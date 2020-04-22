#!/bin/csh

set comp_type=$1

#Testbench vhdl code compile
echo "========================================================================"
echo "                          Compiling VHDL code                           "
echo "========================================================================"

#rm work -rf
mkdir -p work 
vlib work
##Verdi lib compile
#echo "----Verdi lib compile----"
#vcom ./novas.vhd
#echo " "
#echo " "

#work lib
echo "----Work lib compile----"
vmap secureip               ${LIB_PATH}/secureip
vmap simprims_ver           ${LIB_PATH}/simprims_ver
vmap unifast                ${LIB_PATH}/unifast
vmap unifast_ver            ${LIB_PATH}/unifast_ver
vmap unimacro               ${LIB_PATH}/unimacro
vmap unimacro_ver           ${LIB_PATH}/unimacro_ver
vmap unisim                 ${LIB_PATH}/unisim
vmap unisims_ver            ${LIB_PATH}/unisims_ver
#vmap xilinxcorelib          /EDA/verify/SimLib/simLib_v002/questa10.7c/vivado_2018.2/xilinxcorelib
#vmap xilinxcorelib_ver      /EDA/verify/SimLib/simLib_v002/questa10.7c/vivado_2018.2/xilinxcorelib_ver
vmap work                   work
vmap c                      work
vmap shanghai_common        work
vmap shanghai_common_vendor work
vmap odu_sncp_1n_fsm        work
vmap altera_mf              work

vcom -2008 $ALT_LIB_PATH/altera_mf_components.vhd
vcom -2008 $ALT_LIB_PATH/altera_mf.vhd
echo " "
echo " "
echo "compiling c common"
vcom -f ${SCRIPT_PATH}/filelist/c_common.f
echo " "
echo " "
echo "compiling shanghai common"
vcom -f $SCRIPT_PATH/filelist/shanghai_common_vendor.f
vcom -f $SCRIPT_PATH/filelist/shanghai_common_filelist.f
echo " "
echo " "
echo "compiling verilog rtl"
vlog +incdir+$FALCON_ROOT/rtl/gcc_proc/common/ -f ${SCRIPT_PATH}/filelist/verilog_filelist.f
vlog -f ${SCRIPT_PATH}/filelist/fifo.f
#vlog $FALCON_ROOT/src/public/supplier_ip_vivado_2016.4_xcku040/example_design/*.v
vlog $TB_PATH/st_S4X400H/rtl/supplier_ip_vivado_2016.4_xcku040/example_design/ip_rxaui_xilinx_vivado201604_xcku040_gt_common_wrapper.v
vlog $TB_PATH/st_S4X400H/rtl/supplier_ip_vivado_2016.4_xcku040/example_design/gtwizard_ultrascale_v1_6_gthe3_common.v
vlog $VIVADO_HOME/data/verilog/src/glbl.v
#vlog $FALCON_ROOT/src/public/supplier_ip_vivado_2016.4_xcku040/ip_0/hdl/*.v
#echo "compiling SFD bfm"
#vcom -f $FALCON_SIM/scripts/bfm_filelist.f
echo " "
echo " "
echo "compiling vhdl rtl"
vcom -2008 -f $SCRIPT_PATH/filelist/bfm_filelist.f
vcom -2008 -f $SCRIPT_PATH/filelist/rtl_filelist.f

if $comp_type == S4X400H then
    echo "==============S4X400H================="
    vcom -2008 $SHANGHAI_COMMON/shanghai_common/Signal_clock_true_dual_port_RAM_With_Depth.vhd
    vlog ${TB_PATH}/st_S4X400H/rtl/harness.sv
else
    if $comp_type == testmode then
        echo "==============TEST MODE================="
        vlog ${TB_PATH}/st_DFC12/rtl/Signal_clock_true_dual_port_RAM_With_Depth_Common.sv
        vcom -2008 ${TB_PATH}/st_DFC12/rtl/Signal_clock_true_dual_port_RAM_With_Depth.vhd
        vlog ${TB_PATH}/st_DFC12/rtl/harness_test_mode.sv
    else
        echo "==============DFC12================="
        vcom -2008 $SHANGHAI_COMMON/shanghai_common/Signal_clock_true_dual_port_RAM_With_Depth.vhd
    endif
endif

echo " "
echo " "
