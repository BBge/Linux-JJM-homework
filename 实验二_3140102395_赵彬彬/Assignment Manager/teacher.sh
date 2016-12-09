lecture_exits()
{
	echo "$lid"
	if [[ -n $(sed -n "/^$lid/p" lectures) ]]; then
		return 0
	else
		return 1
	fi
}

teacher_exits()
{
	echo "$tid"
	if [[ -n $(sed -n "/^$tid/p" teachers) ]]; then
		return 0
	else
		return 1
	fi
}

listFiles()
{
	menu=$(echo $tid"_"$lid"_files")
	if [[ -d $(echo $tid"_"$lid"_files") ]]; then
		
		echo "ok">/dev/null
	else
		mkdir  $(echo $tid"_"$lid"_files")
	fi
	echo "作业编号_学生编号:"
	ls $menu 
	echo "按任意键继续"
	read nothing
}

#查看作业
viewFile()
{
	menu=$(echo $tid"_"$lid"_files")
	if [[ -d $(echo $tid"_"$lid"_files") ]]; then
		
		echo "ok">/dev/null
	else
		mkdir  $(echo $tid"_"$lid"_files")
	fi
	echo "请输入作业编号_学生编号查看:"
	echo "example : homework1_st1"
	read input
	cat $menu"/"$input
	echo "按任意键继续"
	read nothing
}

#添加作业
addHomework()
{
	if [[ -d $(echo $tid"_"$lid"_files") ]]; then
		
		echo "ok">/dev/null
	else
		mkdir  $(echo $tid"_"$lid"_files")
	fi

	filename=$(echo $tid"_"$lid"_homework")

	if [[ -e $filename ]]; then
		echo "ok">/dev/null
	else
		touch $filename
	fi

	echo "你将要添加一份新的作业"
	echo "请输入作业编号:"
	read hid

	#作业编号只可以使用'a'-'z'、'A'-'Z'和'0'-'9'
	hid=$(echo $hid | sed 's/[^a-zA-Z0-9]*//g')
	echo "请输入作业名字:"
	
	read hname
	hname=$(echo $hname | sed 's/[^a-zA-Z0-9]*//g')


	while [[ true ]]; do
		echo "作业名字: "$hname
		echo "作业编号: "$hid
		echo "是否创建该作业? (y/n)"
		read x
		case "$x" in
			y )
			#加入一条新的记录
			printf "$hid $hname\n">>$filename 
			echo "OK"
			sleep 1
			return	1;;
			n ) return 0;;
			*) echo "请输入 y 或 n"
		esac
		sleep 1
	done
}

#添加学生
addStudent()
{
	filename=$(echo $tid"_"$lid"_students")

	if [[ -e $(echo $tid"_"$lid"_students") ]]; then
		echo "ok">/dev/null
	else
		touch $filename
	fi

	echo "你将要添加一个学生账号"
	echo "请输入学生编号:"
	read sid

	
	sid=$(echo $sid | sed 's/[^a-zA-Z0-9]*//g')
	echo "请输入学生名字:"
	
	read sname
	sname=$(echo $sname | sed 's/[^a-zA-Z0-9]*//g')


	while [[ true ]]; do
		echo "学生姓名: "$sname
		echo "学生编号: "$sid
		echo "是否创建账号? (y/n)"
		read x
		case "$x" in
			y )
			
			printf "$sid $sname\n">>$filename 
			echo "OK"
			sleep 1
			return	1;;
			n ) return 0;;
			*) echo "请输入 y 或 n"
		esac
		sleep 1
	done
}

#列出所有学生
listStudent()
{
	filename=$(echo $tid"_"$lid"_students")

	if [[ -e $(echo $tid"_"$lid"_students") ]]; then
		echo "ok">/dev/null
	else
		touch $filename
	fi
	echo "学生编号 学生名字"
	echo "---------------"
	cat $(echo $tid"_"$lid"_students")
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

#列出所有作业
listHomework()
{
	if [[ -d $(echo $tid"_"$lid"_files") ]]; then
		
		echo "ok">/dev/null
	else
		mkdir  $(echo $tid"_"$lid"_files")
	fi

	filename=$(echo $tid"_"$lid"_homework")

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

#删除作业
delHomework()
{

	filename=$(echo $tid"_"$lid"_homework")

	if [[ -e $filename ]]; then
		echo "ok">/dev/null
	else
		touch $filename
	fi
	echo "你将要删除一门作业"
	echo "请输入作业编号:"
	read hid

	#作业编号只可以使用'a'-'z'、'A'-'Z'和'0'-'9'
	hid=$(echo $hid | sed 's/[^a-zA-Z0-9]*//g')

	while [[ true ]]; do
		echo "作业编号: "$hid
		echo "是否删除该作业? (y/n)"
		read x
		case "$x" in
			y )
			#删除文件中保存的记录
			sed "/^$hid /d" $filename>output
			mv -f output $filename
			echo "OK"
			sleep 1
			return	1;;
			n ) return 0;;
			*) echo "请输入 y 或 n"
		esac
		sleep 1
	done
}

#删除学生账号
delStudent()
{
	filename=$(echo $tid"_"$lid"_students")

	if [[ -e $(echo $tid"_"$lid"_students") ]]; then
		echo "ok">/dev/null
	else
		touch $filename
	fi
	echo "你将要删除一个学生账号"
	echo "请输入学生编号:"
	read sid

	#学生编号只可以使用'a'-'z'、'A'-'Z'和'0'-'9'
	sid=$(echo $sid | sed 's/[^a-zA-Z0-9]*//g')

	while [[ true ]]; do
		echo "学生编号: "$sid
		echo "是否删除账号? (y/n)"
		read x
		case "$x" in
			y )
			#删除记录
			sed "/^$sid /d" $filename>output
			mv -f output $filename
			echo "OK"
			sleep 1
			return	1;;
			n ) return 0;;
			*) echo "输入 y 或 n"
		esac
		sleep 1
	done

}

#修改信息
modifyInfo()
{
	if [[ -e  $(echo $tid"_"$lid"_info") ]]; then
		echo "当前课程信息:"
		echo "教师编号  课程编号"
		cat $(echo $tid"_"$lid"_info")
		echo "按任意键继续"
		read nothing
	else
		touch $(echo $tid"_"$lid"_info")
		echo "当前课程信息:"
		echo "教师编号  课程编号"
		cat $(echo $tid"_"$lid"_info")
		echo "按任意键继续"
		read nothing
	fi
		echo "请输入新的课程信息(教师编号和课程编号）:"

		read info
		echo $info>$(echo $tid"_"$lid"_info")
	
}


echo "请输入你的教师编号:"
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

while [[ true ]]; do
	clear
	echo "###################################"
    echo "#      欢迎使用作业管理系统       #"
    echo "###################################"
	echo "老师您好，请根据指示输入编号"
	echo "1 —— 修改课程信息"
	echo "2 —— 添加学生"
	echo "3 —— 删除学生"
	echo "4 —— 列出所有学生"
	echo "5 —— 添加作业"
	echo "6 —— 删除作业"
	echo "7 —— 列出作业"
	echo "8 —— 列出已上传作业"
	echo "9 —— 查看学生的作业"
	echo "0 —— 退出"
	read num

	case $num in
		1) modifyInfo;;		
		2) addStudent;;
		3) delStudent;;
		4) listStudent;;
		5) addHomework;;
		6) delHomework;;
		7) listHomework;;
		8) listFiles;;
		9) viewFile;;
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