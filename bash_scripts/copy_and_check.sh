#!/bin/bash

dest=$2/${1##.*/}
if [[ -d $1 ]]
then
    cp -rf $1 $dest 
elif [[ -e $1 ]]
then
    cp $1 $dest
fi

sum1=$(find $1 -type f -exec sha1sum "{}" \; | awk '{print $1}' | sha1sum)
sum2=$(find $dest -type f -exec sha1sum "{}" \; | awk '{print $1}' | sha1sum)

while [[ $sum1 != $sum2 ]]
do
    rm -r $dest
    cp -rf $1 $dest
    sum1=$(find $1 -type f -exec sha1sum "{}" \; | awk '{print $1}' | sha1sum)
    sum2=$(find $dest -type f -exec sha1sum "{}" \; | awk '{print $1}' | sha1sum)
done

echo -e "$(readlink -f $1) -> $(readlink -f $dest)\ttrue"
rm -rf $1 && [[ ! -e $1 ]] && echo "$(readlink -f $1) removed"
