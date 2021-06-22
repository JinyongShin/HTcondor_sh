#!bin/bash

for dir in $(ls -ld /x4/cms/jyshin/TT_Had/* | grep "^d" | awk '{print $9}') ;do
	ls -d $dir/events*.lhe > `basename $dir`.list
	source delphes_sub.sh `basename $dir`.list
	echo "done"
#	break
done

