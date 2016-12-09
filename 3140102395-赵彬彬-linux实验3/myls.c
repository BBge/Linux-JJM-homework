#include <stdio.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <unistd.h>
#include <pwd.h>
#include <grp.h>
#include <time.h>
#include <dirent.h>
#include <string.h>

void showdir(char *dir);//显示文件夹
void showfile(char *path,char *name);//显示文件夹中的文件
void sizesort();//根据文件大小排序
void timesort();//根据时间排序

static int option_a = 0;     //判断是否为 ls -a，显示隐藏文件
static int option_l = 0;     //判断是否为 ls -l，列出文件的详细信息
static int option_1 = 0;     //判断是否为 ls -1，一行只输出一个文件
static int option_i = 0;     //判断是否为 ls -i，输出文件的i节点的索引信息
static int option_d = 0;     //判断是否为 ls -d，将目录像文件一样显示，而不是显示其下的文件
static int option_t = 0;     //判断是否为 ls -t，将文件以时间排序
static int option_n = 0;     //判断是否为 ls -n，用数字的UID,GID代替名称
static int option_F = 0;     //判断是否为 ls -F，显示不同的符号来区别文件
static int option_R = 0;     //判断是否为 ls -R，列出所有子目录下的文件
static int option_s = 0;     //判断是否为 ls -s，在每个文件名后输出该文件的大小
static int option_m = 0;     //判断是否为 ls -m，横向输出文件名，并以","作分隔符
static int option_o = 0;     //判断是否为 ls -o，显示文件的除组信息外的详细信息
static int option_r = 0;     //判断是否为 ls -r，对目录反向排序
static int option_Q = 0;     //判断是否为 ls -Q，把输出的文件名用双引号括起来
static int option_g = 0;     //判断是否为 ls -g，列出文件的详细信息，但不列出文件拥有者
static int option_B = 0;     //判断是否为 ls -B，不输出以~结尾的备份文件
static int option_N = 0;     //判断是否为 ls -N，输出不限制文件长度
static int option_S = 0;     //判断是否为 ls -S，以文件大小排序
static int option_A = 0;     //判断是否为 ls -A，显示除"."和".."外的所有文件
static int option_u = 0;     //判断是否为 ls -u，以文件上一次的访问时间排序

char filename_1[100];            //设置一个全局变量来存储文件名
int total = 0;  
             


char filename_2[100][100]; //用来倒序输出
int h = 0;                       //用于控制filename_2
int n = 0;                       //用于控制排序


struct size{                     //size结构用于按文件大小排序;
    int file_size;
    char name[100];
};

struct size filesize[100];

struct time1{                   //time1结构用于按时间顺序
    int year;
    int month;
    int day;
    char name[100];
};

struct time1 filetime[100];

void timesort()
{
    int i;
    int j;
    struct time1 temp;
    //冒泡排序
    for(i=0;i<n;i++)
    {
        for(j=i;j<n;j++)
        {   
            //比较文件的时间大小
            if((filetime[i].year<filetime[j].year) || 
               ((filetime[i].year == filetime[j].year)&& (filetime[i].month<filetime[j].month))||
               ((filetime[i].year == filetime[j].year)&& (filetime[i].month==filetime[j].month)&&
               (filetime[i].day<filetime[j].day)))
            {
                temp = filetime[i];
                filetime[i] = filetime[j];
                filetime[j] = temp;
            }
        }
    }
    for(i=0;i<n;i++)
        printf("%s    ",filetime[i].name);
}

void sizesort()
{
    int i;
    int j;
    struct size temp;

    //冒泡排序
    for(i=0;i<n;i++)
    {
        for(j=i;j<n;j++)
        {
            //比较文件的大小
            if(filesize[i].file_size<filesize[j].file_size)
            {
                temp = filesize[i];
                filesize[i] = filesize[j];
                filesize[j] = temp;
            }
        }
    }

    for(i=0;i<n;i++)
        printf("%s    ",filesize[i].name);
}


