#!/bin/bash

if [[ ! -d ~/.config/lgames ]]
then
       mkdir ~/.config/lgames
       touch ~/.config/lgames/games.conf
fi
if [[ ! -e ~/.config/lgames/games.conf ]]
then
    touch ~/.config/lgames/games.conf
fi

if [[ $1 == "-c" ]];then
    echo "$2" > ~/.config/lgames/games.conf
    GAMES_DIR=$2
    echo "PATH HAS BEEN SET!"
fi

GAMES_DIR=$(cat ~/.config/lgames/games.conf)

if [[ -n $GAMES_DIR ]]
then
        echo "Searching in the path: $GAMES_DIR"
	sleep 1s
else
    echo -e "\x1b[37mgames.conf file is empty.\x1b[0m"
    echo "usage: lgames -c <path to the games/programes directory>"
    echo "the path is then stored in ~/.config/lgames/games.conf so you can call it again without an arguement"
    exit -1
fi


ls "$GAMES_DIR" > ~/.config/lgames/Games.txt

games_count=$(( $(wc -l ~/.config/lgames/Games.txt | cut -b -2) - 1 ))
DISPLAYED_GAMES=$(tput lines)
count=1
Game_path=""

create_list(){
	clear
	if [[ -f ~/.lapp.txt ]];then
	     rm ~/.lapp.txt
	fi
	touch ~/.lapp.txt

	for (( i = $count ; i < $games_count ; i++));
do
        first_game=$( sed -n "$i p" ~/.config/lgames/Games.txt )

        first_character=$( echo $first_game | cut -c 1 )

        Game_exe=$( ls "$GAMES_DIR"/"$first_game" 2>/dev/null | grep -i -P "^(?=.*$first_character)(?=.*exe)" | sed -n "1 p" )
        if [ -z "$Game_exe" ]
        then
                Game_exe=$( ls -R "$GAMES_DIR"/"$first_game" 2>/dev/null | grep -i ".exe$" | sed -n "1 p" )
        fi

	
	if [ -z "$Game_exe" ]
        then
            echo -e "Couldn't find the following game : $first_game\n" >> ~/.lapp.txt
	    games_count=$(( games_count - 1 ))
            continue
        fi

            Game_path=$( find "$GAMES_DIR"/"$first_game" -name "$Game_exe" | sed -n "1p" )
	    echo "$Game_path" >> ~/.lapp.txt
        

        echo -e "[APP] : [$Game_exe]" >> ~/.lapp.txt
done
}

create_list

list_count=$(( $(wc -l ~/.lapp.txt | cut -b -2)/2 - 1 ))

#displaying the list found in ~/.lapp.txt
display_list(){
	clear
	DISPLAYED_GAMES=$(tput lines)
	if [[ $DISPLAYED_GAMES -ge $list_count ]];then
		DISPLAYED_GAMES=$list_count
	fi

	if [[ ! $(( DISPLAYED_GAMES % 2 )) -eq 0 ]];then
		if [[ $DISPLAYED_GAMES -gt 0 ]];then
		    DISPLAYED_GAMES=$((DISPLAYED_GAMES-1))
		else
		    DISPLAYED_GAMES=$((DISPLAYED_GAMES+1))
		fi
	fi

	sed -n "$(( 2*count+3 )),$(( DISPLAYED_GAMES+(2*(count+1)) )) p" ~/.lapp.txt
	
	echo -e "\x1b[32m\x1b[1m"
	sed -n "$(( 2*count+1 )),$(( 2*(count+1) )) p" ~/.lapp.txt
	echo -e "\x1b[0m"

	Game_path=$( sed -n "$(( (2*count+1)  ))p" ~/.lapp.txt)
	echo "Count: $count, Games_count: $games_count, Possible_displayed_games: $DISPLAYED_GAMES, Terminal_height: $(tput lines)"
}

display_list


#The main loop

while :
do

    read -rsn3 char
        case $char in
            $'\e[A')
		    if [[ $count -gt 0 ]];then
		        count=$(( (count - 1) ))
		        display_list
		    fi
		    ;;

            $'\e[B')
		    if [[ $count -lt $games_count ]];then

                        count=$(( count + 1 ))
		        display_list
		    fi
		;;
        esac
   if [[ $char == $'\0' ]]; then
        wine "$Game_path" &
	exit
   fi
done
