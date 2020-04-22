#onbreak {quit}
onbreak {resume}

echo "print argv"
echo $argv
set command $argv
set idx_begin [string last "-gVERDI_ENABLE" $command]
set idx_begin [expr $idx_begin+15]
#set idx_last [string last "-do" $command]
set idx_last [expr $idx_begin+1]
echo idx_begin
echo idx_last
set verdi_en [string range $command $idx_begin $idx_last]
echo "run vsim $verdi_en"


##vsim    -L work                                     \
#vsim    -pli /home/kejiany/01_personal/00_software/vJ-2014.12-SP2/share/PLI/MODELSIM/LINUX64/novas_fli.so   \
#        -L secureip                                 \
#        -L unisims_ver                              \
#        -L xilinxcorelib_ver                        \
#        -L work                                     \
#        -L novas                                    \
#        -vopt                                       \
#        -voptargs="+acc" +notimingchecks -t 1ns     \
#        work.harness

if {$verdi_en == 1} {
    echo "=============================================================="
    echo "                          Run verdi                           "
    echo "=============================================================="
    fsdbDumpfile harness.fsdb
    fsdbDumpvars 0 harness 
} else {
    echo "=============================================================="
    echo "                     Run without verdi                        "
    echo "=============================================================="
}

run 1000ms
quit
