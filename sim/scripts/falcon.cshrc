#!/bin/csh

#Set envirament parameters
source /vobs/oam_vob/ip_falcon_oh/top_sim/testbench_systemc/scripts/SetEnv.cshrc

mkdir -p sim
cp ${SCRIPT_PATH}/modelsim.ini ./sim
cp ${SCRIPT_PATH}/makefile ./sim
cp ${TB_PATH}/include/sc_dpiheader.h ./sim
cd sim
chmod 755 ./*
