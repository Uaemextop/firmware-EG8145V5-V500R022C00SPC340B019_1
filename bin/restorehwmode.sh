#! /bin/sh

var_pack_temp_dir=/bin/
login_user=$(whoami)
if [ $login_user != "root" ]; then
	echo -e "$0 failed !!!\nPlease switch to the su mode, then run $0 again."
	exit 0
fi

if [ -f /etc/wap/DebugVersionFlag ]; then
    if [ -f /mnt/jffs2/RestoreHWExecTime ]; then
        var_lineCount=`cat /mnt/jffs2/RestoreHWExecTime | wc -l`
        if [ $var_lineCount -gt 10 ]; then
            rm /mnt/jffs2/RestoreHWExecTime
        fi
    fi
    date "+%Y-%m-%d_%H:%M:%S" >> /mnt/jffs2/RestoreHWExecTime
fi

#如果flash中boardinfo是加密的则解密覆盖
if [ -f /bin/decrypt_boardinfo ]; then
    if [ -f /mnt/jffs2/hw_boardinfo ]; then
        decrypt_boardinfo -s /mnt/jffs2/hw_boardinfo -d /mnt/jffs2/hw_boardinfo
    fi
    if [ -f /mnt/jffs2/hw_boardinfo.bak ]; then
        decrypt_boardinfo -s /mnt/jffs2/hw_boardinfo.bak -d /mnt/jffs2/hw_boardinfo.bak
    fi
fi

