#!/bin/python3
# -*- coding:utf-8 -*-
import ssh_connection
import time
import tc_list


class local_command:
    user = 'kejiany'
    password = 'IC!shanghai8'
    prj_path = '/home/kejiany/Project/01_falcon_repo/07_DFC12/testbench_systemv'
    sim_path = '/home/kejiany/sim'

    def git_add(self):
        ssh_con = ssh_connection.ssh_connection('127.0.0.1')
        ssh_con.port = 23
        ssh_con.serv_connect()
        ssh_con.open_session()
        ssh_con.wait_echo('kejiany')
        ssh_con.send_cmd('cd ' + self.prj_path + '\r')
        ssh_con.wait_echo('>')
        ssh_con.send_cmd('ls\r')
        ssh_con.wait_echo('>')
        ssh_con.send_cmd('git add .\r')
        ssh_con.wait_echo('>')
        ssh_con.send_cmd('git commit -m "update"\r')
        ssh_con.wait_echo('>')
        ssh_con.serv_close()
        time.sleep(1)

    def git_push(self):
        ssh_con = ssh_connection.ssh_connection('127.0.0.1')
        ssh_con.port = 23
        ssh_con.serv_connect()
        ssh_con.open_session()
        ssh_con.send_cmd('cd ' + self.prj_path + '\r')
        ssh_con.wait_echo('>')
        ssh_con.send_cmd('git push origin s6ad600\r')
        ssh_con.wait_echo('password:')
        ssh_con.send_cmd(self.password + '\r')
        ssh_con.wait_echo('>')
        ssh_con.serv_close()
        time.sleep(1)

    def make_dir(self, path):
        ssh_con = ssh_connection.ssh_connection('127.0.0.1')
        ssh_con.port = 23
        ssh_con.serv_connect()
        ssh_con.open_session()
        ssh_con.send_cmd('cd .\r')
        ssh_con.send_cmd('mkdir -p ' + path + '\r')
        ssh_con.wait_echo('>')
        ssh_con.serv_close()
        time.sleep(1)

    def collect_log(self):
        ins_tc_list = tc_list.tc_list()
        ins_tc_list.read_file(self.sim_path + '/falcon_uvm_package.sv')
        reg_log_path = self.sim_path + '/' + 'regress_log'
        reg_log = open(reg_log_path, 'w')
        for tc in ins_tc_list.testcast_list:
            for i in range(0, 100):
                reg_log.write('-')
            else:
                reg_log.write('\n')
            # localtime = time.asctime(time.localtime(time.time()))
            # reg_log.write(localtime + '\n')
            reg_log.write(tc + ': ')
            tc_log_path = self.sim_path + '/' + tc + '/run_log'
            # Try to open the log file
            try:
                tc_log = open(tc_log_path, 'r')
                # Looking for the result
                failed = ''
                while(True):
                    rd_line = tc_log.readline()
                    if ('FAILED' in rd_line):
                        failed = 'true'
                    if ('PASSED' in rd_line):
                        failed = 'false'
                    if ('Elapsed' in rd_line):
                        reg_log.write(rd_line)
                    if ('Sv_Seed' in rd_line):
                        reg_log.write(rd_line)

                    if not rd_line:
                        if failed == '':
                            reg_log.write('run not finished\n')
                        elif failed == 'false':
                            reg_log.write('passed\n')
                        else:
                            reg_log.write('failed\n')
                        break
            except IOError:
                print("Open log file " + tc + " failed")
                reg_log.write('no log file\n')
                continue
            reg_log.write('Log path: ' + tc_log_path + '\n')
