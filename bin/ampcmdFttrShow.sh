#! /bin/sh

isNum()
{
	number=`echo $1 | grep ^[0-9]*$`
	result=1
	if [ ! -z "$number" ]; then 
		result=0
	fi
	return $result
}

if [ $# -eq 1 ];then
	if [ "$1" = "onlineedgeont" ];then
		ampcmd show onlineedgeont
		return $?
	elif [ "$1" = "edgeontinfo" ];then
		ampcmd show edgeontinfo
		return $?
	elif [ "$1" = "omcistatinfo" ];then
		ampcmd show omcistatinfo
		return $?
	elif [ "$1" = "failinfo" ];then
		ampcmd show failinfo
		return $?
	elif [ "$1" = "debugont" ];then
		ampcmd show debugont
		return $?
	else
		echo "ERROR::input para is not right!"
		return 1;
	fi
elif [ $# -eq 2 ];then
	isNum $2
	if [ $? -ne 0 ]; then
		echo "ERROR::input para is not right!"
		return 1;
	fi
 
	let var=$2;
	if [ $var -lt 0 ] || [ $var -gt 15 ];then
		echo "ERROR::input para is not right!"
		return 1;
    fi

	if [ "$1" = "saveinfo" ];then
		ampcmd show saveinfo 0 $2
		return $?
	elif [ "$1" = "ontpathinfo" ];then
		ampcmd show ontpathinfo 0 $2
		return $?
	elif [ "$1" = "edgeontinfo" ];then
		ampcmd show edgeontinfo 0 $2
		return $?
	else
		echo "ERROR::input para is not right!"
		return 1;
	fi
else
	echo "ERROR::input para is not right!"
	return 1;
fi