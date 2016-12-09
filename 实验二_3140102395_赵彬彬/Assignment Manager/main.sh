#! /bin/bash

clear

while [[ true ]]; do
    echo "###################################"
    echo "#      欢迎使用作业管理系统       #"
    echo "#      作者:赵彬彬                #"
    echo "#      学号:3140102395            #"
    echo "#      version:1.2                #"
    echo "###################################"

	echo "       请选择登录用户"
	echo "        1 —— 管理员"
	echo "        2 —— 教师"
	echo "        3 —— 学生"
	echo "        0 —— 退出"
	read num

	case $num in
		1) bash admin.sh;;
		2) bash teacher.sh;;
		3) bash student.sh;;
		0) clear
		
		while [[ true ]]; do
			exit
		done;;
		*) echo "请输入正确的编号"
		sleep 1
		clear;;

	esac
done
