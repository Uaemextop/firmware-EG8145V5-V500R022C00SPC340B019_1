#! /bin/sh

FILE_BOARTYPE=/mnt/jffs2/board_type
FILE_BOARDTYPE_CLASS=/var/productclass.cfg

GetSupportType()
{
	var_board_name=""
	if [ -f $FILE_BOARDTYPE_CLASS ]
	then 
		while read line;
		do
			board_type=`echo $line | sed 's/product="\(.*\)";\(.*\)/\1/g'`
			var_board_name=$var_board_name" "$board_type
		done < $FILE_BOARDTYPE_CLASS
	fi
	echo "support boardtype:" 
	echo "   "$var_board_name
}

PrintHelp()
{
	echo "boardtype.sh Usage:"
	echo "    -s to set custom boardtype."
	echo "    -g to get custom boardtype."
	echo "    -c to clean custom boardtype."
	echo "Example:"
	echo "    boardtype.sh -s HG8240R"
	echo "    boardtype.sh -g"
	echo "    boardtype.sh -c"
	GetSupportType
}

var_boardtype=0
var_boardid=0
var_pcbid=0
var_temp=`cat /var/board_cfg.txt | grep board_id|cut -d ';' -f 3|grep -oE "HWSOC.*|RTL.*|SD51.*"`

