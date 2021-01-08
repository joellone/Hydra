#!/bin/python3
# -*- coding:utf-8 -*-

import getopt
import sys


class arg_proc:
    argv = ""

    def __init__(self, args):
        self.argv = args
        '''
        Get server name from argv
        Args: -s --serv
        '''
        try:
            self.opts, self.args = getopt.getopt(self.argv[1:], "hs:t:r:j:", ["serv=", "tc=", "verdi=", "regress=", "seed="])
            print(self.opts)
            self.get_server()
            self.get_tc()
            self.get_verdi_en()
            self.get_reg_en()
            self.get_jump()
            self.get_seed()
        except getopt.GetoptError:
            print('ver_run.py -s <server> -t <tc_name>')
            sys.exit(2)

    def get_server(self):
        for opt, arg in self.opts:
            if opt in ("-s", "--serv"):
                if len(arg) == 0:
                    exit(2)
                self.server = arg
                return

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
