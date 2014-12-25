#!/bin/bash
i=1
URL="http://h.acfun.tv/t/"
IMAGE="http://static.acfun.mm111.net/h"
echo -n 'Enter thread number: '
read number
last_page=$(curl -s "$URL$number"|grep -Eo "?page[^>]*>末页"|cut -d"=" -f2|cut -d"\"" -f1);
echo There are $last_page pages!;

while [ $i -le $last_page ]
do
	echo downloading $i / $last_page;
	curl -s "$URL$number?page=$i"|grep -Eo "<a href=\"http[^<]*<i"|cut -d"\"" -f2|uniq > download_list;
	cat download_list >> backup;
	echo "`cat download_list|wc -l` pictures on this page"
	aria2c -c -x5 -s5 -i download_list 2&>log;
	i=`expr $i + 1`;
done