GetTypeByName_5117()
{		
    case $1  in	
	
	#5117H系列CA8011V
	CA8011V )
		if [ "$var_boardid" = "7" ];then
		      var_boardtype=10071
		fi
		;;
	#HWSOC1
	HS8346V5 )
		if [ "$var_boardid" = "32" ];then
		      var_boardtype=13321
		fi
	    if [ "$var_boardid" = "39" ];then
		      var_boardtype=13391
		fi
	    if [ "$var_boardid" = "41" ];then
		      var_boardtype=13411
		fi
        if [ "$var_boardid" = "65" ];then
		      var_boardtype=13651
		fi
		if [ "$var_boardid" = "46" ];then
			  var_boardtype=13461
		fi
		if [ "$var_boardid" = "122" ];then
			  var_boardtype=131221
		fi
		;;
	HG8145V5 )
	    if [ "$var_boardid" = "41" ];then
		      var_boardtype=13413
		fi
		if [ "$var_boardid" = "65" ];then
		      var_boardtype=13653
		fi
		if [ "$var_boardid" = "69" ];then
		      var_boardtype=13696
		fi
		if [ "$var_boardid" = "126" ];then
		      var_boardtype=131264
		fi
		if [ "$var_boardid" = "125" ];then
		      var_boardtype=131251
		fi
		;;
	999#HG8145V5 )
	    if [ "$var_boardid" = "89" ];then
		      var_boardtype=131259
		fi
		;;
	TELMEX_HG8145V5 )
		if [ "$var_boardid" = "126" ];then
		      var_boardtype=131262
		fi
		;;
	HG8145V5V2 )
	    if [ "$var_boardid" = "125" ];then
		      var_boardtype=131257
		fi
	    if [ "$var_boardid" = "64" ];then
		      var_boardtype=13643
		fi
		;;
	# HWSOC1
	999#HS8346V5 )
		if [ "$var_boardid" = "41" ];then
			var_boardtype=13412
		fi
		if [ "$var_boardid" = "65" ];then
			var_boardtype=13652
		fi
		;;	
	HG8145V5-20 )
		if [ "$var_boardid" = "37" ];then
		      var_boardtype=13372
		fi
		if [ "$var_boardid" = "126" ];then
		      var_boardtype=131263
		fi
		if [ "$var_boardid" = "69" ];then
		      var_boardtype=13695
		fi
		if [ "$var_boardid" = "125" ];then
		      var_boardtype=131255
		fi
		;;
	HG8140H5 )
		if [ "$var_boardid" = "5" ];then
		      var_boardtype=13052
		fi
		;;
	EG8140H5 )
		if [ "$var_boardid" = "5" ];then
		      var_boardtype=13053
		fi
		;;
	EG8245H5 )
		if [ "$var_boardid" = "1" ];then
		      var_boardtype=13011
		fi
		;;
	HG8245H5 )
		if [ "$var_boardid" = "1" ];then
		      var_boardtype=13012
		fi
		;;
	HG8245H6 )
		if [ "$var_boardid" = "1" ];then
		      var_boardtype=13013
		fi
		;;
	EG8247H5 )
		if [ "$var_boardid" = "2" ];then
		      var_boardtype=13021
		fi
		;;
    HG8240T5 )
		if [ "$var_boardid" = "3" ];then
		      var_boardtype=13031
		fi
		;;
	EG8240H5 )
		if [ "$var_boardid" = "3" ];then
		      var_boardtype=13032
		fi
		;;	
    HG8245Q5 )
		if [ "$var_boardid" = "33" ];then
		      var_boardtype=13331
		fi
		;;
	HG8247Q5 )
		if [ "$var_boardid" = "34" ];then
		      var_boardtype=13341
		fi
		;;
	EG8145V5 )
		if [ "$var_boardid" = "35" ];then
		      var_boardtype=13351
		fi
                if [ "$var_boardid" = "37" ];then
		      var_boardtype=13371
		fi
		if [ "$var_boardid" = "69" ];then
		      var_boardtype=13691
		fi
		if [ "$var_boardid" = "70" ];then
		      var_boardtype=13701
		fi
		if [ "$var_boardid" = "126" ];then
		      var_boardtype=131261
		fi
		if [ "$var_boardid" = "125" ];then
		      var_boardtype=131361
		fi
		if [ "$var_boardid" = "66" ];then
		      var_boardtype=131364
		fi
		;;
	EG8145V5-V2 )
		if [ "$var_boardid" = "66" ];then
		      var_boardtype=131363
		fi
		;;
	HG8145V5-V2 )
		if [ "$var_boardid" = "125" ];then
		      var_boardtype=131256
		fi
		;;
	HG8145V5-PRO )
		if [ "$var_boardid" = "69" ];then
		      var_boardtype=13692
		fi
		if [ "$var_boardid" = "37" ];then
		var_boardtype=13374
		fi
		;;
	HS8145V5 )
		if [ "$var_boardid" = "36" ];then
		      var_boardtype=13361
		fi
	    if [ "$var_boardid" = "40" ];then
		      var_boardtype=13401
		fi
		if [ "$var_boardid" = "42" ];then
		      var_boardtype=13421
		fi
        if [ "$var_boardid" = "68" ];then
		      var_boardtype=13681
		fi
		if [ "$var_boardid" = "37" ];then
		      var_boardtype=13373
		fi
		if [ "$var_boardid" = "69" ];then
		      var_boardtype=13693
		fi
		;;
	HS8145V6 )
		if [ "$var_boardid" = "68" ];then
		      var_boardtype=13682
		fi
		;;
	HS8145X6 )
		if [ "$var_boardid" = "98" ];then
		      var_boardtype=13985
		fi
		;;
    EG8040H5 )
		if [ "$var_boardid" = "4" ];then
		      var_boardtype=13041
		fi
		;;
    HG8040H6 )
		if [ "$var_boardid" = "4" ];then
		      var_boardtype=13014
		fi
		;;
	EG8040C )
		if [ "$var_boardid" = "4" ];then
		      var_boardtype=13042
		fi
		;;
	EG8040C-S )
		if [ "$var_boardid" = "4" ];then
		      var_boardtype=13043
		fi
		;;
	RT-GM-2 )
		if [ "$var_boardid" = "67" ];then
		      var_boardtype=13671
		fi
		;;
	EG8245W5-6T )
		if [ "$var_boardid" = "67" ];then
		      var_boardtype=13673
		fi
		;;
	WA8021V5-PRO )
		if [ "$var_boardid" = "109" ];then
		      var_boardtype=131091
		fi
		;;
	EG8145X6 )
		if [ "$var_boardid" = "99" ];then
		      var_boardtype=13991
		fi
		if [ "$var_boardid" = "98" ];then
		      var_boardtype=13993
		fi
		;;
	EG8147X6 )
		if [ "$var_boardid" = "117" ];then
		      var_boardtype=131171
		fi
		if [ "$var_boardid" = "68" ];then
		      var_boardtype=131173
		fi
		;;
	T623 )
		if [ "$var_boardid" = "117" ];then
		      var_boardtype=131172
		fi
		;;
	A623 )
		if [ "$var_boardid" = "112" ];then
		      var_boardtype=131121
		fi
		;;
	HG8045X6-10 )
		if [ "$var_boardid" = "72" ];then
		      var_boardtype=13722
		fi
		;;
	EG8145X6-10 )
		if [ "$var_boardid" = "72" ];then
		      var_boardtype=13721
		fi
		;;
	HG8145X6-10 )
		if [ "$var_boardid" = "72" ];then
		      var_boardtype=13723
		fi
		;;
	999#HG8145X6-10 )
		if [ "$var_boardid" = "72" ];then
		      var_boardtype=13725
		fi
		;;
	998#HG8145X6-10 )
		if [ "$var_boardid" = "72" ];then
		      var_boardtype=13726
		fi
		;;
	HG8145X6-12 )
		if [ "$var_boardid" = "36" ];then
		      var_boardtype=13365
		fi
		;;
	HG8245X6-10 )
		if [ "$var_boardid" = "64" ];then
		      var_boardtype=13642
		fi
		;;
	999#HG8245X6-10 )
		if [ "$var_boardid" = "64" ];then
		      var_boardtype=13641
		fi
		;;
    SGP100B )
        if [ "$var_boardid" = "4" ];then
              var_boardtype=13044
        fi
        ;;
    HG8041X6 )
        if [ "$var_boardid" = "66" ];then
              var_boardtype=13662
        fi
        ;;
	HG8045W5-6T )
		if [ "$var_boardid" = "67" ];then
		      var_boardtype=13675
		fi
		;;
    F600D-30-4G1V )
        if [ "$var_boardid" = "99" ];then
            var_boardtype=13992
        fi
        ;;
	#HWSOC2
	HS8145C5 )
		if [ "$var_boardid" = "1" ];then
		      var_boardtype=15011
		fi
		if [ "$var_boardid" = "2" ];then
		      var_boardtype=12021
		fi
	    if [ "$var_boardid" = "6" ];then
		      var_boardtype=12061
		fi
		;;
	HG8040F5 )
		if [ "$var_boardid" = "0" ];then
		      var_boardtype=15004
		fi
		;;
	EG8040F5-S )
		if [ "$var_boardid" = "0" ];then
		      var_boardtype=15007
		fi
		;;		
	HG8120L5 )
		if [ "$var_boardid" = "0" ];then
		      var_boardtype=15005
		fi
		;;
	HG8245Hv5 )
		if [ "$var_boardid" = "10" ];then
		      var_boardtype=12101
		fi
		;;
    EG8141A5 )
		if [ "$var_boardid" = "10" ];then
		      var_boardtype=12102
		fi
		if [ "$var_boardid" = "4" ];then
		      var_boardtype=15047
		fi
		;;
	HG8141A5 )
		if [ "$var_boardid" = "4" ];then
		      var_boardtype=15048
		fi
		;;
	#HWSOC2
	HS8545M5 )
		if [ "$var_boardid" = "0" ];then
		      var_boardtype=15001
		fi
		if [ "$var_boardid" = "2" ];then
		      var_boardtype=15022
		fi
		if [ "$var_boardid" = "3" ];then
		      var_boardtype=15032
		fi
		;;
	EG8012H5 )
		if [ "$var_boardid" = "3" ];then
			  var_boardtype=15031
		fi
		;;
	EG6145A5 )
		if [ "$var_boardid" = "0" ];then
		      var_boardtype=15003
		fi
		;;
	EG8143A5 )
		if [ "$var_boardid" = "2" ];then
			  var_boardtype=15026
		fi
		;;
	HG8010Hv6 )
		if [ "$var_boardid" = "1" ];then
			  var_boardtype=15013
		fi
		;;
    EG8010Hv6 )
        if [ "$var_boardid" = "1" ];then
              var_boardtype=15014
        fi
        ;;
    F100P-1G1V )
        if [ "$var_boardid" = "0" ];then
              var_boardtype=15006
        fi
        ;;
    #HWSOC1
	HS8546X6 )
		if [ "$var_boardid" = "98" ];then
			  var_boardtype=13984
		fi
		if [ "$var_boardid" = "76" ];then
			  var_boardtype=13765
		fi
		if [ "$var_boardid" = "79" ];then
			  var_boardtype=13796
		fi
		;;
	HS8546X6-10 )
		if [ "$var_boardid" = "66" ];then
			  var_boardtype=13661
		fi
		;;
	HS8546X6-50 )
		if [ "$var_boardid" = "67" ];then
			  var_boardtype=13678
		fi
		;;
	HG8043X6-10 )
		if [ "$var_boardid" = "74" ];then
			  var_boardtype=13741
		fi
		;;
	EG8147X6-10 )
		if [ "$var_boardid" = "74" ];then
			  var_boardtype=13742
		fi
		;;
	W616E-D )
		if [ "$var_boardid" = "119" ];then
			  var_boardtype=131191
		fi
		;;
	#HWSOC3
	Game-RT-X )
		if [ "$var_boardid" = "11" ];then
			  var_boardtype=14111
		fi
		;;
	K654p )
		if [ "$var_boardid" = "11" ];then
		      var_boardtype=14112
		fi
		;;
    HG8245W5-6T-V1 )
        if [ "$var_boardid" = "67" ];then 
            var_boardtype=13674 
        fi
        ;;
    HG8245W5-6T-12 )
        if [ "$var_boardid" = "67" ];then 
            var_boardtype=13676
        fi
        ;;
    EG8245W5-8T )
        if [ "$var_boardid" = "11" ];then
            var_boardtype=14113
        fi
        ;;
	HG8546M5 )
		if [ "$var_boardid" = "0" ];then
		      var_boardtype=15002
		fi
		;;
	HG8245X6 )
		if [ "$var_boardid" = "29" ];then
		      var_boardtype=14295
		fi
		;;
	999#HG8245X6 )
		if [ "$var_boardid" = "29" ];then
		      var_boardtype=14294
		fi
		;;
	K662R )
		if [ "$var_boardid" = "106" ];then
		      var_boardtype=131061
		fi
		;;
	K662c )
		if [ "$var_boardid" = "131061" ];then
		      var_boardtype=106
		fi
		if [ "$var_boardid" = "114" ];then
		      var_boardtype=131143
		fi
		;;
	K662m )
		if [ "$var_boardid" = "114" ];then
		      var_boardtype=131141
		fi
		if [ "$var_boardid" = "115" ];then
		      var_boardtype=131151
		fi
		;;
	K662u )
		if [ "$var_boardid" = "114" ];then
		      var_boardtype=131142
		fi
		if [ "$var_boardid" = "115" ];then
		      var_boardtype=131152
		fi
		;;
	F600C-30-1GH )
		if [ "$var_boardid" = "32" ];then 
			var_boardtype=13322
		fi
		;;
	F600P-30-1GH )
		if [ "$var_boardid" = "65" ];then 
			var_boardtype=13654
		fi
		;;
	B671G-1E3W )
		if [ "$var_boardid" = "32" ];then 
			var_boardtype=13323
		fi
		;;
	F200D-4G-L )
		if [ "$var_boardid" = "4" ];then 
			var_boardtype=13045
		fi
		;;
	F100D-4G )
		if [ "$var_boardid" = "4" ];then 
			var_boardtype=13046
		fi
		;;
	esac

	return $var_boardtype
}

