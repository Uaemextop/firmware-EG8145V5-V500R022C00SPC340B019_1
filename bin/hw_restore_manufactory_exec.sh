#! /bin/sh

var_default_ctree=/mnt/jffs2/hw_default_ctree.xml
var_default_ctree2=/mnt/jffs2/hw_default_ctree2.xml
var_etc_def=/etc/wap/hw_default_ctree.xml
var_etc_boardinfo=/etc/wap/hw_boardinfo

var_ctree=/mnt/jffs2/hw_ctree.xml
var_ctree_bak=/mnt/jffs2/hw_ctree_bak.xml
var_rebootsave=/mnt/jffs2/cwmp_rebootsave
var_oldcrc=/mnt/jffs2/oldcrc
var_oltoldcrc=/mnt/jffs2/oltoldcrc
var_precrc=/mnt/jffs2/prevcrc
var_oltprecrc=/mnt/jffs2/oltprevcrc
txt_boardinfo=/var/dup_boardinfo
var_boardinfo=/mnt/jffs2/hw_boardinfo
var_boardinfo_bak=/mnt/jffs2/hw_boardinfo.bak
var_boardinfo_dec=/var/decrypt_boardinfo
var_boardinfo_temp=/var/hw_boardinfo.temp
var_bms_prevxml_temp="/mnt/jffs2/hw_bms_prev.xml"
var_bms_oskvoice_temp="/mnt/jffs2/hw_osk_voip_prev.xml"
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
var_ontfirstonline_temp="/mnt/jffs2/ontfirstonlinefile"
var_servicecfg=/mnt/jffs2/servicecfg.xml
var_commonversion=/var/common_version
var_tde2version=/var/tde2_version
var_p2p_dhcp_file="/mnt/jffs2/p2pdhcpboot_prev.ini"
var_p2p_dhcpcfg_file="/mnt/jffs2/p2pdhcploadcfgdone"
var_p2p_dhcpsoft_file="/mnt/jffs2/p2pdhcploadsoftdone"
var_bms_result_file="/mnt/jffs2/xmlcfgerrorcode"
var_reg_info_file="/mnt/jffs2/RegStepDataInfo"
var_smartshowbssguide="/mnt/jffs2/smartshowbssguide"
var_smartshowuserguide="/mnt/jffs2/smartshowuserguide"
var_upnpexpandfile="/mnt/jffs2/UpnpExpandFirstInit"
var_restore="/mnt/jffs2/restore"
var_jffs2_l2m_para_file="/mnt/jffs2/l2m_topo_ctp.cfg"
var_jffs2_customize_txt_file="/mnt/jffs2/customize.txt"
var_jffs2_xponmode_file="/mnt/jffs2/xpon_mode"
var_restore_file="/mnt/jffs2/dmrestoreinfo"

g_defupportmode=""
g_Currentupportvalue=""
g_Currentupportmode=""
var_binword=""
var_cfgword=""
var_typeword=""
boardinfo_typeword=""
boardinfo_binword=""
GetDefUpportMode()
{
    #记录原始上行模式 
    while read line;
    do
        obj_id_temp=`echo $line | sed 's/\(.*\)obj.value\(.*\)/\1/g'`
        obj_id=`echo $obj_id_temp | sed 's/\(.*\)"\(.*\)"\(.*\)/\2/g'`

        if [ "0x00000059" == $obj_id ];then
            obj_value=`echo $line | sed 's/\(.*\)"\(.*\)"\(.*\)"\(.*\)"\(.*\)/\4/g'`
            g_defupportmode=$obj_value
            continue
        elif [ "0x00000001" == $obj_id ];then
            obj_value=`echo $line | sed 's/\(.*\)"\(.*\)"\(.*\)"\(.*\)"\(.*\)/\4/g'`
            g_Currentupportmode=$obj_value
            continue
        elif [ "0x00000039" == $obj_id ];then
            obj_value=`echo $line | sed 's/\(.*\)"\(.*\)"\(.*\)"\(.*\)"\(.*\)/\4/g'`
            g_Currentupportvalue=$obj_value
            continue
        elif [ "0x00000035" == $obj_id ];then
            obj_value=`echo $line | sed 's/\(.*\)"\(.*\)"\(.*\)"\(.*\)"\(.*\)/\4/g'`
            boardinfo_typeword=$obj_value
            continue
        fi
    done < $txt_boardinfo
    return
} 

g_cfgWord=""
GetCfgWord()
{
    #记录cfgword
    while read line;
    do
        obj_id_temp=`echo $line | sed 's/\(.*\)obj.value\(.*\)/\1/g'`
        obj_id=`echo $obj_id_temp | sed 's/\(.*\)"\(.*\)"\(.*\)/\2/g'`

        if [ "0x0000001b" == $obj_id ];then
            obj_value=`echo $line | sed 's/\(.*\)"\(.*\)"\(.*\)"\(.*\)"\(.*\)/\4/g'`
            g_cfgWord=$obj_value
            break
        fi
    done < $txt_boardinfo
    return
} 

GetBinWord()
{
    #记录binword
    while read line;
    do
        obj_id_temp=`echo $line | sed 's/\(.*\)obj.value\(.*\)/\1/g'`
        obj_id=`echo $obj_id_temp | sed 's/\(.*\)"\(.*\)"\(.*\)/\2/g'`

        if [ "0x0000001a" == $obj_id ];then
            obj_value=`echo $line | sed 's/\(.*\)"\(.*\)"\(.*\)"\(.*\)"\(.*\)/\4/g'`
            boardinfo_binword=$obj_value
            break
        fi
    done < $txt_boardinfo
    return
}

