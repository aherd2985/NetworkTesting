#!/bin/bash

TODAY=$(date)

MODE="all"
TARGET="8.8.8.8"
CWD=$(pwd)

# Get the options
while getopts ":h:m:t:" option; do
   case $option in
      h) # display Help
         Help
         exit;;
      m) # Set the Mode
         MODE=$OPTARG;;
      t) # Set the Target
         TARGET=$OPTARG;;
     \?) # Invalid option
         echo "Error: Invalid option"
         exit;;
   esac
done

pingSweep_meth(){
    echo "Beginning the hunt for targets"
    echo "Target is set for $TARGET"
    fping -a -g $TARGET > $DIRECTORY/pingSweep.txt
    echo "Targets saved to $DIRECTORY/pingSweep.txt"
}

portCheck_meth(){
    #nmap -T4 -sC -sV -p- --min-rate=1000 -iL $DIRECTORY/pingSweep.txt -oN nmap.txt
    echo "Reading from $CWD/$DIRECTORY/pingSweep.txt"
    input="$CWD/$DIRECTORY/pingSweep.txt"
    while read -r line
    do
        echo "Beginning full nMap scan for $line"
        nmap -T4 -sC -sV -A -p- --script smb-enum-shares -oN $DIRECTORY/nmap_$line.txt "$line"
        echo "nMap results saved to $DIRECTORY/nmap_$line.txt"
    done < "$input"
}

DIRECTORY=ServerRecon

echo "Mode is set for $MODE"

if [ -d "$DIRECTORY" ]
then
    echo "Directory already exists."
else
    echo "Creating directory $DIRECTORY"
    mkdir $DIRECTORY
fi
    
case $MODE in 
pingSweep)
    pingSweep_meth
    ;;
portCheck)
    portCheck_meth
    ;;
all)
    pingSweep_meth
    portCheck_meth
    ;;

esac







