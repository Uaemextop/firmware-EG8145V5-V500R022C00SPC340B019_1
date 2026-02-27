#!/bin/sh
TTREEPATH=/etc/app
KEYPATH=/var/ttree_def/
ELE_PER_LINE=9 #ls -l 每行元素数量
MODE_LEN=10 # -rwxrwxr-x 长度

SrcTtree=/var/SrcTtree
DesTtree=/var/DesTtree

#解压spec和ttree
if [ -f /mnt/jffs2/ttree_spec_smooth.tar.gz ]; then
    mkdir /var/ttreeDef/
    smoothTtreeDef /mnt/jffs2/ttree_spec_smooth.tar.gz /var/ttree_spec_smooth.tar.gz
    if [ $? == 0 ]; then
        tar ozxf /var/ttree_spec_smooth.tar.gz -C /var/ttreeDef/
        if [ -d "/var/ttreeDef/ttree_def/`cat /etc/version`" ]; then
            if [ ! -d /mnt/jffs2/ttree_def_smooth/ ]; then
                mkdir /mnt/jffs2/ttree_def_smooth/
            fi
            cp /mnt/jffs2/ttree_spec_smooth.tar.gz /mnt/jffs2/ttree_def_smooth/`cat /etc/version`
        fi
        rm /var/ttree_spec_smooth.tar.gz
    fi
    rm /mnt/jffs2/ttree_spec_smooth.tar.gz
    rm /var/ttreeDef/ -rf
fi

if [ -e /mnt/jffs2/ttree_def_smooth/ ] && [ ! -h /mnt/jffs2/ttree_def_smooth/ ]; then
    ontchown 3008:2002 /mnt/jffs2/ttree_def_smooth/
    ontchown 3008:2002 /mnt/jffs2/ttree_def_smooth/*
fi

if [ -f "/mnt/jffs2/ttree_def_smooth/`cat /etc/version`" ];then
    smoothTtreeDef /mnt/jffs2/ttree_def_smooth/`cat /etc/version` /var/ttree_def_smooth.tar.gz
    if [ $? == 0 ]; then
        tar ozxf /var/ttree_def_smooth.tar.gz -C /var/
        rm /var/ttree_def_smooth.tar.gz
    fi
fi

# 装备模式临时调试用
if [ -f /mnt/jffs2/Equip.sh ] && [ -f /usr/bin/equip_single.sh ]; then
    exit
fi

if [ -f "/var/ttree_def/`cat /etc/version`/hw_ttree.bin.def" ];then
    ontchown 3008:2002 /var/ttree_def/`cat /etc/version`/hw_ttree.bin.def
    ontchmod 640 /var/ttree_def/`cat /etc/version`/hw_ttree.bin.def
fi

#修改权限流程
ls -l $(find ${TTREEPATH} -name *ttree.bin) > $SrcTtree
find ${KEYPATH} -name *ttree.bin.def > $DesTtree

function ch_ttree() {
    local mod_str=$1
    local target=$2
    local own_str=$3
    local group_str=$4
    local i=1
    local mod=0
    while [ $i -lt $MODE_LEN ]
        do
        rshift=$(((i-1)/3 * 4))
        case ${mod_str:i:1} in
            r) mod=$(($mod + (0x400>>$rshift) ));;
            w) mod=$(($mod + (0x200)>>$rshift));;
            x) mod=$(($mod + (0x100)>>$rshift));;
        esac
        let i+=1
    done

    chmod $(printf "%x" $mod) $target

    chown $own_str":"$group_str $target
}

while read desTreeLine;
do
    KEYSTR=${desTreeLine##*/}
    while read srcTtreeLine;
    do
    BINSTR=${srcTtreeLine##*/}
    if echo $KEYSTR | grep "$BINSTR" > /dev/null; then #if BINSTR is substring of KEYSTR
        mod_str=$(echo $srcTtreeLine | cut -d ' ' -f 1)
        own_str=$(echo $srcTtreeLine | cut -d ' ' -f 3)
        group_str=$(echo $srcTtreeLine | cut -d ' ' -f 4)
        ch_ttree $mod_str $desTreeLine $own_str $group_str
    fi
    done < $SrcTtree
done < $DesTtree

rm $SrcTtree $DesTtree