#!/bin/sh

FILE=bin/heapsu.hl

rm -f $FILE
haxe build.hxml --connect 6003 --times # -dce full

if [ -f $FILE ]; then
    hl $FILE
fi