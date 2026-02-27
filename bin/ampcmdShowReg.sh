#! /bin/sh

if [ $# -ne 1 ];then
	echo "ERROR::input para is not right!";
	return 1;
elif [ "$1" = "0" ];then
	ampcmd reg showinfo 0 0
	return $?
elif [ "$1" = "1" ];then
	ampcmd reg showinfo 1 0
	return $?
elif [ "$1" = "3" ];then
	ampcmd reg showinfo 3 0
	return $?
elif [ "$1" = "4" ];then
	ampcmd reg showinfo 4 0
	return $?
elif [ "$1" = "5" ];then
	ampcmd reg showinfo 5 0
	return $?
elif [ "$1" = "6" ];then
	ampcmd reg showinfo 6 0
	return $?
else
	echo "ERROR::input para is not right!"
	return 1;
fi