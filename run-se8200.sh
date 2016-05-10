#! /bin/sh

if [ ! -d /usr/emc/API ]
then
	(cd /usr && tar zxf ./emc.tar.gz)
	rm -f /usr/emc/API/symapi/ipc/storapid
	rm -f /usr/emc/API/symapi/ipc/storgnsd
	rm -f /usr/emc/API/symapi/ipc/storwatchd
	rm -f /usr/emc/API/symapi/ipc/storevntd
fi

/tmp/se8200/se8200_install.sh -increment -silent -cert -jni -srm -smis -symrec
/opt/emc/SYMCLI/bin/symcfg discover
/opt/emc/SYMCLI/bin/symcfg list

while true
do
	sleep 300
done

exit 0
