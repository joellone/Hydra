#!/bin/csh

################################################################
# Base configs
################################################################
#source /opt/fpga/script/.cshrc
#source ~/.ts/.modelsim
#source /home/$user/.ts/.zeroin
#source /home/$user/.ts/.vhdldevsys
#source /home/$user/.ts/.proverify
#source /home/$user/.ts/.synplify
#source /home/$user/.ts/.altera
#source /home/$user/.ts/.xilinx
#source /home/$user/.ts/.hds
#source /home/$user/.ts/.lattice
#source /home/$user/.ts/.precision
#source /home/$user/.ts/.catapultc
#source /home/$user/.ts/.vivado
#setenv XIL_MAP_OLD_SAVE 1
setenv TMOUT 60000000

#setenv PATH ${PATH}:/usr/share/man:/opt/fpga/acrobat/95/Adobe/Reader9/bin:/opt/fpga/script:/opt/fpga/script/rar:/opt/fpga/script/rtlman:/opt/fpga/tool/rdesktop/bin:/opt/fpga/tool/xxdiff/bin:/usr/atria/bin:/opt/fpga/emacs/23.1/bin
#setenv MGLS_LICENSE_FILE 27037@87.254.223.77:27037@10.135.73.175:27037@10.135.73.176:27037@10.135.73.177
setenv MGLS_LICENSE_FILE 27037@10.135.8.33:27037@10.135.8.27:27037@10.135.8.36:27037@87.254.223.77:27037@10.135.73.175:27037@10.135.73.176:27037@10.135.73.177
#setenv LM_LICENSE_FILE 27012@87.254.223.64:27031@10.135.73.20:27031@10.135.73.210:27031@10.135.73.234:27031@87.254.223.77:27027@87.254.223.62:27000@135.251.52.101:27037@87.254.223.77:27037@10.135.73.175:27037@10.135.73.176:27037@10.135.73.177:7800@135.251.52.101:7800@alpha:1700@135.251.52.101:27020@135.251.48.49:27010@135.251.52.101
setenv LM_LICENSE_FILE 27012@87.254.223.64:27031@10.135.73.20:27031@10.135.73.210:27031@10.135.73.234:27031@87.254.223.77:27027@87.254.223.62:27000@135.251.52.101:27037@10.135.8.33:27037@10.135.8.27:27037@10.135.8.36:27037@10.135.73.175:27037@10.135.73.176:27037@10.135.73.177:7800@135.251.52.101:7800@alpha:1700@135.251.52.101:27020@135.251.48.49:27010@135.251.52.101:1717@135.251.52.101:1717@135.251.12.170:1717@135.251.52.95
################################################################
# Server paths
################################################################
setenv GUANGDONG 135.252.217.111
setenv GANSU 135.252.218.201
setenv GUANGXI 135.252.218.208
setenv SHANXI 135.252.218.209
setenv SICHUAN 135.252.218.111
setenv JIANGSU 135.252.218.206
setenv SHANGHAI 135.252.218.205
setenv ALI 47.102.131.211

if ($?SOFTWARE_SETTED) then
    echo "Reload .cshrc"
else
    source ~/.software.cshrc
endif

setenv http_proxy "http://kejiany:ACP1mmdazj\!@cnproxy.cn.alcatel-lucent.com:8080"
setenv https_proxy "http://kejiany:ACP1mmdazj\!@cnproxy.cn.alcatel-lucent.com:8080"

#Protject Settings
#setenv OAM_CORE /vobs/oam_vob/oam_core/rtl
#setenv OAM_REBUILD /home/kejiany/00_work/00_verification/01_files_verify/oam_rebuild
#setenv FALCON_ROOT /home/kejiany/00_work/00_verify/01_falcon_repo/02_falcon_prj
#setenv FALCON_SIM /home/kejiany/00_work/00_verify/01_falcon_repo/04_add4_sc
#setenv FALCON_SIM /home/kejiany/00_work/00_verify/01_falcon_repo/03_add4_sim
#setenv FALCON_TC $FALCON_SIM/testcase/tb3_testcase_add4/testcase
#setenv SIM_REUSE_PATH /vobs/oam_vob/at/tb

alias ls 'ls --color=auto'
alias ll 'ls -al'
alias gv gvim
alias cd 'cd \!*; set prompt="%n@%m `pwd` \n>"; ls'
alias sv_eophy 'sv kejiany_eophy_int'
alias sv_falcon 'sv kejiany_tndwq_ip_falcon_oh_prj'
alias src_falcon 'source /vobs/oam_vob/ip_falcon_oh/top_sim/testbench_systemc/scripts/falcon.cshrc'
alias pdf acroread
#alias gcc /usr/bin/gcc
alias scs 'source ~/.cshrc'
alias gts 'git status ./'
alias gadd 'git add \!*'
alias gpush 'git push origin master'
alias gpull 'git pull origin master'
alias gcmmt 'git commit -m "update" \!*'
#ctags / cscope
alias run_ctags 'ctags -R --c++-kinds=+p --fields=+iaS --extra=+q'
alias run_cscope 'cscope -bkq -i \!*'
#clear case
alias ct cleartool
alias sv cleartool setview
alias cci 'ct ci -nc \!*'
alias cco 'ct co -nc \!*'
alias clschk 'ct lscheckout -cview -me -avobs'
alias ctimport 'clearfsimport -recurse -nsetevent \!*'
#alias makeself /home/kejiany/01_personal/01_download/makeself-2.2.0/makeself.sh
#setenv MAKESELF /home/kejiany/01_personal/01_download/makeself-2.2.0
alias rmt 'rmate -p 52698 \!*'

alias del 'mv \!* ~/trash'

