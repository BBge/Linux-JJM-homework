echo 请输入一个字符串:
read str_1;
#除去字符串中除了'a' - 'z'  和 'A' - 'Z'之外的所有字符
str_2=`echo -n $str_1|tr -d -c 'a-zA-Z'`;    
echo 经过转化后的字符串：$str_2;
length=`echo -n $str_2|wc -c`;                
mid=$(($length/2));                   
i=1;
#判断是否回文
while [ $i -le $mid ]; do
	#character_1代表从第一个字符开始
    character_1=`echo -n $str_2|cut -c $i`;
    #character_2代表从第二个字符开始
    character_2=`echo -n $str_2|cut -c $length`;
    if [ $character_1 != $character_2 ]; then
        echo "$str_2 不是一个回文串";
        break;
    fi
    i=$(($i+1));
    length=$(($length-1));
done
if [ $character_1 = $character_2 ];then
    echo "$str_2 是一个回文串"
fi
