#! /bin/sh

#set CTCOM, Unicom or mobily spec parameters
#include bin and spec word
#include spec sn, common web username ssid password

# 定制信息文件
var_customize_file=/mnt/jffs2/customizepara.txt
var_customize_file_var_path=/var/customizepara_getcustomize.txt
var_customize_file_not_aes=/var/customizepara_getcustomize_not_aes.txt
var_jffs2_customize_txt_file=/mnt/jffs2/customize.txt
var_customize_telmex=/mnt/jffs2/TelmexCusomizePara

var_binword=""
var_cfgword=""
var_customizeinfo=""
var_factory_file="/var/customizerealfinish"
var_customizedoingflagfile="/var/customizedoing"
var_customizetarfile="/mnt/jffs2/customize_xml.tar.gz"
Customize_Script_GetBoardinfoFtWord()
{
	var_binword=$(getboardinfo 0x0000001a)
	var_cfgword=$(getboardinfo 0x0000001b)
}

if [ -f $var_customizedoingflagfile ]
then
	if [ ! -f $var_factory_file ]
	then
		echo "ERROR::customizing, please wait!"
		exit 1
	fi
	Customize_Script_GetBoardinfoFtWord
	read var_binword_tmp var_cfgword_tmp < /mnt/jffs2/binftwordsave
	if [ "$var_binword_tmp" != "$var_binword" ] || [ "$var_cfgword_tmp" != "$var_cfgword" ]
	then
		echo "ERROR::board info not match"
		exit 1
	fi
