#!/bin/bash

#####################################################################
#
# Script to retain / store files with file integrity guarantee
# Tamas Bogdan <tamasbogdan@paypoint.net>
# $version 3.14 - Now with added calcium and vitamins!
#
#####################################################################

exec 3>&1 4>&2
trap 'exec 2>&4 1>&3' 0 1 2 3
exec 1>/tmp/retn.out 2>&1
trap ctrl_c INT

regex_pref=posix-extended

CONFDIR=/etc/glutenvrij/config/

cd $CONFDIR
for conf in `ls  -1 $CONFDIR`;
do

		. $conf
		. /usr/local/glutenvrij/functions

		locations="${LOCATIONS}"

        echo "Script version $version started at `date` on `hostname` for $conf .." >> ${LOG}

        lock

        checkConf
        createRefFiles
		printf "Reconciling file list, this might take some time ..\n"
        printf "Rules apply: \n" >> ${LOG}

			for reg in "${xpressions[@]}"
			do
					printf "${reg} \n" >> ${LOG}
					find ${locations} -type f -regextype ${regex_pref} -regex "${reg}" >> ${tmpwrk}
			done

		echo "Unify file sort: stage1, start " >> ${LOG}
		cat ${tmpwrk} | sort | uniq > ${sorted}
		cat ${sorted} > ${tmpwrk}
		echo "Unify file sort: stage1, complete" >> ${LOG}


		echo "Check 0 byte files and deleting them if any, start " >> ${LOG}
		while IFS='' read -r line || [[ -n "$line" ]];
		do
			if [ -s $line ]; then
				echo $line >> ${sorted}
			else
				echo "File has 0 byte size = $line" >> ${LOG}
				rm -f $line
			fi
		done < "${tmpwrk}"
		cat ${sorted} | sort | uniq > ${tmpwrk}

		echo "Check 0 byte files: done" >> ${LOG}


		echo "Open file handle check: start" >> ${LOG}
		echo "" > ${sorted}

		echo -n "FHANDLE_CHK `date +[%Y/%m/%d:%H:%M:%S]` ..."
		while IFS='' read -r line || [[ -n "$line" ]];
		do

			if [ ! -z "`lsof -n | grep ${line}`" ];
			then
				echo "Skip processing $line, found file handle open .." >> ${LOG}
			else
				echo $line >> ${sorted}
				echo "lsof: $line (not locked)" >> ${LOG}
			fi

		done < "${tmpwrk}"
		echo " done"
		echo "Open file handle check: finished" >> ${LOG}

		echo "Removing new lines .. " >> ${LOG}
		grep -v ^$ ${sorted} > ${tmpwrk}
		cat ${tmpwrk} > ${sorted}
		echo ".. done" >> ${LOG}

		echo "Processing a file with size of `du -h ${sorted}`" >> ${LOG}
		echo "== | Dumping file list which aren't locked and will be processed:" >> ${LOG}
		cat ${sorted} >> ${LOG}
		echo "== | File list: over" >> ${LOG}

		printf "The following config file being is processed: $conf \n"
		if [ ! -s ${sorted} ]; then
					printf "No files to work with - no regexes match or directory empty.\n" >> ${LOG}
					printf "Extend regex list if you feel there sould be files to rotate. \n" >> ${LOG}
					success
		else
					process
					success
		fi

        echo "Script version $version finished at `date` on `hostname` for $conf .. " >> ${LOG}

done
