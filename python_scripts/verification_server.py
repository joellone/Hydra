#!/bin/python3
# -*- coding:utf-8 -*-
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
        ssh_con.wait_echo("----Compile finished----")

    def run_tc(self, arg_p, ssh_con):
        ssh_con.send_cmd('cd ' + self.sim_path + '\r')
        ssh_con.send_cmd('source ' + self.script_path + '/SetEnv.cshrc\r')
        ssh_con.wait_echo('>')
        ssh_con.send_cmd('rm work/_lock\r')
        ssh_con.wait_echo('>')
        tc_str = ' tc=' + arg_p.tc + ' '
        verdi_str = ' verdi=' + str(arg_p.verdi_en) + ' '
        seed_str = ' seed=' + str(arg_p.seed) + ' '
        ssh_con.send_cmd('make run' + tc_str + verdi_str + seed_str + '\r')
        ssh_con.wait_echo("Note: $finish")

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
