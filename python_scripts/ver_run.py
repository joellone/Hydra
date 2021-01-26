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

    # def git_push(self):
    #     self.ins_lcmd.git_add()
    #     self.ins_lcmd.git_push()

    # def git_pull(self):
    #     self.ver_serv.code_update(self.ssh_con)

    def code_update(self):
        self.ins_lcmd.git_add()
        self.ins_lcmd.git_push()
        self.ver_serv.git_update(self.ssh_con)
        self.ver_serv.mk_sim_env(self.ssh_con)
        if (self.arg_p.cmd == 'wrapper'):
            print("---------------Setting XCVR compile enviroment----------------")
            self.ver_serv.set_sim_wrapper(self.ssh_con)
        if (self.arg_p.cover == 1):
            # If enable coverage report, run compile with cover
            self.ver_serv.run_compile('source ${SCRIPT_PATH}/compile_tb.csh cover | tee dut_comp_log\r', self.ssh_con)
        else:
            self.ver_serv.run_compile('make dut\r', self.ssh_con)
        self.ver_serv.run_compile('make tb prj=' + self.arg_p.project_name + '\r', self.ssh_con)
        self.ssh_con.get_file(self.ver_serv.sim_path, self.sim_path, 'compile_log')

    def connect_serv(self):
        self.ssh_con.serv_connect()
        self.ssh_con.open_session()
        self.ssh_con.wait_echo('Last login')
        if (self.arg_p.jump != ''):
            self.ssh_con.send_cmd('ssh -p 2211 kejiany@127.0.0.1\r')
            self.ssh_con.wait_echo('password:')
            self.ssh_con.send_cmd('IC!shanghai8\r')

    def run_tc(self):
        tc_path = self.sim_path + '/' + self.arg_p.tc
        self.connect_serv()
        # Update code by git
        if (self.arg_p.mode == 'update'):
            self.code_update()
        if (self.arg_p.cmd == 'wrapper'):
            print("---------------Setting XCVR run enviroment----------------")
            self.ver_serv.set_sim_wrapper(self.ssh_con)
        self.ver_serv.run_tc(self.arg_p, self.ssh_con)
        try:
            os.mkdir(tc_path)
        except OSError:
            print(tc_path + " excists")
        self.ssh_con.get_file(self.ver_serv.sim_path, tc_path, 'run_log')
        self.ssh_con.serv_close()

    def continue_run(self, ins_tc_list):
        while (True):
            self.connect_serv()
            run_list = os.listdir(self.sim_path)
            # Regenerate TC list
            # Read the dir list from sim folder, exclude the dirs from tc list
            for run_tc in run_list:
                try:
                    print("Removing: " + run_tc)
                    # ins_tc_list.testcast_list.remove(run_list)
                    tc_index = ins_tc_list.testcast_list.index(run_tc)
                    # print(str(tc_index))
                    ins_tc_list.testcast_list.pop(tc_index)
                except ValueError:
                    print(run_tc + " not in list")
            # If TC list is empty, stop the regression
            if (len(ins_tc_list.testcast_list) == 0):
                print("All testcase finished")
                return
            # Run with new TC list
            for tc in ins_tc_list.testcast_list:
                self.arg_p.tc = tc
                print("Running testcase: " + tc)
                self.run_tc()
            self.ssh_con.serv_close()

    def get_tc_list(self, package_file_name):
        self.connect_serv()
        self.ins_tc_list = tc_list.tc_list()
        self.ssh_con.get_file(self.ver_serv.DFC12_PATH + '/testbench_systemv/uvm_env', self.sim_path, package_file_name)
        self.ssh_con.serv_close()
        self.ins_tc_list.read_file(self.sim_path + '/' + package_file_name)

    def get_cov_rpt(self):
        # self.get_tc_list('falcon_uvm_package.sv')
        self.connect_serv()
        str_tc_list = ''
        for tc in self.ins_tc_list.testcast_list:
            ucdb_file = tc + '.ucdb'
            self.ssh_con.get_file(self.ver_serv.sim_path, self.sim_path, ucdb_file)
            str_tc_list = str_tc_list + ' ' + ucdb_file
        self.ssh_con.send_cmd('cd ' + self.ver_serv.sim_path + '\r')
        self.ssh_con.wait_echo('>')
        self.ssh_con.send_cmd('vcover merge harness.ucdb' + str_tc_list + '\r')
        self.ssh_con.wait_echo('>')
        self.ssh_con.send_cmd('vcover report -details -source -html harness.ucdb\r')
        self.ssh_con.wait_echo('>')
        self.ssh_con.serv_close()

    def run_regression(self):
        # If regression mode is restart
        if self.arg_p.mode == "restart":
            # remove all the tc folder
            os.popen('mkdir -p ' + self.sim_path)
            os.popen('rm ' + self.sim_path + '/svf_* -rf')
        self.connect_serv()
        self.ins_lcmd.write_log('Regress Start\n')
        # Running normal testcase
        print("============================================================================")
        print("                            Running normal test                             ")
        print("============================================================================")
        self.code_update()
        self.get_tc_list('falcon_uvm_package.sv')
        self.continue_run(self.ins_tc_list)
        self.ins_lcmd.collect_log('falcon_uvm_package.sv')
        if (self.arg_p.cover == 0):
            # Running XCVR testcase
            print("============================================================================")
            print("                            Running XCVR test                               ")
            print("============================================================================")
            self.arg_p.cmd = 'wrapper'
            self.code_update()
            self.get_tc_list('falcon_wrapper_package.sv')
            self.continue_run(self.ins_tc_list)
            self.ins_lcmd.collect_log('falcon_wrapper_package.sv')

    def run_cover(self):
        self.run_regression()
        self.get_cov_rpt()
