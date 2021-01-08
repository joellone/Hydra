#!/bin/python3
# -*- coding:utf-8 -*-
import arg_proc
import sys
import ver_run


print(sys.argv)
arg_p = arg_proc.arg_proc(sys.argv)
ins_ver_run = ver_run.ver_run(arg_p)
ins_ver_run.git_push()
ins_ver_run.connect_serv()
ins_ver_run.git_pull()