var_default_ctree=/mnt/jffs2/hw_default_ctree.xml;
var_default_ctree2=/mnt/jffs2/hw_default_ctree2.xml;
var_default_ctree3=/mnt/jffs2/hw_default_ctree3.xml;
var_ctree=/mnt/jffs2/hw_ctree.xml
var_customize=/mnt/jffs2/customizepara.txt
var_origiscust=/var/iscustomize.txt
var_bms_prevxml_temp="/mnt/jffs2/hw_bms_prev.xml"
var_bms_oldcrc_temp="/mnt/jffs2/oldcrc"
var_bms_oltoldcrc_temp="/mnt/jffs2/oltoldcrc"
var_bms_prevcrc_temp="/mnt/jffs2/prevcrc"
var_bms_oltprevcrc_temp="/mnt/jffs2/oltprevcrc"
var_bms_oskvoice_temp="/mnt/jffs2/hw_osk_voip_prev.xml"
var_rebootsave="/mnt/jffs2/cwmp_rebootsave"
var_recovername_temp="/mnt/jffs2/recovername"
var_usr_device_temp="/mnt/jffs2/usr_device.bin"
var_ftcrc_temp="/mnt/jffs2/FTCRC"
var_ftvoip_temp="/mnt/jffs2/ftvoipcfgstate"
var_dhcp_temp="/mnt/jffs2/dhcpc"
var_dhcp6_temp="/mnt/jffs2/dhcp6c"
var_DHCPlasterrwan1_temp="/mnt/jffs2/DHCPlasterrwan1"
var_DHCPlasterrwan2_temp="/mnt/jffs2/DHCPlasterrwan2"
var_DHCPlasterrwan3_temp="/mnt/jffs2/DHCPlasterrwan3"
var_DHCPlasterrwan4_temp="/mnt/jffs2/DHCPlasterrwan4"
var_DHCPstatewan1_temp="/mnt/jffs2/DHCPstatewan1"
var_DHCPstatewan2_temp="/mnt/jffs2/DHCPstatewan2"
var_DHCPstatewan3_temp="/mnt/jffs2/DHCPstatewan3"
var_DHCPstatewan4_temp="/mnt/jffs2/DHCPstatewan4"
var_DHCPoutputwan1_temp="/mnt/jffs2/DHCPoutputwan1"
txt_boardinfo=/var/dup_boardinfo
var_boardinfo_dec=/var/decrypt_boardinfo
var_boardinfo_file="/mnt/jffs2/hw_boardinfo"
var_boardinfo_bakfile="/mnt/jffs2/hw_boardinfo.bak"
var_boardinfo_temp="/mnt/jffs2/hw_boardinfo.temp"
var_jffs2_customize_txt_file="/mnt/jffs2/customize.txt"
var_jffs2_choose_xml_dir="/mnt/jffs2/choose_xml"
var_jffs2_choose_xml_tar="/mnt/jffs2/choose_xml.tar.gz"
var_jffs2_spec_file="/mnt/jffs2/hw_hardinfo_spec"
var_jffs2_spec_bak_file="/mnt/jffs2/hw_hardinfo_spec.bak"
var_jffs2_feature_file="/mnt/jffs2/hw_hardinfo_feature"
var_jffs2_feature_bak_file="/mnt/jffs2/hw_hardinfo_feature.bak"
var_jffs2_hardinfo_para_file="/mnt/jffs2/hw_equip_hardinfo"
var_jffs2_l2m_para_file="/mnt/jffs2/l2m_topo_ctp.cfg"
var_ontfirstonline_temp="/mnt/jffs2/ontfirstonlinefile"
var_dublecore="/mnt/jffs2/doublecore"
var_customize_telmex=/mnt/jffs2/TelmexCusomizePara
var_customize_dir="/mnt/jffs2/customize"
var_customize_xml_dir="/mnt/jffs2/customize_xml"
var_customize_xml_tar="/mnt/jffs2/customize_xml.tar.gz"
var_smartshowbssguide="/mnt/jffs2/smartshowbssguide"
var_smartshowuserguide="/mnt/jffs2/smartshowuserguide"
var_old_ctree="/mnt/jffs2/hw_old_ctree.xml"
var_ctree_bak="/mnt/jffs2/hw_ctree_bak.xml"
var_cfgbackup="/mnt/jffs2/CfgFile_Backup"
var_PrimaryDir="/mnt/jffs2/PrimaryDir"
var_p2p_dhcp_file="/mnt/jffs2/p2pdhcpboot_prev.ini"
var_jffs2_hardversion_bak_file="/mnt/jffs2/hw_boardinfo.bak"
var_jffs2_specsn_file="/mnt/jffs2/customize_specsn"
var_plat_root="/mnt/jffs2/platroot.crt" 
var_plat_pub="/mnt/jffs2/platpub.crt"
var_plat_prvt="/mnt/jffs2/platprvt.key"
var_bms_result_file="/mnt/jffs2/xmlcfgerrorcode"
var_reg_info_file="/mnt/jffs2/RegStepDataInfo"
var_upnpexpandfile="/mnt/jffs2/UpnpExpandFirstInit"
var_ap_reportSN_file="/mnt/jffs2/ap_report_sn"
var_tde2version=/var/tde2_version
var_bridgeapguide="/mnt/jffs2/bridgeapguideflag"
var_bmsbackupdir="/mnt/jffs2/bmsxml"
var_autobackupdir="/mnt/jffs2/restore"
var_jffs2_bakup_optic_para_file="/mnt/jffs2/sfp_optic_hw_mode_bakup_par.bin"
var_jffs2_slave_optic_para_file="/mnt/jffs2/optic_slave_par.bin"
var_jffs2_common_bakup1_optic_para_file="/mnt/jffs2/sfp_optic_common_bakup1_par.bin"
var_jffs2_common_bakup2_optic_para_file="/mnt/jffs2/sfp_optic_common_bakup2_par.bin"
var_jffs2_custominfo_file="/mnt/jffs2/oldcustinfo"
var_upgrade_log="/mnt/jffs2/restorehwmode_log.txt"
var_fttrmergebin_support=`GetFeature FT_FTTR_CHINA_UNITE_BIN`
var_bpon_flag=`GetFeature HW_FEATURE_ZQ`
# remove plugin files 
HW_Script_RemovePluginFile()
{
    #通过特性开关来决定删除哪些插件
    var_feature_enble=`GetFeature HW_FT_OSGI_JVM_FROM_VAR`
    if [ $var_feature_enble = 1 ];then
        rm  -rf /mnt/jffs2/app/osgi/felix-cache;
        rm  -f /mnt/jffs2/app/osgi/prebundlestatus.info;
        rm  -f /mnt/jffs2/app/osgi/dlna.jar;
        rm  -f /mnt/jffs2/app/osgi/samba.jar;
    else
        rm -rf /mnt/jffs2/app/osgi;
    fi
    rm -rf  /mnt/jffs2/app/cplugin /var/cplugin;
}