else
    if [ -f $var_jffs2_customize_txt_file ] && [ -f "$var_customize_file" ] && [ -f /mnt/jffs2/binftwordsave ]
    then
        Customize_Script_GetBoardinfoFtWord
        read var_jffs2_binwordsave var_jffs2_cfgwordsave < /mnt/jffs2/binftwordsave
        read var_jffs2_binword var_jffs2_cfgword < $var_jffs2_customize_txt_file
        var_cfg_ft_word_choose=$(echo $(echo $var_jffs2_cfgword | cut -b -7) | tr a-z A-Z)

        #判断配置特征字是否包含:字符,var_cfg_ft_word 和 var_cfgfileword JSCT:8X2X定制 var_cfg_ft_word=JSCT，cfgfileword=8X2X
        echo $var_jffs2_cfgword | grep : > /dev/null
        if [ $? == 0 ]
        then
            var_cfg_ft_word=`echo $var_jffs2_cfgword | tr a-z A-Z | cut -d : -f1 `
        else
            var_cfg_ft_word=`echo $var_jffs2_cfgword | tr a-z A-Z`
        fi

        if [ "$var_cfg_ft_word_choose" = "CHOOSE_" ] \
        || [ "$var_cfg_ft_word" = "UNICOM" ] \
        || [ "$var_cfg_ft_word" = "UNICOM2" ] \
        || [ "$var_cfg_ft_word" = "UNICOM2WIFI" ] \
        || [ "$var_cfg_ft_word" = "UNICOM_BUCPE" ] \
        || [ "$var_cfg_ft_word" = "UNICOMBRIDGE" ] \
        || [ "$var_cfg_ft_word" = "BZTLF2" ] \
        || [ "$var_cfg_ft_word" = "BZTLF2WIFI" ] \
        || [ "$var_cfg_ft_word" = "CMCC" ] \
        || [ "$var_cfg_ft_word" = "CMCC_BUCPE" ] \
        || [ "$var_cfg_ft_word" = "CMCCWIFI" ] \
        || [ "$var_cfg_ft_word" = "CMCC_RMS" ] \
        || [ "$var_cfg_ft_word" = "CMCC_RMS2" ] \
        || [ "$var_cfg_ft_word" = "CMDC" ] \
        || [ "$var_cfg_ft_word" = "CIOT" ] \
        || [ "$var_cfg_ft_word" = "CMCC_RMSWIFI" ] \
        || [ "$var_cfg_ft_word" = "CMCC_RMS2WIFI" ] \
        || [ "$var_cfg_ft_word" = "CMCC_RMSBRIDGE" ] \
        || [ "$var_cfg_ft_word" = "LANAP" ] \
        || [ "$var_cfg_ft_word" = "AISAP" ] \
        || [ "$var_cfg_ft_word" = "TRIPLET4AP" ]\
        || [ "$var_cfg_ft_word" = "CTCTRIAP" ]\
        || [ "$var_cfg_ft_word" = "TRUEAP" ] \
        || [ "$var_cfg_ft_word" = "BATELCO" ]\
        || [ "$var_cfg_ft_word" = "E8CAP" ]\
        || [ "$var_cfg_ft_word" = "A8C" ]\
        || [ "$var_cfg_ft_word" = "CMCC_FTTO" ]\
        || [ "$var_cfg_ft_word" = "UNICOM_FTTO" ] ; then
        {
            if [ "$var_jffs2_binword" != "$var_binword" ]
            then
                echo "ERROR::board info not match"
            fi
        } else {
            if [ "$var_jffs2_binword" = "$var_binword" ] && [ "$var_jffs2_cfgwordsave" = "MYTIME" ]; then
                if [ "$var_cfgword" != "MYTIME" ] && [ "$var_cfgword" != "MALAYTIMEAP6" ]
                then
                    echo "ERROR::board info not match"
                fi
            else 
                if [ "$var_jffs2_binword" != "$var_binword" ] || [ "$var_jffs2_cfgwordsave" != "$var_cfgword" ]
                then
                    echo "ERROR::board info not match"
                fi
            fi
        }
        fi

        cp -rf /mnt/jffs2/hw_ctree.xml /var/hw_ctree.xml
        cp -rf /mnt/jffs2/hw_default_ctree.xml /var/hw_default_ctree.xml

        /bin/aescrypt2 1 /var/hw_ctree.xml /var/hw_ctree.xml_tmp
        if [ 0 -eq $? ]
        then
            mv /var/hw_ctree.xml /var/hw_ctree.xml.gz
            gunzip -f /var/hw_ctree.xml.gz
        fi

        /bin/aescrypt2 1 /var/hw_default_ctree.xml /var/hw_default_ctree.xml_tmp
        if [ 0 -eq $? ]
        then
            mv /var/hw_default_ctree.xml /var/hw_default_ctree.xml.gz
            gunzip -f /var/hw_default_ctree.xml.gz
        fi

        var_ctreeCustomInfo=`cat /var/hw_ctree.xml | grep "customInfo" | sed 's/\(.*\)customInfo=\(.*\)/\2/g' | cut -d "\"" -f2`
        var_defaultctreeCustomInfo=`cat /var/hw_default_ctree.xml | grep "customInfo" | sed 's/\(.*\)customInfo=\(.*\)/\2/g' | cut -d "\"" -f2`
        if [ "$var_ctreeCustomInfo" != "$var_defaultctreeCustomInfo" ] || [ "$var_ctreeCustomInfo" = "" ]
        then
            if [ "$var_ctreeCustomInfo" != "MalayTimeAP6LanRouterRT" ] || [ "$var_defaultctreeCustomInfo" != "TIME" ]
            then
                echo "ERROR::ctree custominfo not match"
            fi
        fi
        rm -rf /var/hw_ctree.xml
        rm -rf /var/hw_default_ctree.xml
    fi
fi

#get feature word
HW_Script_GetFtWord()
{
	if [ -f $var_jffs2_customize_txt_file ];then
	read var_binword var_cfgword < $var_jffs2_customize_txt_file
	else
		Customize_Script_GetBoardinfoFtWord
	return
	fi
}

