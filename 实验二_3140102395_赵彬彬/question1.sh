#! /bin/bash
printf "Please input file path\n";
read filepath
index=0;
j=0;
oridinary_file=0;
directory_file=0;
executable_file=0;
total_byte=0;
#将路径名存储在数组中
for s in `ls $filepath`; do
files[index]=$s;
let "index++";
done
#遍历所有数组
while ([ $j -lt $index ]); do
ts=$filepath"/"${files[j]};
#如果该文件是ordinary file，那么fn++
if [ -f $ts ]; then
let "oridinary_file++";
for ts in `wc -c $ts`; do
res=$ts;
break;
done
total_byte=$[$total_byte + $res];
#如果该文件是directory，那么dn++
elif [ -d $ts ]; then
let "directory_file++";
fi
#如果该文件是executable，那么xn++
if [ -x $ts ]; then
let "executable_file++";
fi
let "j++";
done
printf "Ordinary File = $oridinary_file\n";
printf "Directory = $directory_file\n";
printf "Executable File = $executable_file\n";
printf "Total Byte = $total_byte\n";
