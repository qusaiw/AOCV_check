#!/usr/bin/env bash
file="AOCV_list"
lib=()
pvt=()
h=""
files=()
under_score="_"
# Reads the lines from the provided file and makes 2 lists: Libs and PVTs
while IFS= read -r line
do
    if [ $line = "LIBs" ]; then
        h="LIB"
	continue
    fi
    if [ $line = "PVTs" ]; then
        h="PVT"
	continue
    fi
    if [ $h = "LIB" ]; then
        lib+=("$line")
    fi
    if [ $h = "PVT" ]; then
        pvt+=("$line")
    fi
done <"$file"

# makes a "files" list that has all the lib_pvt combinations based on the list
for i in "${lib[@]}"
do
    for l in "${pvt[@]}"
    do
        files+=("$i$under_score$l")
    done
done

# deletes the result file in case it WAS GENERATED from previous runs and creates a new one starting with "Results file"
rm result
echo "Results file" > result
for i in "${files[@]}"
do
    count=$(ls AOCV*/$i.aocv | wc -l)
    if [ "$count" -eq 1 ]; then
        ls_command=$(ls AOCV*/$i.aocv)
        echo "$ls_command" >> result
        grep object_spec $ls_command | wc -l >> result
    elif [ "$count" -gt 1 ]; then
        ls_command=$(ls AOCV*/$i.aocv)
        echo "***$i is in $count folders***"
	echo "$ls_command"
        for file in $ls_command
	do
	    echo "$file" >> result
	    grep object_spec $file | wc -l >> result
	done
	echo "***WARNING: the previous $count lines are for the same PVT***" >> result
    else
        echo "$i" >> result
        echo "NO folder" >> result
    fi
done
