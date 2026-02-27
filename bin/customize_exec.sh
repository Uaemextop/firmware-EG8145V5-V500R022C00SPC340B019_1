#! /bin/sh

# 输入参数变量
var_cfg_word_orig_in=$2
var_bin_ft_word=$(echo $1 | tr a-z A-Z)
var_cfg_ft_word_init_in=$(echo $2 | tr a-z A-Z)
var_cfg_ft_word_en_in=$(echo $2 | tr a-z A-Z)
var_ssid=$3
var_wpa=$4
var_input_para=$*
var_is_HGU=1
var_is_ENBG=0
var_para_num=$#
var_customize_telmex=/mnt/jffs2/TelmexCusomizePara
var_jffs2_specsn_file="/mnt/jffs2/customize_specsn"
# 全局的文件变量
mnt_jffs2_boardinfo_file="/mnt/jffs2/hw_boardinfo"
var_jffs2_customize_txt_file="/mnt/jffs2/customize.txt"
var_hw_hardinfo_feature="/mnt/jffs2/hw_hardinfo_feature"
var_certfile="/mnt/jffs2/root.crt"
var_hw_hardinfo_feature_back="/mnt/jffs2/hw_hardinfo_feature.bak"
var_country_code=""
var_frameworkcheck_file="/mnt/jffs2/frameworkcheck"
var_customizetarfile="/mnt/jffs2/customize_xml.tar.gz"
var_boardinfo_dup="/var/dup_boardinfo"
var_boardinfo_dec="/var/decrypt_boardinfo"

umask 027

#解密Spec
SpecProc.sh

##参数8是CMEI
var_cmei=$(echo $8 | tr a-z A-Z)
if [ ! -z "$var_cmei" ]; then
	echo -n $var_cmei > /mnt/jffs2/CMEI
fi

##如果参数2输入了类似 CMCC_FTTO:SMART#B850# 带#的字符，就将#后边的内容忽略，这个只是为了给装备用的标记，产品不用
echo $var_cfg_ft_word_en_in | grep \# > /dev/null
if [ $? == 0 ]
then
	var_customize_name=`echo $var_cfg_ft_word_init_in | tr a-z A-Z | cut -d \# -f2 `
	echo -n $var_customize_name > /mnt/jffs2/customize_name
	var_cfg_ft_word_init=`echo $var_cfg_ft_word_init_in | tr a-z A-Z | cut -d \# -f1 `
	var_cfg_word_orig=`echo $var_cfg_word_orig_in | tr a-z A-Z | cut -d \# -f1 `
	var_cfg_ft_word_en=`echo $var_cfg_ft_word_en_in | tr a-z A-Z | cut -d \# -f1 `
else
	var_cfg_ft_word_init=`echo $var_cfg_ft_word_init_in | tr a-z A-Z`
	var_cfg_word_orig=`echo $var_cfg_word_orig_in | tr a-z A-Z`
	var_cfg_ft_word_en=`echo $var_cfg_ft_word_en_in | tr a-z A-Z`
	rm -f  /mnt/jffs2/customize_name
fi

boardinfo_encrypt_support=`GetFeature FT_SUPPORT_BOARDINFO_ENCRYPT`

echo > /var/customizedoing
# 其它变量
var_pack_temp_dir=/bin/
rm -rf /mnt/jffs2/V5_TypeWord_FLAG
rm -rf /mnt/jffs2/oldcustinfo
rm -rf /mnt/jffs2/hw_ctree_rt.xml
rm -rf /mnt/jffs2/hw_ctree_ap.xml


#新增企业网防串货特性，会在配置特征字后添加_ENBG
var_cfg_ft_word_en=`echo $var_cfg_ft_word_init | sed 's/_ENBG$//g'`
if [ $var_cfg_ft_word_init != $var_cfg_ft_word_en ];then
	var_is_ENBG=1
fi

var_upcase_cfg_ft_word=$(echo $var_cfg_ft_word_en | tr '[a-z]' '[A-Z]')
var_BUCPEkeycfg=$(expr match "$var_upcase_cfg_ft_word" '.*\(BUCPE\).*')

#判断配置特征字是否包含:字符,var_cfg_ft_word 和 var_cfgfileword JSCT:8X2X定制 var_cfg_ft_word=JSCT，cfgfileword=8X2X
#将回显输入到空设备文件
echo $var_cfg_ft_word_en | grep : > /dev/null
if [ $? == 0 ]
then
	var_cfg_ft_word=`echo $var_cfg_ft_word_en | tr a-z A-Z | cut -d : -f1 `
	var_typeword=`echo $var_cfg_ft_word_en | tr a-z A-Z | cut -d : -f2 `
	var_bucpe=`echo $var_cfg_ft_word_en | tr a-z A-Z | cut -d : -f3 `
	var_ExtendTy=`echo $var_cfg_ft_word_en | tr a-z A-Z | cut -d : -f4 `
else
	var_cfg_ft_word=`echo $var_cfg_ft_word_en | tr a-z A-Z`
	var_typeword=""
fi

