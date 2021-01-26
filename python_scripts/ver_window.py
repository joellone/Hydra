#!/bin/python3
# -*- coding: utf-8 -*-
import tkinter
import tkinter.ttk
import ver_run
import sys
import arg_proc


class Application(tkinter.Frame):
    def __init__(self, master=None):
        tkinter.Frame.__init__(self, master)
        self.pack(padx=20, pady=30)
        self.createWidgets()

    def createWidgets(self):
        self.column = 0
        self.row = 0
        # ROW 1 Project Name
        self.project_label = tkinter.Label(self, text="Project Name: ")
        self.project_label.grid(column=self.column, row=self.row)
        self.column = self.column + 2
        self.project_name = tkinter.ttk.Combobox(self, width=10)
        self.project_name['values'] = ("DFC12", "S6AD600")
        self.project_name.set("S6AD600")
        self.project_name.grid(column=self.column, row=self.row)
        # ROW 2 Server Name
        self.column = 0
        self.row = self.row + 1
        self.server_name_label = tkinter.Label(self, text="Server Name: ")
        self.server_name_label.grid(column=self.column, row=self.row)
        self.column = self.column + 2
        self.server_name_comb = tkinter.ttk.Combobox(self, width=10)
        self.server_name_comb['values'] = ("nanjing", "guangdong")
        self.server_name_comb.set("nanjing")
        self.server_name_comb.grid(column=self.column, row=self.row)
        # TestCase Name
        self.column = 0
        self.row = self.row + 1
        self.tc_name_label = tkinter.Label(self, text="TestCase Name: ")
        self.tc_name_label.grid(column=self.column, row=self.row)
        self.column = self.column + 2
        self.tc_name_comb = tkinter.ttk.Combobox(self, width=10)
        self.tc_name_comb['values'] = ("svf_exp", "regress")
        self.tc_name_comb.set("regress")
        self.tc_name_comb.grid(column=self.column, row=self.row)
        # Verdi enable
        self.column = 0
        self.row = self.row + 1
        self.verdi_en = tkinter.Checkbutton(self, text="Verdi EN: ", var=True)
        self.verdi_en.grid(column=self.column, row=self.row)
        # ROW 3
        self.row = self.row + 2
        self.run_button = tkinter.Button(self, text='Run', command=self.run_sim)
        self.run_button.grid(column=1, row=self.row)

    def update_tc_name(self):
        self.ins_ver_run.arg_p.server = self.server_name_comb.get()
        self.ins_ver_run.get_tc_list()
        for tc in self.ins_ver_run.ins_tc_list.testcast_list:
            self.tc_name_comb['values'].append(tc)
            self.tc_name_comb.set(tc)

    def run_sim(self):
        print(sys.argv)
        self.arg_p = arg_proc.arg_proc(sys.argv)
        self.arg_p.server = self.server_name_comb.get()
        self.arg_p.project_name = self.project_name.get()
        self.arg_p.tc = self.tc_name_comb.get()
        if (self.verdi_en.getboolean()):
            self.arg_p.verdi_en = 1
        else:
            self.arg_p.verdi_en = 0
        self.ins_ver_run = ver_run.ver_run(self.arg_p)
        # if (self.ins_ver_run.arg_p.tc != 'regress'):
        #     print("Running testcase: " + str(self.arg_p.tc) + " on: " + str(self.arg_p.server))
        #     self.ins_ver_run.run_tc()
        # else:
        #     print("Running regression on: " + str(self.arg_p.server))
        #     self.ins_ver_run.run_regression()


app = Application()
# 设置窗口标题:
app.master.title('Hello World')
# 主消息循环:
app.mainloop()
