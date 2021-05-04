#!/bin/bash

FASTFORWARD=${FASTFORWARD:-0}
TITLE_COLOR=${TITLE_COLOR:-green}
SUBTITLE_COLOR=${SUBTITLE_COLOR:-yellow}
BODY_COLOR=${BODY_COLOR:-grey}
CMDOUT_COLOR=${CMDOUT_COLOR:-bold}
CMDERR_COLOR=${CMDERR_COLOR:-red}
SPACES_BEFORE_TITLE=${SPACES_AFTER_PRESENT:-5}
SPACES_AFTER_TITLE=${SPACES_AFTER_PRESENT:-7}
SPACES_AFTER_PRESENT=${SPACES_AFTER_PRESENT:-5}
READ_BEFORE_TITLE=${READ_BEFORE_TITLE:-y}
READ_AFTER_TITLE=${READ_AFTER_TITLE:-y}

read_if() {
	[ $FASTFORWARD -ge 0 ] && echo || read
}

no_clear() {
	#for i in $(seq 60); do echo; done
	#echo -e "\033[0H"
	clear
}

color() {
	case "$1" in
		white)
			;;
		yellow)
			echo 33
			;;
		red)
			echo 31
			;;
		green)
			echo "32;1"
			;;
		grey)
			echo 2
			;;
		bold)
			echo 1
			;;
		*)
			echo >&2 "Color $1 not recognized"
			exit
	esac
}

open_color() {
	COLOR_NAME=${COLOR_NAME:-white}
	COLOR=${COLOR:-$(color $COLOR_NAME)}
	echo -ne "\033[${COLOR}m"
}

close_color() {
	echo -ne "\033[m"
}

colorise() {
	(COLOR_NAME=$COLOR_NAME open_color)
	echo $*
	close_color
}

red() {
	(COLOR_NAME="red" colorise $*)
}

yellow() {
	(COLOR_NAME="yellow" colorise $*)
}

green() {
	(COLOR_NAME="green" colorise $*)
}

grey() {
	(COLOR_NAME="grey" colorise $*)
}

subtitle() {
	(COLOR_NAME=$SUBTITLE_COLOR colorise $1)
}

body() {
	(COLOR_NAME=$BODY_COLOR colorise $1)
}

test_ff() {
	FASTFORWARD=$(expr $FASTFORWARD - 1)
}

title() {
	[ x$READ_BEFORE_TITLE == xy ] && read_if
	no_clear
	spaces $SPACES_BEFORE_TITLE
	(COLOR_NAME=${COLOR_NAME:-$TITLE_COLOR} colorise $1)

	test_ff

	spaces $SPACES_AFTER_TITLE
	[ x$READ_AFTER_TITLE == xy ] && read_if
}

present() {
	MSG=$1
	CMD=$2

	test_ff

	subtitle "$MSG"
	body "$CMD"
	read_if
	run "$CMD"
	spaces $SPACES_AFTER_PRESENT
}

run() {
	CMD=$1
	OUT=/tmp/$$.out
	ERR=/tmp/$$.err
	eval $CMD > $OUT 2> $ERR
	(COLOR_NAME=$CMDOUT_COLOR open_color)
	cat $OUT
	close_color
	(COLOR_NAME=$CMDERR_COLOR open_color)
	cat $ERR
	close_color
}

spaces() {
	for i in $(seq $1); do echo; done
}
