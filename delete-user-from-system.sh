#! /bin/bash
# Author: Johan Jobin, 2022.
# Description: script that completely deletes a user from The Littlest JupyterHub
# Notes:
#	1. the script deletes the jupyterhub users that match the specified pattern from the .sqlite database, deletes their associated Linux account and removes their /home directory.
#	2. to run the script first do "chmod +x delete-user-from-system.sh" and then "./delete-user-from-system.sh HOST TOKEN PATTERN" from the /home folder where:
#	- HOST is the JupyterHub URL.
#	- PATTERN is a pattern to filter the users that will be deleted.
# - TOKEN is a token generated on JupyterHub to interact with the API.

if [ $# -ne 3 ]; then
	echo "Please specify a HOST, a JupyterHub token and a PATTERN to run the script"
	exit 1
fi

HOST=$1
TOKEN=$2
PATTERN=$3
counter=0

echo "Here is the list of users that will be deleted:"

for dir in ./jupyter-*$PATTERN*
do
#	avoid glob pattern matching itself when it does not match the loop variable
	[ -e "$dir" ] || continue
	echo "${dir:10}"
	counter=$((counter+1))
done

if [ "$counter" -eq 0 ]; then
	echo $counter
	echo ">>> No user to delete"
	exit 1
fi

echo "-------------------------------------------------"
echo ">>> Total of users who will be deleted:" $counter
echo -e "\n"

echo "Would you really definitively delete these users? (y for 'yes')"
read answer
answer="${answer,,}"

if [ $answer = "y" ]; then
	for d in ./jupyter-*$PATTERN*
		do
#      			avoid glob pattern matching itself when it does not match the loop variable
			[ -e "$d" ] || continue
			curl -X "DELETE" "$HOST/hub/api/users/${d:10}" --header "Authorization: token $TOKEN" --header "Content-Type: application/json"
			echo ">>> User '${d:10}' deleted from JupyterHub."
			userdel -r "jupyter-${d:10}"
			echo ">>> '${d:10}': home folder and user deleted."
			echo -e "\n"
		done
else
	echo ">>> Operation canceled"
	exit 1
fi
