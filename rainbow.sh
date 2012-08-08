#!/bin/bash
# 
# EXCELLENT VIIKSIPOJAT RAINBOW DEMO
#
# 888     888 8888888 8888888 888    d8P   .d8888b. 8888888 8888888b.   .d88888b. 888888        d8888 88888888888                          888     888 8888888 8888888 888    d8P   .d8888b. 8888888 8888888b.   .d88888b. 888888        d8888 88888888888                          
# 888     888   888     888   888   d8P   d88P  Y88b  888   888   Y88b d88P' 'Y88b  '88b       d88888     888                              888     888   888     888   888   d8P   d88P  Y88b  888   888   Y88b d88P' 'Y88b  '88b       d88888     888                              
# 888     888   888     888   888  d8P    Y88b.       888   888    888 888     888   888      d88P888     888                              888     888   888     888   888  d8P    Y88b.       888   888    888 888     888   888      d88P888     888                              
# Y88b   d88P   888     888   888d88K      'Y888b.    888   888   d88P 888     888   888     d88P 888     888                              Y88b   d88P   888     888   888d88K      'Y888b.    888   888   d88P 888     888   888     d88P 888     888                              
#  Y88b d88P    888     888   8888888b        'Y88b.  888   8888888P'  888     888   888    d88P  888     888                               Y88b d88P    888     888   8888888b        'Y88b.  888   8888888P'  888     888   888    d88P  888     888                              
#   Y88o88P     888     888   888  Y88b         '888  888   888        888     888   888   d88P   888     888                                Y88o88P     888     888   888  Y88b         '888  888   888        888     888   888   d88P   888     888                              
#    Y888P      888     888   888   Y88b  Y88b  d88P  888   888        Y88b. .d88P   88P  d8888888888     888                                 Y888P      888     888   888   Y88b  Y88b  d88P  888   888        Y88b. .d88P   88P  d8888888888     888                              
#     Y8P     8888888 8888888 888    Y88b  'Y8888P' 8888888 888         'Y88888P'    888 d88P     888     888                                  Y8P     8888888 8888888 888    Y88b  'Y8888P' 8888888 888         'Y88888P'    888 d88P     888     888                              
#                                                                                  .d88P                                                                                                                                    .d88P                                                   
#                                                                                .d88P'                                                                                                                                   .d88P'                                                    
#                                                                               888P'                                                                                                                                    888P'                                                      

# COLORS OF THE RAINBOW !!!
red='\e[41;33m'
yellow='\e[43;32m'
green='\e[42;34m'
blue='\e[44;35m'
magenta='\e[45;31m'
#hl='\e[4;47;37m'
# red='\e[38;5;09;48;5;11m'
# yellow='\e[38;5;11;48;5;10m'
# green='\e[38;5;10;48;5;12m'
# blue='\e[38;5;12;48;5;13m'
# magenta='\e[38;5;13;48;5;09m'
hl='\e[38;5;15;48;5;15m'

SCREENWIDTH=80
CONTROLCHARS=$((${#red}-1))
WIDTH=$(($SCREENWIDTH+$CONTROLCHARS))
TEXTWIDTH=138 
MAX=1000000
INTERVAL=0.01

init() {
	clear
	iteration=114 # HACK TO GET THE TEXT SCROLLING FROM A PROPER PLACE
	rainbowgen
}

loop() {
	while [ $iteration -lt $MAX ]; do
		iteration=$((iteration+1))
		drawframe
		swap=${rainbow:0:$WIDTH}
		rainbow=${rainbow:$WIDTH}$swap
		sleep $INTERVAL
	done
}

cleanup() {
	printf "\e[00m\n"
}


drawframe() {
	frame=""

	# HEADER (8 LINES)
	frame+="${rainbow:0:$(($WIDTH*8))}"

	# GO THROUGH LINES (11) CONTAINING TEXT
	for i in {0..10}; do
		slice="$(sed -n $((i+5))p $0)" # 5 IS THE LINE WHERE THE TEXT DATA BEGINS
		slice="${slice:$((iteration%$TEXTWIDTH+2)):80}" # +2 BECAUSE THERE'S A COMMENT CHARACTER AND A SPACE BEFORE ACUAL "DATA" 
		frame+="$(merge "${rainbow:$(($WIDTH*(8+$i))):$WIDTH}" "$slice")"
	done

	# FOOTER (5 LINES)
	frame+="${rainbow:$(($WIDTH*19)):$(($WIDTH*5))}" # 19 = HEADER + TEXTAREA

	printf "$frame"
}

merge() { # $1 = rainbow, $2 text
	color="${1:0:$CONTROLCHARS}"
	line=$color

	# if there's text data print it, else use the rainbow
	for (( i=0; i<${#2}; i++)); do
		char="${2:$i:1}"
		if [ "$char" != " " ]; then
			line+="$hl$char$color"
		else
			line+="${1:$((i+$CONTROLCHARS)):1}"
		fi
	done

	printf "$line"
}

rainbowgen() {
	chars=" ░▒▒▓"
	colors="$red $yellow $green $blue $magenta"
	for color in $colors; do
		for (( i=0; i<${#chars}; i++)); do
			rainbow+="$(line $color "${chars:i:1}")"
		done
	done
}

line() {
	printf -v line "%0*.*d" "" "$SCREENWIDTH" # prints $SCREENWIDTH zeroes to $line
	line="$1"${line//0/"$2"}
	printf "$line\n"
}

# MAIN
init
loop
cleanup