function Clean_CustInstallCerts()
{
    cert_list="8F9D72F9B9E992C6A6D6EEA45E21C9ACC7A93CC4 AA8E82F4C4CAAB4073CC9878B3AEB6B8A25B9428 houpCA.crt wolink_cert2.crt wolink_cert3.crt hilinkCert1.pem hilinkCA1.pem hilinkPriKey1.pem shct_server_ca.pem"
    for cert in $cert_list; do
        if [ -f /mnt/jffs2/certs/$cert ]; then
            rm -f /mnt/jffs2/certs/$cert
        fi
    done
}

# remove files
HW_Script_RemoveFile()
{
    rm -f $var_default_ctree
    rm -f $var_default_ctree2
    rm -f $var_default_ctree3
    rm -f $var_ctree
    if [ -f $var_customize ]; then
        rm -f $var_customize
        touch $var_origiscust
    fi
    rm -f $var_bms_prevxml_temp
    rm -f $var_bms_result_file
    rm -f $var_bms_oldcrc_temp
    rm -f $var_bms_oltoldcrc_temp
    rm -f $var_bms_prevcrc_temp
    rm -f $var_bms_oltprevcrc_temp
    rm -f $var_bms_oskvoice_temp
    rm -f $var_rebootsave
    rm -f $var_recovername_temp
    rm -f $var_usr_device_temp
    rm -rf $var_ftcrc_temp
    rm -rf $var_ftvoip_temp
    rm -rf $var_dhcp_temp
    rm -rf $var_dhcp6_temp
    rm -rf $var_DHCPlasterrwan1_temp
    rm -rf $var_DHCPlasterrwan2_temp
    rm -rf $var_DHCPlasterrwan3_temp
    rm -rf $var_DHCPlasterrwan4_temp
    rm -rf $var_DHCPstatewan1_temp
    rm -rf $var_DHCPstatewan2_temp
    rm -rf $var_DHCPstatewan3_temp
    rm -rf $var_DHCPstatewan4_temp
    rm -rf $var_DHCPoutputwan1_temp
    rm -rf $var_jffs2_customize_txt_file
    rm -rf $var_jffs2_choose_xml_dir
    rm -f $var_jffs2_choose_xml_tar
    rm -fr $var_jffs2_spec_file
    rm -fr $var_jffs2_spec_bak_file
    rm -fr $var_jffs2_feature_file
    rm -fr $var_jffs2_feature_bak_file
    rm -fr $var_jffs2_hardinfo_para_file
    rm -fr $var_ontfirstonline_temp
    rm -f $var_dublecore
    rm -f /mnt/jffs2/simcard_flowflag
    rm -f /mnt/jffs2/simcardreadflag
    rm -f /mnt/jffs2/typeword
    rm -f /mnt/jffs2/first_start
    rm -f $var_customize_telmex
    rm -rf $var_customize_dir
    rm -f $var_smartshowbssguide
    rm -rf $var_smartshowuserguide
    rm -rf $var_bridgeapguide
    rm -fr $var_old_ctree
    rm -fr $var_ctree_bak
    rm -fr $var_cfgbackup
    rm -f $var_jffs2_hardversion_bak_file
    rm -rf $var_PrimaryDir
    rm -rf /mnt/jffs2/p2ploadcfgdone
    rm -rf /mnt/jffs2/dhcp6c
    rm -rf /mnt/jffs2/dhcpc
    rm -rf /mnt/jffs2/onlinecounter
    rm -rf $var_jffs2_specsn_file
    rm -rf /mnt/jffs2/reboot_bind_tag
    rm -rf $var_p2p_dhcp_file
     rm -rf $var_upnpexpandfile
    rm -rf $var_customize_xml_dir
    rm -rf $var_customize_xml_tar
    rm -rf $var_ap_reportSN_file
    rm -rf $var_bmsbackupdir
    rm -rf $var_autobackupdir
    
    rm  -rf /mnt/jffs2/app/osgi
    rm  -rf /mnt/jffs2/app/cplugin

    if [ -d /mnt/jffs2/Install_gram ]; then
        rm -rf /mnt/jffs2/Install_gram
    fi

    rm  -rf /mnt/jffs2/cert/

    rm -f /mnt/jffs2/smooth_finsh
    
    rm -f /mnt/jffs2/ontvideochangefile
    
    if [ -f /mnt/jffs2/exstbmac.bin ]; then
        rm -f /mnt/jffs2/exstbmac.bin
    fi
   
    if [ -f /mnt/jffs2/stbmac.bin ]; then
        rm -f /mnt/jffs2/stbmac.bin
    fi

    if [ -f /mnt/jffs2/l2m_topo_ctp.cfg ]; then
        rm -f /mnt/jffs2/l2m_topo_ctp.cfg
    fi
    
    rm -rf /mnt/jffs2/bbsp_awifibindports
    rm -rf /mnt/jffs2/speedstatus
    rm -rf /mnt/jffs2/selspeedModes
    if [ -f /mnt/jffs2/vpn_route ] ; then
    rm -rf /mnt/jffs2/vpn_route
    fi
    if [ -f /mnt/jffs2/dnsfilter_hostlist ] ; then
    rm -rf /mnt/jffs2/dnsfilter_hostlist
    fi
    rm -f $var_plat_root
    rm -f $var_plat_pub
    rm -f $var_plat_prvt
    rm -f $var_reg_info_file
    rm -f /var/new_key_encryte_ctree
    HW_Script_RemovePluginFile

    if [ -f /mnt/jffs2/Probe/probe ] ; then
    rm -rf /mnt/jffs2/Probe
    fi
    rm -rf /mnt/jffs2/stagingmode
    rm -rf /mnt/jffs2/V5_TypeWord_FLAG
    rm -f $var_jffs2_custominfo_file

    rm -rf /mnt/jffs2/oldcustinfo
    rm -rf /mnt/jffs2/hw_ctree_rt.xml
    rm -rf /mnt/jffs2/hw_ctree_ap.xml
    rm -f /mnt/jffs2/smartshownormaluserguide
    if [ ! -f "/mnt/jffs2/auto_mode" ];then
        rm -f /mnt/jffs2/xpon_mode
    fi
    rm -f /mnt/jffs2/binftwordsave
    rm -f /mnt/jffs2/HoupFirstInit
    if [ -f "/mnt/jffs2/frameworkcheck" ];then
        rm -rf "/mnt/jffs2/frameworkcheck"
    fi
    if [ -f "/mnt/jffs2/frameworkcheckunion" ];then
        rm -f /mnt/jffs2/frameworkcheckunion
    fi
    if [ $var_fttrmergebin_support = 1 ];then
        rm -rf /mnt/jffs2/plug/apps/etc/dbus-1
    fi
    rm -rf /mnt/jffs2/choose/
    rm -rf /mnt/jffs2/app/approuteDB
    rm -rf /mnt/jffs2/app/appfilterDB
    rm -f /mnt/jffs2/access_dsl_mode
    rm -f /mnt/jffs2/dbus-1
    rm -rf /mnt/jffs2/app/true
    if [ -f "/mnt/jffs2/cfmflag" ];then
        rm -f "/mnt/jffs2/cfmflag"
    fi

    [ -f /mnt/jffs2/time_sync_stamp ] && rm -f /mnt/jffs2/time_sync_stamp

    rm -f /mnt/jffs2/roguestatus
    rm -f /mnt/jffs2/eponroguestatus
    rm -f /mnt/jffs2/emergencystatus

    # 删除5G提前静默数据
    if [ -f /mnt/jffs2/wifi_5g_cac_data ]; then
        rm -f /mnt/jffs2/wifi_5g_cac_data
    fi

    rm -f /mnt/jffs2/closecaptcha
    rm -rf /mnt/jffs2/pack_sh
    rm -rf /mnt/jffs2/fttredge_unicom

    Clean_CustInstallCerts

    return 0
}

