#!/bin/python3
# -*- coding:utf-8 -*-

import local_command
import sys
import getopt

opts, args = getopt.getopt(sys.argv[1:], "f:", ["file="])
for opt, arg in opts:
    if opt in ("-f", "--file"):
        if len(arg) == 0:
            print("Please input testcase list name")
        else:
            file = arg

ins_lcmd = local_command.local_command()
if (file == 'wrapper'):
    ins_lcmd.collect_log('falcon_wrapper_package.sv')
else:
    ins_lcmd.collect_log()
