#!/bin/bash
#
# This file is used to submit jobs into the cluster, and I have to set the maximum 
# number of jobs running on the cluster simutanously because of the limited machines. 
# If the number of my running jobs is equal to the maximum value, then it will wait 
# for some seconds and query again to check if we could submit another job
#

lower_sec=10
max_num_of_tasks=15
status_file=sge_status.txt
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
			#rm -rf *_pp.mat model.mat train.out job_*.sh.o* 2>/dev/null # delete old result files
			if [ -f train.out ]
			then
				echo "job is existing!"
				continue;
			fi
			for job in `ls -t job_*.sh 2>/dev/null` #find job file which need to be submitted
			do
				if [ -f $job ] 	#check if it is a valid job file
				then
					if [ -e ${status_file} ];then #check if the status file exists, if yes, delete it
						rm -rf ${status_file}
					fi
					qstat -u "username" > ${status_file} #query the status of my jobs
					current_num_of_my_tasks=`cat ${status_file} | wc -l 2>/dev/null` #get the count of my current running jobs
					let current_num_of_my_tasks=$current_num_of_my_tasks-2; 
					while [ $current_num_of_my_tasks -ge $max_num_of_tasks ];do #if the count is greater than the max count, waiting for 10 seconds
						sleep_sec=30 #`shuf -i $lower_sec-$lower_sec+10 -n 1`
						echo "Maximum Tasks!!!, waiting for $sleep_sec seconds ..."
						sleep $sleep_sec
						if [ -e ${status_file} ];then # query the status
							rm -rf ${status_file}
						fi
						qstat -u "username" > ${status_file} #query the status
						current_num_of_my_tasks=`cat ${status_file} | wc -l 2>/dev/null`
						let current_num_of_my_tasks=$current_num_of_my_tasks-2;
					done
					m_currentpath=`pwd`
					for m in `ls -t m*.m 2>/dev/null`
					do
						sed -i "1s@.*@datapath='$m_currentpath';@" $m #replace the datapath into current directory
						break;
					done
					qsub $job #if run to this line, then submit the job in the current directory
					echo "$job submitted. Waiting ... " #show success
					sleep 60
					break; #in each directory, just permit the latest job file, the other
				fi
			done
			cd $current_dir
		fi
	fi
done
