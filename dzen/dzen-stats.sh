#!/bin/bash

shopt -s expand_aliases; source ~/.bashrc


# ======================================================================================


separator=" | "

pathIcons="/home/kamil/.dzen/icons"


# --------------------------------------------------------------------------------------

function clockUpdate {
	clock="^fg($colFgFocus)`date +\"%H:%M:%S\"`^fg()"
}

# --------------------------------------------------------------------------------------

function cpuUpdate {
	# max=`sensors | grep coretemp | wc -l`
	max=`echo "$senses" | grep coretemp | wc -l`
	cpu="^fg($colFgFocus)^i($pathIcons/cpu.xbm)^fg()"

	# temperature
	cpu="$cpu  ^fg($colFgNormal)^i($pathIcons/temp.xbm)^fg() "
	for (( i=0; i<$max; i++ )); do
		# cpu="$cpu`sensors | grep \"core $i\" | awk '{print $3}'`"
		cpu="$cpu`echo "$senses" | grep \"core $i\" | awk '{print $3}'`"
		if [ $i -lt $((max-1)) ]; then cpu="$cpu$separator"; fi
	done

	# frequency
	cpu="$cpu  ^fg($colFgNormal)^i($pathIcons/load.xbm)^fg() "
	cpu="$cpu"`cat /proc/cpuinfo | awk '/MHz/ {print $4/1}' | sed -n -e ":a" -e "$ s/\n/$separator/gp;N;b a"`" MHz"
}

# --------------------------------------------------------------------------------------

function memUpdate {
	mem="^fg($colFgFocus)^i($pathIcons/mem.xbm)^fg()"

	mem="$mem  `sudo hddtemp /dev/sda | awk '{print $3}'`"
	mem="$mem$separator`free | awk '/Mem/ {printf \"%3.2f\", $3*100/$2}'`%"
	mem="$mem$separator`free | awk '/Swap/ {printf \"%3.2f\", $3*100/$2}'`%"
}

# --------------------------------------------------------------------------------------

function netInit {
	# iface=`ifconfig | grep Bcast -B 1 | /bin/grep -o "eth0\|wlan0"`
	iface="wlan0"
	netRO=`cat /sys/class/net/$iface/statistics/rx_bytes`
	netTO=`cat /sys/class/net/$iface/statistics/tx_bytes`
}

function netUpdate {
	net="^fg($colFgFocus)^i($pathIcons/net-$iface.xbm)^fg()"

	netRN=`cat /sys/class/net/$iface/statistics/rx_bytes`
	netTN=`cat /sys/class/net/$iface/statistics/tx_bytes`
	tmp=`wcalc -q "($netRN-$netRO)/1024"`; net="$net ${tmp:0:4}"
	tmp=`wcalc -q "($netTN-$netTO)/1024"`; net="$net$separator${tmp:0:4} kB/s"
	netRO=$netRN; netTO=$netTN;
}

# --------------------------------------------------------------------------------------

function procUpdate {
	proc="^fg($colFgFocus)^i($pathIcons/proc.xbm)^fg()"
	proc="$proc $((`ps -e | wc -l`-1))"
	proc="$proc$separator$((`ps x | wc -l`-1))"
}

# --------------------------------------------------------------------------------------

function tempUpdate {
	# max=`sensors | grep "temp[[:digit:]]" | wc -l`
	max=`echo "$senses" | grep "temp[[:digit:]]" | wc -l`
	temp="^fg($colFgFocus)^i($pathIcons/temp.xbm)^fg() "

	for (( i=1; i<$((max+1)); i++ )); do
		# temp="$temp`sensors | grep temp$i | awk '{print $2}'`"
		temp="$temp`echo "$senses" | grep temp$i | awk '{print $2}'`"
		if [ $i -lt $max ]; then temp="$temp$separator"; fi
	done
}

# --------------------------------------------------------------------------------------

function upTimeUpdate {
	upTime="^fg($colFgFocus)^i($pathIcons/up.xbm)^fg()"

	upTime="$upTime `uptime | awk '{print $3}' | awk '{
		sub(/:(0)?/, \"h \", $1)
		sub(/,/, "", $1)
		print $1\"m\"
		}'`"
}
# --------------------------------------------------------------------------------------

function volUpdate {
	if [ "`amixer get Master | awk -F[ '/Front Left:/ {print $3}'`" == "off]" ]; then
		vol="^fg($colFgFocus)^i($pathIcons/vol-mute.xbm)^fg()"
	else
		vol="^fg($colFgFocus)^i($pathIcons/vol-hi.xbm)^fg()"
		vol="$vol `amixer get Master | awk -F[ '/Front Left:/ {print $2}' | tr -d ]`"
	fi
}


# ======================================================================================


# toggle itself
lock="/home/kamil/.dzen/.dzen-stats.lck"
if [ -f "$lock" ]; then
	rm -f "$lock"
	killall stalonetray
	killall dzen-stats.sh
else
	touch "$lock"
	stalonetray &
	netInit
	# senses=`sensors` &
	while true; do
		# if [ `ps aux | grep sensors | wc -l` -le 1 ]; then senses=`sensors`; fi
		tmp=1; while [ ${tmp:0:1} != 0 ]; do tmp=`date +"%N"`; done		# the measurements might take more than a second
		clockUpdate; memUpdate; netUpdate; procUpdate; upTimeUpdate; volUpdate
		# cpuUpdate; tempUpdate;
		echo "$clock     $temp     $cpu     $mem     $net     $vol     $proc     $upTime"
	done | dzen2 -bg "$colBgNormal" -fg "$colFgUnimp" -fn "$fontNormal" -h 24
fi