if [ "$var_typeword" = "BUCPE" ] || [ "$var_cfg_ft_word_en" = "CHOOSE_BUCPE" ] ; then
	if [ -f $var_hw_hardinfo_feature ]
	then
		echo 'feature.name="HW_SSMP_FEATURE_GXBMONITOR" feature.enable="1" feature.attribute="0"' >> $var_hw_hardinfo_feature
	else 
		echo 'feature.name="HW_SSMP_FEATURE_GXBMONITOR" feature.enable="1" feature.attribute="0"' > $var_hw_hardinfo_feature
	fi
	
	cp -rf $var_hw_hardinfo_feature $var_hw_hardinfo_feature_back
	var_typeword=""
fi

if [ "$var_bucpe" = "BUCPE" ] || [ "$var_BUCPEkeycfg" = "BUCPE" ]; then
	if [ -f $var_hw_hardinfo_feature ]
	then
		echo 'feature.name="HW_SSMP_FEATURE_GXBMONITOR" feature.enable="1" feature.attribute="0"' >> $var_hw_hardinfo_feature
	else 
		echo 'feature.name="HW_SSMP_FEATURE_GXBMONITOR" feature.enable="1" feature.attribute="0"' > $var_hw_hardinfo_feature
	fi
	
	cp -rf $var_hw_hardinfo_feature $var_hw_hardinfo_feature_back
fi
	
if [ "$var_bucpe" = "V5" ] || [ "$var_ExtendTy" = "V5" ];then
	echo 1 > /mnt/jffs2/V5_TypeWord_FLAG
else
	var_ExtendTy=""
fi

if [ "$var_bin_ft_word" = "CMCC" ] &&  [ "$var_typeword" = "V8XXC" -o "$var_typeword" = "CDN" ]; then
	echo 1 > /mnt/jffs2/V5_TypeWord_FLAG
fi

if [ "$var_bin_ft_word" = "CMCC" ] &&  [ "$var_typeword" = "FTTRANDLINK" ]; then
	echo 1 > /mnt/jffs2/V5_TypeWord_FLAG
fi

var_cfg_ft_word_save=`echo $var_cfg_ft_word_init | tr a-z A-Z`
if [ "$var_cfg_word_orig" = "SONET_HN8255Ws" ] || [ "$var_cfg_word_orig" = "JAPAN_HN8255Ws" ]
then
	var_cfg_ft_word_save="$var_cfg_word_orig"
fi
var_cfg_ft_word1=$var_cfg_ft_word
if [ "$var_cfg_ft_word1" = "TRIPLET4APPWD" ] ; then
	var_cfg_ft_word1="TRIPLET4AP"
fi

var_cfg_ft_word_choose=$(echo $(echo $var_cfg_ft_word | cut -b -7) | tr a-z A-Z)

#如果mnt/jffs2下有待解压的证书文件，就把证书文件解压出来
if [ -f /mnt/jffs2/fidnadeskapcert.tar.gz ]
then
    curDir=`pwd`
    cd /mnt/jffs2
    tar -zxvf fidnadeskapcert.tar.gz > /dev/null
    rm ./fidnadeskapcert.tar.gz
    cd $curDir
fi


# 参数检测
HW_Customize_Check_Arg()
{
	if [ -z "$var_bin_ft_word" ] || [ -z "$var_cfg_ft_word" ]
	then
		echo "ERROR::The binfeature word and cfgword should not be null!"
		return 1
	fi

	return 0
}

# 如果是COMMON_WIFI ~COMMON定制，则将BinWord由COMMON_WIFI->COMMON，依然走定制流程
# 如果CfgWord以wifi结尾，则去掉"wifi"字符串
HW_Change_Customize_Parameter()
{
	if [ "$var_bin_ft_word" = "COMMON_WIFI" ] ; then
	{
		var_bin_ft_word="COMMON"
	}
	fi

	#判断配置特征字是否以WIFI结尾，如果是则删除
	var_cfg_ft_word_temp=`echo "$var_cfg_ft_word" | sed 's/WIFI$//g'`
	if [ "$var_bin_ft_word" = "CMCC" ] && [ "$var_cfg_ft_word_temp" != "CMCC_RMS2" ] ; then
		var_cfg_ft_word_cmcc="$var_cfg_ft_word_temp"
		var_cfg_ft_word_temp=`echo "$var_cfg_ft_word_cmcc" | sed 's/2$//g'`
		
	fi

	if [ "$var_cfg_ft_word" = "TRIPLET4APPWD" ] ; then
		var_cfg_ft_word_temp="TRIPLET4AP"
	fi

	if [ "$var_cfg_word_orig" = "SONET_HN8255Ws" ] || [ "$var_cfg_word_orig" = "JAPAN_HN8255Ws" ]
	then
		var_cfg_ft_word_temp=$var_cfg_word_orig
	fi

	shift 2

	var_input_para="$var_bin_ft_word ""$var_cfg_ft_word_temp ""$*"

	return 0
}

# 如果CfgWord中去掉_SIP或者_H248字符
HW_Change_Customize_ParameterForVspa()
{
	#如果配置特征字中没有_SIP或者_H248则直接返回，不显示
	echo $var_cfg_ft_word | grep -iE "_SIP|_H248" > /dev/null
	if [ ! $? == 0 ]
	then
		return 0
	fi

	#删除配置特征字中去掉'_'后字符，并重新构造配置参数，作为Customize程序的参数
	var_cfg_ft_word_temp=`echo "$var_cfg_ft_word" | sed 's/_.*//g'`
	shift 2  #输入参数左移动2个
	var_input_para="$var_bin_ft_word ""$var_cfg_ft_word_temp ""$*"
	return 0
}

