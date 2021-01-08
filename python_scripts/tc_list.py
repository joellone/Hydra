class tc_list:
    testcast_list = []

    def read_file(self, file):
        fd = open(file, 'r')
        lines = fd.readlines()
        print("Reading testcase list:")
        for line in lines:
            # print(line)
            if ('`include' in line):
                # print('valid line')
                begin_index = len('`include \"testcase/')
                end_index = line.find('.sv')
                tc_name = line[begin_index:end_index]
                print(tc_name)
                self.testcast_list.append(tc_name)
