#!/bin/bash

function start_if_not {
    task_name=$1
    process_name=$2
    bin_name=$3
    ps aux|grep -v grep|grep -i "$process_name" &> /dev/null
    if [[ $? == 0 ]];then
        echo "$task_name: up"
    else
        echo "$task_name: starting..."
        /bin/bash -c "$bin_name" &> /dev/null
        if [[ $? == 0 ]];then
            echo "$task_name: started"
        else
            echo "$task_name: failed"
        fi
    fi
}

start_if_not "dnsmasq" "dnsmasq" "sudo /usr/local/sbin/dnsmasq"
start_if_not "dnscrypt-proxy" "dnscrypt-proxy" "sudo /usr/local/sbin/dnscrypt-proxy /usr/local/etc/dnscrypt-proxy.conf"
start_if_not "mpd" "mpd " "mpd ~/.config/mpd/mpd.conf"
start_if_not "mpdscribble" "mpdscribble" "mpdscribble"
