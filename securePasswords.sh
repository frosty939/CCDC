#!/bin/bash
#=======================================================================================
#=== DESCIPTION ========================================================================
#=======================================================================================
	## randomly generates passwords for all non-locked accounts
	## locks ALL accounts except for the one you are using
	## will require manual unlocking after infection is purged, almost certainly
########################################################################################
########################################################################################
	#
	#*************** NEED TO DO/ADD ***********************
	# clean this shit up
	# figure out how to import passwords without using plaintext..
	# maybe dont backup the orig shadow file..?
	#******************************************************
	#
#///////////////////////////////////////////////////////////////////////////////////////
#|||||||||||||||||||||||| Script Stuff Starts |||||||||||||||||||||||||||||||||||||||||
#\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
#
#### global backup var ####
backupDir=$HOME"/ccdc_backups/$(basename "$0" | tr -d ".sh")"
###########################################################################################
# If error, give up
set -e
###########################################################################################
#are you root? no? well, try again
###########################################################################################
neo() {
	if [[ $EUID -ne 0  ]]; then
	echo "you forgot to run as root again... "
	echo "Current dir is "$(pwd)
	exit 1
	fi
	}
###########################################################################################
# copies everything to the backupDir
###########################################################################################
antiFuckUp(){
	# creating the dir if it doesn't exist
	if [ ! -d $backupDir ]; then
		command mkdir -p "$backupDir"
	fi
	# copying current states
	command cp -a /etc/passwd $backupDir/passwd.bak
	command cp -a /etc/shadow $backupDir/shadow.bak
	command cp -a /etc/shadow- $backupDir/shadow-.bak
	command cp -a /etc/shadow.old $backupDir/shadow.old.bak
	}
###########################################################################################
# Locks all accounts except for the one you are on and makes you change password
###########################################################################################
jailer(){
	#### Locking accounts ############################
	users=$(cat /etc/shadow | grep -oP "^.+?(?=:)" | sed "/$(logname)/d" )
    for i in ${users[*]}; do
        command passwd -lq $i
		command printf "\nDisabled Login for: $i"
    done
	#### current account pw change ############################
	command printf "\n\n========== All Accounts now have Randomized Passwords and are Locked Except for: $(logname) ==========\n"
	command printf "\nChanging [$(logname)'s] Password\n"
	command passwd $(logname)
	#### Announcing Backup Location ############################
	printf "\n====== original files backed up to $backupDir--$(date +"%Y-%m-%d_%H%M") ======\n"
	}
###########################################################################################
# generates random passwords for all accounts
###########################################################################################
madMixer(){
	#### checks/installs pwgen ############################
	if ! dpkg-query -W -f='${Status}' pwgen | grep -q "ok installed"; then
		apt install pwgen -y
		echo ""
	fi
	#### randomizes passwords ############################
	for i in $(compgen -u); do
        if [[ $i != $(logname) ]]; then
			pass="$(pwgen 16 1)"
			command echo -e "$pass\n$pass" | passwd $i
			command echo -e "$pass\n$pass" > /dev/null
        fi
        done
}
###########################################################################################
# zips it all up
###########################################################################################
coldOutside(){
	#### compressing ############################
	command tar -zcf $HOME/ccdc_backups/$(basename "$0" | sed 's/\.sh//')--$(date +"%Y-%m-%d_%H%M").tar.gz -C $HOME/ccdc_backups $(basename "$0" | sed 's/\.sh//')
	command rm -rf $backupDir
	}
#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
#+++++++++++++++++++++++++++++++++ FIGHT!! +++++++++++++++++++++++++++++++++++++++++++++++++++++++++
#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
main(){
	neo
	antiFuckUp
	madMixer
	jailer
	coldOutside
	}
main
