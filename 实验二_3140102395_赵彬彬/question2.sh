#随机生成100个数存储到数组中，替代手工输入100个数
for((i=0;i<100;++i)); do
    #random 0 9999;
    array[$i]=$(($RANDOM%10000));
    printf "%d " ${array[$i]};
done
printf "\n";

i=0;
#定义一个max和min用于之后寻找最大最小值
max=0;
min=999999999;
#定义sum用来求和，用average来获得平均值
sum=0;
average=0;
while([ $i -lt ${#array[@]} ]); #将数组长度赋值给i，也可以直接用100
do
    if [ $min -gt ${array[$i]} ]; #如果min比当前值大，那么将当前值赋值给min
      then
        min=${array[$i]};
    fi
    if [ $max -lt ${array[$i]} ]; #如果max比当前值小，那么将当前值赋值给max
      then
        max=${array[$i]};        
    fi
    let "i++";
done

#排序
for((i=1;i< ${#array[@]};i++));
do
    k=${array[$i]};
    for((j=i-1;j>=0;j--));
    do
        if [  ${array[$j]} -gt $k ];
         then
            array[$[ $j + 1 ]]=${array[$j]};
            array[$j]=$k;
        fi
    done
done

#求平均值
for((i=0;i<${#array[@]};i++));
do
  sum=$(($sum+${array[$i]}));
done

#output the res:MAX,MIN,SORT
echo "最大值: $max";
echo "最小值: $min";
echo "总和:   $sum";
awk 'BEGIN{printf "平均值: %.2f\n",('$sum'/'${#array[@]}')}';
echo "排序后的结果(从小到大）:";
i=0;
while [[ $i -lt ${#array[@]} ]]; 
do
    printf "%d " ${array[$i]};
    let "i++";
done
printf "\n";
