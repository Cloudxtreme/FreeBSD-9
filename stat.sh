#!/bin/bash

pattern=$1

[ "$patern" = "." ] && pattern=""

shift

logfile=$*

[ "$logfile" = "" ] && logfile=/var/log/squid/access.log

if [ "$pattern" = "" ]; then

HIT_COUNT=`grep HIT $logfile | grep -v "POST\|304" | wc -l`

MISS_COUNT=`grep -v HIT $logfile | grep -v "POST\|304" | wc -l `

HIT_BYTES=`grep HIT $logfile | grep -v "POST\|304" | tr -s " "\

| cut -d ' ' -f 5 | ( sz=0; while read a; do let sz=sz+a; done; echo $sz )`

MISS_BYTES=`grep -v HIT $logfile | grep -v "POST\|304" | tr -s " "\

| cut -d ' ' -f 5 | ( sz=0; while read a; do let sz=sz+a; done; echo $sz )`

else

echo $pattern

HIT_COUNT=`grep $pattern $logfile | grep HIT | grep -v "POST\|304" | wc -l`

MISS_COUNT=`grep $pattern $logfile | grep -v HIT | grep -v "POST\|304" | wc -l `

HIT_BYTES=`grep $pattern $logfile | grep HIT | grep -v "POST\|304" | tr -s " "\

| cut -d ' ' -f 5 | ( sz=0; while read a; do let sz=sz+a; done; echo $sz )`

MISS_BYTES=`grep $pattern $logfile | grep -v HIT | grep -v "POST\|304"\

| grep -v 304 | tr -s " " | cut -d ' ' -f 5\

| ( sz=0; while read a; do let sz=sz+a; done; echo $sz )`

fi

TOTAL_BYTES=$((HIT_BYTES+MISS_BYTES))

echo HIT_BYTES=$HIT_BYTES MISS_BYTES=$MISS_BYTES TOTAL_BYTES=$TOTAL_BYTES

TOTAL_COUNT=$((HIT_COUNT+MISS_COUNT))

echo HIT_COUNT=$HIT_COUNT MISS_COUNT=$MISS_COUNT TOTAL_COUNT=$TOTAL_COUNT

echo

echo Чтение байт из кэша: $(((HIT_BYTES*100)/TOTAL_BYTES))%

echo Чтение колво запросов из кэша: $(((HIT_COUNT*100)/TOTAL_COUNT))%

