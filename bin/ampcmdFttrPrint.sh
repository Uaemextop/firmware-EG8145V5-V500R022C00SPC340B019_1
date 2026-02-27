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
	if [ "$1" = "on" ];then
		ampcmd print oltomcion
		return $?
	elif [ "$1" = "off" ];then
		ampcmd print oltomcioff
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
	if [ "$1" = "mib" ];then
		if [ $var -lt 0 ] || [ $var -gt 15 ];then
			echo "ERROR::input para is not right!"
			return 1;
		fi

		ampcmd print oltomcimib $2
		return $?
	else
		echo "ERROR::input para is not right!"
		return 1;
	fi
else
	echo "ERROR::input para is not right!"
	return 1;
fi