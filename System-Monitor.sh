#!/bin/bash

while true
do
    clear
    echo "===== LINUX SYSTEM MONITOR ====="

    # Get CPU usage from top, search for the CPU usage line, then convert 100-idle% to an integer to get total current usage%
    cpu_usage=$(top -bn1 | grep "Cpu(s)" | awk '{printf "%d", 100 - $8}')

    # Create CPU bar
    cpu_bar=""
    filled=$((cpu_usage / 10)) # Get number of filled squares (10 total for 100%)
    empty=$((10 - filled)) # Get number of empty squares
    for i in $(seq 1 $filled) # Append $filled number of filled squares at the beginning of the string
        do cpu_bar+="■"
        done
    for i in $(seq 1 $empty) # Same with empty squares
        do cpu_bar+="□";
        done
    echo "CPU Usage:    $cpu_usage%   $cpu_bar"

    # Get memory usage from total memory - free memory grabbed from /proc/meminfo
    mem_total=$(grep MemTotal /proc/meminfo | awk '{print $2}')
    mem_free=$(grep MemAvailable /proc/meminfo | awk '{print $2}')
    mem_used=$((mem_total - mem_free))
    mem_percent=$((mem_used * 100 / mem_total))

    # Create memory bar (same process as CPU bar)
    mem_bar=""
    filled=$((mem_percent / 10))
    empty=$((10 - filled))
    for i in $(seq 1 $filled)
        do mem_bar+="■"
        done
    for i in $(seq 1 $empty)
        do mem_bar+="□"
        done
    echo "Memory Usage: $mem_percent%   $mem_bar"

    # Get disk usage from df, filter to total system memory, access use%, then remove the % sign to have an integer
    disk_percent=$(df / | grep '/' | awk '{print $5}' | sed 's/%//')

    # Create Disk bar (same as before)
    disk_bar=""
    filled=$((disk_percent / 10))
    empty=$((10 - filled))
    for i in $(seq 1 $filled)
        do disk_bar+="■"
        done
    for i in $(seq 1 $empty)
        do disk_bar+="□"
        done
    echo "Disk Usage:   $disk_percent%   $disk_bar"

    echo "================================"
    sleep 2
done
