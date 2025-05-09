#!/bin/bash

while true
do
    clear
    # Print top border in magenta
    echo -e "\e[35m===== LINUX SYSTEM MONITOR =====\e[0m"

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
    # Print the title in blue; if usage is above 50%, print usage in red, and otherwise print in green
    if [ $cpu_usage -ge 50 ]
    then echo -e "\e[34mCPU Usage:      \e[31m$cpu_usage%   $cpu_bar\e[0m"
    else echo -e "\e[34mCPU Usage:      \e[32m$cpu_usage%   $cpu_bar\e[0m"
    fi

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
    # Print the title in yellow; otherwise follow CPU warning color
    if [ $mem_percent -ge 50 ]
    then echo -e "\e[33mMemory Usage:   \e[31m$mem_percent%   $mem_bar\e[0m"
    else echo -e "\e[33mMemory Usage:   \e[32m$mem_percent%   $mem_bar\e[0m"
    fi

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
    # Print the title in cyan; otherwise follow CPU warning color
    if [ $disk_percent -ge 50 ]
    then echo -e "\e[36mDisk Usage:    \e[31m$disk_percent%   $disk_bar\e[0m"
    else echo -e "\e[36mDisk Usage:    \e[32m$disk_percent%   $disk_bar\e[0m"
    fi

    # Get name of process with highest usage and output in red
    # Grabs data from 8th line of top, which includes information about the process consuming the most CPU time
    highest_usage=$(top -bn1 | awk 'NR==8 {print $12}')
    echo -e "\e[31mHighest Usage From: $highest_usage"

    # Print bottom border in magenta
    echo -e "\e[35m================================\e[0m"
    
    # Get current date and time and output all to CSV log file
    current_date_time="`date +%Y%m%d%H%M%S`"
    echo "$current_date_time,$cpu_usage,$mem_percent,$disk_percent,$highest_usage" >> Monitor-Log.csv

    # Delay two seconds between readings
    sleep 2
done
