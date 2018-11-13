#!/bin/bash
#=======================================================================================
#=== DESCIPTION ========================================================================
#=======================================================================================
	## lists all cronjobs for all users
	##
	##
########################################################################################
########################################################################################
	#
	#*************** NEED TO DO/ADD ***********************
	#
	#******************************************************
	#
#///////////////////////////////////////////////////////////////////////////////////////
#|||||||||||||||||||||||| Script Stuff Starts |||||||||||||||||||||||||||||||||||||||||
#\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
#
# If error, give up
# set -e
#### global backup var ####
backupDir=$HOME"/ccdc_backups/$(basename "$0" | tr -d ".sh")"
###########################################################################################
# locks down cron use so none run (maybe)
###########################################################################################
jailer(){
	#### PART 1 ############################
	command echo ALL > /etc/cron.deny
	}
###########################################################################################
# backs everything up into a box and puts a bow on it
###########################################################################################
backupTheWorld(){
	# creating the dir if it doesn't exist
	if [[ ! -d $backupDir ]]; then
		command mkdir -p "$backupDir"
	fi
	# creating backups
	if [[ -f /etc/cron.deny ]]; then
		command cp /etc/cron.deny $backupDir
	fi
	}
#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
#+++++++++++++++++++++++++++++++++ FIGHT!! +++++++++++++++++++++++++++++++++++++++++++++++++++++++++
#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
main(){
	backupTheWorld
	jailer
	}
main
