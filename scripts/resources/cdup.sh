#!/bin/bash

startDir=`pwd`
targetDir=$1

while [[ "$targetDir" != "$(basename `pwd`)" ]]
do
    if [[ "/" == `pwd` ]]
    then
        echo "Couldn't find $targetDir..."
        cd $startDir
        break
    else
        cd ..
    fi
done
