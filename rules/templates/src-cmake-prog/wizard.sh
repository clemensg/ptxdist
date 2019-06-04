#!/bin/bash

NAME="${1}"
if [ -z "$NAME" ]; then
	echo -n "project name: "
	read NAME
fi
NAME_UP="$(echo $NAME | tr '[a-z-]' '[A-Z_]')"

mv "@name@.cpp" "${NAME}.cpp"

for i in \
	CMakeLists.txt \
	"${NAME}.cpp" \
; do
	sed -i -e "s/\@name\@/${NAME}/g" \
	       -e "s/\@NAME\@/${NAME_UP}/g" $i
done