#creat files
HW_Script_CreateFile()
{
    local _file=/mnt/jffs2/ProductLineMode
    [[ ! -f $_file ]] && echo "" > $_file && chown -h 3008:2002 $_file

    return 0
}

HW_Script_Encrypt()
{
    if [ $1 -eq 1 ]
    then
        gzip -f $2
        mv $2".gz" $2
        $var_pack_temp_dir/aescrypt2 0 $2 $2"_tmp"    
    fi
}   

HW_Script_cfgtool_add_value()
{
    cfgtool gettofile $1 $2 $3
    if [ 0 -eq $? ]
    then
        cfgtool set $1 $2 $3 $4
        if [ 0 -ne $? ]
        then
            echo $2 $3 $4 "set fail" >> $var_upgrade_log
        fi    
    else
        cfgtool add $1 $2 $3 $4    
        if [ 0 -ne $? ]
        then
            echo $2 $3 $4 "add fail" >> $var_upgrade_log
        fi          
    fi
}    

HW_Script_SetDatToFile()
{   
    varIsXmlEncrypted=0
    
    # decrypt var_ctree          
    $var_pack_temp_dir/aescrypt2 1 $1 $1"_tmp"
    if [ 0 -ne $? ]
    then
        echo $1" Is not Encrypted!" >> $var_upgrade_log
    else
        echo $1" Is Encrypted!" >> $var_upgrade_log
        varIsXmlEncrypted=1
        mv $1 $1".gz"
        gunzip -f $1".gz"
    fi
    var_NodePath="InternetGatewayDevice.X_HW_DataModel.PortalGuideCtrl"
    HW_Script_cfgtool_add_value $1 $var_NodePath "PortalGuideSupport" "0" 
    var_NodePath="InternetGatewayDevice.UserInterface.X_HW_WebUserInfo.X_HW_WebUserInfoInstance.2"
    HW_Script_cfgtool_add_value $1 $var_NodePath "ModifyPasswordFlag" "1" 
    if [ 0 -ne $varIsXmlEncrypted ]
    then
        #encrypt var_ctree
        HW_Script_Encrypt $varIsXmlEncrypted $1
    fi
    return 0
}

