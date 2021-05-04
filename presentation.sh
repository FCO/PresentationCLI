#!/bin/bash

source PresentationCLI.sh


title "First title"
present "test" \
	"ls \
		-a\
		-l"

present "test2" "ls"
present "test3" "ls error"
present "test4" "echo >&2 com error"

title "Second title"
present "test5" "ls"
present "test6" "ls"
present "test7" "ls"
present "test8" "ls"