# remove files
HW_Script_RemoveFile()
{
    rm -f $var_smartshowbssguide
    rm -f $var_smartshowuserguide
    rm -f $var_ctree
    rm -f $var_ctree_bak
    rm -f $var_rebootsave
    rm -f $var_oldcrc
    rm -f $var_oltoldcrc
    rm -f $var_precrc
    rm -f $var_oltprecrc
    rm -f $var_bms_prevxml_temp
    rm -f $var_bms_result_file
    rm -f $var_bms_oskvoice_temp
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
    rm -rf $var_upnpexpandfile
    rm -rf $var_restore
    rm -rf $var_jffs2_l2m_para_file
    if [ $(getboardinfo PDATTR_PON_MODE) -eq 15 ]; then
        rm -f $var_jffs2_xponmode_file
    fi
    rm -f /mnt/jffs2/usr_device.bin
    rm -f /mnt/jffs2/FTCRC
    rm -f /mnt/jffs2/ftvoipcfgstate
    rm -f /mnt/jffs2/dhcpc/wan*_request_ip
    rm -f /mnt/jffs2/emergencystatus
    rm -f /mnt/jffs2/first_start
    rm -fr $var_ontfirstonline_temp
    rm -f $var_reg_info_file

    rm -f $var_servicecfg

    rm -f /mnt/jffs2/p2ploadcfgdone
    rm -rf /mnt/jffs2/dhcp6c
    rm -rf /mnt/jffs2/dhcpc
    rm -rf $var_p2p_dhcp_file
    rm -f $var_p2p_dhcpcfg_file
    rm -f $var_p2p_dhcpsoft_file
    rm -f /mnt/jffs2/dhcp_data_a
    rm -f /mnt/jffs2/dhcp_data_b
    rm -f /mnt/jffs2/dhcp_lastip
    rm -f /mnt/jffs2/ontvideochangefile
    rm -rf /mnt/jffs2/app/osgi
    rm -rf /mnt/jffs2/app/cplugin
    rm -rf /mnt/jffs2/speedstatus
    rm -rf /mnt/jffs2/selspeedModes
    rm -rf /mnt/jffs2/ap_wifiguideconfig_up.temp
    if [ -f /mnt/jffs2/exstbmac.bin ]; then
        rm -f /mnt/jffs2/exstbmac.bin
    fi

    if [ -f /mnt/jffs2/l2m_topo_ctp.cfg ]; then
        rm -f /mnt/jffs2/l2m_topo_ctp.cfg
    fi

    if [ -f /mnt/jffs2/stbmac.bin ]; then
        rm -f /mnt/jffs2/stbmac.bin
    fi

    if [ -f /mnt/jffs2/Probe/probe ] ; then
        rm -rf /mnt/jffs2/Probe
    fi
    rm -rf /mnt/jffs2/stagingmode
    rm -f /mnt/jffs2/equip_portisolate
    if [ -f /mnt/jffs2/vpn_route ] ; then
        rm -rf /mnt/jffs2/vpn_route
    fi
    if [ -f /mnt/jffs2/dnsfilter_hostlist ] ; then
        rm -rf /mnt/jffs2/dnsfilter_hostlist
    fi

    rm -rf /mnt/jffs2/hw_ctree_rt.xml
    rm -rf /mnt/jffs2/hw_ctree_ap.xml

    rm -f /mnt/jffs2/HoupFirstInit
    rm -f /mnt/jffs2/smartshownormaluserguide

    if [ "$boardinfo_binword" = "E8C" ];then
        rm -f /mnt/jffs2/roguestatus
        rm -f /mnt/jffs2/eponroguestatus
        rm -f /mnt/jffs2/emergencystatus
    fi

    # 删除WIFI提前静默配置数据
    if [ -f /mnt/jffs2/wifi_5g_cac_data ] ; then
        rm -f /mnt/jffs2/wifi_5g_cac_data
    fi

    return
}

