#! /bin/bash
# Author: Johan Jobin, 2022
# Description: script that removes the content of all jupyterhub users' folders.
# Notes:
#		1. the script doesn't delete the Linux associated to the the folder (https://github.com/jupyterhub/the-littlest-jupyterhub/issues/353), nor the user in the  jupyterhub.sqlite database (https://jupyterhub.readthedocs.io/en/stable/reference/rest-api.html#/)
#		2. to run the script first do "chmod +x empty-user-folders.sh" and then "./empty-user-folder.sh PATTERN" from the /home folder

if [ $# -ne 1 ]; then
	echo "Please specifiy a pattern for the folder names to be emptied"
	exit 1
fi

pattern=$1;
counter=0

echo "Here is the list of folders that will be empty:"
for dir in ./jupyter-*$pattern*
do
	[ -e "$dir" ] || continue
	echo $dir
	counter=$((counter+1))
done

echo "-------------------------------------------------"
echo ">>> Total of lines afffected:" $counter
echo -e "\n"

if [ "$counter" -eq 0 ]; then
        echo ">>> No folder to empty"
        exit 1
fi



echo "Would you really empty these folders (y for 'yes')?"
read answer
answer="${answer,,}"

if [ $answer = "y" ]; then
	for d in ./jupyter-*$pattern*
		do
			[ -e "$d" ] || continue
			rm -rf "$d"/*
			rm -rd "$d"/.ipynb_checkpoints*
			rm -rd "$d"/.ipython
			rm -rd "$d"/.cache
			rm -rd "$d"/.jupyter
			rm -rd "$d"/.local
			rm -rd "$d"/.config
			echo "$d"
			echo ">>> Deletion succeeded"
		done
else
	echo ">>> Operation canceled"
	exit 1
fi
