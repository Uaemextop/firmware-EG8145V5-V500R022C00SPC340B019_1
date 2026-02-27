#! /bin/sh

login_user=$(whoami)

if [ "$login_user" != "root" ]; then
    echo "exit login_user : $login_user"
	exit 0
fi

rm -rf /var/spec/
mkdir /var/spec/
cp -rf /etc/wap/spec/encrypt_spec/* /var/spec/
if [ -f /var/ttree_def/`cat /etc/version`/encrypt_spec_key.tar.gz ] && [ ! -h /var/ttree_def/`cat /etc/version`/encrypt_spec_key.tar.gz ]; then
    #修改目标文件权限
    ontchmod 400 /var/ttree_def/`cat /etc/version`/encrypt_spec_key.tar.gz
    ontchown 0:0 /var/ttree_def/`cat /etc/version`/encrypt_spec_key.tar.gz
    cp /var/ttree_def/`cat /etc/version`/encrypt_spec_key.tar.gz /var/spec/encrypt_spec_key.tar.gz 
    aescrypt2 1 /var/spec/encrypt_spec_key.tar.gz  /var/spec/encrypt_spec_key.tar.gz".bak"
    cd /var/spec/
    tar ozxf encrypt_spec_key.tar.gz 
    rm encrypt_spec_key.tar.gz 
else
    if [ -f /mnt/jffs2/encrypt_spec_key.tar.gz ] && [ ! -h /mnt/jffs2/encrypt_spec_key.tar.gz ]; then
        cp /mnt/jffs2/encrypt_spec_key.tar.gz /var/spec/encrypt_spec_key.tar.gz 
        aescrypt2 1 /var/spec/encrypt_spec_key.tar.gz  /var/spec/encrypt_spec_key.tar.gz".bak"
        cd /var/spec/
        tar ozxf encrypt_spec_key.tar.gz 
        rm encrypt_spec_key.tar.gz 
    fi
fi

aescrypt2 1 /var/spec/encrypt_spec.tar.gz /var/spec/encrypt_spec.tar.gz".bak"
cd /var/spec/
tar ozxf encrypt_spec.tar.gz
rm encrypt_spec.tar.gz
cd - > /dev/null