void showfile(char *path,char *name)
{
	struct stat buf;
	int i = 8;
    int j = 0;
    int k;
	struct tm *t;
	char filemode[11];//存储文件类型
    
	if(lstat(path,&buf) < 0)
	{
		perror("stat");
		return ;
	}
    
    //S_IFMT是文件类型的位遮罩
	switch(buf.st_mode & S_IFMT)
    {
    	//一般文件
        case S_IFREG:
    	             filemode[0] = '-';
    	             break;
        //socket
    	case S_IFSOCK:
    	             filemode[0] = 's';
    	             break;
        //符号链接
    	case S_IFLNK:
    	             filemode[0] = '1';
    	             break;
        //区块装置
    	case S_IFBLK:
    	             filemode[0] = 'b';
    	             break;
        //字符装置
    	case S_IFCHR:
    	             filemode[0] = 'c';
    	             break;
        //先进先出
    	case S_IFIFO:
    	             filemode[0] = 'p';
    	             break;
        //目录
        case S_IFDIR:
                     filemode[0] = 'd';
                     break;
    }
    while(i >= 0)
    {
    	if((buf.st_mode)&1 << i)
    	{
    		switch(i % 3)
    		{
    			case 2:
    			       filemode[9-i] = 'r';
    			       break;

    			case 1:
    			       filemode[9-i] = 'w';
    			       break;

    			case 0:
    			       filemode[9-i] = 'x';
    			       break;
    		}
    	}
    	else
    		filemode[9-i] = '-';

    	i--;
    }
    filemode[10] = '\0';
    //实现 ls -l 命令
    if(option_l == 1)
    {
    	printf("%s ",filemode);//输出文件类型
        printf("%2d ",buf.st_nlink);//该文件的硬链接数目
        printf(" %s\t%s\t",getpwuid(buf.st_uid)->pw_name,getgrgid(buf.st_gid)->gr_name);//输出用户名和组名
        
        //如果文件类型是区块装置和字符装置
        if(filemode[0] == 'c' || filemode[0] == 'b')
        {
        	printf("%5d,",buf.st_rdev >> 8);
        	printf("%2d",buf.st_rdev &0xff);
        }
        else
        	printf("%8lld ",buf.st_size);
        
        //用localtime函数取时间
        t = localtime(&buf.st_mtime);
        printf("%d %d %2d %2d:%d ",t->tm_year+1900,t->tm_mon+1,t->tm_mday,t->tm_hour,t->tm_min);
        printf("%s",name);

        printf("\n");
    }
    //实现 ls -n 命令
    else if(option_n == 1)
    {
        printf("%s ",filemode);//输出文件类型
        printf("%2d ",buf.st_nlink);//该文件的硬链接数目
        printf(" %d\t%d\t",getpwuid(buf.st_uid)->pw_uid,getgrgid(buf.st_gid)->gr_gid);//输出UID和GID

        //如果文件类型是区块装置和字符装置
        if(filemode[0] == 'c' || filemode[0] == 'b')
        {
            printf("%5d,",buf.st_rdev >> 8);
            printf("%2d",buf.st_rdev &0xff);
        }
        else
            printf("%8lld ",buf.st_size);

        //用localtime函数取时间
        t = localtime(&buf.st_mtime);
        printf("%d %d %2d %2d:%d ",t->tm_year+1900,t->tm_mon+1,t->tm_mday,t->tm_hour,t->tm_min);
        printf("%s  ",name);


        total = total +buf.st_size;
        printf("\n");
    }
    //实现 ls -o 命令
    if(option_o == 1)
    {
        printf("%s ",filemode);//输出文件类型
        printf("%2d ",buf.st_nlink);//该文件的硬链接数目
        printf(" %s\t",getpwuid(buf.st_uid)->pw_name);//输出用户名

        //如果文件类型是区块装置和字符装置
        if(filemode[0] == 'c' || filemode[0] == 'b')
        {
            printf("%5d,",buf.st_rdev >> 8);
            printf("%2d",buf.st_rdev &0xff);
        }
        else
            printf("%8lld ",buf.st_size);

        //用localtime函数取时间
        t = localtime(&buf.st_mtime);
        printf("%d %d %2d %2d:%d ",t->tm_year+1900,t->tm_mon+1,t->tm_mday,t->tm_hour,t->tm_min);
        printf("%s  ",name);

        printf("\n");
    }
    //实现 ls -i 命令
    else if(option_i == 1)
    	 {
             printf("%8llu %s      ",buf.st_ino,name);
             printf("\n");
         }
    //递归实现ls -R命令
    else if(option_R == 1)
         {
            printf("%s\n",name);

            //如果文件类型是目录，则递归输出内容
            if(filemode[0] == 'd')
               showdir(name);

         }
    //实现ls -s命令
    else if(option_s == 1)
         {
             printf("%4lld ",buf.st_blocks);
             printf("%s",name);
             printf("\n");
             total = total + buf.st_blocks;
         }
    //实现ls -m命令
    else if(option_m == 1)
         {
            printf("%s,  ",name);
         }
    //实现ls -A命令
    else if(option_A == 1)
         {
            printf("%s    ",name);
         }

    //实现ls -t命令   
    else if(option_t == 1)
         {
            //将每个文件的时间数据存到数组中，之后进行比较
             t = localtime(&buf.st_mtime);
             filetime[n].year = t->tm_year;
             filetime[n].month = t->tm_mon;
             filetime[n].day = t->tm_mday;
             strcpy(filetime[n].name,name);
             n++;
         }

    //实现ls -u命令
    else if(option_u == 1)
         {
             t = localtime(&buf.st_atime);
             filetime[n].year = t->tm_year;
             filetime[n].month = t->tm_mon;
             filetime[n].day = t->tm_mday;
             strcpy(filetime[n].name,name);
             n++;
         }

    //实现ls -B命令
    else if(option_B == 1)
         {
            for(k=0;name[k]!='\0';k++)
            {
                if(name[k]=='~')
                  break;
            }
            if(name[k] == '\0')
                printf("%-15s",name);
         }
    //当输入 ls -S
    else if(option_S == 1)
         {
            strcpy(filesize[n].name,name);
            filesize[n++].file_size = buf.st_size;
         }

    //实现ls -r命令
    else if(option_r == 1)
         {
            strcpy(filename_2[h++],name);//将文件名正向存到数组中，之后逆向输出
         }
    //实现ls -N命令
    else if(option_N == 1)
         {
            printf("%s     ",name);
         }
    //实现ls -Q命令
    else if(option_Q == 1)
         {
            printf("\"%s\"  ",name);//给每个文件名加上双引号
         }
    //实现ls -1命令
    else if(option_1 == 1)
         {
            printf("%s  ",name);
         }
    //实现ls -a命令
    else if(option_a == 1)
         {
            printf("%s  ",name);
         }
    //实现ls -g命令
    else if(option_g == 1)
        {
            printf("%s ",filemode);//输出文件类型
            printf("%2d ",buf.st_nlink);//该文件的硬链接数目
            printf(" %s\t",getpwuid(buf.st_uid)->pw_name);//输出用户名

            //如果文件类型是区块装置和字符装置
            if(filemode[0] == 'c' || filemode[0] == 'b')
            {
                printf("%5d,",buf.st_rdev >> 8);
                printf("%2d",buf.st_rdev &0xff);
            }
            else
                printf("%8lld ",buf.st_size);

            //用localtime函数取时间
            t = localtime(&buf.st_mtime);
            printf("%d %d %2d %2d:%d ",t->tm_year+1900,t->tm_mon+1,t->tm_mday,t->tm_hour,t->tm_min);
            printf("%s  ",name);


            printf("\n");
        }
    //实现ls -F命令
    else if(option_F == 1)
         { 
            //不同的文件类型，文件末尾添加不同的符号
            printf("%s",name);
            if(filemode[0] == 'd')
                printf("/");
            if(filemode[0] == '1')
                printf("@");
            if(filemode[0] == 'p')
                printf("|");
            if(filemode[0] == 's')
                printf("=");
            if((filemode[0] == '-') && (buf.st_mode & S_IXUSR))
                printf("*");
            printf("\n");
         }
    

}

