#!/bin/bash                                                                                                        
# Can put this into i3 bar
# count how many updates we have got
ups=`/usr/lib/update-notifier/apt-check --human-readable | head -1 | awk '{print $1;}'`

# print the results
if [ "$ups" -eq "1" ]
then
  echo "1 update"
elif [ "$ups" -gt "1" ]
then
  echo "$ups updates"
else
  echo "No Updates"
fi

