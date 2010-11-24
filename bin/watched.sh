#! /bin/bash

watched="$1"
shift
 
function getTime {
    ls --full-time $watched | awk '{ print $6 $7 }'
}
 
filetime=`getTime`
while true
     do lfiletime="$filetime"
	filetime=`getTime`
	if [[ "$lfiletime" != "$filetime" ]]
            then $@  ## Run the remainder of the commandline.
		 filetime=`getTime`
	fi
	sleep 0.1
        done

edit 
