#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <pthread.h>
#include <unistd.h>

int number; /*全局变量number表示Fibonacci序列个数*/
void *calculate(void *a);/*Fibonacci的计算*/

int main(void)
{
	int i, temp, *p;
	pthread_t tid;
	
	
	printf("请输入Fibonacci序列的个数:");
	scanf("%d", &number);
	
	/*分配一块动态内存*/
	p = (int *)malloc(sizeof(int) * number);
	
	/*创建线程*/
	temp = pthread_create(&tid, NULL, calculate, p);
	/*无法创建线程时的错误提示*/
	if (temp != 0)
		fprintf(stderr, "无法创建线程: %s\n", strerror(temp));
	
	/*等待线程结束*/
	temp = pthread_join(tid, NULL);

	/*线程无法结束时的错误提示*/
	if (temp != 0)
		fprintf(stderr, "线程无法结束: %s\n", strerror(temp));

	printf("正在等待子进程结束...\n");

	/*子进程结束后，父进程会输出Fibnoacci序列*/
	for (i = 0; i < number; i++)
		printf("%d  ", p[i]);

    free(p);
	printf("\n");
	
	return 0;
	
}

void *calculate(void *a)
{
	int i;
	
	/*计算Fibonacci序列并赋给数组a*/
	if (number == 1) {
		*((int *)a) = 0;
	} else {
		*((int *)a) = 0;
		*((int *)a + 1) = 1;
		for (i = 2; i < number; i++)
			*((int *)a + i) = *((int *)a + i - 1) + *((int *)a + i - 2);
	}
}