HW_Script_ChangeCTree()
{  
    if [ -f /mnt/jffs2/hw_ctree.xml ]
    then
        #对当前ctree做操作
        rm -rf /var/hw_ctree_temp.xml
        cp -rf /mnt/jffs2/hw_ctree.xml /var/hw_ctree_temp.xml
        HW_Script_SetDatToFile /var/hw_ctree_temp.xml
        cp -rf /var/hw_ctree_temp.xml /mnt/jffs2/hw_ctree.xml
    fi
}

# copy files
HW_Script_CopyFile()
{
    var_etc_def=/etc/wap/hw_default_ctree.xml
    
    #增加延时，确保DB不保存
    echo > /var/notsavedata
    chmod 644 /var/notsavedata
    sleep 1

    cp -f $var_etc_def $var_ctree
    cp -f $var_ctree $var_ctree_bak
    if [ 0 -ne $? ]
    then
        rm -rf /var/notsavedata
        echo "ERROR::Failed to cp hw_default_ctree.xml to hw_ctree.xml!"
        return 1
    fi
    newap_support=`GetFeature FT_NEW_AP`
    if [ $newap_support = 1 ] ;then
        HW_Script_ChangeCTree
    fi
    return 0
}

# set spec data
HW_Script_SetData()
{
    cat $txt_boardinfo | while read -r line;
    do
        obj_id_temp=`echo $line | sed 's/\(.*\)obj.value\(.*\)/\1/g'`
        obj_id=`echo $obj_id_temp | sed 's/\(.*\)"\(.*\)"\(.*\)/\2/g'`

        if [ "0x00000003" == $obj_id ];then
            echo "obj.id = \"0x00000003\" ; obj.value = \"\";"
        elif [ "0x00000004" == $obj_id ];then
            echo "obj.id = \"0x00000004\" ; obj.value = \"\";"
        elif [ "0x00000005" == $obj_id ];then
            echo "obj.id = \"0x00000005\" ; obj.value = \"\";"
        elif [ "0x00000006" == $obj_id ];then
            echo "obj.id = \"0x00000006\" ; obj.value = \"\";"
        elif [ "0x00000016" == $obj_id ];then
            echo "obj.id = \"0x00000016\" ; obj.value = \"\";"
        elif [ "0x0000001a" == $obj_id ];then
            echo "obj.id = \"0x0000001a\" ; obj.value = \"COMMON\";"
        elif [ "0x0000001b" == $obj_id ];then
            echo "obj.id = \"0x0000001b\" ; obj.value = \"COMMON\";"
        elif [ "0x00000019" == $obj_id ];then
            echo "obj.id = \"0x00000019\" ; obj.value = \"\";"
        elif [ "0x00000020" == $obj_id ];then
            echo "obj.id = \"0x00000020\" ; obj.value = \"\";"
        elif [ "0x00000031" == $obj_id ];then
            echo "obj.id = \"0x00000031\" ; obj.value = \"NOCHOOSE\";"
        elif [ "0x00000035" == $obj_id ];then
            echo "obj.id = \"0x00000035\" ; obj.value = \"\";"
        elif [ "0x0000003a" == $obj_id ];then
            echo "obj.id = \"0x0000003a\" ; obj.value = \"\";"
        elif [ $var_bpon_flag != 1 ] && [ "0x0000003c" == $obj_id ];then
            echo "obj.id = \"0x0000003c\" ; obj.value = \"\";"
        elif [ "0x0000003d" == $obj_id ];then
            echo "obj.id = \"0x0000003d\" ; obj.value = \"\";"
        elif [ "0x00000042" == $obj_id ];then
            echo "obj.id = \"0x00000042\" ; obj.value = \"0\";"
        elif [ "0x00000060" == $obj_id ];then
            echo "obj.id = \"0x00000060\" ; obj.value = \"\";"
        elif [ "0x00000061" == $obj_id ];then
            echo "obj.id = \"0x00000061\" ; obj.value = \"0\";"
        elif [ "0x00000065" == $obj_id ];then
            echo "obj.id = \"0x00000067\" ; obj.value = \"\";"
        elif [ "0x00000066" == $obj_id ];then
            echo "obj.id = \"0x00000068\" ; obj.value = \"\";"
        elif [ "0x00000073" == $obj_id ];then
            echo "obj.id = \"0x00000073\" ; obj.value = \"0\";"
        elif [ "0x00000083" == $obj_id ];then
            echo "obj.id = \"0x00000083\" ; obj.value = \"\";"
        else
            echo -E $line
        fi
    done  > $var_boardinfo_temp

    mv -f $var_boardinfo_temp $txt_boardinfo

    return 0
}

