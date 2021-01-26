#!/bin/python3
# -*- coding:utf-8 -*-
import sys


class verification_server:
    DFC12_PATH = "/home/kejiany/00_work/00_verify/01_falcon_repo/07_DFC12"
    sim_path = DFC12_PATH + "/sim"
    script_path = DFC12_PATH + "/testbench_systemv/scripts"

    def __init__(self):
        print("Creating verification server")

    def git_update(self, ssh_con):
        ssh_con.send_cmd('cd ' + self.DFC12_PATH + '\r')
        ssh_con.wait_echo('>')
        ssh_con.send_cmd('git pull origin s6ad600\r')
        ssh_con.wait_echo('password:')
        ssh_con.send_cmd('IC!shanghai8\r')
        ssh_con.send_cmd(':q\r')
        ssh_con.wait_echo('>')

    def run_compile(self, compile_cmd, ssh_con):
        ssh_con.send_cmd('cd ' + self.sim_path + '\r')
        ssh_con.send_cmd('sv kejiany_tndwq_ip_falcon_oh_prj\r')
        ssh_con.send_cmd('source ' + self.script_path + '/SetEnv.cshrc\r')
        ssh_con.send_cmd('rm work/_lock\r')
        ssh_con.send_cmd(compile_cmd)
        ssh_con.wait_echo("----Compile finished----", 1)
        if ssh_con.error_num > 0:
            print("Compile error quit")
            sys.exit(0)

    def run_tc(self, arg_p, ssh_con):
        ssh_con.send_cmd('cd ' + self.sim_path + '\r')
        ssh_con.wait_echo('>')
        ssh_con.send_cmd('source ' + self.script_path + '/SetEnv.cshrc\r')
        ssh_con.wait_echo('>')
        ssh_con.send_cmd('rm work/_lock\r')
        ssh_con.wait_echo('>')
        tc_str = ' ' + arg_p.tc + ' '
        verdi_str = ' ' + str(arg_p.verdi_en) + ' '
        seed_str = ' ' + str(arg_p.seed) + ' '
        cover_str = ' ' + str(arg_p.cover) + ' '
        # ssh_con.send_cmd('nohup make run' + tc_str + verdi_str + seed_str + arg_p.cmd + '&\r')
        # ssh_con.send_cmd('make run' + tc_str + verdi_str + seed_str + cover_str + arg_p.cmd + '\r')
        ssh_con.send_cmd('source ${SCRIPT_PATH}/sim_run.csh' + tc_str + verdi_str + seed_str + cover_str + ' | tee run_log\r')
        if (arg_p.cover == 1):
            ssh_con.wait_echo("Saving coverage database on exit")
        else:
            ssh_con.wait_echo("Note: $finish")
        ssh_con.send_cmd('cp run_log ' + arg_p.tc + '\r')
        ssh_con.send_cmd('mv *.fsdb' + arg_p.tc + '\r')

    def run_reg(self, ssh_con):
        ssh_con.send_cmd('cd ' + self.sim_path + '\r')
        ssh_con.send_cmd('source ' + self.script_path + '/SetEnv.cshrc\r')
        ssh_con.send_cmd('rm work/_lock\r')
        ssh_con.send_cmd('make reg\r')
        ssh_con.wait_echo("Regress finish")

    def mk_sim_env(self, ssh_con):
        ssh_con.send_cmd('mkdir -p ' + self.sim_path + '\r')
        ssh_con.send_cmd('cp ' + self.script_path + '/makefile ' + self.sim_path + '\r')
        ssh_con.send_cmd('cp ' + self.script_path + '/modelsim.ini ' + self.sim_path + '\r')
        ssh_con.send_cmd('sv kejiany_tndwq_ip_falcon_oh_prj\r')
        ssh_con.send_cmd('source ' + self.script_path + '/SetEnv.cshrc\r')

    def set_sim_wrapper(self, ssh_con):
        ssh_con.send_cmd('cd ' + self.sim_path + '\r')
        ssh_con.wait_echo('>')
        ssh_con.send_cmd('setenv RXAUI_EN 1\r')
        ssh_con.wait_echo('>')
