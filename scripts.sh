#!/bin/bash

get_cpu_usage(){
        echo "CPU Usage:"
        mpstat | awk '$12 ~ /[0-9.]+/ { print 100 -$12"% used" }'
}


get_memory_usage(){
        echo "Memory Usage:"
        free -m | awk 'NR==2{printf "Memory Usage: %s/%sMB (%.2f%%)\n", $3,$2,$3*100/$2 }'
}

get_disk_usage(){
        echo "Disk Usage:"
        df -h --total | awk 'END{print "Used: "$3", Free: "$4", Usage: "$5}'
    echo ""

}

get_top_cpu_processes(){
        echo "Top % processes by CPU Usage:"
        ps -eo pid,ppid,cmd,%mem,%cpu --sort=-%cpu | head -n 6
        echo ""
}

get_extra_stats(){
        echo "OS Versions:"
        lsb_release -a 2>/dev/null || /etc/os-release
        echo ""

        echo "Uptime:"
        uptime
        echo ""

        echo "Load Average:"
        cat /proc/loadavg
        echo ""

        echo " Logged in users:"
        who
        echo ""

}
main(){
        echo "Server Performance Stats "
        echo "-------------------------------"
        get_cpu_usage
        get_memory_usage
        get_disk_usage
        get_top_cpu_processes
        get_extra_stats
        echo " --------------------------------"
main