# get customize info 
HW_Script_GetCustomizeInfo()
{
	if [ ! -f "$var_customize_file" ]
	then
		echo "ERROR::no customize info exist!"
		return 1
	fi
	
	# 考虑到如果之前用5个参数定制的jffs2下生成的是TelmexCusomizePara
	# 此处暂不修改
	if [ "TELMEX" == $var_cfgword ] && [ -f $var_customize_telmex ]
	then
		read var_customizeinfo < $var_customize_telmex
		if [ 0 -eq $? ]
		then
			return 0
		fi
	fi
	
	#判断是否已经加密
	var_is_en=0
	
	cp -f $var_customize_file $var_customize_file_var_path

	var_str=$(hexdump $var_customize_file_var_path | grep 0000000)
	var_first_four=$(echo $var_str | cut -b 9-12)
	var_last_four=$(echo $var_str | cut -b 14-17)

	if [ $var_first_four == 0001 ] || [ "$var_first_four" == "0100" ]; then
		if [ $var_last_four == 0000 ]; then
			var_is_en=1
			
		else
			var_is_en=0
		fi
	else
		var_is_en=0
	fi
	
	if [ $var_is_en == 1 ]; then
		aescrypt2 1 $var_customize_file_var_path $var_customize_file_not_aes
		
		#sprint the spec content
		read var_customizeinfo < $var_customize_file_var_path
		if [ 0 -ne $? ]
		then
			echo "ERROR:Failed to spec info"
			return 1
		fi
	
		#deal for read end
		rm -rf $var_customize_file_var_path
	else
		#sprint the spec content
		read var_customizeinfo < $var_customize_file
		if [ 0 -ne $? ]
		then
			echo "ERROR:Failed to spec info"
			return 1
		fi
	fi

	return
}

function Customize_Check_ChooseXml_Tar()
{
    CheckChooseXml.sh
    [ ! $? == 0 ] && echo "ERROR::customize check choose_xml.tar.gz fail!" && return 1
    return 0
}

check_sign=0
#装备包签名校验
function check_equip_sign
{
    #debug调试版本不校验
    if [ -f /etc/wap/DebugVersionFlag ]; then
        return 0
    fi

    data_path=/mnt/jffs2/Equip.sh
    cms_path=/mnt/jffs2/equipment/sign/cms
    crl_path=/mnt/jffs2/equipment/sign/crl
    pub_path=/etc/app_cert.crt

    #非装备模式不校验
    if [ ! -f $data_path ]; then
        return 0
    fi

    cms_check $pub_path $cms_path $crl_path $data_path

    if [ $? != 0 ]; then
        echo "ERROR::check equip sign fail!"
        rm -rf $data_path
        check_sign=1
    fi

    cat $data_path | cut -d ',' -f 1 | grep ^EquipId=[0-9]'\{1,\}$' > /dev/null
    if [ $? != 0 ];then
        echo "check equip content error"
        rm -rf $data_path
        check_sign=1
    fi

    return 0
}

if [ 0 -ne $# ]; then
    echo "ERROR::input para is not right!";
    exit 1;
else
#
HW_Script_GetFtWord
[ ! $? == 0 ] && exit 1

#
HW_Script_GetCustomizeInfo
[ ! $? == 0 ] && exit 1

#检查choose_xml.tar.gz是否完整
var_check_choose_xml_result=0
Customize_Check_ChooseXml_Tar
[ ! $? == 0 ] && var_check_choose_xml_result=1

check_equip_sign
#非装备模式下仅输出binword,cfgword,typeword，避免一键式收集时打印敏感信息
if [ -e "/var/Equip.sh" ] && [ ${check_sign} == "0" ]; then
    if [ -f "/mnt/jffs2/customize_name" ]; then
        var_customize_name=`cat /mnt/jffs2/customize_name`
        echo "$var_binword $var_cfgword#$var_customize_name# $var_customizeinfo" 
    else
        echo "$var_binword $var_cfgword $var_customizeinfo" 
    fi
else
    if [ -f "/mnt/jffs2/customize_name" ]; then
        var_customize_name=`cat /mnt/jffs2/customize_name`
        echo "$var_binword $var_cfgword#$var_customize_name#" 
    else
        echo "$var_binword $var_cfgword" 
    fi
fi

if [ $var_check_choose_xml_result -eq 1 ]; then
    exit 1;
fi

echo "success!"

exit 0 
fi

