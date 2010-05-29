#!/bin/sh


show_name=0
show_ver=0
show_arch=0
show_default=1
fname=""

usage="usage: $0 [option]... <cls_filename>\n"
usage=$usage"options:\n"
usage=$usage"\t-n, --name\n"
usage=$usage"\t-v, --ver\n"
usage=$usage"\t-a, --arch\n"

usage_exit() {
	printf "$usage"
	exit 1
}

err_exit() {
	echo $*
	exit 1
}

while [ $# -ge 1 ]; do
case $1 in
    -n | --name )
	    show_name=1
	    show_default=0
	    ;;
    -v | --ver )
	    show_ver=1
	    show_default=0
	    ;;
    -a | --arch )
	    show_arch=1
	    show_default=0
	    ;;
    * )
	    [ "$fname" != "" ] && usage_exit
	    fname=$1
	    ;;

esac
shift
done

[ "$fname" == "" ] && usage_exit

if [ $show_default -eq 1 ]; then
	show_name=1
	show_ver=1
	show_arch=1
fi

[ -e "$fname" ] || err_exit "File not found: ${fname}"

if [ $show_name -eq 1 ]; then
	raw_name=`nm $fname | grep __cls_name__`
	name=`echo $raw_name | sed 's/.*cls_name__//g'`
	s=$name
	c=" "
fi

if [ $show_ver -eq 1 ]; then
	raw_ver=`nm $fname | grep __cls_ver__`
	ver=`echo $raw_ver | sed 's/.*cls_ver__//g; s/_/./g'`
	s=$s$c$ver
	c=" "
fi

if [ $show_arch -eq 1 ]; then
	raw_arch=`file -L $fname | awk '{print $7}'`
	arch=`echo $raw_arch | sed 's/,//g'`
	s=$s$c$arch
	c=" "
fi

echo $s
