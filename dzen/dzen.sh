#!/bin/bash

shopt -s expand_aliases; source ~/.bashrc

# ======================================================================================

interval=1
separator=" | "
updateNowFile=".dzen-update-now"

# --------------------------------------------------------------------------------------

battIval=60
function battUpdate {
	if [ `acpi -a | grep -c "on-line"` -eq 1 ]; then
		batt="^i(/home/kamil/.dzen/icons/power-ac.xbm)"
		if [ `acpi -b | grep -c "Full"` -ne 1 ]; then
			batt="$batt "`acpi -b | awk '{print $4}'`
		fi
	else
		batt="^i(/home/kamil/.dzen/icons/power-bat.xbm)"
		battValue=`acpi -b | awk '{print $4}'`
		battRound=`echo $battValue | sed s/"\(\.[0-9]*\)*%,"//g`
		if [ "$battRound" -ge 50 ]; then
			batt="$batt$battValue"
		elif [ "$battRound" -lt 50 ] && [ "$battRound" -ge 25 ]; then
			batt="$batt^fg($colFgNormal)$battValue^fg()"
		elif [ "$battRound" -lt 25 ] && [ "$battRound" -ge 10 ]; then
			batt="$batt^fg($colFgFocus)$battValue^fg()"
		else
			batt="$batt^fg($colFgUrgent)$battValue^fg()"
		fi
	fi
}

# --------------------------------------------------------------------------------------

clockIval=60
function clockUpdate {
	clock="^fg($colFgNormal)`/home/kamil/devel/hs/fuzzytime/dist/build/fuzzytime/fuzzytime clock --caps 0`^fg()"
	# clock="^fg($colFgNormal)`/home/kamil/.dzen/fuzzyclock.r`^fg()"
}

# --------------------------------------------------------------------------------------

dateIval=300
function dateUpdate {
	date="`date +\"%m.%d.\"`"
}

# --------------------------------------------------------------------------------------

revDecIval=1
function revDecUpdate {
	revDec=`/home/kamil/devel/hs/revdectime/dist/build/revdectime/revdectime`
}

# ======================================================================================

battCnt=0; battUpdate
clockCnt=0;	clockUpdate
dateCnt=0;	dateUpdate
revDecCnt=0; revDecUpdate

while true; do
	if [ -e "$updateNowFile" ]; then
		rm -rf "$updateNowFile"
		battCnt=$battIval
		clockCnt=$clockIval
		dateCnt=$dateIval
		revDecCnt=$revDecIval
	fi

	if [ $battCnt -ge $battIval ]; then battUpdate; battCnt=0; fi
	battCnt=$((battCnt+1))
	if [ $clockCnt -ge $clockIval ]; then clockUpdate; clockCnt=0; fi
	clockCnt=$((clockCnt+1))
	if [ $dateCnt -ge $dateIval ]; then dateUpdate; dateCnt=0; fi
	dateCnt=$((dateCnt+1))
	if [ $revDecCnt -ge $revDecIval ]; then revDecUpdate; revDecCnt=0; fi
	revDecCnt=$((revDecCnt+1))

	echo "${batt}${separator}${date}${separator}${revDec}${separator}${clock}"
	sleep $interval
done | dzen2 -bg "$colBgNormal" -fg "$colFgUnimp" -fn "$fontNormal" -ta r -w 720 -x 720 -h 24
