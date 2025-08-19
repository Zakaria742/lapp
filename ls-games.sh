#!/bin/bash


source ~/App_launcher/src/check_configs.sh
source ~/App_launcher/src/display_list.sh

display_list

if [[ $DISPLAYED_GAMES -gt $games_count ]];then
    DISPLAYED_GAMES=$games_count
fi

while :
do

    read -rsn3 char
    echo -e "\x1b[36m\x1b[1m"
        case $char in
            $'\e[A')
                if [[ $count -gt 1 ]]; then
                    count=$(( count - 1 ))
		    display_list
                fi
		;;

            $'\e[B')
		    if [[ $count -lt $games_count ]]; then
                    count=$(( count + 1 ))
		    display_list
                fi
		;;
        esac
   if [[ $char == $'\0' ]]; then
        wine "$Game_path" &
	exit
   fi
   read -t 0.0001 -rs _
done
