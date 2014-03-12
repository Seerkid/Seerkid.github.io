---
layout: post
title: "Linux进程控制系统调用"
date: 2014-03-12 02:00:44 +0800
comments: true
categories: 
---


>Some notes of course


##进程的状态


TASK_RUNNING(运行):可执行状态 

*   正在执行
*   在就绪队列中等待

TASK_INTERRUPTIBLE(可中断):睡眠（阻塞）

*   条件满足，内核将其状态设置为运行。
*   收到信号而被提前唤醒并投入运行。 

TASK_UNINTERRUPTIBLE(不可中断）：

*   同可中断状态，但不会因为接收到信号而被唤醒

TASK_ZOMBIE(僵死):

*   该进程已经结束，但其父进程尚未调用wait()，子进程的进程描述符仍然被保留着。

TASK_STOPPED(停止) — 停止执行

*   这种状态发生在接收到SIGSTOP、SIGTSTP、SIGTTIN、SIGTTOU等信号的时候。此外，在调试期间接收到任何信号，都会使进程进入这种状态。


``` c

//子进程与父进程

#include <stdio.h>
#include <stdlib.h>

int main(void){

	pid_t pid;

	printf("Original process: PID = %d,PPID = %d \n",getpid(),getppid());
	pid = fork();

	if( pid ==-1 ) { perror("fork");	exit(1); }
	
	if( pid != 0 )
		printf(" Parent process: PID = %d, PPID = %d, CPID = %d \n  ", getpid(), getppid(), pid);
	
	else {
		sleep(2);
		printf(" Child process :PID = %d, PPID = %d, \n ",getpid(), getppid());
	}

	printf (" Process with PID = %d terminates \n ",getpid() );
}
```

