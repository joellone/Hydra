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
    regress_log = 'regress_log'

    def __init__(self, arg_p):
        self.fail_cnt = 0
        self.pass_cnt = 0

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

    def append_log(self, append_str):
        reg_log_path = self.sim_path + '/' + self.regress_log
        reg_log = open(reg_log_path, 'a')
        reg_log.write(append_str)
        reg_log.close()

    def write_log(self, write_str):
        reg_log_path = self.sim_path + '/' + self.regress_log
        reg_log = open(reg_log_path, 'w')
        reg_log.write(write_str)
        reg_log.close()

    def collect_log(self, tc_list_name='falcon_uvm_package.sv'):
        ins_tc_list = tc_list.tc_list()
        ins_tc_list.read_file(self.sim_path + '/' + tc_list_name)
        for tc in ins_tc_list.testcast_list:
            for i in range(0, 100):
                self.append_log('-')
            else:
                self.append_log('\n')
            # localtime = time.asctime(time.localtime(time.time()))
            # reg_log.write(localtime + '\n')
            self.append_log(tc + ': ')
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
                        self.fail_cnt += 1
                    elif ('PASSED' in rd_line):
                        failed = 'false'
                        self.pass_cnt += 1

                    if ('Elapsed' in rd_line):
                        self.append_log(rd_line)
                    if ('Sv_Seed' in rd_line):
                        self.append_log(rd_line)

                    # End of file
                    if not rd_line:
                        if failed == '':
                            self.append_log('run not finished\n')
                        elif failed == 'false':
                            self.append_log('passed\n')
                        else:
                            self.append_log('failed\n')
                        break
            except IOError:
                print("Open log file " + tc + " failed")
                self.append_log('no log file\n')
                continue
            self.append_log('Log path: ' + tc_log_path + '\n')
