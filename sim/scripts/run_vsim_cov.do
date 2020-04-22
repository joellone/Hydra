#onbreak {quit}
onbreak {resume}

echo "print argv"
echo $argv
set command $argv
set idx_begin [string last "-gTC_NAME" $command]
set idx_begin [expr $idx_begin+10]
set idx_last [string last "-do" $command]
set idx_last [expr $idx_last-2]
set tc_name [string range $command $idx_begin $idx_last]
echo "run vsim $tc_name"

coverage save -onexit $tc_name.ucdb

run 1000ms

quit
