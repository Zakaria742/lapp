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