void showdir(char *dir)
{
	DIR *dirp;
	struct dirent *dp;
	char name[100];
    int i=0;
	if((dirp = opendir(dir)) == NULL)
	{
		perror("opendir");
		return ;
	}

	while((dp = readdir(dirp)) != NULL)
	{
		if(option_a == 0)
		{
			if(dp->d_name[0] == '.')
				continue;
		}
        //实现 ls -d 命令
        if(option_d == 1)
        {
            printf("%s\n",filename_1);
            return;
        }
		sprintf(name,"%s/%s",dir,dp->d_name);
		showfile(name,dp->d_name);

        //实现 ls -1 命令，每行只输出一个
        if(option_1 == 1)
        {
            printf("\n");
        }
	}
        //计算total
        if(option_s == 1 || option_n ==1)
        {
            printf("total = %d",total);
            total = 0;
        }
        //将文件倒序输出
        if(option_r == 1)
        {
            for(i = h;i >= 0;i--)
                printf("%s     ",filename_2[i]);
        }
        //按时间排序
        if(option_t == 1 || option_u ==1)
        {
            timesort();
        }
        //按文件大小排序
        if(option_S == 1)
        {
            sizesort();
        }
		printf("\n");
}


int main(int argc,char **argv)
{
	struct stat buf;
	int i = 8;
	int oc;
	char filename[100];
    //将filename数组中的内容置为0
	memset(filename,0,sizeof(filename));
  
    strcpy(filename,".");
    strcpy(filename_1,filename);

    //选择输入的字符
	while((oc = getopt(argc,argv,"al1idntFRAsmorQgNBSu")) != -1)
	{
		switch(oc)
		{
			case 'a':
			         option_a = 1;
			         break;

            case 't':
                    option_t = 1;
                    break;

			case 'l':
			        option_l = 1;
			        break;

            case '1':
                    option_1 = 1;
                    break;  

            case 'i':
                    option_i = 1;
                    break;

            case 'd':
                    option_d = 1;
                    break;

            case 'n':
                    option_n = 1;
                    break;

            case 'F':
                    option_F = 1;
                    break;

            case 'A':
                    option_A = 1;
                    break;

            case 'R':
                    option_R = 1;
                    break;

            case 's':
                    option_s = 1;
                    break;
            
            case 'm':
                    option_m = 1;
                    break;

            case 'o':
                    option_o = 1;
                    break;

            case 'r':
                    option_r = 1;
                    break;

            case 'Q':
                    option_Q = 1;
                    break;
                    
            case 'g':
                    option_g = 1;
                    break;
            
            case 'N':
                    option_N = 1;
                    break;

            case 'B':
                    option_B = 1;
                    break;
 
            case 'S':
                    option_S = 1;
                    break;

            case 'u':
                    option_u = 1;
                    break;

			case '?':
			        printf("Unknown option:%c\n",(char)optopt);
			        break;
		}
	}

	if(stat(filename,&buf) < 0)
	{
		perror("stat");
		return -1;
	}

	if(S_ISDIR(buf.st_mode))
		showdir(filename);
	else 
		showfile(filename,filename);


	return 0;
}

