class verification_env:
    def get_file(self, str):
        fd = open('log_file', 'w+')
        fd.write(str)
        fd.close
