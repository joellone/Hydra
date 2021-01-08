#!/bin/python3
# -*- coding:utf-8 -*-
import verification_server
import ssh_connection
import tc_list
import local_command
import os


class ver_run:
    sim_path = '/home/kejiany/sim'

    def __init__(self, arg_p):
        self.arg_p = arg_p
        self.ins_lcmd = local_command.local_command()
        self.ver_serv = verification_server.verification_server()
        self.ssh_con = ssh_connection.ssh_connection(arg_p.server)

    def git_push(self):
        self.ins_lcmd.git_add()
        self.ins_lcmd.git_push()

    def git_pull(self):
        self.ver_serv.git_update(self.ssh_con)

    def connect_serv(self):
        self.ssh_con.serv_connect()
        self.ssh_con.open_session()
        if (self.arg_p.jump != ''):
            self.ssh_con.wait_echo('Last login')
            self.ssh_con.send_cmd('ssh -p 2211 kejiany@127.0.0.1\r')
            self.ssh_con.wait_echo('password:')
            self.ssh_con.send_cmd('IC!shanghai8\r')

    def run_tc(self):
        tc_path = self.sim_path + '/' + self.arg_p.tc
        try:
            os.mkdir(tc_path)
        except OSError:
            print(tc_path + "excists")
        self.ver_serv.mk_sim_env(self.ssh_con)
        self.ver_serv.run_compile('make dut\r', self.ssh_con)
        self.ver_serv.run_compile('make tb prj=S6AD600\r', self.ssh_con)
        self.ssh_con.get_file(self.ver_serv.sim_path, self.sim_path, 'compile_log')
        self.ver_serv.run_tc(self.arg_p, self.ssh_con)
        self.ssh_con.get_file(self.ver_serv.sim_path, tc_path, 'run_log')
        self.ssh_con.serv_close()

    def run_regression(self):
        ins_tc_list = tc_list.tc_list()
        self.ver_serv.mk_sim_env(self.ssh_con)
        self.ver_serv.run_compile('make dut\r', self.ssh_con)
        self.ver_serv.run_compile('make tb prj=S6AD600\r', self.ssh_con)
        result = os.popen('mkdir -p ' + self.sim_path).readlines()
        print(result)
        self.ssh_con.get_file(self.ver_serv.DFC12_PATH + '/testbench_systemv/uvm_env', self.sim_path, 'falcon_uvm_package.sv')
        ins_tc_list.read_file('/home/kejiany/falcon_uvm_package.sv')
        for tc in ins_tc_list.testcast_list:
            self.arg_p.tc = tc
            self.ver_serv.run_tc(self.arg_p, self.ssh_con)
            tc_path = self.sim_path + '/' + tc
            try:
                os.mkdir(tc_path)
            except OSError:
                print(tc_path + "excists")
            self.ssh_con.get_file(self.ver_serv.sim_path, tc_path, 'run_log')
        self.ssh_con.serv_close()
