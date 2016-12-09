#判断作业是否存在
homework_exits()
{
	filename=$(echo $tid"_"$lid"_homework")
	echo "$hid"
	if [[ -n $(sed -n "/^$hid /p" $filename) ]]; then
		return 0
	else
		return 1
	fi
}

#判断课程是否存在
lecture_exits()
{
	echo "$lid"
	if [[ -n $(sed -n "/^$lid/p" lectures) ]]; then
		return 0
	else
		return 1
	fi
}

#判断教师是否存在
teacher_exits()
{
	echo "$tid"
	if [[ -n $(sed -n "/^$tid/p" teachers) ]]; then
		return 0
	else
		return 1
	fi
}

#判断学生是否存在
student_exits()
{
	filename=$(echo $tid"_"$lid"_students")
	echo "$sid"
	if [[ -n $(sed -n "/^$sid /p" $filename) ]]; then
		return 0
	else
		return 1
	fi
}

#列出所有作业
listHomework()
{
	#创建目录，如果目录不存在
	if [[ -d $(echo $tid"_"$lid"_files") ]]; then
		echo "ok">/dev/null
	else
		mkdir  $(echo $tid"_"$lid"_files")
	fi

	filename=$(echo $tid"_"$lid"_homework")

	#创建文件，如果文件不存在

	if [[ -e $filename ]]; then
		echo "ok">/dev/null
	else
		touch $filename
	fi
	echo "作业编号 作业名字"
	echo "---------------"
	cat $filename
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

#编辑你的作业
editHomework()
{
	echo "请输入作业编号:"
	read hid

	if homework_exits
	then
		echo "作业编号有效!"
	else
		echo  "作业编号无效!"
		sleep 1
		return 0
	fi

	filename=$(echo $tid"_"$lid"_files/"$hid"_"$sid)

	if [[ -e $filename ]]; then
		echo "ok">/dev/null
	else
		touch $filename
	fi

	echo "当前作业答案:"
	cat $filename
	echo "请输入新的作业答案:"
	read input
	echo $input>$filename
}


echo "请输入你的任课老师的编号:"
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

echo "请输入你上的课的课程编号:"
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


echo "请输入你的学生编号:"
read sid


sid=$(echo $sid | sed 's/[^a-zA-Z0-9]*//g')

if student_exits "$sid"
then
	echo "学生编号有效!"
else
	echo "学生编号无效!"
	sleep 1
	return 0
fi

while [[ true ]]; do
	clear
	echo "###################################"
    echo "#      欢迎使用作业管理系统       #"
    echo "###################################"
	echo "学生你好，请根据指示输入编号"

	echo "1 —— 列出作业"
	echo "2 —— 编辑作业"
	echo "0 —— 退出"
	read num

	case $num in
		1) listHomework;;
		2) editHomework;;
		0) clear
		
		sleep 1
		while [[ true ]]; do
			exit
		done;;
		*) echo "请输入正确的编号"
		sleep 1
		clear;;

	esac
done