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
	if [ "$1" = "2" ];then
		ampcmd gmacdrv execcmd 2
		return $?
	elif [ "$1" = "3" ];then
		ampcmd gmacdrv execcmd 3
		return $?
	elif [ "$1" = "15" ];then
		ampcmd gmacdrv execcmd 15
		return $?
	elif [ "$1" = "17" ];then
		ampcmd gmacdrv execcmd 17
		return $?
	elif [ "$1" = "19" ];then
		ampcmd gmacdrv execcmd 19
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
	if [ "$1" = "9" ];then
		if [ $var -lt 0 ] || [ $var -gt 15 ];then
			echo "ERROR::input para is not right!"
			return 1;
		fi

		ampcmd gmacdrv execcmd 9 $2
		return $?
	elif [ "$1" = "14" ];then
		ampcmd gmacdrv execcmd 14 $2
		return $?
	elif [ "$1" = "16" ];then
		if [ $var -lt 0 ] || [ $var -gt 15 ];then
			echo "ERROR::input para is not right!"
			return 1;
		fi

		ampcmd gmacdrv execcmd 16 $2
		return $?
	elif [ "$1" = "18" ];then
		if [ $var != 0 -a $var != 1 ]; then
			echo "ERROR::input para is not right!"
			return 1;
		fi

		ampcmd gmacdrv execcmd 18 $2
		return $?
	else
		echo "ERROR::input para is not right!"
		return 1;
	fi
elif [ $# -eq 4 ];then
	if [ "$1" = "13" ];then
		ampcmd gmacdrv execcmd 13 $2 $3 $4
		return $?
	else
		echo "ERROR::input para is not right!"
		return 1;
	fi
else
	echo "ERROR::input para is not right!"
	return 1;
fi