GetTypeByName_5118()
{		
    case $1  in	
	
	#5118V2系列HN8541M
	HN8541M )
		if [ "$var_boardid" = "50" ];then
		      var_boardtype=11181
		fi
		;;
	HN8140 )
		if [ "$var_boardid" = "50" ];then
		      var_boardtype=11502
		fi
		;;
	HN8255Ws )		
		var_boardtype=11201
		;;
	MA5875-8E8P )
		if [ "$var_boardid" = "12" ];then
		      var_boardtype=11121
		fi
		;;
	esac

	return $var_boardtype
}
GetTypeByName_5182()
{
	case $1  in
	#HWSOC4
	HN8546V5 )
		if [ "$var_boardid" = "8" ];then
		      var_boardtype=81
		fi
		if [ "$var_boardid" = "40" ];then
		      var_boardtype=401
		fi
		;;
	P622EF )
		if [ "$var_boardid" = "15" ];then 
			  var_boardtype=603 
		fi
		;;
	EG8141XR-10 )
		if [ "$var_boardid" = "6" ];then 
			  var_boardtype=16061
		fi
		;;
	HG8141XR-10 )
		if [ "$var_boardid" = "22" ];then 
			  var_boardtype=16221
		fi
		;;
	B610-4E )
		if [ "$var_boardid" = "7" ];then 
			  var_boardtype=71 
		fi
		;;
	P502E )
		if [ "$var_boardid" = "1" ];then
			  var_boardtype=16011
		fi
		;;
	P603E )
		if [ "$var_boardid" = "23" ];then
			  var_boardtype=16231
		fi
		;;
	P603E-S )
		if [ "$var_boardid" = "23" ];then
			  var_boardtype=16232
		fi
		;;
	P613E-S )
		if [ "$var_boardid" = "23" ];then
			  var_boardtype=16233
		fi
		;;
	P612E-S )
		if [ "$var_boardid" = "19" ];then
			  var_boardtype=16191
		fi
		;;
	HN8546X6-30 )
		if [ "$var_boardid" = "25" ];then
			  var_boardtype=16251
		fi
		;;
	HN8546X6-20 )
		if [ "$var_boardid" = "45" ];then
			  var_boardtype=16451
		fi
		;;
	HN8546X6-60 )
		if [ "$var_boardid" = "45" ];then
			  var_boardtype=16452
		fi
		;;
	HN8546X6 )
		if [ "$var_boardid" = "46" ];then 
			  var_boardtype=461 
		fi
		if [ "$var_boardid" = "54" ];then 
			  var_boardtype=542
		fi
		if [ "$var_boardid" = "82" ];then 
			  var_boardtype=823
		fi
		;;
	HN8145X6 )
		if [ "$var_boardid" = "46" ];then 
			  var_boardtype=462 
		fi
		;;
	P803E )
		if [ "$var_boardid" = "9" ];then 
			  var_boardtype=16091 
		fi
		;;
	V854-C3 )
		if [ "$var_boardid" = "34" ];then 
			  var_boardtype=342
		fi
		;;
	EN8145X6 )
		if [ "$var_boardid" = "70" ];then 
			  var_boardtype=16701
		fi
		;;
	T620W-90 )
		if [ "$var_boardid" = "1271" ];then 
			  var_boardtype=162471 
		fi
		;;
	V662m )
		if [ "$var_boardid" = "110" ];then 
			  var_boardtype=161102 
		fi
        if [ "$var_boardid" = "18" ];then  
              var_boardtype=16181
        fi
		;;
	V662u-C )
		if [ "$var_boardid" = "18" ];then 
			  var_boardtype=16182
		fi
		;;
	V862m )
		if [ "$var_boardid" = "42" ];then 
			  var_boardtype=16422 
		fi
		if [ "$var_boardid" = "26" ];then 
			  var_boardtype=16261 
		fi
		;;
	EG8245X6-8N )
		if [ "$var_boardid" = "98" ];then 
			  var_boardtype=16982
		fi
		;;
	HG8247X6-8N-10 )
		if [ "$var_boardid" = "98" ];then 
			  var_boardtype=16983
		fi
		;;
    P613E-2 )
        if [ "$var_boardid" = "1219" ];then 
            var_boardtype=1612191
        fi
        if [ "$var_boardid" = "1389" ];then
            var_boardtype=1613891
        fi
        ;;
    F200D-4G )
        if [ "$var_boardid" = "7" ];then 
            var_boardtype=16071
        fi
        ;;
    F100P-2G )
        if [ "$var_boardid" = "1086" ];then 
            var_boardtype=1610861
        fi
        ;;
    B610-4E4D )
        if [ "$var_boardid" = "1223" ];then 
            var_boardtype=1612231
        fi
        ;;
	#HWSOC5
	MA5671B )
		if [ "$var_boardid" = "0" ];then 
			  var_boardtype=2001 
		fi
		;;
	C610L )
		if [ "$var_boardid" = "61" ];then 
			  var_boardtype=16611 
		fi
		;;
	V852R-m1 )
		if [ "$var_boardid" = "44" ];then 
			  var_boardtype=16441 
		fi
		;;
	S800E-M )
		if [ "$var_boardid" = "1" ];then 
			  var_boardtype=2014 
		fi
		;;
	HN8010Ts )
		if [ "$var_boardid" = "2" ];then 
			  var_boardtype=17021 
		fi
		;;
    B850-8E8P3W2 )
		if [ "$var_boardid" = "1024" ];then 
			  var_boardtype=1610241
		fi
		;;
	MA5621E-AC )
		if [ "$var_boardid" = "1089" ];then 
			  var_boardtype=1610891
		fi
		;;
	EN8010Ts-20 )
		if [ "$var_boardid" = "10" ];then 
			  var_boardtype=2101
		fi
		;;
	HN8012Ts-20 )
		if [ "$var_boardid" = "10" ];then 
			  var_boardtype=2102
		fi
		;;
	EN8012Ts-20 )
		if [ "$var_boardid" = "10" ];then 
			  var_boardtype=2103
		fi
		;;
	esac

	return $var_boardtype
}

