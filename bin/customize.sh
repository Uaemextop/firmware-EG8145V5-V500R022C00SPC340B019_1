#! /bin/sh
login_user=$(whoami)
if [ "$login_user" != "root" ]; then
	echo "Please switch to the su mode, then run customize command!"
	exit 0
fi

if [ -f /mnt/jffs2/hw_default_ctree.xml ];then
    chmod 660 /mnt/jffs2/hw_default_ctree.xml
fi
if [ -f /mnt/jffs2/hw_default_ctree2.xml ];then
    chmod 660 /mnt/jffs2/hw_default_ctree2.xml
fi
if [ -f /mnt/jffs2/hw_default_ctree3.xml ];then
    chmod 660 /mnt/jffs2/hw_default_ctree3.xml
fi

customize_exec.sh $*

if [ -f /mnt/jffs2/hw_default_ctree.xml ];then
    chmod 660 /mnt/jffs2/hw_default_ctree.xml
fi
if [ -f /mnt/jffs2/hw_default_ctree2.xml ];then
    chmod 660 /mnt/jffs2/hw_default_ctree2.xml
fi
if [ -f /mnt/jffs2/hw_default_ctree3.xml ];then
    chmod 660 /mnt/jffs2/hw_default_ctree3.xml
fi
