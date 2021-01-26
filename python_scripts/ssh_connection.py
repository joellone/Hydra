#!/bin/python3
# -*- coding:utf-8 -*-
import paramiko
# import os
import select
import sys
import tty
import termios
import time


class ssh_connection:
    name = ""
    port = 22
    username = "kejiany"
    password = "IC!shanghai8"
    DFC12_PATH = "/home/kejiany/00_work/00_verify/01_falcon_repo/07_DFC12"
    sim_path = DFC12_PATH + "/sim"
    script_path = DFC12_PATH + "/testbench_systemv/scripts"
    local_path = "/home/kejiany"
    error_num = 0

    def __init__(self, serv_name):
        self.name = serv_name
        print("Creating verification server")

    def set_user(self, user_name, pass_word):
        self.username = user_name
        self.password = pass_word

    def serv_connect(self):
        # 建立一个socket
        self.trans = paramiko.Transport((self.name, self.port))
        # trans = paramiko.Transport(('47.102.131.211', 22))
        # 启动一个客户端
        self.trans.start_client()

        # 如果使用rsa密钥登录的话
        '''
        default_key_file = os.path.join(os.environ['HOME'], '.ssh', 'id_rsa')
        prikey = paramiko.RSAKey.from_private_key_file(default_key_file)
        trans.auth_publickey(username='super', key=prikey)
        '''
        # 如果使用用户名和密码登录
        self.trans.auth_password(username=self.username, password=self.password)

        return

    def open_session(self, pty_en=0):
        print("Connecting: " + self.name)
        self.channel = self.trans.open_session()
        self.channel.get_pty(term='xterm', width=160, height=53)
        self.channel.invoke_shell()
        # 获取原操作终端属性
        oldtty = termios.tcgetattr(sys.stdin)
        try:
            # 将现在的操作终端属性设置为服务器上的原生终端属性,可以支持tab了
            tty.setraw(sys.stdin)
            self.channel.settimeout(0)
            if (pty_en == 1):
                self.open_pty()
        finally:
            # 执行完后将现在的终端属性恢复为原操作终端属性
            termios.tcsetattr(sys.stdin, termios.TCSADRAIN, oldtty)
        return

    def send_cmd(self, cmd):
        print(cmd)
        self.channel.send(cmd)

    def wait_echo(self, str_echo, error_stat=0):
        while True:
            readlist, writelist, errlist = select.select([self.channel, ], [], [])
            # 服务器返回了结果,channel通道接受到结果,发生变化 select感知到
            if self.channel in readlist:
                # 获取结果
                result = self.channel.recv(1024)
                result = result.decode()

                # 断开连接后退出
                if len(result) == 0:
                    print("\r\n**** EOF **** \r\n")
                    break

                if (error_stat == 1):
                    self.error_stat(result)

                # wait
                if str_echo in result:
                    print(result)
                    time.sleep(1)
                    break

                # 输出到屏幕
                sys.stdout.write(result)
                sys.stdout.flush()

    def error_stat(self, str_stat):
        sub_str = str_stat
        while ("Errors" in sub_str):
            # print("Sub string: " + sub_str)
            index = sub_str.find("Errors")
            if (index != -1):
                sub_str = sub_str[(index+len("Errors: ")):]
                # print("Sub string: " + sub_str)
                index = sub_str.find(",")
                num_str = sub_str[0:index]
                # print("Received error number is: %d" % int(num_str))
                self.error_num = self.error_num + int(num_str)
            else:
                return

    def open_pty(self):
        while True:
            readlist, writelist, errlist = select.select([self.channel, sys.stdin, ], [], [])
            # 如果是用户输入命令了,sys.stdin发生变化
            if sys.stdin in readlist:
                # 获取输入的内容，输入一个字符发送1个字符
                input_cmd = sys.stdin.read(1)
                # print("input: " + input_cmd)
                # 将命令发送给服务器
                self.channel.sendall(input_cmd)

            # 服务器返回了结果,channel通道接受到结果,发生变化 select感知到
            if self.channel in readlist:
                # 获取结果
                result = self.channel.recv(1024)

                # 断开连接后退出
                if len(result) == 0:
                    print("\r\n**** EOF **** \r\n")
                    break

                result = result.decode()

                # 输出到屏幕
                if result.find('\r>') >= 0:
                    print(result[0:result.index('\r>')-1])
                    sys.stdout.write(result[result.index('\r>'):])
                    sys.stdout.flush()
                else:
                    sys.stdout.write(result)
                    sys.stdout.flush()

    def serv_close(self):
        # 关闭通道
        self.channel.close()
        # 关闭链接
        self.trans.close()
        return

    def get_file(self, src_path, dst_path, file_name):
        sftp = paramiko.SFTPClient.from_transport(self.trans)
        try:
            # copy to local path
            sftp.get(src_path + '/' + file_name, dst_path + '/' + file_name)
        except FileNotFoundError:
            print(sftp.listdir(src_path))

    def put_file(self, src_path, dst_path, file_name):
        sftp = paramiko.SFTPClient.from_transport(self.trans)
        try:
            # copy to remote path
            sftp.put(src_path + '/' + file_name, dst_path + '/' + file_name)
        except FileNotFoundError:
            print(sftp.listdir(src_path))

    def make_dir(self, path):
        sftp = paramiko.SFTPClient.from_transport(self.trans)
        try:
            sftp.chdir(self.sim_path)
        except IOError:
            sftp.mkdir(self.sim_path, mode=0o777)