GetTypeByName_rtl960xx()
{
	case $1  in
	#RTL9603C系列
	HS8545M5 )
		if [ "$var_boardid" = "1" ];then
		      var_boardtype=4013
		fi
		;;
	HS8545M5-10 )
		if [ "$var_boardid" = "1" ];then
		      var_boardtype=4014
		fi
		;;
	HS8346R5-C )
		if [ "$var_boardid" = "1" ];then
			  var_boardtype=40111
		fi
		;;
	EG8010Hv6-20 )
		if [ "$var_boardid" = "2" ];then
			  var_boardtype=4021
		fi
		;;
	#RTL9607C系列
	HS8346V5 )
		if [ "$var_boardid" = "0" ];then
			  var_boardtype=3014
		fi
		;;
	HS8546V5-10 )
		if [ "$var_boardid" = "0" ];then
			  var_boardtype=3005
		fi
		;;
	HS8346V5-C )
		if [ "$var_boardid" = "0" ];then
			  var_boardtype=30111
		fi
		;;
	esac

	return $var_boardtype
}

GetTypeByName_rtl961xx()
{
	case $1  in
	#RTL9617C系列
	HN8145X6 )
		if [ "$var_boardid" = "5" ];then
		      var_boardtype=5051
		fi
		;;
	HN8346X6-C )
		if [ "$var_boardid" = "6" ];then
		      var_boardtype=5061
		fi
		;;

	esac

	return $var_boardtype
}

