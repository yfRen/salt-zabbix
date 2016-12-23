#!/bin/bash
#必须安装 yum -y install sysstat
dev=$1
type=$2

if [[ -z "$dev" ]]; then
  echo "error: wrong input value (device)"
  exit 1
fi

if [[ -z "$type" ]]; then
  echo "error: wrong input value (type)"
  exit 1
fi

line=2
for i in 'rrqm/s' 'wrqm/s' 'r/s' 'w/s' 'rkB/s' 'wkB/s' 'avgrq-sz' 'avgqu-sz' 'await' 'r_await' 'w_await' 'svctm' '%util'
	do
		if [ $type == $i ]
			then
				
				any=`/usr/bin/iostat -d sda -x -k 1 3 | grep -v '^$' | grep -v 'Device' | tail -3 | awk -v n=$line '{print $n}'`
				avg=0
				for a in $any
					do
						avg=$(awk -v a=$avg -v b=$a 'BEGIN{print a+b}')
					done
				avg=$(awk -v n=$avg 'BEGIN{printf "%.1f\n",n/3}')
		fi
		let line++
	done
echo $avg
	
