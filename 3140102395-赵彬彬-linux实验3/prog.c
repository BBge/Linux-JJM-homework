#include <stdio.h>
#include <stdlib.h>
#include <sys/types.h>
#include <sys/wait.h>
#include <unistd.h>
#include <string.h>

int main()
{
	pid_t p1, p2, p3;
	int r_num;
	int pipe_fd1[2], pipe_fd2[2];
	char message_p1[] = "Child process p1 is sending a message!\n";
	char message_p2[] = "Child process p2 is sending a message!\n";
	char read_p1[100], read_p2[100];
	
	if (pipe(pipe_fd1) < 0) {
		printf("创建管道1失败");
		exit(0);
	}
	if (pipe(pipe_fd2) < 0) {
		printf("创建管道2失败");
		exit(0);
	}
	
	p1 = fork();
	if (p1 < 0) {
		perror("创建子进程p1失败");
		exit(0);
	} else if (p1 == 0) { 
	    /*子进程p1创建成功*/		
		p3 = fork();
		if (p3 < 0) {
			perror("创建子进程p3失败");
			exit(0);
		} else if (p3 == 0) {
		/*子进程p3创建成功*/
			printf("\n");
			printf("I am child process p3\n");
			printf("My(p3) pid is %d\n", getpid());
			
			execl("/bin/ls", "ls", "-l", "-r", NULL);
			
		} else {
			/*进程p1*/
			
			close(pipe_fd1[0]);
			if (write(pipe_fd1[1], message_p1, strlen(message_p1)) == -1) {
				printf("p1向管道1写入数据失败\n");
				exit(0);
			}
			close(pipe_fd1[1]);
			
			close(pipe_fd2[1]);
			if (read(pipe_fd2[0], read_p1, 100) <= 0) {
				printf("p1从管道2读取数据失败\n");
				exit(0);
			}
			printf("\np1从管道2读取的信息为:%s", read_p1);
			close(pipe_fd2[0]);
			
			printf("My(p1) pid is %d\n", getpid());
			
			waitpid(p3, NULL, 0);
			exit(0);
		}
		
	} else { /*prog进程（父进程）*/
		
		p2 = fork();
		if (p2 < 0) {
			perror("创建子进程p2失败");
			exit(0);
		} else if (p2 == 0) {
			/*子进程p2*/
			
			close(pipe_fd1[1]);
			if (read(pipe_fd1[0], read_p2, 100) <= 0) {
				printf("p2从管道1读取数据失败\n");
				exit(0);
			}
			printf("\n");
			printf("p2从管道1读取的信息为:%s", read_p2);
			close(pipe_fd1[0]);
			
			close(pipe_fd2[0]);
			if (write(pipe_fd2[1], message_p2, strlen(message_p2)) == -1) {
				printf("p2向管道2写入数据失败\n");
				exit(0);
			}
			close(pipe_fd2[1]);
			
			printf("My(p2) pid is %d\n", getpid());
			
		} else {
			/*prog进程*/
			printf("\n");
			printf("I am main process\n");
			printf("My(prog) pid is %d\n", getpid());
			
			waitpid(p1, NULL, 0);
			waitpid(p2, NULL, 0);
		}
	}
}