# 刷新boardinfo文件的crc行
HW_Customize_ValidateBoardinfoCRC()
{
    if [ -z $1 ]; then
        return 0
    fi
    if [ -x /bin/factparam ]; then
        /bin/factparam -v $1
        if [ 0 -ne $? ]; then
            echo "ERROR::Failed to validate boardinfo crc on $1!"
            return 1
        fi
    fi
}

# 清除出厂参数备份
HW_Customize_ClearFactoryParamsBackup()
{
    if [ -x /bin/factparam ]; then
        /bin/factparam -e reserved
        if [ 0 -ne $? ]; then
            echo "ERROR::Failed to clear factory parameter backup area!"
            return 1
        fi
    fi
}

HW_Script_Clear_BoardinfoForTDE2()
{
    if [ ! -f $var_tde2version ] ; then    
        return 0
    fi

    #eponkey：0x00000005，eponpwd：0x00000006 snpassword：0x00000003 loid：0x00000016
    #这个是跟DM的代码保持一致的，产品平台存在强耦合，不能随意更改
    
    #检查boardinfo是否存在，不存在则返回
    if [ ! -f $txt_boardinfo ]; then
        echo "ERROR::$txt_boardinfo is not exist!"
        return 1;
    fi

    cat $txt_boardinfo | while read -r line;
    do
        obj_id_temp=`echo $line | sed 's/\(.*\)obj.value\(.*\)/\1/g'`
        obj_id=`echo $obj_id_temp | sed 's/\(.*\)"\(.*\)"\(.*\)/\2/g'`
        
        if [ "0x00000052" == $obj_id ];then
            echo "obj.id = \"0x00000052\" ; obj.value = \"\";"            
        else
            echo -E $line
        fi    
    done  > $var_boardinfo_temp
    
    mv -f $var_boardinfo_temp $txt_boardinfo
    
    return 0
}

