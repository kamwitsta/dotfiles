#!/bin/bash

shopt -s expand_aliases; source ~/.bashrc

l="pl_lng"
layouts=( "basic" "arabic" "cyrillic" "greek" "hebrew" )

case "$1" in
	"menu")		# all layouts as a dmenu
			menu="${layouts[0]}"
			for (( i=1; i<${#layouts[@]}; i++ )); do menu="$menu\n${layouts[$i]}"; done
			setxkbmap $l -variant `echo -e "$menu" | dmenu -nb "$colBgNormal" -nf "$colFgUnimp" -fn "$fontNormal"`
			;;
	"often")	# toggle between latin and cyrillic
			if [ -z `setxkbmap -print | grep basic` ]; then
				setxkbmap $l -variant basic
			else
				setxkbmap $l -variant cyrillic
			fi
			;;
	*)
			echo "$0: unknown argument(s) \"$@\"" | dzen2 -p 10
			;;
esac