GetTypeByName()
{
    if [ $var_temp == SD5116H -o $var_temp == SD5116S -o $var_temp == SD5116L -o $var_temp == SD5116T -o $var_temp == SD5116T_PLUS ]
    then
        GetTypeByName_5116 $1
    elif [ $var_temp == SD5117H -o $var_temp == HWSOC1 -o $var_temp == SD5117M -o $var_temp == HWSOC2 -o $var_temp == HWSOC3 -o $var_temp == HWSOC6 ];then
        GetTypeByName_5117 $1
    elif [ $var_temp == SD5118 -o $var_temp == SD5118V2 ];then
        GetTypeByName_5118 $1
    elif [ $var_temp == HWSOC4 -o $var_temp == HWSOC5 -o $var_temp == HWSOC7 -o $var_temp == HWSOC9 ];then
        GetTypeByName_5182 $1
    elif [ $var_temp == RTL9603C -o $var_temp == RTL9607C ];then
        GetTypeByName_rtl960xx $1
    elif [ $var_temp == HWSOC33 ];then
        GetTypeByName_rtl961xx $1
    else
        GetTypeByName_5115 $1
    fi

    return $var_boardtype
}

EchoNameByBoardtype_5117()
{		
    case $1  in	

	10071 )		
		var_boardname=CA8011V
		;;	
	13321 )		
		var_boardname=HS8346V5
		;;
	13372 )		
		var_boardname=HG8145V5-20
		;;
	131263 )
		var_boardname=HG8145V5-20
		;;
	13695 )
		var_boardname=HG8145V5-20
		;;	
	131255 )
		var_boardname=HG8145V5-20
		;;
	13011 )		
		var_boardname=EG8245H5
		;;	
	13052 )
		var_boardname=HG8140H5
		;;
	13053 )
		var_boardname=EG8140H5
		;;
	13012 )		
		var_boardname=HG8245H5
		;;
	13013 )
		var_boardname=HG8245H6
		;;
	13021 )		
		var_boardname=EG8247H5
		;;
	13031 )		
		var_boardname=HG8240T5
		;;    
    13032 )		
		var_boardname=EG8240H5
		;;   		
    13331 )		
		var_boardname=HG8245Q5
		;;	
	13341 )		
		var_boardname=HG8247Q5
		;;
	13351 )		
		var_boardname=EG8145V5
		;;
	13371 )		
		var_boardname=EG8145V5
		;;
	13691 )		
		var_boardname=EG8145V5
		;;
	13692 )		
		var_boardname=HG8145V5-PRO
		;;
	13374 )		
		var_boardname=HG8145V5-PRO
		;;
	13701 )		
		var_boardname=EG8145V5
		;;
	131261 )
		var_boardname=EG8145V5
		;;
	131361 )
		var_boardname=EG8145V5
		;;
	131364 )
		var_boardname=EG8145V5
		;;
	131363 )
		var_boardname=EG8145V5-V2
		;;
	131256 )
		var_boardname=HG8145V5-V2
		;;
	13391 )		
		var_boardname=HS8346V5
		;;	
	13411 )		
		var_boardname=HS8346V5
		;;	
	13651 | 13461 )		
		var_boardname=HS8346V5
		;;	
	13412 )		
		var_boardname=999#HS8346V5
		;;	
	13652 )		
		var_boardname=999#HS8346V5
		;;
	13361 )		
		var_boardname=HS8145V5
		;;
	13401 )		
		var_boardname=HS8145V5
		;;	
	13421 )		
		var_boardname=HS8145V5
		;;	
	13681 )		
		var_boardname=HS8145V5
		;;	
	13373 )
		var_boardname=HS8145V5
		;;
	13693 )
		var_boardname=HS8145V5
		;;
	13682 )
		var_boardname=HS8145V6
		;;
	13985 )
		var_boardname=HS8145X6
		;;
	12021 )		
		var_boardname=HS8145C5
		;;	
	12061 )		
		var_boardname=HS8145C5
		;;
	15011 )		
		var_boardname=HS8145C5
		;;
	15004 )		
		var_boardname=HG8040F5
		;;	
	15005 )		
		var_boardname=HG8120L5
		;;		
	15007 )
		var_boardname=EG8040F5-S
		;;
	12101 )		
		var_boardname=HG8245Hv5
		;;		
    12102 )		
		var_boardname=EG8141A5
		;;	
    15047 )
		var_boardname=EG8141A5
		;;
    15048 )
		var_boardname=HG8141A5
		;;
    13041 )
		var_boardname=EG8040H5
		;;
    13014 )
		var_boardname=HG8040H6
		;;
	13042 )
		var_boardname=EG8040C
		;;
	13043 )
		var_boardname=EG8040C-S
		;;
	15001 )
		var_boardname=HS8545M5
		;;
	15003 )
		var_boardname=EG6145A5
		;;
	15026 )
		var_boardname=EG8143A5
		;;
	15013 )
		var_boardname=HG8010Hv6
		;;
    15014 )
        var_boardname=EG8010Hv6
        ;;
	15032 )
		var_boardname=HS8545M5
		;;
    13984 | 13765 | 13796 )
		var_boardname=HS8546X6
		;;
	13661 )
		var_boardname=HS8546X6-10
		;;
	13678 )
		var_boardname=HS8546X6-50
		;;
	13741 )
		var_boardname=HG8043X6-10
		;;
	13742 )
		var_boardname=EG8147X6-10
		;;
	131191 )
		var_boardname=W616E-D
		;;
	13671 )
		var_boardname=RT-GM-2
		;;
	13673 )
		var_boardname=EG8245W5-6T
		;;
    13674 )
		var_boardname=HG8245W5-6T-V1
		;;
    13676 )
		var_boardname=HG8245W5-6T-12
		;;
	13675 )
		var_boardname=HG8045W5-6T
		;;
	14111 )
		var_boardname=Game-RT-X
		;;
	14112 )
		var_boardname=K654p
		;;	
    15022 )
        var_boardname=HS8545M5
        ;;
    14113 )
        var_boardname=EG8245W5-8T
        ;;
	131091 )		
		var_boardname=WA8021V5-PRO
		;;
	13991 )
		var_boardname=EG8145X6
		;;
	13993 )
		var_boardname=EG8145X6
		;;
	131171 )		
		var_boardname=EG8147X6
		;;
	131173 )
		var_boardname=EG8147X6
		;;
	131172 )		
		var_boardname=T623
		;;
    131121 )
        var_boardname=A623
        ;;
	13641 )
		var_boardname=999#HG8245X6-10
		;;
	13642 )
		var_boardname=HG8245X6-10
		;;
	13722 )
		var_boardname=HG8045X6-10
		;;
	13721 )
		var_boardname=EG8145X6-10
		;;
	13723 )
		var_boardname=HG8145X6-10
		;;
	13725 )
		var_boardname=999#HG8145X6-10
		;;
	13726 )
		var_boardname=998#HG8145X6-10
		;;
	13365 )
		var_boardname=HG8145X6-12
		;;
	15002 )
		var_boardname=HG8546M5
		;;
	15031 )
		var_boardname=EG8012H5
		;;
	14294 )
		var_boardname=999#HG8245X6
		;;
	14295 )
		var_boardname=HG8245X6
		;;
	106 | 131143 )
		var_boardname=K662c
		;;
	131061 )
		var_boardname=K662R
		;;
	131141 | 131151 )
		var_boardname=K662m
		;;
	131142 | 131152 )
		var_boardname=K662u
		;;
	131221 )
		var_boardname=HS8346V5
		;;
	13413 )
		var_boardname=HG8145V5
		;;
	13653 )
		var_boardname=HG8145V5
		;;
	13696 )
		var_boardname=HG8145V5
		;;
	131262 )
		var_boardname=TELMEX_HG8145V5
		;;
	131264 )
		var_boardname=HG8145V5
		;;
	13044 )
		var_boardname=SGP100B
		;;
	131251 )
		var_boardname=HG8145V5
		;;
	131259 )
		var_boardname=999#HG8145V5
		;;
	13662 )
		var_boardname=HG8041X6
		;;
	131257 | 13643 )
		var_boardname=HG8145V5V2
		;;
	13654 )
		var_boardname=F600P-30-1GH
		;;
	13322 )
		var_boardname=F600C-30-1GH
		;;
	13323 )
		var_boardname=B671G-1E3W
		;;
	13992 )
		var_boardname=F600D-30-4G1V
		;;
	15006 )
		var_boardname=F100P-1G1V
		;;
	13045 )
		var_boardname=F200D-4G-L
		;;
	13046 )
		var_boardname=F100D-4G
		;;
	esac

	echo "custom board name is $var_boardname"
}

