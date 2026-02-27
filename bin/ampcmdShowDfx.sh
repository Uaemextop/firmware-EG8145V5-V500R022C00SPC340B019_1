
#! /bin/sh

if [ $# -ne 1 ];then
	echo "ERROR::input para is not right!";
	return 1;
elif [ "$1" = "0" ];then
	ampcmd dfx showinfo 0
	return $?
elif [ "$1" = "1" ];then
	ampcmd dfx showinfo 1
	return $?
else
	echo "ERROR::input para is not right!"
	return 1;
fi