#设置CHOOSE字段
HW_Customize_Set_Choose()
{
	#后面会进行检查，再次不检查boardinfo是否存在
	echo $var_boardinfo_dup | xargs sed 's/obj.id = \"0x00000031\" ; obj.value = \"[a-zA-Z0-9_]*\"/obj.id = \"0x00000031\" ; obj.value = \"'$1'\"/g' -i
	return 0
}

# 资源检测
HW_Customize_Check_Resource()
{
	#HGU需要关注免预配置定制,需要涉及CHOOSE_WORD字段修改，SFU则可以直接传入
	if [ "$var_cfg_ft_word_choose" = "CHOOSE_" ] \
	|| [ "$var_cfg_ft_word" = "UNICOM" ] \
	|| [ "$var_cfg_ft_word" = "UNICOM2" ]  \
	|| [ "$var_cfg_ft_word" = "UNICOM2WIFI" ]  \
	|| [ "$var_cfg_ft_word" = "UNICOM_BUCPE" ] \
	|| [ "$var_cfg_ft_word" = "UNICOMBRIDGE" ] \
	|| [ "$var_cfg_ft_word" = "BZTLF2" ] \
	|| [ "$var_cfg_ft_word" = "BZTLF2WIFI" ] \
	|| [ "$var_cfg_ft_word" = "CMCC" ] \
	|| [ "$var_cfg_ft_word" = "CMCC_BUCPE" ] \
	|| [ "$var_cfg_ft_word" = "CMCCWIFI" ] \
	|| [ "$var_cfg_ft_word" = "CMCC_RMS" ] \
	|| [ "$var_cfg_ft_word" = "CMCC_RMS2" ]  \
	|| [ "$var_cfg_ft_word" = "CMDC" ]  \
	|| [ "$var_cfg_ft_word" = "CIOT" ]  \
	|| [ "$var_cfg_ft_word" = "CMCC_RMS2WIFI" ]  \
	|| [ "$var_cfg_ft_word" = "CMCC_RMSWIFI" ] \
	|| [ "$var_cfg_ft_word" = "CMCC_RMSBRIDGE" ] \
	|| [ "$var_cfg_ft_word" = "TRUEAP" ] \
	|| [ "$var_cfg_ft_word" = "E8CAP" ] \
	|| [ "$var_cfg_ft_word" = "LANAP" ]\
	|| [ "$var_cfg_ft_word" = "AISAP" ]\
	|| [ "$var_cfg_ft_word" = "TRIPLET4APPWD" ]\
	|| [ "$var_cfg_ft_word" = "TRIPLET4AP" ]\
	|| [ "$var_cfg_ft_word" = "CTCTRIAP" ]\
	|| [ "$var_cfg_ft_word" = "BATELCO" ]; then
		shift 2
		if [ "$var_cfg_ft_word_choose" = "CHOOSE_" ]; then
			var_input_para="$var_bin_ft_word ""$var_cfg_ft_word1 ""$*"
		elif [ "$var_cfg_ft_word" = "CMCCWIFI" ]; then
			var_input_para="$var_bin_ft_word ""CHOOSE_CMCC ""$*"	
		elif [ "$var_cfg_ft_word" = "CMCC_RMS2WIFI" ]; then
			var_input_para="$var_bin_ft_word ""CHOOSE_CMCC_RMS2 ""$*"
		elif [ "$var_cfg_ft_word" = "UNICOM2WIFI" ]; then
			var_input_para="$var_bin_ft_word ""CHOOSE_UNICOM2 ""$*"
		elif [ "$var_cfg_ft_word" = "CMCC_RMSWIFI" ]; then
			var_input_para="$var_bin_ft_word ""CHOOSE_CMCC_RMS ""$*"
		elif [ "$var_cfg_ft_word" = "BZTLF2WIFI" ]; then
			var_input_para="$var_bin_ft_word ""CHOOSE_BZTLF2 ""$*"
		else
			if [ $var_is_HGU -eq 1 ] ; then
			var_input_para="$var_bin_ft_word ""CHOOSE_$var_cfg_ft_word1 ""$*"
			else
				var_input_para="$var_bin_ft_word ""$var_cfg_ft_word1 ""$*"
			fi
		fi
	fi

	#现在TELMEX只支持12个参数（customize.sh后面的），格式如下：
	#customize.sh COMMON TELMEX SSID WEP_KEY PPPoE_user PPPoE_pwd TR069_user TR069_pwd WEB_pwd CLI_user CLI_pwd  WPA_pwd
	if [ $var_cfg_ft_word == "TELMEX" ]
	then
		#对于之前的已经用5个参数定制的整机，返工场景（重新定制，要删除该文件，否则定制检查会失败）
		if [ -f $var_customize_telmex ]
		then
			rm -rf $var_customize_telmex
		fi
		#只支持12个参数（除customize.sh以外的其他参数）
		if [ 12 -ne $var_para_num ]
		then
			echo "ERROR::input para must be COMMON TELMEX SSID WEP_KEY PPPoE_user PPPoE_pwd TR069_user TR069_pwd WEB_pwd CLI_user CLI_pwd  WPA_pwd !"
			return 1
		fi
	fi

	# 调用Customize进程进行装备资源的校验, 把文件暂时写入typeword 暂时写入/mnt/jffs2/typeword 文件。 如果不通过文件传递，通过argv 传递
	# 需要函数扩展的函数有十个左右，且在Customize APP 中需要扩展解析该字段。
	if [ -f /mnt/jffs2/typeword ]; then
		cp -f /mnt/jffs2/typeword /mnt/jffs2/typeword_bak
	fi
	
	if [ ! -z "$var_typeword" ]; then
		echo $var_typeword > /mnt/jffs2/typeword
	fi
	
	#检测是是否在生产过程中写入specsn文件，重新返工需要将此文件删除。
	if [ -f $var_jffs2_specsn_file ]
	then 
		rm -rf $var_jffs2_specsn_file
	fi

	rm -f /var/input_para
	rm -f /var/tmppara
	echo $var_input_para > /var/input_para
	echo $var_bin_ft_word $var_cfg_ft_word $var_cfg_ft_word_choose $var_cfg_word_orig $var_cfg_ft_word_save $var_is_ENBG > /var/tmppara

	Customize $var_input_para
	var_result=$?
	
	remove_choose_xml
	
	if [ 0 -eq $var_result ]
	then
		return 0
	elif [ 28 -eq $var_result ]
	then
		return 1
	else
		#定制失败, 如果存在备份文件,还原备份
		if [ -f /mnt/jffs2/typeword_bak ]; then
			mv -f /mnt/jffs2/typeword_bak /mnt/jffs2/typeword
		else
			#第一次定制失败
			if [ -f /mnt/jffs2/typeword ]; then
				rm -f /mnt/jffs2/typeword
			fi	
		fi		
		
		if [ -f /mnt/jffs2/customizepara.txt ] ; then
			rm -f /mnt/jffs2/customizepara.txt
		fi
		
	fi

	return 0
}

