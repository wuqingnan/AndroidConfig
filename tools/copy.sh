#!/bin/bash

cat list.txt | while read LINE
do
	/home/www/tmp/copy.exp $LINE
	sleep 2
done

