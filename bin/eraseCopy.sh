#! /bin/sh
 
mkdir -p /var/ER
for  file  in `ls /mnt/jffs2`
do
    if [ -f /mnt/jffs2/$file ] || [ -L /mnt/jffs2/file ]; then
        cp -pfd /mnt/jffs2/$file /var/ER
    fi
 
    if [ -d /mnt/jffs2/$file ]; then 
        if [ $file != "app" ] && [ $file != "apps" ] && [ $file != "plug" ] && [ $file != "sdk_mnt" ];then
            cp -prfd /mnt/jffs2/$file /var/ER
        fi
    fi
done
 
exit 0
