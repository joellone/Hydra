#!/bin/python3
# -*- coding:utf-8 -*-
import ssh_connection
import getopt
import sys
import os


print(sys.argv)
opts, args = getopt.getopt(sys.argv[1:], "hs:p:f:", ["server=", "path=", "file=", "tail="])
for opt, arg in opts:
    if opt in ("-s", "--server"):
        if len(arg) == 0:
            print("Please input server name")
        else:
            server = arg
            print("Server: " + server)

    if opt in ("-p", "--path"):
        if len(arg) == 0:
            print("Please input file path")
        else:
            path = arg
            print("Path: " + path)

    if opt in ("-f", "--file"):
        if len(arg) == 0:
            print("Please input file name")
        else:
            file = arg
            print("File: " + file)

    if opt == "--tail":
        print("Tail file")
        tail_en = 1

else:
    if ('server' not in vars()):
        server = 'nanjing'
    if ('path' not in vars()):
        path = '/home/kejiany/00_work/00_verify/01_falcon_repo/07_DFC12/sim'
    if ('file' not in vars()):
        file = 'run_log'
    if ('tail_en' not in vars()):
        tail_en = 0

os.system('rm ./' + file)
print("Get " + path + "/" + file + " from " + server)
ssh_con = ssh_connection.ssh_connection(server)
ssh_con.serv_connect()
ssh_con.open_session()
ssh_con.send_cmd('cd ' + path + '\r')
ssh_con.wait_echo('>')
ssh_con.send_cmd('ls\r')
if (tail_en == 0):
    ssh_con.get_file(path, '.', file)
    os.system('vim ./' + file)
else:
    ssh_con.send_cmd('tail -f ' + file)
    ssh_con.wait_echo("Note: $finish")
