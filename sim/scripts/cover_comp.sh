#!/bin/csh

#Testbench vhdl code compile
echo "========================================================================"
echo "                      Compiling VHDL coverage                           "
echo "========================================================================"

##Verdi lib compile
#echo "----Verdi lib compile----"
#rm novas -rf
#vlib novas
#vmap novas novas
#vcom -work novas ./novas.vhd
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

echo "Compiling coverage code..."
vcom -2008 +cover=sbce -f $SCRIPTS/filelist/rtl_filelist.f
echo " "
echo " "