EchoNameByBoardtype_5118()
{		
    case $1  in	
	
	#5118V2系列HN8541M
	11181 )		
		var_boardname=HN8541M
		;;
	11502 )		
		var_boardname=HN8140
		;;
	11201 )		
		var_boardname=HN8255Ws
		;;
	11121 )		
		var_boardname=MA5875-8E8P
		;;
	esac
	echo "custom board name is $var_boardname"
}

EchoNameByBoardtype_5182()
{		
    case $1 in
	81 )
		var_boardname=HN8546V5
		;;
	401 )
		var_boardname=HN8546V5
		;;
	603 )
		var_boardname=P622EF
		;;
	16221 )
		var_boardname=HG8141XR-10
		;;
	71 )
		var_boardname=B610-4E
		;;
	16011 )
		var_boardname=P502E
		;;
	16061 )
		var_boardname=EG8141XR-10
		;;
	16231 )
		var_boardname=P603E
		;;
	16232 )
		var_boardname=P603E-S
		;;
	16233 )
		var_boardname=P613E-S
		;;
	16191 )
		var_boardname=P612E-S
		;;
	461 | 542 | 823)
		var_boardname=HN8546X6
		;;
	462 )
		var_boardname=HN8146X6
		;;
	16091 )
		var_boardname=P803E
		;;
	342 )
		var_boardname=V854-C3
		;;
	16701 )
		var_boardname=EN8145X6
		;;
	2001 )
		var_boardname=MA5671B
		;;
	17021 )
		var_boardname=HN8010Ts
		;;
	162471 )
		var_boardname=T620W-90
		;;
	161102 )
		var_boardname=V662m
		;;
	16181 )
		var_boardname=V662m
		;;
	2101 )
		var_boardname=EN8010Ts-20
		;;
	2102 )
		var_boardname=HN8012Ts-20
		;;
	2103 )
		var_boardname=EN8012Ts-20
		;;
	16182 )
		var_boardname=V662u-C
		;;
	16422  )
		var_boardname=V862m
		;;
	16261  )
		var_boardname=V862m
		;;
	16611 )
		var_boardname=C610L
		;;
	16982 )
		var_boardname=EG8245X6-8N
		;;
	16441 )
		var_boardname=V852R-m1
		;;
	2014 )
		var_boardname=S800E-M
		;;
    1612191 | 1613891)
        var_boardname=P613E-2
        ;;
    1610241 )
        var_boardname=B850-8E8P3W2
        ;;
    1610891 )
        var_boardname=MA5621E-AC
        ;;
    16071 )
        var_boardname=F200D-4G
        ;;
    1610861 )
        var_boardname=F100P-2G
        ;;
    1612231 )
        var_boardname=B610-4E4D
        ;;
    16251 )
        var_boardname=HN8346X6-1
        ;;
    16451 )
        var_boardname=HN8546X6-20
        ;;
    16452 )
        var_boardname=HN8546X6-60
        ;;
	esac
	echo "custom board name is $var_boardname"
}