g_newupportmode=""
# 恢复hw_boardinfo.xml的eponkey、snpassword、eponpwd、loid到默认空配置
HW_Script_Clear_Boardinfo()
{
        #检查boardinfo是否存在，不存在则返回
        if [ ! -f $txt_boardinfo ]; then
            echo "ERROR::$txt_boardinfo is not exist!"
            return 1;
    fi
    
    var_is_pon2lan=`GetFeature FT_PON_UPPORT_CONFIG`
    var_is_restoremode=`GetFeature FT_SSMP_RESTORE_PON_MODE`
    if [ 0 -ne $var_is_pon2lan ] || [ 0 -ne $var_is_restoremode ];then
        g_newupportmode="$g_defupportmode"
        if [ "1" = "$g_defupportmode" ] || [ "2" = "$g_defupportmode" ] || [ "4" = "$g_defupportmode" ] || [ "5" = "$g_defupportmode" ] || [ "6" = "$g_defupportmode" ] || [ "7" = "$g_defupportmode" ] || [ "10" = "$g_defupportmode" ];then
            g_newupportmode="0x102001"

        fi
    else

        g_newupportmode="$g_Currentupportvalue"
    fi

    var_is_restoreToLan=`GetFeature FT_RESTORE_TO_LAN`
    if [ $var_is_restoreToLan -eq 1 ];then
        g_newupportmode="0x0000000"`cat /proc/wap_proc/pd_static_attr | grep eth_num | awk -F "\"" '{print $2}'`
        g_defupportmode="3"
    fi

    cat $txt_boardinfo | while read -r line;
    do
        obj_id_temp=`echo $line | sed 's/\(.*\)obj.value\(.*\)/\1/g'`
        obj_id=`echo $obj_id_temp | sed 's/\(.*\)"\(.*\)"\(.*\)/\2/g'`
        
        if [ "0x00000001" == $obj_id ];then
            if [ $var_is_pon2lan -ne 0 ] || [ $var_is_restoremode -ne 0 ] || [ $var_is_restoreToLan -ne 0 ];then
                if [ "" != "$g_defupportmode" ] && [ "0" != "$g_defupportmode" ];then
                    echo "obj.id = \"0x00000001\" ; obj.value = \"$g_defupportmode\";"
                else
                    echo "obj.id = \"0x00000001\" ; obj.value = \"$g_Currentupportmode\";"
                fi
            else
                echo "obj.id = \"0x00000001\" ; obj.value = \"$g_Currentupportmode\";"
            fi
        elif [ "0x00000005" == $obj_id ];then
            echo "obj.id = \"0x00000005\" ; obj.value = \"\";"
        elif [ "0x00000006" == $obj_id ];then
            echo "obj.id = \"0x00000006\" ; obj.value = \"\";"
        elif [ "0x00000003" == $obj_id ];then            
            if [ "$g_cfgWord" = "SPAINMSMV2WIFI" ] || [ "$g_cfgWord" = "PTVDF2WIFI_PWD" ];then
                echo -E $line
            else
                echo "obj.id = \"0x00000003\" ; obj.value = \"\";"
            fi
        elif [ "0x00000016" == $obj_id ];then
            echo "obj.id = \"0x00000016\" ; obj.value = \"\";"
        elif [ "0x00000004" == $obj_id ];then
            echo "obj.id = \"0x00000004\" ; obj.value = \"\";"
        elif [ "0x0000003c" == $obj_id ];then
            if [ $var_is_restoremode -ne 0 ] || [ $var_is_restoreToLan -ne 0 ];then
                echo "obj.id = \"0x0000003c\" ; obj.value = \"$g_newupportmode\";"
            else
                echo "obj.id = \"0x0000003c\" ; obj.value = \"\";"
            fi
        elif [ "0x0000003d" == $obj_id ];then
            echo "obj.id = \"0x0000003d\" ; obj.value = \"\";"
        elif [ "0x00000052" == $obj_id ];then
            echo "obj.id = \"0x00000052\" ; obj.value = \"\";"    
        elif [ "0x00000039" == $obj_id ];then
            echo "obj.id = \"0x00000039\" ; obj.value = \"$g_newupportmode\";"                        
        else
            echo -E $line
        fi
    done  > $var_boardinfo_temp
    
    #AP自适应（WA）不清除上行口模式
    ap_mode_switch=`GetFeature FT_SSMP_AP_OPERATION_SWITCH`
    if [ 1 -eq $ap_mode_switch ] && [ 0 -eq $var_is_restoremode ];then
        var_eth="0x0000000"`cat /proc/wap_proc/pd_static_attr | grep eth_num | awk -F "\"" '{print $2}'`
        echo $var_boardinfo_temp | xargs sed 's/obj.id = \"0x0000003c\" ; obj.value = \"[a-zA-Z0-9_-]*\"/obj.id = \"0x0000003c\" ; obj.value = \"'$var_eth'\"/g' -i
    fi

    if [ $var_is_restoreToLan -eq 1 ]; then
        echo $var_boardinfo_temp | xargs sed 's/obj.id = \"0x00000035\" ; obj.value = \"[a-zA-Z0-9_-]*\"/obj.id = \"0x00000035\" ; obj.value = \"LAN\"/g' -i
    fi

    var_is_restoreToPON=`GetFeature FT_RESTORE_TO_PON`
    if [ $var_is_restoreToPON -eq 1 ]; then
        echo $var_boardinfo_temp | xargs sed 's/obj.id = \"0x00000035\" ; obj.value = \"[a-zA-Z0-9_-]*\"/obj.id = \"0x00000035\" ; obj.value = \"PON\"/g' -i
        echo $var_boardinfo_temp | xargs sed 's/obj.id = \"0x0000003c\" ; obj.value = \"[a-zA-Z0-9_-]*\"/obj.id = \"0x0000003c\" ; obj.value = \"0x102001\"/g' -i
    fi

    cp -f $var_boardinfo_temp $txt_boardinfo
    
    return 0
}

HW_Script_Clear_BoardinfoForTDE2()
{
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
    
    cp -f $var_boardinfo_temp $txt_boardinfo
    
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
            if [ "$varCfgWord" = "COMMON" ] ; then
                touch $var_commonversion
                return 0
            elif [ "$varCfgWord" = "TDE2" ] || [ "$varCfgWord" = "TDESME2" ] ; then
                touch $var_tde2version
                return 0
            fi
        else
            echo -E $line
        fi
    done > /dev/null
}

# copy files
HW_Script_CopyFile()
{    
    HW_Script_IsCustomizeVersion
    #1）如果不是定制，var_etc_def拷贝为hw_ctree.xml
    #2）如果是定制，var_default_ctree不存在需要报错，存在，则拷贝此文件为hw_ctree.xml
    
    #增加延时，确保DB不保存
    echo > /var/notsavedata
    sleep 1
    
    if [ -f $var_default_ctree ];then
        cp -f $var_default_ctree $var_ctree
        cp -f $var_ctree $var_ctree_bak
        if [ 0 -ne $? ] ; then
            rm -rf /var/notsavedata
            echo "ERROR::Failed to cp $var_default_ctree to hw_ctree.xml!"
            return 1
        fi
    else
        cp -f $var_etc_def $var_ctree
        cp -f $var_ctree $var_ctree_bak
        if [ 0 -ne $? ] ; then
            rm -rf /var/notsavedata
            echo "ERROR::Failed to cp $var_etc_def to hw_ctree.xml!"
            return 1
        fi
    fi
    
    #copy hw_boardinfo
    if [ ! -f $var_tde2version ] ; then
        HW_Script_Clear_Boardinfo
        if [ 0 -ne $? ] ; then
            return 1
        fi
    else
        HW_Script_Clear_BoardinfoForTDE2
        if [ 0 -ne $? ] ; then
            return 1
        fi
    fi
    
    #VDF定制创建标志文件
    if [ "$g_cfgWord" = "PTVDF2WIFI_PWD" ];then
        echo > /mnt/jffs2/restore_manufacture_done
        chown -h 3008:2002 /mnt/jffs2/restore_manufacture_done
        chmod 660 /mnt/jffs2/restore_manufacture_done
    fi

    return
}

