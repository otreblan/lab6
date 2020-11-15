#!/usr/bin/env bash

arm-none-eabi-as "$@"

function hex() {
arm-none-eabi-objdump -d a.out |\
	tail -n+8 |\
	awk '{printf "%s\0", toupper($2)}'
}

while IFS= read -rd '' i
do
	printf "%s " "$i"
	dc -e 16i2o"$i"p | cut -b7-12
done < <(hex) | paste "$@" - | column -to" "
