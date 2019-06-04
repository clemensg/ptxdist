#!/bin/bash

NAME="${1}"
if [ -z "$NAME" ]; then
	echo -n "project name: "
	read NAME
fi

VERSION="${3}"
if [ -z "$VERSION" ]; then
	echo -n "project version: "
	read VERSION
fi

mv "@name@.c" "${NAME}.c"

for i in \
	meson.build \
	${NAME}.c \
; do
	sed -i -e "s/\@name\@/${NAME}/g" \
	       -e "s/\@version\@/${VERSION}/g" $i
done

