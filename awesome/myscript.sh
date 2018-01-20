#!/bin/bash
function dmenu_start
{
	app=`dmenu_path | dmenu  -b -p 'Run:'`;
	/bin/bash -c "export QT_IM_MODULE=fcitx; exec $app" &
}

function info_time
{
	echo ====GLOBAL====
	echo `TZ='Asia/Tokyo' date "+%I:%M:%S %p %Y-%m-%d/%a "` - TOKYO
	echo `TZ='Europe/London' date "+%I:%M:%S %p %Y-%m-%d/%a "` - LONDON
	echo `TZ='Europe/Rome' date "+%I:%M:%S %p %Y-%m-%d/%a "` - ROMA
	echo `TZ='Europe/Paris' date "+%I:%M:%S %p %Y-%m-%d/%a "` - PARIS
	echo `TZ='Europe/Moscow' date "+%I:%M:%S %p %Y-%m-%d/%a "` - MOSCOW
	echo `TZ='Australia/Sydney' date "+%I:%M:%S %p %Y-%m-%d/%a "` - SYDNEY
	echo `TZ='US/Pacific' date "+%I:%M:%S %p %Y-%m-%d/%a "` - SEATTLE
	echo `TZ='US/Central' date "+%I:%M:%S %p %Y-%m-%d/%a "` - MNNESOTA
	echo `TZ='US/Eastern' date "+%I:%M:%S %p %Y-%m-%d/%a "` - NYC
}

function info_sys
{
	echo ==SYSTEMINFO==
	echo `uname -r`
	echo `uptime|sed 's/,  /\n/g'|grep -v user|grep -v load`
	echo ==LASTUPDATE==
	echo $(awk '/upgraded/ {line=$0;} END { $0=line; gsub(/[\[\]]/,"",$0); printf "%s %s",$1,$2;}' /var/log/pacman.log)
	echo ==DISKUSAGE==
	echo `df -h --output=avail,size,target|grep -E "/$"`
	echo `df -h --output=avail,size,target|grep -E "/home$"`
	echo `df -h --output=avail,size,target|grep -E "/tmp$"`
	echo `df -h --output=avail,size,target|grep -E "/boot$"`
}

function info_net
{
	local RUNNING_INTERFACE=`ip addr|grep UP|grep -v lo|cut -d" " -f2|cut -d":" -f1`
	local QUAL=`iwconfig ${RUNNING_INTERFACE} | sed -n 's@.*Quality=\([0-9]*/[0-9]*\).*@100\*\1@p' | bc`
	local ESSID=`iwconfig ${RUNNING_INTERFACE}|sed 's/"//g'|grep  ESSID|sed 's/^.*ESSID://'`
    local SIGNAL=`iwconfig ${RUNNING_INTERFACE}|sed 's/^.*level=-//'|sed -n '6p'`
	local IPADDRESS=`hostname -i`
    local DOWNLOAD=`ifconfig ${RUNNING_INTERFACE}|sed -n 5p|sed 's/^.*bytes //'|sed 's/ .*$//'`
    local UPLOAD=`ifconfig ${RUNNING_INTERFACE}|sed -n 7p|sed 's/^.*bytes //'|sed 's/ .*$//'`
	echo $ESSID@$SIGNAL/$QUAL
	echo $IPADDRESS
	echo ↓`expr $DOWNLOAD / 1024 / 1024`MB ↑`expr $UPLOAD / 1024 / 1024`MB/
}

function fetch_pm25
{
    [[ ! -d ~/.weather ]]&&mkdir ~/.weather
	curl 'http://www.stateair.net/web/rss/1/1.xml'|\
	grep -Eo "[0-9]{2}-[0-9]{2}-[0-9]{4}[^<]*<"|\
	sed 's/<//g' >> ~/.weather/pm25.history&&\
	sort -u -r ~/.weather/pm25.history -o \
	~/.weather/pm25.history
}

function fetch_weather
{
    [[ ! -d ~/.weather ]]&&mkdir ~/.weather
	curl "http://weather.yahooapis.com/forecastrss?w=2151330&u=c" > ~/.weather/weather
}

function display_temp_only
{
	echo `grep "yweather:condition" ~/.weather/weather|\
	grep -Eo "temp[^ ]* "|\
	cut -d"\"" -f2`°C`sed -n '2p' ~/.weather/pm25.history|\
	cut -d";" -f3|sed 's/ /@/g'|cut -d"." -f1`
}

function tooltip_temp
{
	local PM25_TIME=`sed -n '2p' ~/.weather/pm25.history|cut -d";" -f1`
	local PM25=`sed -n "2p" ~/.weather/pm25.history|cut -d" " -f3-5`
	local NOW_TEMP=`grep "yweather:condition" ~/.weather/weather|grep -Eo "temp[^ ]* "|cut -d"\"" -f2`
	local NOW_COND=`grep "yweather:condition" ~/.weather/weather|grep -Eo "text[^ ]* "|cut -d"\"" -f2`
	echo $PM25
	echo $PM25_TIME
	echo ==TEMP==
	grep "lastBuildDate" ~/.weather/weather|sed 's/<[^>]*>//g'
	echo $NOW_TEMP℃ $NOW_COND 
	grep "yweather:location" ~/.weather/weather -A4|grep -v unit|sed -e 's/"//g' -e 's/^<[^ ]* //g' -e 's/\/>//g'
	echo =FORECAST=
	grep "yweather:forecast" ~/.weather/weather|cut -d"\"" -f2,4,6,8,10|sed 's/"/ /g'
}

function share_nowplaying
{
	nowPlaying="$(qdbus org.mpris.clementine /Player GetMetadata 2>/dev/null)"
	if [[ -n $nowPlaying ]];then
		title="$(echo "${nowPlaying}" | sed -ne 's/^title: \(.*\)$/\1/p')"                                                                                                                                                            
		artist="$(echo "${nowPlaying}" | sed -ne 's/^artist: \(.*\)$/\1/p')"
		album="$(echo "${nowPlaying}" | sed -ne 's/^album: \(.*\)$/\1/p')"
		songinfo="$artist - $title"
		echo -e "#nowplaying $songinfo"|\
		xclip -i -selection clipboard		
	else
		local song=$(mpc -f "[%artist% - %title%]"|head -n 1)
		echo -e "#nowplaying $song"|\
		xclip -i -selection clipboard
	fi
}

function input_m
{
	zenity --entry|xclip -i -selection clipboard;
	#sleep 1s;xdotool key Return;
	#sleep 0.5s;xdotool key "ctrl+v";
	#xdotool key Return;
}
case "$1" in
	display_temp_only)
		display_temp_only;
		;;
	tooltip_temp)
		tooltip_temp;
		;;
	update)
		case "$2" in
			pm25)
				fetch_pm25;
				;;
			weather)
				fetch_weather;
				;;
			*)
				fetch_pm25;
				fetch_weather;
		esac
		;;
	time)
		info_time;
		;;
	sysinfo)
		info_sys;
		;;
	netinfo)
		info_net;
		;;
	nowplaying)
		share_nowplaying;
		;;
	input_m)
		input_m;
		;;
	dmenu_start)
		dmenu_start;
		;;
esac
