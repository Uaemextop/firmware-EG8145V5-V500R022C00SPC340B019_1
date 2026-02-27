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
	isNum $1
	if [ $? -ne 0 ]; then
		echo "ERROR::input para is not right!"
		return 1;
	fi
 
	let var=$1;
	if [ $var -lt 0 ] || [ $var -gt 15 ];then
		echo "ERROR::input para is not right!"
		return 1;
	fi

	ampcmd set debugont 0 $1
	return $?
else
	echo "ERROR::input para is not right!"
	return 1;
fi