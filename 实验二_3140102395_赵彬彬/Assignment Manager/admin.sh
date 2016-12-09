#! /bin/bash

#判断该教师是否存在
teacher_exits()
{
	echo "$tid"
	if [[ -n $(sed -n "/^$tid/p" teachers) ]]; then
		return 0
	else
		return 1
	fi
}
#判断该课程是否存在
lecture_exits()
{
	echo "$lid"
	if [[ -n $(sed -n "/^$lid/p" lectures) ]]; then
		return 0
	else
		return 1
	fi
}

#绑定老师和课程
connect_teacher_lecture()
{
	echo "你将要绑定老师和课程"
	echo "请输入课程编号:"
	read lid

	#课程编号只可以使用'a'-'z'、'A'-'Z'和'0'-'9'
	lid=$(echo $lid | sed 's/[^a-zA-Z0-9]*//g')

	if lecture_exits "$lid"
	then
		echo "课程编号有效!"
	else
		echo "课程编号无效!"
		sleep 1
		return 0
	fi

	echo "请输入教师编号:"
	read tid
    #教师编号只可以使用'a'-'z'、'A'-'Z'和'0'-'9'
	tid=$(echo $tid | sed 's/[^a-zA-Z0-9]*//g')

	if teacher_exits "$tid"
	then
		echo "教师编号有效!"
	else
		echo "教师编号无效!"
		sleep 1
		return 0
	fi
	sleep 1

	while [[ true ]]; do
		echo "课程编号: "$lid
		echo "教师编号: "$tid
		echo "是否绑定? (y/n)"
		read x
		case "$x" in
			y )
			#添加一条新的记录到文件中
			printf "$lid $tid\n">>teaches 
			echo "OK"
			sleep 1
			return	1;;
			n ) return 0;;
			*) echo "请输入 y 或 n"
		esac
		sleep 1
	done
}

#将老师和课程解绑
disconnect_teacher_lecture()
{
	echo "你将要解绑一门课程"
	echo "请输入课程编号:"
	read lid

	#课程编号只可以使用'a'-'z'、'A'-'Z'和'0'-'9'
	lid=$(echo $lid | sed 's/[^a-zA-Z0-9]*//g')

	
	echo "Input teacher ID:"
	read tid

	#教师编号只可以使用'a'-'z'、'A'-'Z'和'0'-'9'
	tid=$(echo $tid | sed 's/[^a-zA-Z0-9]*//g')

	while [[ true ]]; do
		echo "课程编号: "$lid
		echo "教师编号: "$tid
		echo "解绑? (y/n)"
		read x
		case "$x" in
			y )
			sed "/^$lid $tid/d" teaches>output
			mv -f output teaches
			echo "OK"
			sleep 1
			return	1;;
			n ) return 0;;
			*) echo "请输入 y 或 n"
		esac
		sleep 1
	done
}

#添加一门新的课程
addLecture()
{
	echo "你将要添加一门新的课程"
	echo "请输入课程编号:"
	read lid

	
	#课程编号只可以使用'a'-'z'、'A'-'Z'和'0'-'9'
	lid=$(echo $lid | sed 's/[^a-zA-Z0-9]*//g')
	echo "请输入课程名字:"

	read lname
	lname=$(echo $lname | sed 's/[^a-zA-Z0-9]*//g')


	while [[ true ]]; do
		echo "Name: "$lname
		echo "ID: "$lid
		echo "是否创建课程? (y/n)"
		read x
		case "$x" in
			y )
			#添加一条新的记录到课程文件当中
			printf "$lid $lname\n">>lectures 
			echo "OK"
			sleep 1
			return	1;;
			n ) return 0;;
			*) echo "请输入 y 或 n"
		esac
		sleep 1
	done
}

