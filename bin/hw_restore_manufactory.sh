#! /bin/sh

login_user=$(whoami)
if [ $login_user != "root" ]; then
	sudo hw_restore_manufactory_exec.sh
else
	hw_restore_manufactory_exec.sh
fi