HW_Script_Restore_GHN()
{
    #调用ontinfo工具获取产品类型
    if [ ! -f /bin/ontinfo ]
    then
        return 1
    fi  
    
    var_boardtype="`ontinfo -s -b`"
    var_len=${#var_boardtype}
    let var_len=var_len-1
    var_boardtype=`expr substr $var_boardtype 1 $var_len`
        
    #限制到产品形态为PA8011V CA8011V
    if [ $var_boardtype != "PA8011V" ] && [ $var_boardtype != "CA8011V" ]
    then
        return 0
    fi    
    
    #GNN底板恢复出厂
    if [ ! -f /bin/ghnap ]
    then
        return 1
    fi  
    ghnap manufactory
    if [ $? -ne 0 ]; then
        echo "GHN restore manufactory fail";
        return 1;
    fi
    
    return
}

HW_Script_SetTypeWord()
{
    if [ -f $var_jffs2_customize_txt_file ];then
    read var_binword var_cfgword < $var_jffs2_customize_txt_file
        if [ 0 -ne $? ]
        then
            echo "Failed to read var_jffs2_customize_txt_file info!"
            return 1
        fi
    fi
    var_typeword=`echo $var_cfgword | tr a-z A-Z | cut -d : -f2 `
    var_cfg_customize=`echo $var_cfgword | tr a-z A-Z | cut -d : -f1 `
    var_upportssid="0x0030400"`cat /proc/wap_proc/pd_static_attr | grep ssid_num | awk -F "\"" '{print $2}'`
    var_upport="0x0000000"`cat /proc/wap_proc/pd_static_attr | grep eth_num | awk -F "\"" '{print $2}'`
    ap_autoselectupport=`GetFeature FT_NEW_AP`
    ap_deskvdfptapupport=`GetFeature FT_AP_DESKVDFPTAP`
    ap_aisMesh=`GetFeature FT_AIS_MESH`
    ap_restoreponmode=`GetFeature FT_SSMP_RESTORE_PON_MODE`
    var_is_ap=`GetFeature FT_ONT_SWITCH_AP_MODE`
    var_is_zq=`GetFeature HW_FEATURE_ZQ`
    local var_is_support_select=`GetFeature FT_DM_AP_SELECT_MODE`
    local deskap_jordanpair=`GetFeature FT_DESKAP_PAIR`
    if [ 1 -eq $ap_autoselectupport ] && [ 1 -ne $ap_deskvdfptapupport ] && [ 1 -ne $ap_restoreponmode ] && [ 1 -ne $deskap_jordanpair ] || [ "$var_cfg_customize" = "SCCTAP" ] || \
       ([ "$var_typeword" = "RT" ] && [ "$var_cfg_customize" = "CHINAEBG5" ]) || ([ "$var_typeword" = "RT" ] && [ "$var_cfg_customize" = "COMMONEBG5" ]) || \
       ([ "$var_is_zq" -eq 1 ] && [ "$var_typeword" = "RT" ] && ([ "$var_cfg_customize" = "CHINAEBG2" ] || [ "$var_cfg_customize" = "CHINAFTTO6" ]));then
        #检查boardinfo是否存在，不存在则返回错误
        if [ ! -f $txt_boardinfo ]; then
            return 1;
        fi
        if [ "$boardinfo_typeword" = "FTTRAP" ];then
            echo $txt_boardinfo | xargs sed 's/obj.id = \"0x00000001\" ; obj.value = \"[a-zA-Z0-9_-]*\"/obj.id = \"0x00000001\" ; obj.value = \"1\"/g' -i
            echo $txt_boardinfo | xargs sed 's/obj.id = \"0x00000039\" ; obj.value = \"[a-zA-Z0-9_-]*\"/obj.id = \"0x00000039\" ; obj.value = \"0x00102001\"/g' -i
            echo $txt_boardinfo | xargs sed 's/obj.id = \"0x0000003c\" ; obj.value = \"[a-zA-Z0-9_-]*\"/obj.id = \"0x0000003c\" ; obj.value = \"0x00102001\"/g' -i
            echo $txt_boardinfo | xargs sed 's/obj.id = \"0x00000042\" ; obj.value = \"[a-zA-Z0-9_-]*\"/obj.id = \"0x00000042\" ; obj.value = \"0\"/g' -i
        elif ([ "$var_cfg_customize" = "HUNCTAP" ] && [ "$var_typeword" = "AP" ]); then
            echo $txt_boardinfo | xargs sed 's/obj.id = \"0x00000001\" ; obj.value = \"[a-zA-Z0-9_-]*\"/obj.id = \"0x00000001\" ; obj.value = \"8\"/g' -i
            echo $txt_boardinfo | xargs sed 's/obj.id = \"0x00000035\" ; obj.value = \"[a-zA-Z0-9_-]*\"/obj.id = \"0x00000035\" ; obj.value = \"'$var_typeword'\"/g' -i
            echo $txt_boardinfo | xargs sed 's/obj.id = \"0x00000039\" ; obj.value = \"[a-zA-Z0-9_-]*\"/obj.id = \"0x00000039\" ; obj.value = \"'$var_upportssid'\"/g' -i
            echo $txt_boardinfo | xargs sed 's/obj.id = \"0x0000003c\" ; obj.value = \"[a-zA-Z0-9_-]*\"/obj.id = \"0x0000003c\" ; obj.value = \"'$var_upport'\"/g' -i
            echo $txt_boardinfo | xargs sed 's/obj.id = \"0x00000042\" ; obj.value = \"[a-zA-Z0-9_-]*\"/obj.id = \"0x00000042\" ; obj.value = \"3\"/g' -i
        elif [ "$var_typeword" = "AP" ];then
            echo $txt_boardinfo | xargs sed 's/obj.id = \"0x00000001\" ; obj.value = \"[a-zA-Z0-9_-]*\"/obj.id = \"0x00000001\" ; obj.value = \"8\"/g' -i
            echo $txt_boardinfo | xargs sed 's/obj.id = \"0x00000039\" ; obj.value = \"[a-zA-Z0-9_-]*\"/obj.id = \"0x00000039\" ; obj.value = \"'$var_upportssid'\"/g' -i
            echo $txt_boardinfo | xargs sed 's/obj.id = \"0x0000003c\" ; obj.value = \"[a-zA-Z0-9_-]*\"/obj.id = \"0x0000003c\" ; obj.value = \"'$var_upport'\"/g' -i
            echo $txt_boardinfo | xargs sed 's/obj.id = \"0x00000042\" ; obj.value = \"[a-zA-Z0-9_-]*\"/obj.id = \"0x00000042\" ; obj.value = \"3\"/g' -i
        elif ([ "$var_typeword" = "RT" ] && [ "$var_cfg_customize" = "CHINAEBG5" ]) || ([ "$var_typeword" = "RT" ] && [ "$var_cfg_customize" = "COMMONEBG5" ]) || \
             ([ "$var_is_zq" -eq 1 ] && [ "$var_typeword" = "RT" ] && ([ "$var_cfg_customize" = "CHINAEBG2" ] || [ "$var_cfg_customize" = "CHINAFTTO6" ])); then
            echo $txt_boardinfo | xargs sed 's/obj.id = \"0x00000001\" ; obj.value = \"[a-zA-Z0-9_-]*\"/obj.id = \"0x00000001\" ; obj.value = \"1\"/g' -i
            echo $txt_boardinfo | xargs sed 's/obj.id = \"0x00000039\" ; obj.value = \"[a-zA-Z0-9_-]*\"/obj.id = \"0x00000039\" ; obj.value = \"0x00102001\"/g' -i
            echo $txt_boardinfo | xargs sed 's/obj.id = \"0x0000003c\" ; obj.value = \"[a-zA-Z0-9_-]*\"/obj.id = \"0x0000003c\" ; obj.value = \"0x00102001\"/g' -i
            echo $txt_boardinfo | xargs sed 's/obj.id = \"0x00000042\" ; obj.value = \"[a-zA-Z0-9_-]*\"/obj.id = \"0x00000042\" ; obj.value = \"1\"/g' -i
        elif ([ "$var_typeword" = "PWD" ] && [ "$var_cfg_customize" = "MYTIME" ]); then
            echo $txt_boardinfo | xargs sed 's/obj.id = \"0x00000001\" ; obj.value = \"[a-zA-Z0-9_-]*\"/obj.id = \"0x00000001\" ; obj.value = \"1\"/g' -i
            echo $txt_boardinfo | xargs sed 's/obj.id = \"0x0000001b\" ; obj.value = \"[a-zA-Z0-9_-]*\"/obj.id = \"0x0000001b\" ; obj.value = \"MYTIME\"/g' -i
            echo $txt_boardinfo | xargs sed 's/obj.id = \"0x00000035\" ; obj.value = \"[a-zA-Z0-9_-]*\"/obj.id = \"0x00000035\" ; obj.value = \"PWD\"/g' -i
            echo $txt_boardinfo | xargs sed 's/obj.id = \"0x00000039\" ; obj.value = \"[a-zA-Z0-9_-]*\"/obj.id = \"0x00000039\" ; obj.value = \"0x00102001\"/g' -i
            echo $txt_boardinfo | xargs sed 's/obj.id = \"0x0000003c\" ; obj.value = \"[a-zA-Z0-9_-]*\"/obj.id = \"0x0000003c\" ; obj.value = \"0x00102001\"/g' -i
            echo $txt_boardinfo | xargs sed 's/obj.id = \"0x00000042\" ; obj.value = \"[a-zA-Z0-9_-]*\"/obj.id = \"0x00000042\" ; obj.value = \"0\"/g' -i
            echo $txt_boardinfo | xargs sed 's/obj.id = \"0x00000061\" ; obj.value = \"[a-zA-Z0-9_-]*\"/obj.id = \"0x00000061\" ; obj.value = \"0\"/g' -i
        elif ([ "$var_cfg_customize" = "DESKPON" ]); then
            echo $txt_boardinfo | xargs sed 's/obj.id = \"0x00000001\" ; obj.value = \"[a-zA-Z0-9_-]*\"/obj.id = \"0x00000001\" ; obj.value = \"1\"/g' -i
            echo $txt_boardinfo | xargs sed 's/obj.id = \"0x0000001b\" ; obj.value = \"[a-zA-Z0-9_-]*\"/obj.id = \"0x0000001b\" ; obj.value = \"DESKPON\"/g' -i
            echo $txt_boardinfo | xargs sed 's/obj.id = \"0x00000035\" ; obj.value = \"[a-zA-Z0-9_-]*\"/obj.id = \"0x00000035\" ; obj.value = \"\"/g' -i
            echo $txt_boardinfo | xargs sed 's/obj.id = \"0x00000039\" ; obj.value = \"[a-zA-Z0-9_-]*\"/obj.id = \"0x00000039\" ; obj.value = \"0x00102001\"/g' -i
            echo $txt_boardinfo | xargs sed 's/obj.id = \"0x0000003c\" ; obj.value = \"[a-zA-Z0-9_-]*\"/obj.id = \"0x0000003c\" ; obj.value = \"0x00102001\"/g' -i
            echo $txt_boardinfo | xargs sed 's/obj.id = \"0x00000042\" ; obj.value = \"[a-zA-Z0-9_-]*\"/obj.id = \"0x00000042\" ; obj.value = \"0\"/g' -i
            echo $txt_boardinfo | xargs sed 's/obj.id = \"0x00000061\" ; obj.value = \"[a-zA-Z0-9_-]*\"/obj.id = \"0x00000061\" ; obj.value = \"0\"/g' -i
            return
        elif ([ "$var_cfg_customize" = "IDXL2WIFI" ]); then
            echo $txt_boardinfo | xargs sed 's/obj.id = \"0x00000001\" ; obj.value = \"[a-zA-Z0-9_-]*\"/obj.id = \"0x00000001\" ; obj.value = \"1\"/g' -i
            echo $txt_boardinfo | xargs sed 's/obj.id = \"0x0000001b\" ; obj.value = \"[a-zA-Z0-9_-]*\"/obj.id = \"0x0000001b\" ; obj.value = \"IDXL2\"/g' -i
            echo $txt_boardinfo | xargs sed 's/obj.id = \"0x00000035\" ; obj.value = \"[a-zA-Z0-9_-]*\"/obj.id = \"0x00000035\" ; obj.value = \"\"/g' -i
            echo $txt_boardinfo | xargs sed 's/obj.id = \"0x00000039\" ; obj.value = \"[a-zA-Z0-9_-]*\"/obj.id = \"0x00000039\" ; obj.value = \"0x00102001\"/g' -i
            echo $txt_boardinfo | xargs sed 's/obj.id = \"0x0000003c\" ; obj.value = \"[a-zA-Z0-9_-]*\"/obj.id = \"0x0000003c\" ; obj.value = \"0x00102001\"/g' -i
            echo $txt_boardinfo | xargs sed 's/obj.id = \"0x00000042\" ; obj.value = \"[a-zA-Z0-9_-]*\"/obj.id = \"0x00000042\" ; obj.value = \"0\"/g' -i
            echo $txt_boardinfo | xargs sed 's/obj.id = \"0x00000061\" ; obj.value = \"[a-zA-Z0-9_-]*\"/obj.id = \"0x00000061\" ; obj.value = \"0\"/g' -i
            return
        elif ([ "$var_cfg_customize" = "LAOSTELNCE" ]); then
            echo $txt_boardinfo | xargs sed 's/obj.id = \"0x00000001\" ; obj.value = \"[a-zA-Z0-9_-]*\"/obj.id = \"0x00000001\" ; obj.value = \"1\"/g' -i
            echo $txt_boardinfo | xargs sed 's/obj.id = \"0x0000001b\" ; obj.value = \"[a-zA-Z0-9_-]*\"/obj.id = \"0x0000001b\" ; obj.value = \"LAOSTELNCE\"/g' -i
            echo $txt_boardinfo | xargs sed 's/obj.id = \"0x00000035\" ; obj.value = \"[a-zA-Z0-9_-]*\"/obj.id = \"0x00000035\" ; obj.value = \"\"/g' -i
            echo $txt_boardinfo | xargs sed 's/obj.id = \"0x00000039\" ; obj.value = \"[a-zA-Z0-9_-]*\"/obj.id = \"0x00000039\" ; obj.value = \"0x00102001\"/g' -i
            echo $txt_boardinfo | xargs sed 's/obj.id = \"0x0000003c\" ; obj.value = \"[a-zA-Z0-9_-]*\"/obj.id = \"0x0000003c\" ; obj.value = \"0x00102001\"/g' -i
            echo $txt_boardinfo | xargs sed 's/obj.id = \"0x00000042\" ; obj.value = \"[a-zA-Z0-9_-]*\"/obj.id = \"0x00000042\" ; obj.value = \"0\"/g' -i
            echo $txt_boardinfo | xargs sed 's/obj.id = \"0x00000061\" ; obj.value = \"[a-zA-Z0-9_-]*\"/obj.id = \"0x00000061\" ; obj.value = \"0\"/g' -i
            return
        elif ([ "$var_cfg_customize" = "GLOBE2WIFI" ]); then
			echo $txt_boardinfo | xargs sed 's/obj.id = \"0x00000001\" ; obj.value = \"[a-zA-Z0-9_-]*\"/obj.id = \"0x00000001\" ; obj.value = \"1\"/g' -i
			echo $txt_boardinfo | xargs sed 's/obj.id = \"0x0000001b\" ; obj.value = \"[a-zA-Z0-9_-]*\"/obj.id = \"0x0000001b\" ; obj.value = \"GLOBE2\"/g' -i
			echo $txt_boardinfo | xargs sed 's/obj.id = \"0x00000035\" ; obj.value = \"[a-zA-Z0-9_-]*\"/obj.id = \"0x00000035\" ; obj.value = \"\"/g' -i
			echo $txt_boardinfo | xargs sed 's/obj.id = \"0x00000039\" ; obj.value = \"[a-zA-Z0-9_-]*\"/obj.id = \"0x00000039\" ; obj.value = \"0x00102001\"/g' -i
			echo $txt_boardinfo | xargs sed 's/obj.id = \"0x0000003c\" ; obj.value = \"[a-zA-Z0-9_-]*\"/obj.id = \"0x0000003c\" ; obj.value = \"0x00102001\"/g' -i
			echo $txt_boardinfo | xargs sed 's/obj.id = \"0x00000042\" ; obj.value = \"[a-zA-Z0-9_-]*\"/obj.id = \"0x00000042\" ; obj.value = \"0\"/g' -i
			echo $txt_boardinfo | xargs sed 's/obj.id = \"0x00000061\" ; obj.value = \"[a-zA-Z0-9_-]*\"/obj.id = \"0x00000061\" ; obj.value = \"0\"/g' -i
        else
            echo $txt_boardinfo | xargs sed 's/obj.id = \"0x00000001\" ; obj.value = \"[a-zA-Z0-9_-]*\"/obj.id = \"0x00000001\" ; obj.value = \"3\"/g' -i
            echo $txt_boardinfo | xargs sed 's/obj.id = \"0x00000039\" ; obj.value = \"[a-zA-Z0-9_-]*\"/obj.id = \"0x00000039\" ; obj.value = \"'$var_upport'\"/g' -i
            echo $txt_boardinfo | xargs sed 's/obj.id = \"0x0000003c\" ; obj.value = \"[a-zA-Z0-9_-]*\"/obj.id = \"0x0000003c\" ; obj.value = \"'$var_upport'\"/g' -i
            echo $txt_boardinfo | xargs sed 's/obj.id = \"0x00000042\" ; obj.value = \"[a-zA-Z0-9_-]*\"/obj.id = \"0x00000042\" ; obj.value = \"1\"/g' -i
        fi

        if [ 1 -ne  $var_is_ap ];then
            echo $txt_boardinfo | xargs sed 's/obj.id = \"0x00000035\" ; obj.value = \"[a-zA-Z0-9_]*\"/obj.id = \"0x00000035\" ; obj.value = \"'$var_typeword'\"/g' -i
        fi

        ap_fixupport=`GetFeature FT_AP_FIX_UPPORT`
        #0x00000061表示wan口选择模式：1代表自适应  2代表固定上行口
        if [[ 1 -eq $ap_fixupport ]] || [[ 1 -eq $ap_aisMesh ]] ;then
            echo $txt_boardinfo | xargs sed 's/obj.id = \"0x00000061\" ; obj.value = \"[a-zA-Z0-9_-]*\"/obj.id = \"0x00000061\" ; obj.value = \"2\"/g' -i
        elif [[ 1 -eq $var_is_support_select ]];then
            echo $txt_boardinfo | xargs sed 's/obj.id = \"0x00000061\" ; obj.value = \"[a-zA-Z0-9_-]*\"/obj.id = \"0x00000061\" ; obj.value = \"1\"/g' -i
        fi
    fi
    
    return
}

function ont_ap_adapt_restore_deal()
{
    #只有在ONT&AP自适应的AP模式才走此流程
    var_is_ap=`GetFeature FT_ONT_SWITCH_AP_MODE`
    if [ $var_is_ap -ne 0 ];then
        #增加延时，确保DB不保存
        echo > /var/notsavedata
        sleep 1

        if [ -f $var_default_ctree2 ];then
            cp -f $var_default_ctree2 $var_ctree
            if [ 0 -ne $? ] ; then
                rm -rf /var/notsavedata
                echo "ERROR::Failed to cp $var_default_ctree2 to hw_ctree.xml!"
                return 1
            fi
        fi
    fi

    return 0
}

function fitap_restore_to_edgeont()
{
    restore_to_edgeont=`GetFeature FT_FITAP_RESTORE_TO_EDGEONT`
    if [ 1 -eq $restore_to_edgeont ]; then
        echo $txt_boardinfo | xargs sed 's/obj.id = \"0x00000061\" ; obj.value = \"[a-zA-Z0-9_-]*\"/obj.id = \"0x00000061\" ; obj.value = \"0\"/g' -i
        echo $txt_boardinfo | xargs sed 's/obj.id = \"0x00000042\" ; obj.value = \"[a-zA-Z0-9_-]*\"/obj.id = \"0x00000042\" ; obj.value = \"0\"/g' -i
        echo $txt_boardinfo | xargs sed 's/obj.id = \"0x00000001\" ; obj.value = \"[a-zA-Z0-9_-]*\"/obj.id = \"0x00000001\" ; obj.value = \"1\"/g' -i
        echo $txt_boardinfo | xargs sed 's/obj.id = \"0x00000039\" ; obj.value = \"[a-zA-Z0-9_-]*\"/obj.id = \"0x00000039\" ; obj.value = \"0x00102001\"/g' -i
        echo $txt_boardinfo | xargs sed 's/obj.id = \"0x0000003c\" ; obj.value = \"[a-zA-Z0-9_-]*\"/obj.id = \"0x0000003c\" ; obj.value = \"0x00102001\"/g' -i
    fi
}

add_factory_count()
{
    recordFlag=`GetFeature FT_RECORD_DEV_REBOOT_INFOS`
    if [ recordFlag == 0 ]; then
        return
    fi

    restore_count=0
    factory_reset_date=`date "+%d%m%Y%H%M%S"`
    if [ -f $var_restore_file ]; then
        restore_count=`cat $var_restore_file | cut -d " " -f 4`
    fi
    let "restore_count++"

    echo "Date $factory_reset_date count $restore_count terminal 2" > $var_restore_file
    ontchown 3008:2002 $var_restore_file;chmod 640 $var_restore_file
}

function deal_mode_for_sdcremote()
{
    isSupportSdcremoteOut=`GetFeature FT_AP_SDCREMOTEOUT`
    var_eth="0x0000000"`cat /proc/wap_proc/pd_static_attr | grep eth_num | awk -F "\"" '{print $2}'`
    if [ 1 -eq $isSupportSdcremoteOut ]; then
        echo $txt_boardinfo | xargs sed 's/obj.id = \"0x00000001\" ; obj.value = \"[a-zA-Z0-9_-]*\"/obj.id = \"0x00000001\" ; obj.value = \"3\"/g' -i
        echo $txt_boardinfo | xargs sed 's/obj.id = \"0x00000039\" ; obj.value = \"[a-zA-Z0-9_-]*\"/obj.id = \"0x00000039\" ; obj.value = \"'$var_eth'\"/g' -i
        echo $txt_boardinfo | xargs sed 's/obj.id = \"0x0000003c\" ; obj.value = \"[a-zA-Z0-9_-]*\"/obj.id = \"0x0000003c\" ; obj.value = \"'$var_eth'\"/g' -i
        echo $txt_boardinfo | xargs sed 's/obj.id = \"0x00000042\" ; obj.value = \"[a-zA-Z0-9_-]*\"/obj.id = \"0x00000042\" ; obj.value = \"2\"/g' -i
        echo $txt_boardinfo | xargs sed 's/obj.id = \"0x00000061\" ; obj.value = \"[a-zA-Z0-9_-]*\"/obj.id = \"0x00000061\" ; obj.value = \"2\"/g' -i
    fi
    
    isSupportSdcremoteIn=`GetFeature FT_AP_SDCREMOTEIN`
    var_ssid="0x0030400"`cat /proc/wap_proc/pd_static_attr | grep ssid_num | awk -F "\"" '{print $2}'`
    if [ 1 -eq $isSupportSdcremoteIn ]; then
        echo $txt_boardinfo | xargs sed 's/obj.id = \"0x00000001\" ; obj.value = \"[a-zA-Z0-9_-]*\"/obj.id = \"0x00000001\" ; obj.value = \"8\"/g' -i
        echo $txt_boardinfo | xargs sed 's/obj.id = \"0x00000039\" ; obj.value = \"[a-zA-Z0-9_-]*\"/obj.id = \"0x00000039\" ; obj.value = \"'$var_ssid'\"/g' -i
        echo $txt_boardinfo | xargs sed 's/obj.id = \"0x0000003c\" ; obj.value = \"[a-zA-Z0-9_-]*\"/obj.id = \"0x0000003c\" ; obj.value = \"'$var_ssid'\"/g' -i
        echo $txt_boardinfo | xargs sed 's/obj.id = \"0x00000042\" ; obj.value = \"[a-zA-Z0-9_-]*\"/obj.id = \"0x00000042\" ; obj.value = \"3\"/g' -i
        echo $txt_boardinfo | xargs sed 's/obj.id = \"0x00000061\" ; obj.value = \"[a-zA-Z0-9_-]*\"/obj.id = \"0x00000061\" ; obj.value = \"0\"/g' -i
    fi
}

function fitonu_restore_to_upmode()
{
    restore_to_edgeont=`GetFeature FT_RESTORE_UPMODE_PON`
    if [ 1 -eq $restore_to_edgeont ]; then
        echo $txt_boardinfo | xargs sed 's/obj.id = \"0x00000001\" ; obj.value = \"[a-zA-Z0-9_-]*\"/obj.id = \"0x00000001\" ; obj.value = \"1\"/g' -i
    fi
}

if [ 0 -ne $# ]; then
    echo "ERROR::input para is not right!";
    return 1;
else
    sync
    sleep 1
    if [ -d /mnt/jffs2/app/plugins/work ]; then
        # 发送 EVENT_THIRDPARTYPLUGIN_RESTORE 事件
        write_proc /proc/wap_proc/wap_event "EVENT_THIRDPARTYPLUGIN_RESTORE"
    fi
    if [ ! -f $txt_boardinfo ]; then
        if [ -f $var_boardinfo_dec ]; then
            cp -f $var_boardinfo_dec $txt_boardinfo
        else
            cp -f $var_boardinfo $txt_boardinfo
        fi
    fi
    if [ $? -ne 0 ]; then
        echo "ERROR::Copy to dup boardinfo failed!"
        return 1
    fi

    GetBinWord
    [ ! $? == 0 ] && exit 1

    #删除指定文件
    HW_Script_RemoveFile
    [ ! $? == 0 ] && exit 1
        
    GetDefUpportMode
    [ ! $? == 0 ] && exit 1
    
    GetCfgWord
    [ ! $? == 0 ] && exit 1
    
    #拷贝文件
    HW_Script_CopyFile
    [ ! $? == 0 ] && exit 1
    
    #GHN底板恢复出厂
    HW_Script_Restore_GHN
    
    #TypeWord恢复出厂
    HW_Script_SetTypeWord
    
    #ONT&AP自适应在AP模式下的特殊处理
    ont_ap_adapt_restore_deal

    #适配回传单板处理
    deal_mode_for_sdcremote

    #AP切ONT设置为非盲插模式
    fitap_restore_to_edgeont

    fitonu_restore_to_upmode

    setboardinfo -p bs -c $txt_boardinfo
    chmod 640 $var_boardinfo $var_boardinfo_bak
    chown -h srv_ssmp:service $var_boardinfo $var_boardinfo_bak
    
    ProcDataWh -g -f /mnt/jffs2/hw_ctree.xml
    ProcDataWh -g -f /mnt/jffs2/hw_ctree_bak.xml

    add_factory_count

    var_is_tde2=`GetFeature FT_FEATURE_TDE`
    if [ 0 -ne $var_is_tde2 ]
    then 
        echo " "
        echo "success! "
        echo " "
        echo "reset ont now! "
    fi
    
    if [ "$g_cfgWord" = "SPAINMSMV2WIFI" ];then
        reboot
    else
        exit 0
    fi
    

fi

