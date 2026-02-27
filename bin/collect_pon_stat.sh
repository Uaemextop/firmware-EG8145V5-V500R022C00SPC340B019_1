#! /bin/sh
set -v
/bin/echo all > /proc/soc/gpon
/bin/cat /proc/soc/gpon
/bin/echo all > /proc/soc/epon
/bin/cat /proc/soc/epon
/bin/echo all > /proc/soc/xepon
/bin/cat /proc/soc/xepon
set +v
