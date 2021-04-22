#!/bin/bash

# https://stackoverflow.com/questions/18755967/how-to-make-a-program-that-finds-ids-of-xinput-devices-and-sets-xinput-some-set
ids=$(xinput --list | grep Keychron | awk -v search="keyboard" \
                          '$0 ~ search {match($0, /id=[0-9]+/);\
                  if (RSTART) \
                    print substr($0, RSTART+3, RLENGTH-3)\
                 }'\
   )

for id in $ids
do
    setxkbmap -device $id -layout us -option ctrl:nocaps
done
