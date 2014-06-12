#!/bin/bash
current_dir=`pwd`
cd $current_dir
for dd in `find $current_dir -type d` #get all directiries under current directory
do
	if [ -d $dd ] #check if it is a directory
	then
		echo $dd
		if [ $dd != . ] && [ $dd != .. ] #check if it is a valid directory
		then
			cd $dd #go into the directory
			if [ -e model.mat ] && [ -f model.mat ]; then
				mv *_pp.mat model.mat train.out ../
				rm -rf *
				mv ../*_pp.mat ../model.mat ../train.out ./
			fi
			cd $current_dir
		fi
	fi
done
