#!/bin/bash
######
#
# original code: https://www.reddit.com/r/linux/comments/bpa0fk/my_11_year_old_son_wrote_a_game_in_bash_shell_on/
# I have taken this and cleaned it up. All original credit to original author.
# Consider this as public domain code.
#
######

# list of possible opponents
opponents=(
    'Orc'
    'Stick monster'
    'Giant Slug'
    'Zombie'
    'Fighting Bear'
    'Palladin'
    'Werewolf'
    'Monster'
    'Vampire'
    'Mummy'
    'Bureaucrat'
)

# get-rand-num requires a modulus ($1) and offset ($2)
# i.e. returns ( rand % modulus ) + offset
function get-rand-num() {
    echo $(($(od -An -N2 -i /dev/random | tr -d ' ') % $1 + $2))
}

#Strings and variables
ranoppo=$(get-rand-num ${#opponents[@]} 0)
oppohealth=$(get-rand-num 10 20)
playerhealth=$(get-rand-num 10 20)
boost=20

#Start
while true
do
    read -p "What is your name? " n
    [ -z "${n}" ] && echo "Please type a non-empty name" || break
done

echo "${n}'s opponent is ... the ${opponents[${ranoppo}]}!"

#The program loop begins
while [ ${playerhealth} -gt 0 ] && [ ${oppohealth} -gt 0 ]; do
    echo
    echo "${n}'s health is ${playerhealth}."
    echo "The ${opponents[${ranoppo}]}'s health is ${oppohealth}."
    echo
    read -p "Hit Enter to attack, type 'q' to quit, or type 'p' to use +${boost} health potion: " movement
    echo
    case ${movement,,} in
        p*)
            if [ ${boost} -gt 0 ]
            then
	        echo "${n} drinks the Health potion! (+${boost} health)"
	        playerhealth=$((playerhealth + boost))
                boost=0
            else
	        echo "Oh no, ${n} is out of potions!"
            fi;;
        q*)
            echo "${n} runs away!"
            exit 0;;
        *)
            playerdam=$(get-rand-num 5 1)
            [ ${playerdam} -gt ${oppohealth} ] && playerdam=${oppohealth}
	    echo "You attack ${opponents[${ranoppo}]} with ${playerdam} hit points!"
	    oppohealth=$((oppohealth - playerdam));;
    esac
    # opponent always attacks
    oppodam=$(get-rand-num 5 1)
    [ ${oppodam} -gt ${playerhealth} ] && oppodam=${playerhealth}
    echo "${opponents[${ranoppo}]} attacks with ${oppodam} hit points!"
    playerhealth=$((playerhealth - oppodam))
done

echo "==========================================="
if [ ${oppohealth} -lt 1 ]; then
    echo " You defeated the ${opponents[${ranoppo}]}!"
    echo " ${n} wins with ${playerhealth} points left!"
else
    echo " Oh no! ${n} has ${playerhealth} health left!"
    echo " Game over!"
fi
echo "==========================================="

exit 0