EchoNameByBoardtype_rtl960xx()
{
    case $1 in
	#RTL9603C系列
	4013 )
		var_boardname=HS8545M5
		;;
	4014 )
		var_boardname=HS8545M5-10
		;;
	40111 )
		var_boardname=HS8346R5-C
		;;
	4021 )
		var_boardname=EG8010Hv6-20
		;;
	#RTL9607C系列
	3014 )
		var_boardname=HS8346V5
		;;
	3005 )
		var_boardname=HS8546V5-10
		;;
	30111 )
		var_boardname=HS8346V5-C
		;;
	esac
	echo "custom board name is $var_boardname"
}

EchoNameByBoardtype_rtl961xx()
{
    case $1 in
	#RTL9617C系列
	5051 )
		var_boardname=HN8145X6
		;;
	5061 )
		var_boardname=HN8346X6-C
		;;
	esac
	echo "custom board name is $var_boardname"
}

EchoNameByBoardtype()
{
    if [ $var_temp == SD5116H -o $var_temp == SD5116S -o $var_temp == SD5116L -o $var_temp == SD5116T -o $var_temp == SD5116T_PLUS ]
    then
        EchoNameByBoardtype_5116 $1
        echo "EchoNameByBoardtype_5116 $1"
    elif [ $var_temp == SD5117H -o $var_temp == HWSOC1 -o $var_temp == SD5117M -o $var_temp == HWSOC2 -o $var_temp == HWSOC3 -o $var_temp == HWSOC6 ];then
        EchoNameByBoardtype_5117 $1
        echo "EchoNameByBoardtype_5117 $1"
    elif [ $var_temp == SD5118 -o $var_temp == SD5118V2 ];then
        EchoNameByBoardtype_5118 $1
        echo "EchoNameByBoardtype_5118 $1"
    elif [ $var_temp == HWSOC4 -o $var_temp == HWSOC5 -o $var_temp == HWSOC7 -o $var_temp == HWSOC9 ];then
        EchoNameByBoardtype_5182 $1
        echo "EchoNameByBoardtype_5182 $1"
    elif [ $var_temp == RTL9603C -o $var_temp == RTL9607C ];then
        EchoNameByBoardtype_rtl960xx $1
        echo "EchoNameByBoardtype_rtl960xx $1"
    elif [ $var_temp == HWSOC33 ];then
        EchoNameByBoardtype_rtl961xx $1
        echo "EchoNameByBoardtype_rtl961xx $1"
    else
        EchoNameByBoardtype_5115 $1
        echo "EchoNameByBoardtype_5115 $1"
    fi
}


