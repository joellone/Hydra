#!/bin/python3
# -*- coding:utf-8 -*-

import getopt
import sys


class arg_proc:
    argv = ""

    def __init__(self, args):
        self.argv = args
        self.server = 'nanjing'
        self.project_name = 'S6AD600'
        self.cover = 0
        '''
        Get server name from argv
        Args: -s --serv
        '''
        try:
            self.opts, self.args = getopt.getopt(self.argv[1:], "hs:t:r:j:c:", ["serv=", "tc=", "verdi=", "regress=", "seed=", "mode=", "cmd=", "cover="])
            print(self.opts)
            self.help()
            self.get_server()
            self.get_tc()
            self.get_verdi_en()
            self.get_reg_en()
            self.get_jump()
            self.get_seed()
            self.get_mode()
            self.get_cmd()
            self.get_cover()
        except getopt.GetoptError:
            print('ver_run.py -s <server> -t <tc_name>')
            sys.exit(2)

    def help(self):
        for opt, arg in self.opts:
            if opt == "-h":
                print("-s, --serv:      Server name")
                print("-t, --tc:        Test case name")
                print("-r, --regress:   Regress enable, 1 == enable, 0 == disable")
                print("-j:              Server jump 1 == enable, 0 == disable")
                print("    --verdi:     Enable generating verdi fsdb, 1 == enable, 0 == disable")
                print("-c, --cmd:       Command, <wrapper>: enable wrapper verification")
                print("    --mode:      Mode, <update>: update git repository and compile RTL & Verification code")
                sys.exit(0)

    def get_server(self):
        for opt, arg in self.opts:
            if opt in ("-s", "--serv"):
                if len(arg) == 0:
                    exit(2)
                self.server = arg
                return
            else:
                self.server = 'nanjing'

    def get_tc(self):
        for opt, arg in self.opts:
            if opt in ("-t", "--tc"):
                if len(arg) == 0:
                    print("Error: TC name is empty!")
                    exit(2)
                self.tc = arg
                return
        else:
            self.tc = 'No TestCase'

    def get_verdi_en(self):
        for opt, arg in self.opts:
            print(opt)
            if opt in ("--verdi"):
                print('verdi enable: ' + arg)
                self.verdi_en = arg
                return
            else:
                self.verdi_en = 0
        return

    def get_reg_en(self):
        for opt, arg in self.opts:
            if opt in ("-r", "--regress"):
                print("regress_en: " + arg)
                self.regress_en = arg
                return
        else:
            print("regress_en: 0")
            self.regress_en = 0
            return

    def get_seed(self):
        for opt, arg in self.opts:
            if opt == "--seed":
                print("seed: " + arg)
                self.seed = arg
                return
            else:
                self.seed = 0
        return

    def get_jump(self):
        for opt, arg in self.opts:
            if opt in ("-j"):
                print("Jump: " + arg)
                self.jump = arg
                return
        else:
            print("No jump")
            self.jump = ''
            return

    def get_mode(self):
        for opt, arg in self.opts:
            if opt in ("--mode"):
                print("Mode: " + arg)
                self.mode = arg
                return
        else:
            print("Mode")
            self.mode = ''
            return

    def get_cmd(self):
        for opt, arg in self.opts:
            if opt in ("-c", "--cmd"):
                print("Command: " + arg)
                self.cmd = arg
                return
        else:
            print("No command")
            self.cmd = ''
            return

    def get_cover(self):
        for opt, arg in self.opts:
            if opt in ("--cover"):
                print("Cover: " + arg)
                self.cover = int(arg)
                return
