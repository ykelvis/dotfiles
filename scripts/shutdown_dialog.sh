#!/bin/sh

ACTION=`zenity --width=90 --height=200 --list --radiolist --text="Select logout action" --title="Logout" --column "Choice" --column "Action" TRUE LockScreen FALSE Suspend FALSE Shutdown FALSE Reboot`

if [ -n "${ACTION}" ];then
  case $ACTION in
  Shutdown)
    zenity --question --text "Are you sure you want to shutdown?" && shutdown -h now
    ;;
  Reboot)
    zenity --question --text "Are you sure you want to reboot?" && reboot
    ;;
  Suspend)
    zenity --question --text "Are you sure you want to suspend?" && systemctl suspend
    ;;
  LockScreen)
    i3lock -e -t -i ~/lock.png
    # Or gnome-screensaver-command -l
    ;;
  esac
fi
