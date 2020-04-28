#!/bin/csh

#echo "Setting software ehnviroment"

setenv SOFTWARE_PATH /home/kejiany/01_personal/00_software
################################################################
# Verdi configure:
# Verdi Path: /home/kejiany/01_personal/00_software/vJ-2014.12-SP2
################################################################
setenv NOVAS_HOME /EDA/verify/Synopsys/verdi/Verdi_N-2017.12
if ($?LD_LIBRARY_PATH) then
    #setenv LD_LIBRARY_PATH ${LD_LIBRARY_PATH}:${NOVAS_HOME}/share/PLI/lib/LINUX/
    setenv LD_LIBRARY_PATH ${LD_LIBRARY_PATH}:${NOVAS_HOME}/share/PLI/MODELSIM/LINUX64/
else
    setenv LD_LIBRARY_PATH ${NOVAS_HOME}/share/PLI/MODELSIM/LINUX64/
endif

setenv PATH ${PATH}:/usr/share/man:/opt/fpga/acrobat/95/Adobe/Reader9/bin:/opt/fpga/script:/opt/fpga/script/rtlman:/usr/atria/bin
setenv PATH ${PATH}:${NOVAS_HOME}/bin

#if ($?PKG_CONFIG_PATH) then
#    setenv PKG_CONFIG_PATH ${SOFTWARE_PATH}/103_libevent/lib/pkgconfig:${PKG_CONFIG_PATH}
#else
#    setenv PKG_CONFIG_PATH ${SOFTWARE_PATH}/103_libevent/lib/pkgconfig
#endif

################################################################
# Common software configure
################################################################
#setenv LD_LIBRARY_PATH ${SOFTWARE_PATH}/100_libs/libffi/lib64:${LD_LIBRARY_PATH}
setenv LD_LIBRARY_PATH ${SOFTWARE_PATH}/110_gcc/lib64:${LD_LIBRARY_PATH}

################################################################
# Modelsim configure
################################################################
################################################################
# Vivado configure
################################################################
#setenv VIVADO_HOME /EDA/vivado/2018.2/Vivado/2018.2 
setenv VIVADO_HOME /EDA/vivado/2016.4/Vivado/2016.4
setenv PATH $VIVADO_HOME/bin:${PATH}
################################################################
# Modelsim configure
################################################################
setenv MODELSIM_PATH /EDA/verify/Mentor/questa_10.7c/questasim/linux_x86_64
setenv PATH ${MODELSIM_PATH}:${PATH}
################################################################
# Git configure:
# Git Path: /home/kejiany/01_personal/00_software/00_git_scm
################################################################
setenv GIT_HOME /home/kejiany/01_personal/00_software/00_git
setenv PATH ${PATH}:${GIT_HOME}/bin
################################################################
# eclipse configure
################################################################
setenv PATH /home/YouKejian/Public/02.eclipse:${PATH}
################################################################
# Other software configure:
# gcc
################################################################
#git clone: git clone kejiany@135.252.218.208:$ORIGIN_PATH/xxx
setenv ORIGIN_PATH /home/kejiany/00_work/00_repositorys
#########################perl###########################
setenv PATH ${SOFTWARE_PATH}/18_perl/bin:${PATH}
######################### openssl ###########################
setenv PATH ${SOFTWARE_PATH}/17_openssl/bin:${PATH}
setenv LD_LIBRARY_PATH ${SOFTWARE_PATH}/17_openssl/lib:${LD_LIBRARY_PATH}
######################## firefox ###########################
setenv PATH /home/kejiany/Downloads/firefox:${PATH}
######################### curl ###########################
setenv PATH /home/kejiany/01_personal/00_software/101_curl/bin:${PATH}
setenv INCLUDE_PATH /home/kejiany/01_personal/00_software/101_curl/include
#########################################################
# Java
#########################################################
setenv JAVA_HOME /home/kejiany/01_personal/01_download/jre1.7.0
setenv PATH ${JAVA_HOME}/bin:${PATH}
setenv JRE_HOME ${JAVA_HOME}
setenv CLASSPATH ${JAVA_HOME}/lib
#########################################################
# iverilog 
#########################################################
setenv PATH /home/kejiany/Public/iverilog/bin:${PATH}
########################eclipse###########################
setenv PATH /home/kejiany/01_personal/01_download/eclipse:${PATH}
########################tomcat###########################
setenv CATALINA_HOME /home/YouKejian/Downloads/apache-tomcat-9.0.24

#######################################################################################
#   LD_LIBRARY_PATH
#######################################################################################
#setenv LD_LIBRARY_PATH ${LD_LIBRARY_PATH}:/home/kejiany/01_personal/00_software/100_lib
setenv LD_LIBRARY_PATH ${LD_LIBRARY_PATH}:${SOFTWARE_PATH}/103_libevent/lib
setenv LD_LIBRARY_PATH ${LD_LIBRARY_PATH}:${SOFTWARE_PATH}/111_gmp/lib
setenv LD_LIBRARY_PATH ${LD_LIBRARY_PATH}:${SOFTWARE_PATH}/112_mpc/lib
setenv LD_LIBRARY_PATH ${LD_LIBRARY_PATH}:${SOFTWARE_PATH}/113_mpfr/lib
setenv LD_LIBRARY_PATH ${LD_LIBRARY_PATH}:${SOFTWARE_PATH}/17_openssl/lib
##setenv LD_LIBRARY_PATH ${LD_LIBRARY_PATH}:/home/kejiany/01_personal/00_software/100_lib
setenv PATH ${PATH}:${SOFTWARE_PATH}/12_tmux/bin
setenv PATH ${PATH}:${SOFTWARE_PATH}
setenv PATH ${PATH}:/home/kejiany/download/fish/bin
setenv PATH ${SOFTWARE_PATH}/114_vim/bin:${PATH}
setenv PATH ${SOFTWARE_PATH}/16_rsync/bin:${PATH}
#source ${SOFTWARE_PATH}/29_xz/xz.cshrc

setenv SOFTWARE_SETTED 1