#定制处理
HW_Customize_Delete_File()
{
	var_reg_info_file="/mnt/jffs2/RegStepDataInfo"
	var_telnet_flag="/mnt/jffs2/ProductLineMode"
	var_smartshowbssguide="/mnt/jffs2/smartshowbssguide"
	var_smartshowuserguide="/mnt/jffs2/smartshowuserguide"
	var_frameworkcheck_file="/mnt/jffs2/frameworkcheck"

	var_jffs2_plug_dbus="/mnt/jffs2/plug/apps/etc/dbus-1"
	if [ -d $var_jffs2_plug_dbus ];then
		rm -rf $var_jffs2_plug_dbus
	fi

	# 删除UPNP增强标记文件
	rm -rf /mnt/jffs2/UpnpExpandFirstInit
	if [ -f /mnt/jffs2/vpn_route ];then
		rm -rf /mnt/jffs2/vpn_route
	fi

	# 删除dnsfilter hostlists文件
	if [ -f /mnt/jffs2/dnsfilter_hostlist ];then
		rm -rf /mnt/jffs2/dnsfilter_hostlist
	fi

	# 删除第一次上线时记录文件
	var_first_online_file="/mnt/jffs2/ontfirstonlinefile"
	if [ -f $var_first_online_file ]
	then
		rm -rf $var_first_online_file
	fi

	rm -f $var_reg_info_file
	rm -f /mnt/jffs2/backup_ok

	rm -f $var_telnet_flag
	rm -f /mnt/jffs2/smooth_finish
	rm -f /mnt/jffs2/equip_ip_enable
	rm -f /mnt/jffs2/app/cplugin/cpluginstate
	rm -rf /mnt/jffs2/app/cplugin/*
	rm -f $var_smartshowbssguide
	rm -rf $var_smartshowuserguide
	rm -rf $var_frameworkcheck_file
	rm -f /mnt/jffs2/first_start
	rm -f /mnt/jffs2/smartshownormaluserguide
	# 删除WIFI提前静默配置数据
	if [ -f /mnt/jffs2/wifi_5g_cac_data ];then
		rm -rf /mnt/jffs2/wifi_5g_cac_data
	fi

	if [ -f /mnt/jffs2/closecaptcha ]; then
		rm -f /mnt/jffs2/closecaptcha
	fi

	return 0
}

#特殊市场web的root证书文件需要改名,单独拉出
Customize_Cwmp_Cert()
{
    if [ -f /var/customize_cert/$1 ]; then
        cp /var/customize_cert/$1 $var_certfile > /dev/null
        chmod 600 $var_certfile
        chown -h cfg_cwmp: $var_certfile
    fi
}

Customize_Copy_Cert()
{
    if [ "$1" == "ais_root.crt" ] || \
       [ "$1" == "VeriSign-Class_3-Public-Primary-Certification-Authority-G5.pem" ] || \
       [ "$1" == "mongoliaCA.pem" ] || \
       [ "$1" == "rosunion_root.crt" ]; then
        Customize_Cwmp_Cert $1

        if [ ! -f $var_certfile ]; then
            echo "customize cwmp cert failed: /mnt/jffs2/root.crt"
            return 1
        else 
            return 0
        fi
    fi

	if [ -f /var/customize_cert/$1 ]; then
		cp /var/customize_cert/$1 /mnt/jffs2/certs/$1 > /dev/null
		chmod 600 /mnt/jffs2/certs/$1
		chown -h 3008:2002 /mnt/jffs2/certs/$1
	fi

	if [ ! -f /mnt/jffs2/certs/$1 ]; then
		echo "customize copy cert failed: /mnt/jffs2/certs/$1"
		return 1
	else 
		return 0
	fi
}

#证书文件处理
HW_Customize_Cert_File_Proc()
{
	cd /var/
	tar -xvzf customize_cert.tar.gz > /dev/null

	#判断是否存在证书目录
	if [ -d /var/customize_cert/ ]; then
		chmod 400 -R /var/customize_cert/
	else 
		return 0
	fi

	local var_cfg_ft_word=`echo $2 | tr a-z A-Z | cut -d : -f1 `

	if [ "$var_cfg_ft_word" = "TELMEX" ] || [ "$var_cfg_ft_word" = "TELMEX5G" ] \
		|| [ "$var_cfg_ft_word" = "TELMEX5GV" ] || [ "$var_cfg_ft_word" = "TELMEX5GV5" ]; then

		cp /var/customize_cert/*1_telmex.pem /mnt/jffs2/
	
		chown -h 3004:2002 /mnt/jffs2/prvt_1_telmex.pem
		chown -h 3004:2002 /mnt/jffs2/pub_1_telmex.pem
		chown -h 3004:2002 /mnt/jffs2/root_1_telmex.pem
	fi

	local result1=""
	local result2=""
	local fileName=""
	local customizeInfo=""
	#解析文件，拷贝定制所需证书到/mnt/jffs2/certs目录
	while read line;
	do
		fileName=`echo $line | cut -d , -f1 `
		customizeInfo=`echo $line | cut -d , -f2 `
		if [[ "$customizeInfo" == "ALL" ]]
		then
			Customize_Copy_Cert $fileName
		else
			result1=`echo $customizeInfo | cut -d ' ' -f 1 `
			result2=`echo $customizeInfo | cut -d ' ' -f 2 `
			if [ "$result1" == "$1" ] && [ "$result2" == "$2" ]
			then
				Customize_Copy_Cert $fileName
			fi
		fi
		[ ! $? == 0 ] && return 1
	done < /var/customize_cert/cert_customize_relationship.csv
	cd - > /dev/null

	return 0
}

#生成出厂版本标志文件
HW_Customize_Add_Factory_File()
{
	var_default_ctree="/mnt/jffs2/hw_default_ctree.xml"
	var_default_ctree2="/mnt/jffs2/hw_default_ctree2.xml"

	version=`cat /etc/version`
	echo $version > /mnt/jffs2/factory_file
	chown -h 3008:2002 /mnt/jffs2/factory_file

	#生成 PDVDF定制 修改上行模式标志文件，用于判断是否能够修改 上行模式
	echo "" > /mnt/jffs2/restore_manufacture_done
	chown -h 3008:2002 /mnt/jffs2/restore_manufacture_done

	#生成智能使用的定制标志文件，用于c插件启动时，重新恢复所有预置c插件
	[[ -d /mnt/jffs2/app ]] && echo > /mnt/jffs2/app/customize_smt_flag

	#更换定制过程中生成的文件的属主
	[[ -f /mnt/jffs2/customize_xml.tar.gz ]] && chown -h 3008:2002 /mnt/jffs2/customize_xml.tar.gz
	[[ -d /mnt/jffs2/customize_xml ]] && chown -h 3008:2002 -R /mnt/jffs2/customize_xml
	[[ -f /mnt/jffs2/choose_xml.tar.gz ]] && chown -h 3008:2002 /mnt/jffs2/choose_xml.tar.gz
	[[ -d /mnt/jffs2/choose_xml ]] && chown -h 3008:2002 -R /mnt/jffs2/choose_xml

	if [ -f $var_default_ctree ]
	then
		chown -h 3008:2002 $var_default_ctree
		chmod 660 $var_default_ctree
	fi

	if [ -f $var_default_ctree2 ]
	then
		chown -h 3008:2002 $var_default_ctree2
		chmod 660 $var_default_ctree2
	fi

	[[ -f /mnt/jffs2/hw_ctree.xml ]] && chown -h 3008:2002 /mnt/jffs2/hw_ctree.xml
	[[ -f /mnt/jffs2/ResolveFlag ]] && chown -h 3008:2002 /mnt/jffs2/ResolveFlag

	#shell umask为0077，定制生成后的其他用户要读写的文件，需变更权限
	[[ -f /mnt/jffs2/customize_specsn ]] && chmod 660 /mnt/jffs2/customize_specsn
	[[ -f mnt/jffs2/typeword ]] && chmod 640 mnt/jffs2/typeword
	[[ -f mnt/jffs2/recovername ]] && chmod 660 mnt/jffs2/recovername
}

# 结果输出
HW_Customize_Print_Result()
{
	# 根据不同的执行结果，返回不同的错误内容
	if [ 0 -eq $var_result ]
	then
		return 0
	elif [ 1 -eq $var_result ]
	then
		echo "ERROR::input para number is not enough!"
		return 1
	elif [ 2 -eq $var_result ]
	then
		echo "ERROR::Updateflag file is not existed!"
		return 1
	elif [ 3 -eq $var_result ]
	then
		echo "ERROR::config tar file is not existed!"
		return 1
	elif [ 4 -eq $var_result ]
	then
		echo "ERROR::Null pointer!!"
		return 1
	elif [ 5 -eq $var_result ]
	then
		echo "ERROR::XML parse fail!!"
		return 1
	elif [ 6 -eq $var_result ]
	then
		echo "ERROR::XML get node or attribute fail!"
		return 1
	elif [ 7 -eq $var_result ]
	then
		echo "ERROR::XML get relation node fail!"
		return 1
	elif [ 8 -eq $var_result ]
	then
		echo "ERROR::Spec file is not existed!"
		return 1
	elif [ 9 -eq $var_result ]
	then
		echo "ERROR::Set bin word fail!"
		return 1
	elif [ 10 -eq $var_result ]
	then
		echo "ERROR::Set config word fail!"
		return 1
	elif [ 11 -eq $var_result ]
	then
		echo "ERROR::Uncompress tar fail!"
		return 1
	elif [ 12 -eq $var_result ]
	then
		echo "ERROR::Config file is not existed!"
		return 1
	elif [ 13 -eq $var_result ]
	then
		echo "ERROR::Recover file is ont existed!"
		return 1
	elif [ 14 -eq $var_result ]
	then
		echo "ERROR::Run script fail!"
		return 1
	elif [ 15 -eq $var_result ]
	then
		echo "ERROR::Create new recover config file fail!"
		return 1
	elif [ 16 -eq $var_result ]
	then
		echo "ERROR::Create old recover config file fail!"
		return 1
	elif [ 17 -eq $var_result ]
	then
		echo "ERROR::Copy spec default ctree fail!"
		return 1
	elif [ 18 -eq $var_result ]
	then
		echo "ERROR::Check Choose Res fail!"
		return 1
	elif [ 19 -eq $var_result ]
	then
		echo "ERROR::Resolver customize file fail!"
		return 1
	elif [ 27 -eq $var_result ]
	then
		echo "ERROR::Language error, please set Language first!"
		return 1
	else
		echo "ERROR::customize fail!"
		return 1
	fi

	return 0
}

#HGU才支持免预配置，在此做判断
HW_Customize_CheckIsHGU()
{
	cat /proc/wap_proc/pd_static_attr | grep -w pdt_type | grep HGU > /dev/null
	if [ $? -eq 0 ] ; then
		return 1
	fi

	return 0
}

#Java进程占用CPU过高，导致定制超时
HW_Customize_ReleaseResource()
{
	customize_kill_proc.sh
	return 0
}

HW_Script_FrameworkCheck()
{
	var_framework_md5_check_result="0"	
	if [ -f $var_frameworkcheck_file ];then
		cat /proc/mtd | grep framework > /dev/null
		if [ $? -eq 1 ] ; then
			rm -f $var_frameworkcheck_file
			return
		fi

		#frameworkcheck文件解析过程临时文件
		var_framework_md5_tmp_file="/var/file_framework_md5_tmp"
		#根据mtdblock计算出来的md5值临时存储文件
		var_devblock_md5_tmp_file="/var/file_devblock_md5_tmp"
		#mtd分区信息文件
		var_mtd_file="/proc/mtd"
		#mtd分区信息文件解析过程临时文件
		var_mtd_framework_tmp_file="/var/file_mtd_framework_tmp"
		var_devblock=""
		var_file_start_flag="0"
		
		while read -r line_file;
		do
			#获取frameworkcheck的第一行
			if [ "$var_file_start_flag" -eq "0" ] ; then
				var_framework_size=$line_file
				var_file_start_flag="1"
			#获取frameworkcheck的第二行
			elif [ "$var_file_start_flag" -eq "1" ] ; then
				echo $line_file > $var_framework_md5_tmp_file
				read var_framework_md5 var_no_concern < $var_framework_md5_tmp_file	
				var_file_start_flag="2"
			fi	
		done < $var_frameworkcheck_file
		
		#获取block分区
		cat $var_mtd_file | grep framework > $var_mtd_framework_tmp_file
		while read -r line_mtd;
		do
			#以:为标志分为两个通配段，\1表示取第1段，即冒号前的内容，然后截取mtd后的数字
			mtd_num=`echo $line_mtd | sed 's/\(.*\):\(.*\)/\1/g' | cut -d "d" -f2`
			var_devblock="/dev/mtdblock"$mtd_num
			
			head -c $var_framework_size $var_devblock | md5sum > $var_devblock_md5_tmp_file
			read var_devblock_md5 var_no_concern < $var_devblock_md5_tmp_file
			
			if [ $var_framework_md5 == $var_devblock_md5 ] ;then
				var_framework_md5_check_result="1"
			fi 
		done < $var_mtd_framework_tmp_file

		rm -rf $var_framework_md5_tmp_file
		rm -rf $var_devblock_md5_tmp_file
		rm -rf $var_mtd_framework_tmp_file
		
		if [ $var_framework_md5_check_result != "1" ];then
			echo "framework check failed!"
			exit 1
		fi
	fi
	return
}

#校验frameworkcheck，有/mnt/jffs2/frameworkcheck这个文件就要校验
#这个文件在加组播包会生成，用于产线校验framework中间件
HW_Script_FrameworkCheck
sync
sleep 1

if [ ! -f $var_boardinfo_dup ]; then
	if [ -f $var_boardinfo_dec ]; then
		cp -f $var_boardinfo_dec $var_boardinfo_dup
	else
		cp -f $mnt_jffs2_boardinfo_file $var_boardinfo_dup
	fi
fi
if [ $? -ne 0 ]; then
    echo "ERROR::Copy to dup boardinfo failed!"
    return 1
fi

# 三大T 九洲标志处理 CHOOSE_XINAN:JIUZ CMCC CMCC_RMS2WIFI:SMART:V5:JIUZ COMMON	UNICOM2WIFI:SMART:JIUZ
if [ "$var_typeword" = "JIUZ" ] || [ "$var_bucpe" = "JIUZ" ] || [ "$var_ExtendTy" = "JIUZ" ]; then
	#若boardinfo文件里不存在模式切换的id，则向boardinfo文件新增
	var_jiuzhouflag=`cat $var_boardinfo_dup |grep "0x00000073"`
	if [ -z "$var_jiuzhouflag" ]
	then
		echo "obj.id = \"0x00000073\" ; obj.value = \"0\";" >> $var_boardinfo_dup
	fi

	echo $var_boardinfo_dup | xargs sed 's/obj.id = \"0x00000073\" ; obj.value = \"[a-zA-Z0-9_-]*\"/obj.id = \"0x00000073\" ; obj.value = \"1\"/g' -i
fi

#参数检测：至少应该包含BinWord&SpecWord
HW_Customize_Check_Arg
[ ! $? == 0 ] && exit 1

HW_Customize_ReleaseResource

#参数处理
HW_Change_Customize_Parameter $var_input_para

#参数处理，主要是将配置特征字中的_SIP和_H248进行过滤
HW_Change_Customize_ParameterForVspa $var_input_para

#HGU才可以免预配置定制，免预配置定制才涉及CHOOSE_WORD的处理
HW_Customize_CheckIsHGU
if [ $? -eq 0 ] ; then
	var_is_HGU=0
fi

#免预配置模式，添加NOCHOOSE字段，并初始化为CHOOSE_XXX
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
|| [ "$var_cfg_ft_word" = "TRIPLET4APPWD" ] \
|| [ "$var_cfg_ft_word" = "CTCTRIAP" ]\
|| [ "$var_cfg_ft_word" = "TRUEAP" ] \
|| [ "$var_cfg_ft_word" = "BATELCO" ]\
|| [ "$var_cfg_ft_word" = "E8CAP" ] ; then
{
	#HW_Customize_Add_Choose
	if [ "$var_cfg_ft_word_choose" = "CHOOSE_" ]; then
		HW_Customize_Set_Choose "$var_cfg_ft_word"
	elif [ "$var_cfg_ft_word" = "UNICOMBRIDGE" ] ; then
		HW_Customize_Set_Choose "CHOOSE_UNICOM"	
	elif [ "$var_cfg_ft_word" = "BZTLF2WIFI" ] ; then
		HW_Customize_Set_Choose "CHOOSE_BZTLF2"
	elif [ "$var_cfg_ft_word" = "CMCC_RMSBRIDGE" ] ; then
		HW_Customize_Set_Choose "CHOOSE_CMCC_RMS"
	elif [ "$var_cfg_ft_word" = "CMCC" ] ; then
		HW_Customize_Set_Choose "CHOOSE_$var_cfg_ft_word"
	elif [ "$var_cfg_ft_word" = "CMCCWIFI" ] ; then
		HW_Customize_Set_Choose "CHOOSE_CMCC"
	elif [ "$var_cfg_ft_word" = "CMCC_RMSWIFI" ] ; then
		HW_Customize_Set_Choose "CHOOSE_CMCC_RMS"
	elif [ "$var_cfg_ft_word" = "CMCC_RMS2WIFI" ] ; then
		HW_Customize_Set_Choose "CHOOSE_CMCC_RMS2"
	elif [ "$var_cfg_ft_word" = "CMCC_BUCPE" ] ; then
		HW_Customize_Set_Choose "CHOOSE_CMCC_BUCPE"
	elif [ "$var_cfg_ft_word" = "UNICOM2WIFI" ] ; then
		HW_Customize_Set_Choose "CHOOSE_UNICOM2"
	elif [ "$var_cfg_ft_word" = "UNICOM_BUCPE" ] ; then
		HW_Customize_Set_Choose "CHOOSE_UNICOM_BUCPE"
	elif [ "$var_cfg_ft_word" = "LANAP" ] ; then
		HW_Customize_Set_Choose "CHOOSE_LANAP"
	elif [ "$var_cfg_ft_word" = "AISAP" ] ; then
		HW_Customize_Set_Choose "CHOOSE_AISAP"
	elif [ "$var_cfg_ft_word" = "TRIPLET4APPWD" ] ; then
		HW_Customize_Set_Choose "CHOOSE_TRIPLET4AP"
	elif [ "$var_cfg_ft_word" = "TRIPLET4AP" ] ; then
		HW_Customize_Set_Choose "CHOOSE_TRIPLET4AP"
	elif [ "$var_cfg_ft_word" = "CTCTRIAP" ] ; then
	    HW_Customize_Set_Choose "CHOOSE_CTCTRIAP"
	elif [ "$var_cfg_ft_word" = "TRUEAP" ] ; then
		HW_Customize_Set_Choose "CHOOSE_TRUEAP"
	elif [ "$var_cfg_ft_word" = "BATELCO" ] ; then
		HW_Customize_Set_Choose "CHOOSE_BATELCO"
	elif [ "$var_cfg_ft_word" = "E8CAP" ] ; then
		HW_Customize_Set_Choose "CHOOSE_E8CAP"
	else
		#COMMON/UNICOM定制只有HGU支持免预配置
		if [ $var_is_HGU -eq 1 ]; then
			HW_Customize_Set_Choose "CHOOSE_$var_cfg_ft_word"
		else
			HW_Customize_Set_Choose ""
		fi
	fi
}
else
{
	HW_Customize_Set_Choose ""
}
fi

function keyfile_proc()
{
    cat /proc/mtd | grep keyfile > /dev/null
    [ ! $? == 0 ] && return 0

    if [ -f /var/ttree_def/`cat /etc/version`/encrypt_spec_key.tar.gz ]; then
        cp -rf /var/ttree_def/`cat /etc/version`/encrypt_spec_key.tar.gz /mnt/jffs2/
    fi

    #校检kmc是否OK
    kmc_tool check kmc_store_A
    [ $? != 0 ] && echo "ERROR::kmc store check failed!" && return 1

    keyfilemng save
    [ ! $? == 0 ] && echo "ERROR::customize keyfile save fail!" && return 1
    keyfilemng check
    [ ! $? == 0 ] && echo "ERROR::customize keyfile check fail!" && return 1
    return 0
}

function remove_choose_xml()
{
    local var_choose_xml_dir="/mnt/jffs2/choose_xml"
    #删去免预配置冗余文件
    [[ -d $var_choose_xml_dir ]] && rm -rf $var_choose_xml_dir
}

function Customize_Check_ChooseXml_Tar()
{
    CheckChooseXml.sh
    [ ! $? == 0 ] && echo "ERROR::customize check choose_xml.tar.gz fail!" && return 1
    return 0
}

# 适配root执行后部分文件归属
function Customize_SetFileOwn()
{
    [[ -f /mnt/jffs2/binftwordsave ]] && chown -h 3030:2002 /mnt/jffs2/binftwordsave
    [[ -f /mnt/jffs2/typeword ]] && chown -h 3030:2002 /mnt/jffs2/typeword
    [[ -f /mnt/jffs2/hw_hardinfo_feature ]] && chown -h 3030:2002 /mnt/jffs2/hw_hardinfo_feature
    [[ -f /mnt/jffs2/hw_hardinfo_feature.bak ]] && chown -h 3030:2002 /mnt/jffs2/hw_hardinfo_feature.bak
    [[ -f /mnt/jffs2/CMEI ]] && chown -h 3030:2002 /mnt/jffs2/CMEI
}

# 根据定制命令信息生成对应的密钥派生字
function generate_carrier_word()
{
    customizeinfo="$var_bin_ft_word$var_cfg_ft_word_en"
    if [ `echo $customizeinfo | grep -e CMCC` ]; then
        write_proc /proc/wap_proc/wap_event "SetCstKey:Carrier_CMCC"
        return
    fi
    if [ `echo $customizeinfo | grep -e E8C` ] || \
       [ `echo $customizeinfo | grep -e CT` ] || \
       [ `echo $customizeinfo | grep -e A8C` ]; then
        write_proc /proc/wap_proc/wap_event "SetCstKey:Carrier_E8C"
        return
    fi
    if [ `echo $customizeinfo | grep -e UNICOM` ] || \
       [ `echo $customizeinfo | grep -e CU` ]; then
        write_proc /proc/wap_proc/wap_event "SetCstKey:Carrier_UNICOM"
        return
    fi
    write_proc /proc/wap_proc/wap_event "SetCstKey:Carrier_COMMON"
}

HW_Customize_Check_Resource $var_input_para
[ ! $? == 0 ] && exit 1

# 结果输出
HW_Customize_Print_Result $var_input_para
[ ! $? == 0 ] && exit 1 

#检查choose_xml.tar.gz是否完整
Customize_Check_ChooseXml_Tar
[ ! $? == 0 ] && exit 1

#定制处理
HW_Customize_Delete_File

#定制证书处理
HW_Customize_Cert_File_Proc $var_bin_ft_word $var_cfg_word_orig_in
[ ! $? == 0 ] && exit 1

#生成出厂版本标志文件
HW_Customize_Add_Factory_File

keyfile_proc
[ ! $? == 0 ] && exit 1

remove_choose_xml

Customize_SetFileOwn

generate_carrier_word

#生成定制标识，这样再定制重启之后，可以将SF控制的包写到mtd里面去，
touch /mnt/jffs2/custum_finish_flag
echo > /var/customizerealfinish
sync
echo "success!" && exit 0