function standby_board_type
{
	feature_value=`GetFeature FT_SUPPORT_5182_DCOM`
	if [ $feature_value = 1 ]; then
		if [ "$1" = "-c" ]; then
			sndhlp 0 0x20004056 0x56 8 0 > /dev/null
		elif [ "$1" = "-s" ]; then
			sndhlp 0 0x20004056 0x56 8 1 $var_boardtype > /dev/null
		fi
	fi
}

var_cmd=$1

# 该命令仅能在装备模式执行
if [ ! -e /mnt/jffs2/Equip.sh ] && [ ! -e /etc/wap/equip_new ] && [ ! $1 == "-g" ]; then
	echo "ERROR::not equip mode!" && exit 1
fi

case $1  in
	-s )
		if [ $# -ne 2 ] ; then
			echo "ERROR::input para is not right!" && exit 1
		fi
		var_boardid=`cat /var/board_cfg.txt | grep board_id | cut -d';' -f 1 | grep -oE [0-9]*`
		var_pcbid=`cat /var/board_cfg.txt | grep pcb_id | cut -d';' -f 2 | grep -oE [0-9]*`
		
		GetTypeByName $2
		if [ $var_boardtype -eq 0 ] ; then
			echo "ERROR::input para is not right!" && exit 1
		fi

		#标定校验
		if [ -f $FILE_BOARDTYPE_CLASS ]
		then
			var_flag=`cat $FILE_BOARDTYPE_CLASS | grep \"$var_boardtype\"`
			if [ -z "$var_flag" ]
			then
				echo "cannot board to type $2!" && exit 0
			else
				#如果支持FT_SUPPORT_5182_DCOM，执行以下操作
				standby_board_type $1

				echo "$var_boardtype" > $FILE_BOARTYPE
				login_user=$(whoami)
				if [ "$login_user" == "root" ]; then
					chown -h 3030:2002 $FILE_BOARTYPE
					chmod 660 $FILE_BOARTYPE
				fi
				sync
				echo "success!" && exit 0
			fi
		else
			echo "cannot board to type $2!" && exit 0
		fi
		;;
	-g )
		if [ $# -ne 1 ] ; then
			echo "ERROR::input para is not right!" && exit 1
		fi
		
	    if [ -f $FILE_BOARTYPE ] ; then
			EchoNameByBoardtype "$(cat $FILE_BOARTYPE)" && exit 0
		else
			echo "ERROR::no custom board name!" && exit 0
		fi	
		;;
	-c )
		if [ $# -ne 1 ] ; then
			echo "ERROR::input para is not right!" && exit 1
		fi

		#如果支持FT_SUPPORT_5182_DCOM，执行以下操作
		standby_board_type $1

		rm -f $FILE_BOARTYPE
		sync
		echo "success!" && exit 0
		;;
	-h )
	        PrintHelp && exit 0
		;;	
	* )
		echo "ERROR::input para is not right!"
		exit 1
		;;
	esac
