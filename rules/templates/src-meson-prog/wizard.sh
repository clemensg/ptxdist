#!/bin/bash

NAME="${1}"
if [ -z "$NAME" ]; then
	echo -n "project name: "
	read NAME
fi

mv "@name@.c" "${NAME}.c"

for i in \
	meson.build \
	${NAME}.c \
; do
	sed -i -e "s/\@name\@/${NAME}/g" $i
done

