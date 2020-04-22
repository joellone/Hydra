SHELL:=/bin/csh

tb  :
	source ${SCRIPT_PATH}/tc_compile.sh ${tc}

dut :
	source ${SCRIPT_PATH}/compile_tb.csh ${comp} ${type}

run :
	source ${SCRIPT_PATH}/run_sim.sh $(tc) $(cmd)

#test mode simulation: make sim tc=xxxxx cmd=testmod
#DFC12 simulation: 	   make sim tc=xxxxx cmd=DFC12
#S4X400H simulation:   make sim tc=xxxxx cmd=S4X400H
sim :
	source ${SCRIPT_PATH}/sim_run.csh $(tc) $(cmd) $(type)| tee compile_log

reg :
	source ${SCRIPT_PATH}/regress.csh $(cmd)

cov :
	source ${SCRIPT_PATH}/cover.csh $(cmd)

clean:
	rm -rf *.fsdb svf_* report.txt novas_dump.log *_log transcript work vish_stacktrace.vstf covhtmlreport cov_report *.ucdb vhdlcomLog
