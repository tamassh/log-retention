#!/bin/bash

E_PARAMOUSR=1		# missing parameter
E_FNTE=2		# file is not te
E_SEMODINS=3		# module install failure
EXITSUCCESS=0		# success exit

export param=$1

function compile(){

makefile=/usr/share/selinux/devel/Makefile
tmpfolder=/tmp/pp_rsync_backup_pol

mkdir $tmpfolder 2>/dev/null
cp $param $tmpfolder
cd $tmpfolder

make -f $makefile

semod=`ls -1 | grep pp$`

semodule -i $semod

if [ $? -ne 0 ];
then
	printf "There was an issue installing the module.. Investigate! \n"
	rm -rf $tmpfolder
	exit $E_SEMODINST
else
	printf "Installed module: \n"
	semodule -l | grep "`echo $semod | sed 's/pp//g' `"
	rm -rf $tmpfolder
	exit $EXITSUCCESS
fi
}

if [[ -z $1 || `id -u` -ne 0 ]]; 
then
	printf "Mandatory parameter or insufficient privileges .. \n"
	exit $E_PARAMOUSR
else
	test -f $1
	if [[ $? -eq 0  && "`echo $1 | grep te$`" != "" ]];
	then
		printf "All good [id=`id -u`], proceed to comipiling the SELinux module..\n"
	else
		printf "Something not quite adds up.. is the file a te file?\n"
		exit $E_FNTE
	fi
fi

compile
