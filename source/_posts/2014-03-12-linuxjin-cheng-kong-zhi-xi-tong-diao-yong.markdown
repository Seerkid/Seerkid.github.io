---
layout: post
title: "Linux进程控制系统调用"
date: 2014-03-12 02:00:44 +0800
comments: true
categories: 
---

###0x01 
编例实现创建n个子进程P1，P2，…，Pn,其中，各进程之间的关系是：P1是调用进程的子进程，P(k+1)是Pk的子进程。请打印各进程本身的进程号、父进程号，子进程号。参考运行结果如下。  
要求:

*	每个父进程都要等待子进程退出后才能退出；
*	n通过命令行参数传入；
*	附上源代码截图和运行结果截图。


``` c
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>

int main( int argc,char * argv[] ){

	pid_t childpid = 0;
	int i,n;

	if (argc!=2){
		fprintf(stderr, "Usage :%s  processes\n",argv[0] );
		return 1;
	}

	n = atoi ( argv[1] );

	for ( i=0; i<n; ++i ){
		if ( childpid == 0 ){
			childpid = fork();
			if( childpid > 0 )
				break;
		}
	}

	if( i>0 )
		printf("P%d :  Process Id:%d, Parent Id:%d, childid:%d \n",i,getpid(),getppid(),childpid );

	if ( childpid > 0 )
		waitpid(childpid,NULL,0);

//	printf(" Process with PID = %d terminates \n ",getpid() ); // Test code
}


```

###0x02

编例实现创建n个子进程P1，P2，…，Pn,其中，各进程之间的关系是：P1，…,Pn都是调用进程的子进程。请打印各进程本身的进程号、父进程号，子进程号。参考运行结果如下。  
要求：

*	每个父进程都要等待子进程退出后才能退出；
*	n通过命令行参数传入；
*	附上源代码截图和运行结果截图.

```c

#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#define MAXLEN 1000

int main( int argc,char * argv[] ){

	pid_t childpid = 1 ,CPID[MAXLEN];
	int i,n;

	if ( argc!=2 ){
		fprintf(stderr, "Usage :%s  processes\n",argv[0] );
		return 1;
	}

	n = atoi ( argv[1] );

	for ( i=1; i<=n; ++i ){
		if ( childpid > 0 ){
			CPID[i]=childpid = fork();
			if( childpid == 0 )
				break;
		}
	}

	if( childpid == 0)
		printf("P%d :  Process Id:%d, Parent Id:%d, childid:%d \n",i,getpid(),getppid(),childpid );		
	if( childpid > 0 ){

		for( i=1; i<=n; ++i )
			waitpid(CPID[i],NULL,0);	
		printf("P0 :  Process Id:%d, Parent Id:%d, childid: ",getpid(),getppid());
		for( i=1; i<=n; ++i ){
			printf("%d ",CPID[i] );	
		}
		printf("\n");	
	}
}


```


###0x03
编例实现创建n=2d-2个子进程P1，P2，…，Pn,其中，d是树的深度且d>=1, P1和P2是调用进程的子进程，P3和P4是P1的子进程，P5和P6是P2的子进程。也就是各进程之间的关系是：Pi是P2i+1和P2i+2的父进程，也是组成二叉树的关系，如下图所示。对于不是叶子的进程，将其ID和父进程ID打印出来。参考运行结果如下。   
要求：

*	每个父进程都要等待子进程退出后才能退出；
*	d通过命令行参数传入；
*	附上源代码截图和运行结果截图。


感觉这道题实现的有点奇葩，应该有更好的实现方式，有时间再去折腾吧～ :)


```c

#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>

int main( int argc,char * argv[] ){

  pid_t Lchildpid = 0,Rchildpid = 0;
  int i,depth,no =0;

  if (argc!=2){
      fprintf(stderr, "Usage :%s  processes\n",argv[0] );
      return 1;
  }

  depth = atoi ( argv[1] );

  for ( i=1; i<depth; ++i ){
    if ( Lchildpid == 0 ){
    	Lchildpid = fork();
    	if (Lchildpid == 0){
    		no = no*2 + 1;
		Rchildpid = Lchildpid =0;
    		continue;
    	}
    }

    if ( Rchildpid == 0 ){
    	Rchildpid = fork();
    	if ( Rchildpid == 0 ){
    		no = no*2 + 2;
    		Rchildpid = Lchildpid =0;
    	}
    }
    if ( (Lchildpid>0) && (Rchildpid>0) )
		break;      
  }

  if ( Rchildpid > 0 ){
      waitpid(Rchildpid,NULL,0); 
      waitpid(Lchildpid,NULL,0); 
   }

      printf("P%d :  Process Id:%d, Parent Id:%d, Left Childid:%d, Right Childid:%d \n",no,getpid(),getppid(),Lchildpid, Rchildpid );


}


```


### 0x04
实现Linux守护进程的创建，如可以自己添加个性化功能（自行发挥，如写文件。。。等）。


	I will finish it later :)
