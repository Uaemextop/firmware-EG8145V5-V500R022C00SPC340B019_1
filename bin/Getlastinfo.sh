#! /bin/sh

if [ -f /mnt/jffs2/lastsysinfo.tar.gz ]; then
    tar -zxvf /mnt/jffs2/lastsysinfo.tar.gz -C /var > /dev/null
else
    if [ -f /var/lastsysinfo.tar.gz ]; then
        tar -zxvf /var/lastsysinfo.tar.gz -C /var > /dev/null
    fi
fi

if [ -f /var/lastsysinfo ]; then
    echo " dlw 1"
    cat /var/lastsysinfo
    rm -rf /var/lastsysinfo
fi

exit 0