HW_Script_IsCustomizeVersion()
{
    #检查boardinfo是否存在，不存在则返回错误
    if [ ! -f $txt_boardinfo ]; then
        return 1;
    fi
    
    cat $txt_boardinfo | while read -r line;
    do
        obj_id_temp=`echo $line | sed 's/\(.*\)obj.value\(.*\)/\1/g'`
        obj_id=`echo $obj_id_temp | sed 's/\(.*\)"\(.*\)"\(.*\)/\2/g'`
        
        if [ "0x0000001b" == $obj_id ];then
            varCfgWord=`echo $line | sed 's/\(.*\)"\(.*\)"\(.*\)"\(.*\)"\(.*\)/\4/g'`
            if [ "$varCfgWord" = "TDE2" ] || [ "$varCfgWord" = "TDESME2" ] ; then
                touch $var_tde2version
                return 0
            fi
        else
            echo -E $line
        fi
    done > /dev/null
}

HW_ClearBackKeyUbi()
{
    keyfilemng clear
    return 0
}

#ONT&AP自适应在AP模式下的特殊处理
HW_OntApAdaptRestorDeal()
{
    #只有在ONT&AP自适应的AP模式才走此流程
    var_is_ap=`GetFeature FT_ONT_SWITCH_AP_MODE`
    var_is_ap_recover=`GetFeature FT_ONT_SWITCH_AP_MODE_RECOVER`
    if [ $var_is_ap -ne 0 ] || [ $var_is_ap_recover -ne 0 ]
    then
        echo $txt_boardinfo | xargs sed 's/obj.id = \"0x00000001\" ; obj.value = \"[a-zA-Z0-9_]*\"/obj.id = \"0x00000001\" ; obj.value = \"1\"/g' -i
        echo $txt_boardinfo | xargs sed 's/obj.id = \"0x00000039\" ; obj.value = \"[a-zA-Z0-9_]*\"/obj.id = \"0x00000039\" ; obj.value = \"0x00102001\"/g' -i
        echo $txt_boardinfo | xargs sed 's/obj.id = \"0x0000003c\" ; obj.value = \"[a-zA-Z0-9_-]*\"/obj.id = \"0x0000003c\" ; obj.value = \"0x00102001\"/g' -i
        echo $txt_boardinfo | xargs sed 's/obj.id = \"0x00000042\" ; obj.value = \"[a-zA-Z0-9_-]*\"/obj.id = \"0x00000042\" ; obj.value = \"0\"/g' -i
        echo $txt_boardinfo | xargs sed 's/obj.id = \"0x00000061\" ; obj.value = \"[a-zA-Z0-9_]*\"/obj.id = \"0x00000061\" ; obj.value = \"0\"/g' -i
    fi

    rm -f $var_jffs2_custominfo_file

    return 0
}

# 对sfp形态ONU做光参数恢复
Customize_RestoreSfpOnuOpticPara()
{
    if [ -f $var_jffs2_bakup_optic_para_file ]; then
        sndhlp 0 0x2000501a 0x1a 0
        if [ 0 -ne $? ]
        then
            echo "ERROR::Failed to clear sfp optic para flag!"
            return 1
        fi
        sleep 1
        cp -pf $var_jffs2_bakup_optic_para_file $var_jffs2_slave_optic_para_file
        if [ 0 -ne $? ]
        then
            echo "ERROR::Failed to cp sfp_optic_hw_mode_bakup_par.bin to optic_slave_par.bin!"
            return 1
        fi
        cp -pf $var_jffs2_bakup_optic_para_file $var_jffs2_common_bakup1_optic_para_file
        if [ 0 -ne $? ]
        then
            echo "ERROR::Failed to cp sfp_optic_hw_mode_bakup_par.bin to sfp_optic_common_bakup1_par.bin!"
            return 1
        fi
        cp -pf $var_jffs2_bakup_optic_para_file $var_jffs2_common_bakup2_optic_para_file
        if [ 0 -ne $? ]
        then
            echo "ERROR::Failed to cp sfp_optic_hw_mode_bakup_par.bin to sfp_optic_common_bakup2_par.bin!"
            return 1
        fi
    fi
}

