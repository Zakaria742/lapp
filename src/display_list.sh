#!/bin/bash

count=1

games_count=$(wc -l ~/.config/lgames/Games.txt | cut -b -2)
Game_path=""
DISPLAYED_GAMES=10
MDISPLAYED_GAMES=$DISPLAYED_GAMES
display_list(){
	clear
        for (( i = $count ; i <= $(( DISPLAYED_GAMES + count)) ; i++));
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
            echo "Couldn't find the following game : $first_game"
            echo -e "-----------------------------\x1b[0m"
            continue
        fi

        if [[ $i -eq $count ]]; then
            Game_path=$( find "$GAMES_DIR"/"$first_game" -name "$Game_exe" )
	    echo -e "[Game Path] : [$Game_path]\n"
        fi

        if [[ $games_count -lt $((DISPLAYED_GAMES + count)) ]]; then
                DISPLAYED_GAMES=$((DISPLAYED_GAMES - 1))
        elif [[ $games_count -gt $(( DISPLAYED_GAMES + count)) && $DISPLAYED_GAMES -lt $MDISPLAYED_GAMES ]];then
                DISPLAYED_GAMES=$(( DISPLAYED_GAMES + 1))
        fi

        echo "[APP] : [$Game_exe]"
        echo -e "-----------------------------\x1b[0m"
done
}

