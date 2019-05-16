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
    'Orc' 'Stick monster' 'Giant Slug' 'Zombie'
    'Fighting Bear' 'Palladin' 'Werewolf' 'Monster'
    'Vampire' 'Mummy' 'Bureaucrat'
)

# get-rand-num requires a modulus ($1) and offset ($2)
# i.e. returns ( rand % modulus ) + offset
function get-rand-num() {
    echo $(($(od -An -N2 -i /dev/random | tr -d ' ') % $1 + $2))
}

#Strings and variables
id=$(get-rand-num ${#opponents[@]} 0)
oh=$(get-rand-num 10 20)
ph=$(get-rand-num 10 20)
boost=20

#Start
while true; do
    read -rp "What is your name? " n
    if [ -z "${n}" ]; then echo "Please type a non-empty name"; else break; fi
done
echo "${n}'s opponent is ... the ${opponents[${id}]}!"

#The program loop begins
while [ "${ph}" -gt 0 ] && [ "${oh}" -gt 0 ]; do
    echo
    echo "${n}'s health is ${ph}."
    echo "The ${opponents[${id}]}'s health is ${oh}."
    echo
    echo -n "Hit Enter to attack"
    [ "${boost}" -gt 0 ] && echo -n ", type 'p' to use +${boost} health potion"
    read -rp ", or type 'q' to quit: " movement
    echo
    case "${movement,,}" in
        p*) [ "${boost}" -gt 0 ] && \
	        echo "${n} drinks the Health potion! (+${boost} health)" || \
	        echo "Oh no, ${n} is out of potions!"
	    ph=$((ph + boost)); boost=0;;
        q*) echo "${n} runs away!" && exit 0;;
        *)  pd=$(get-rand-num 5 1)
            [ "${pd}" -gt "${oh}" ] && pd="${oh}"
	    echo "You attack ${opponents[${id}]} with ${pd} hit point(s)!"
	    oh=$((oh - pd));;
    esac
    # opponent always attacks
    od=$(get-rand-num 5 1)
    [ "${od}" -gt "${ph}" ] && od="${ph}"
    echo "${opponents[${id}]} attacks with ${od} hit point(s)!"
    ph=$((ph - od))
done

echo "=============================================================="
if [ "${oh}" -eq "${ph}" ]; then
    echo " We'll call it a draw! ${n} and the ${opponents[${id}]} have ${ph} point(s) left!"
elif [ "${oh}" -lt 1 ]; then
    echo " Victory! ${n} defeated the ${opponents[${id}]} with ${ph} point(s) left!"
else
    echo " Oh no! ${n} was defeated by the ${opponents[${id}]}!"
fi
echo "=============================================================="
exit "$?"
