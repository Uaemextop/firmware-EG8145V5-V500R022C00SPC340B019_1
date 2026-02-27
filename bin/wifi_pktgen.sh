#! /bin/sh
set +x
PrintOutUsage()
{
    echo "Usage:"
    echo "wifi_pktgen.sh init"
    echo "wifi_pktgen.sh start ifindex 4 dstmac xx:xx:xx:xx:xx:xx"
    echo "wifi_pktgen.sh stop"
    echo "wifi_pktgen.sh time ifindex 4"
    exit 255
}
wifi_pktgen_init()
{
    modprobe pktgen.ko
    echo "rem_device_all" > /proc/net/pktgen/kpktgend_0
}
wifi_pktgen_start()
{
    echo "add_device $2" > /proc/net/pktgen/kpktgend_0
    echo "min_pkt_size 1500" > /proc/net/pktgen/$2
    echo "dst_mac $4" > /proc/net/pktgen/$2
    echo "count 0" > /proc/net/pktgen/$2
    echo "start" > /proc/net/pktgen/pgctrl &
}
wifi_pktgen_stop()
{
    echo "stop" > /proc/net/pktgen/pgctrl
}
wifi_pktgen_calc()
{
    cat /proc/net/pktgen/$2 |grep usec | cut -d ' ' -f 3 | cut -d '(' -f 1
}
wifi_pktgen_main()
{
    subcmd=$1
    shift 1
    case $subcmd in
        "init")
            wifi_pktgen_init
            ;;
        "start")
            wifi_pktgen_start $*
            ;;
        "stop")
            wifi_pktgen_stop
            ;;
        "time")
            wifi_pktgen_calc $*
            ;;
        * )
            PrintOutUsage
            ;;
    esac
}
wifi_pktgen_main $*