#!/bin/sh

KillProcess()
{
        echo -n "Start kill $1 ...... "
        pid=$(pidof $1)
        if [ ! "$pid" = "" ]; then
                kill -9 $pid
        fi
        echo "Done!"
}

KillProcessNormal()
{
        echo -n "Start kill $1 ...... "
        pid=$(pidof $1)
        if [ ! "$pid" = "" ]; then
                kill -15 $pid
        fi
        echo "Done!"
}

KillProcessFivetimeNormal()
{
        count=0
        while [ $count -lt 5 ]; do
        pid=$(pidof $1)
        if [ "$pid" != "" ]; then
                kill -15 $pid
                sleep 1
                let count=$count+1
        else
          break
        fi
        done

        if [ $count -eq 5 ]; then
                echo clean $1 fail! > /proc/wap_proc/wap_log
        fi
}

KillProcessFivetime()
{
        count=0
        while [ $count -lt 5 ]; do
        pid=$(pidof $1)
        if [ "$pid" != "" ]; then
                kill -9 $pid
                sleep 1
                let count=$count+1
        else
          break
        fi
        done

        if [ $count -eq 5 ]; then
                echo clean $1 fail! > /proc/wap_proc/wap_log
        fi
}

CheckProcess()
{
        KillProcessFivetime watchproc.sh

        KillProcessFivetime voice_h248sip
        KillProcessFivetime voice_sip

        KillProcessFivetime omci

        KillProcessFivetime oam

        KillProcessFivetime smp_usb

        KillProcessFivetime hw_ldsp_user

        KillProcessFivetime dnsmasq

        KillProcessFivetime dhcpd

        KillProcessFivetime dhcpc

        KillProcessFivetime upnpdmain

        KillProcessFivetime hostapd

        KillProcessFivetime apm

        KillProcessFivetime igmp

        KillProcessFivetime ethoam

        KillProcessFivetime cwmp

        KillProcessFivetime web

        KillProcessFivetimeNormal procmonitor
        
        KillProcessFivetimeNormal ldspcli
}

# close the kernel print
write_proc /proc/sys/kernel/printk 0

echo "=========================================="
echo "== Start clean memory for Multi-Upgrade! ="
echo "=========================================="

echo "Current memeory info:"
free

echo "=========================================="
echo "Current status info:"
ps

echo "=========================================="

echo "Start kill process ! "

echo > /var/cleanmemflag
echo "***[echo > /var/cleanmemflag]***"

KillProcessNormal procmonitor

KillProcess web

KillProcess cwmp

KillProcess watchproc.sh

killall voice_h248sip
KillProcess voice_h248sip
killall voice_sip
KillProcess voice_sip

KillProcess omci

KillProcess oam

KillProcess smp_usb

KillProcess hw_ldsp_user

KillProcess dnsmasq

KillProcess dhcpd

KillProcess apm

KillProcess igmp

KillProcess ethoam

KillProcess ldspcli

KillProcess aging

KillProcess radvd

KillProcess dhcp6s

KillProcess usb_mngt

KillProcess app_nlc

KillProcess app_acs

KillProcess app_sdt

KillProcess wificli

#bin6单板删除cms和comm和lsvd
is_bin6_bin=$(GetFeature FT_WEB_MAINPAGE_CUT)
if [ "$is_bin6_bin" = "1" ];then
    KillProcess cms
    KillProcess comm
    KillProcess amp
    rmmod uart_suspend
    rmmod hw_module_mbist
    rmmod hw_module_diag
    rm -rf /var/startup_lastword
    rm -rf /var/HighTemperatureConfig.xml
    rm -rf /var/init_debug.txt
    rm -rf /var/sdkFS
    rm /var/init_dlw*
    KillProcess lsvd
    upport=$(getboardinfo 0x00000001)
    if [ "$upport" = "10" ];then
        rmmod hw_ker_optic_chip_511x_equip
        rmmod hi_epon
        rmmod hi_emac
        rmmod hw_amp
        rmmod hi_oam
        rmmod hi_xgmac
        rmmod hi_xgemac
    fi
    KillProcess clid
fi

echo "Kill process done! "

# Drop page cache
echo -n "Start drop page cache ...... "
write_proc /proc/sys/vm/drop_caches 3
echo "Done!"

echo "=========================================="
echo "== End clean memory for Multi-Upgrade! ="
echo "=========================================="

echo "Current memeory info:"
free

echo "=========================================="
echo "Current status info:"
ps


# Open the kernel print
while true; do sleep 10; write_proc /proc/sys/kernel/printk 4; break; done &

#政企单板重新拉起pm，保证不丢失log
is_bpon=$(GetFeature HW_FEATURE_ZQ)
if [ "$is_bpon" = "1" ];then
        while true; do sleep 10; CheckProcess; break; done
	procmonitor &
else
        while true; do sleep 10; CheckProcess; break; done &
fi

# return 0 to system for other application to get the status
return 0