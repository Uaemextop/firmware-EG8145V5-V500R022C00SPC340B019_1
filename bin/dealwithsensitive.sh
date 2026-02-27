#!/bin/sh
#mac
sed -i 's/\<\(\([a-f0-9A-F*][a-f0-9A-F*][.-:]\)\{4\}\)[a-f0-9A-F*][a-f0-9A-F*][.-:][a-f0-9A-F*][a-f0-9A-F*]/\1**-**/g' /var/console.log
#ip
sed -i 's/\(\([0-9]\{1,3\}[.]\)\{2\}\)[0-9]\{1,3\}[.][0-9]\{1,3\}/\1*.*/g' /var/console.log
#ipv6
sed -i 's/\(\([0-9a-fA-F]\{4\}:\)\([0-9a-fA-F]\{0,4\}:\)\{2,\}\)[0-9a-fA-F]\{4\}:[0-9a-fA-F]\{4\}/\1*:*/g' /var/console.log