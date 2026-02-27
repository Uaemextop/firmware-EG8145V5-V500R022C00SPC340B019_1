#! /bin/sh

workpath=/etc/wap/collect
HW_COLLECT_SSMPLIST=$workpath/ssmplist
HW_COLLECT_VOICELIST=$workpath/voicelist
HW_COLLECT_BBSPLIST=$workpath/bbsplist
HW_COLLECT_AMPLIST=$workpath/amplist
HW_COLLECT_LDSPLIST=$workpath/ldsplist
HW_COLLECT_SMARTLIST=$workpath/smartlist
HW_COLLECT_WLANLIST=$workpath/wlanlist
HW_COLLECT_ALLLIST=$workpath/alllist

COLLECT_5182H=$workpath/bbsp_collect_5182H
COLLECT_9617=$workpath/bbsp_collect_9617

if [ $# -gt 1 ]; then
    echo "ERROR::input para is not right!";
    exit 1;
elif [ $# -eq 1 ]; then
	SELECT=$1
else
	SELECT="all"
fi

CLI_MODE=$(cat /var/collectshflag)

if [ "$CLI_MODE" = "1" ]
then
    echo "Now ClientType Is TRANSCHNL, collect.sh can not be used in this ClientType."
    exit 1
fi

if [ -f /var/diacollectisrunning ]
then
    echo "diagnose collection process is existed now!"
    exit 1
fi

if [ "$LOCAL_TELNET" == "1" ]; then
    diag_src="com";
else
    diag_src="telnet";
fi

echo "local telnet flag is $LOCAL_TELNET, diag source is $diag_src"

if [ -p /var/collect_ctrl_fifo ]; then
        echo 1 > /var/collect_ctrl_fifo;
else
        echo !path "/var/console.log" > /proc/wap_proc/tty;
        echo !start > /proc/wap_proc/tty;
fi

#读取配置文件的数据信息，执行collect_exe命令
echo  "Begin to collect"
    case $SELECT in
        ssmp)
            SELECTITEMS=$HW_COLLECT_SSMPLIST
            ;;
        voice)
            SELECTITEMS=$HW_COLLECT_VOICELIST
            ;;
        bbsp)
            SELECTITEMS=$HW_COLLECT_BBSPLIST
            ;;
        amp)
            SELECTITEMS=$HW_COLLECT_AMPLIST
            ;;
        ldsp)
            SELECTITEMS=$HW_COLLECT_LDSPLIST
            ;;
        smart)
            SELECTITEMS=$HW_COLLECT_SMARTLIST
            ;;
        wlan)
            SELECTITEMS=$HW_COLLECT_WLANLIST
            ;;
        all)
            SELECTITEMS=$HW_COLLECT_ALLLIST
            shellconfig InternetGatewayDevice.ManagementServer.X_HW_APInfo set Type all >> /dev/null
            ;;
     history)
            SELECTITEMS=$HW_COLLECT_ALLLIST
            shellconfig InternetGatewayDevice.ManagementServer.X_HW_APInfo set Type history >> /dev/null
           ;;
        *)
            echo "ERROR::input para is not right!"
            exit 1
            ;;
    esac
    cat $SELECTITEMS | while read line
    do
        echo $line | grep -o "[^ ]\+\( \+[^ ]\+\)*"
        collect_exe $line $diag_src
    done

feature_5182H=`GetFeature BBSP_FT_DATAPATH_NP`
if [[ "$SELECT" = "all" ||  "$SELECT" = "bbsp" ]] && [ $feature_5182H -eq 1 ] &&
    [ -f /etc/wap/collect/bbsp_collect_5182H ] ;then
    collect_exe $COLLECT_5182H $diag_src
fi

feature_fc=`GetFeature FT_RTK_FC_DRIVER`
if [[ "$SELECT" = "all" ||  "$SELECT" = "bbsp" ]] && [ $feature_fc -eq 1 ] &&
    [ -f /etc/wap/collect/bbsp_collect_9617 ] ;then
    collect_exe $COLLECT_9617 $diag_src
fi

if [ -p /var/collect_ctrl_fifo ]; then
        echo 2 > /var/collect_ctrl_fifo;
else
        echo !stop > /proc/wap_proc/tty;
fi

if [ -f /var/dealwithsensitive ] ; then
    /bin/dealwithsensitive.sh
fi

if [ "$LOCAL_TELNET" != "1" ]; then
	cat /var/console.log 
fi

#收集网关下挂的ap日志
function collect_ap_log()
{
    local ap_log_file="/var/ap_collect.tar.gz"
    local flag=0
    local count=0
    #等待ap上传到网关完成,最多等待3min
    echo "------------Start collect AP log------------------"
    while(true);do
        if [ $count -gt "36" ];then
            echo "------------Wait AP log timeout!!!------------------"
            return 0
        fi
        if [[ -f "$ap_log_file" ]] && [[ ! -f "/var/web_apcollect_flag" ]];then
            break;
        fi
        sleep 5
        echo -n "....."
        count=$((count+1))
    done
    cd /var
    mkdir ap_collect_tmp
    tar -xf $ap_log_file -C ap_collect_tmp

    cd /var/ap_collect_tmp/ap_collect
    for var in $(ls)
    do
        if [ ${#var} -ne 24 ];then
            if [ ${#var} -eq 30 ];then
                echo "The file ${var:0:12}**:**:**:${var:21:9} is invalid and requires manual confirmation. Skip and continue."
            fi
            continue
        fi
        echo "===================================================================="
        echo "------------Start collect AP(**:**:**:${var:9:8}) log------------------"
        gunzip $var > /dev/null 2>&1
        if [[ $? = "0" ]];then
            cat ${var%%.gz}
            rm -rf ${var%%.gz}
        else
           echo "The Ap log **:**:**${var:9} is invaild!!!!!"
        fi
        echo "-------------End collect AP(**:**:**:${var:9:8}) log-------------------"
        echo "====================================================================="
    done
    return 0
}

#存在下挂ap收集日志
if [[ "$SELECT" = "all" ||  "$SELECT" = "history" ]] && [[ "$diag_src" = "com" || "$diag_src" = "telnet" ]] ;then
    if [[ -f "/var/collect_ap_info_cli" ]];then
        collect_ap_log
        rm -rf "/var/ap_collect_tmp"
    fi
fi
rm -rf "/var/collect_ap_info_cli"

sed -i 's/hilink/smartlink/ig' /var/console.log

echo  "End to collect"

exit 0;