#创建一个教师账号
addTeacher()
{
	echo "你将要创建一个新的教师账号"
	echo "请输入教师编号:"
	read tid

	
	#教师编号只可以使用'a'-'z'、'A'-'Z'和'0'-'9'
	tid=$(echo $tid | sed 's/[^a-zA-Z0-9]*//g')
	echo "请输入教师名字:"

	read tname
	tname=$(echo $tname | sed 's/[^a-zA-Z0-9]*//g')


	while [[ true ]]; do
		echo "Name: "$tname
		echo "ID: "$tid
		echo "是否创建账号? (y/n)"
		read x
		case "$x" in
			y )
			#添加一条新的记录到教师文件中
			printf "$tid $tname\n">>teachers 
			echo "OK"
			sleep 1
			return	1;;
			n ) return 0;;
			*) echo "请输入 y 或 n"
		esac
		sleep 1
	done
}

#列出所有课程
listallLecture()
{
	echo "课程编号 课程名字"
	echo "---------------"
	cat lectures
	echo "---------------"
	echo "输入q退出"

	while [[ true ]]; do
		read x
		case "$x" in
			q) clear 
			return 1;;
			
			*);;
		esac
	done
}

#列出所有老师
listallTeacher()
{
	echo "老师编号 老师名字"
	echo "---------------"
	cat teachers
	echo "---------------"
	echo "输入q退出"

	while [[ true ]]; do
		read x
		case "$x" in
			q) clear 
			return 1;;
			
			*);;
		esac
	done
}

#列出所有绑定的课程以及老师
listallConnect()
{
	echo "课程编号 教师编号"
	echo "---------------"
	cat teaches
	echo "---------------"
	echo "输入q退出"

	while [[ true ]]; do
		read x
		case "$x" in
			q) clear 
			return 1;;
			
			*);;
		esac
	done
}

#删除课程
deleteLecture()
{
	echo "你将要删除一门课程"
	echo "请输入课程编号:"
	read lid

	
	#课程编号只可以使用'a'-'z'、'A'-'Z'和'0'-'9'
	lid=$(echo $lid | sed 's/[^a-zA-Z0-9]*//g')

	while [[ true ]]; do
		echo "课程编号: "$lid
		echo "是否删除该课程? (y/n)"
		read x
		case "$x" in
			y )
			#从lectures文件中删除对应记录
			sed "/^$lid /d" lectures>output
			mv -f output lectures
			echo "OK"
			sleep 1
			return	1;;
			n ) return 0;;
			*) echo "请输入 y 或 n"
		esac
		sleep 1
	done
}


#删除教师账号
deleteTeacher()
{
	echo "你将要删除一个教师账号"
	echo "请输入教师编号:"
	read tid

	#教师编号只可以使用'a'-'z'、'A'-'Z'和'0'-'9'
	tid=$(echo $tid | sed 's/[^a-zA-Z0-9]*//g')

	while [[ true ]]; do
		echo "ID: "$tid
		echo "是否删除账号? (y/n)"
		read x
		case "$x" in
			y )
			#从teachers文件中删除记录
			sed "/^$tid/d" teachers>output
			mv -f output teachers
			echo "OK"
			sleep 1
			return	1;;
			n ) return 0;;
			*) echo "请输入 y 或 n"
		esac
		sleep 1
	done
}

while [[ true ]]; do
	clear
	echo "###################################"
    echo "#      欢迎使用作业管理系统       #"
    echo "###################################"
	echo "管理员你好，请根据指示输入编号"
	echo "1 —— 创建教师账号"
	echo "2 —— 删除教师账号"
	echo "3 —— 列出所有教师账号"
	echo "4 —— 添加一门课程"
	echo "5 —— 删除一门课程"
	echo "6 —— 列出所有课程"
	echo "7 —— 绑定老师和课程"
	echo "8 —— 将老师和课程解绑"
	echo "9 —— 列出绑定的老师和课程"
	echo "0 —— 退出"
	read num

	case $num in
		1) addTeacher;;		
		2) deleteTeacher;;
		3) listallTeacher;;
		4) addLecture;;
		5) deleteLecture;;
		6) listallLecture;;
		7) connect_teacher_lecture;;
		8) disconnect_teacher_lecture;;
		9) listallConnect;;
		0) clear
		
		while [[ true ]]; 
		do
			exit
		done;;
		*) echo "请输入正确的编号"
		sleep 1
		clear;;

	esac
done