function change_file_mode()
{
    chown -h 3008:2002 /mnt/jffs2/*ctree*
    chown -h 3008:2002 /mnt/jffs2/hw_boardinfo*
}

if [ 0 -ne $# ]; then
    echo "ERROR::input para is not right!";
    exit 1;
else

sync
sleep 1
if [ ! -f $txt_boardinfo ]; then
    if [ -f $var_boardinfo_dec ]; then
        cp -f $var_boardinfo_dec $txt_boardinfo
    else
        cp -f $var_boardinfo_file $txt_boardinfo
    fi
fi
if [ $? -ne 0 ]; then
    echo "ERROR::Copy to dup boardinfo failed!"
    return 1
fi

HW_Script_CreateFile
[ ! $? == 0 ] && exit 1

HW_Script_RemoveFile
[ ! $? == 0 ] && exit 1

HW_Script_CopyFile
[ ! $? == 0 ] && exit 1

HW_Script_IsCustomizeVersion

HW_Script_SetData
[ ! $? == 0 ] && exit 1

Customize_RestoreSfpOnuOpticPara
[ ! $? == 0 ] && exit 1

#ONT&AP自适应在AP模式下的特殊处理
HW_OntApAdaptRestorDeal

procid=`pidof saf-huawei`
ctrg_support=`GetFeature HW_SSMP_FEATURE_CTRG`
if [ $ctrg_support = 1 ] && [ "$procid" != "" ] ;then
    dbus-send --system --print-reply --dest=com.ctc.saf1 /com/ctc/saf1 com.ctc.saf1.framework.Restore > /dev/null
fi

HW_Script_Clear_BoardinfoForTDE2

rm -rf $var_boardinfo_bakfile
cp -f $txt_boardinfo $var_boardinfo_file
chmod a+r $txt_boardinfo
cp -f $var_boardinfo_file $var_boardinfo_bakfile

# 必须刷新boardinfo文件的crc行，并且清除reserved分区的出厂参数备份
HW_Customize_ValidateBoardinfoCRC $var_boardinfo_file
[ ! $? == 0 ] && exit 1

rm -rf /mnt/jffs2/custum_finish_flag

rm -f /mnt/jffs2/factory_file

if [ -f /mnt/jffs2/app/fpga_diag_left.bin ];then
    rm -rf /mnt/jffs2/app/fpga_diag_left.bin
    rm -rf /mnt/jffs2/app/fpga_diag_right.bin
    rm -rf /mnt/jffs2/app/fpga_dam_apm_pll.bin
    rm -rf /mnt/jffs2/app/fpga_diag_left_zg.bin
    rm -rf /mnt/jffs2/app/fpga_diag_right_zg.bin
fi

change_file_mode
ProcDataWh -g -f /mnt/jffs2/hw_ctree.xml
ProcDataWh -g -f /mnt/jffs2/hw_ctree_bak.xml
ProcDataWh -g -f /mnt/jffs2/hw_boardinfo
ProcDataWh -g -f /mnt/jffs2/hw_boardinfo.bak

HW_ClearBackKeyUbi

rm -rf /mnt/jffs2/backup_ok
rm -rf /mnt/jffs2/backfile_ok

# 解决非装备模式下组播使能包同时设置上行方式不能清除定制参数的问题
if [ -f $var_boardinfo_dec ]; then
    cp -f $txt_boardinfo $var_boardinfo_dec
    echo "Reload" > /proc/wap_proc/feature
fi

# 解决平滑出来的domainId为3, keyId为2因清除定制信息还保留在jffs2的flash下而产生的问题
kmc_tool delCfgKmcInfo /mnt/jffs2/kmc_store_A
kmc_tool delCfgKmcInfo /mnt/jffs2/kmc_store_B

sync

echo "success!"

exit 0
fi

