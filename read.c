#include<stdio.h>
#include<stdlib.h>
#include<fcntl.h>
#include<sys/mman.h>
#include<unistd.h>
#include<string.h>

struct stu
{ 
	int id; 
	char name[20]; 
	char sex;
};

void sys_err(char* err)
{ 
	perror(err); 
	exit(-1);
}

int main(int argc, char* argv[])
{ 
	if(argc < 2) 
	{ 
		printf("./mmap_w file_share/n"); 
		exit(2); 
	} 
	
	int fd = open(argv[1], O_RDONLY); 
	if(fd == -1) sys_err("open file fail"); 
	struct stu student; 
	struct stu* mm; 
	mm = mmap(NULL, sizeof(student), PROT_READ, MAP_SHARED, fd, 0); 
	if(mm == MAP_FAILED) sys_err("mmap fail"); 
	close(fd); 
	while(1) 
	{ 
		printf("id = %d, name = %s, sex = %c/n", mm->id, mm->name, mm->sex); 
		sleep(2); 
	} 
	munmmap(mm, sizeof(student)); 
	return 0;
}