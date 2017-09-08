#!/bin/bash

read -p "Please in put an accurate time(eg:2016-1-1 12:00:00):  " inputtime

num=`date -d "$inputtime" +%w`
for i in {2,3,4,5,0}
do
		if [ $num -eq $i ] 
		then
			echo $inputtime |bash /root/test/zabbix_API/curl.online.sh > today_data.txt && sed -i -e "{s/.0000$//}" today_data.txt && sed -i -e "{s/00$//}" today_data.txt && sed -i '1,5s/$/%/' today_data.txt && sed -i '$s/$/%/' today_data.txt && echo $inputtime |bash /root/test/zabbix_API/curl.online.yesterday.sh > yesterday_data.txt && sed -i -e "{s/.0000$//}" yesterday_data.txt && sed -i -e "{s/00$//}" yesterday_data.txt && sed -i '1,5s/$/%/' yesterday_data.txt && paste -d '' today_data.txt yesterday_data.txt > data.csv && cat data.csv
fi
done
if [ $num -eq 1 ]
then
			echo $inputtime |bash /root/test/zabbix_API/curl.online.sh > today_data.txt && sed -i -e "{s/.0000$//}" today_data.txt && sed -i -e "{s/00$//}" today_data.txt && sed -i '1,5s/$/%/' today_data.txt && sed -i '$s/$/%/' today_data.txt && echo $inputtime |bash /root/test/zabbix_API/curl.online.lastfriday.sh > lastfriday_data.txt && sed -i -e "{s/.0000$//}" lastfriday_data.txt && sed -i -e "{s/00$//}" lastfriday_data.txt && sed -i '1,5s/$/%/' lastfriday_data.txt && paste -d '' today_data.txt lastfriday_data.txt > data.csv && cat data.csv
			elif [ $num -eq 6 ]
			then
				echo $inputtime |bash /root/test/zabbix_API/curl.online.sh > today_data.txt && sed -i -e "{s/.0000$//}" today_data.txt && sed -i -e "{s/00$//}" today_data.txt && sed -i '1,5s/$/%/' today_data.txt && sed -i '$s/$/%/' today_data.txt && echo $inputtime |bash /root/test/zabbix_API/curl.online.lastsaturday.sh > lastsaturday_data.txt && sed -i -e "{s/.0000$//}" lastsaturday_data.txt && sed -i -e "{s/00$//}" lastsaturday_data.txt && sed -i '1,5s/$/%/' lastsaturday_data.txt && paste -d '' today_data.txt lastsaturday_data.txt > data.csv && cat data.csv
fi
