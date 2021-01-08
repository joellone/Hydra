#!/bin/python3
# -*- coding:utf-8 -*-
import arg_proc
import sys
import local_command
import ver_run


print(sys.argv)
arg_p = arg_proc.arg_proc(sys.argv)
ins_lcmd = local_command.local_command()
ins_ver_run = ver_run.ver_run(arg_p)
ins_ver_run.git_push()
ins_ver_run.connect_serv()
ins_ver_run.git_pull()
if (arg_p.regress_en == 0):
    print("Running testcase: " + str(arg_p.tc) + " on: " + str(arg_p.server))
    ins_ver_run.run_tc()
else:
    print("Running regression on: " + str(arg_p.server))
    ins_ver_run.run_regression()
