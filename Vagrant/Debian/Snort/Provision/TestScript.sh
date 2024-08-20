#!/bin/bash

echo "Running Script"

SERVICE_NAME="snort"

total_ram=$(free -m | awk '/Mem:/ {print $2}')

logfile="/home/vagrant/memory_usage_log_${total_ram}MB.csv"

sleep 10

duration=600 # 10 min
interval=30 # 30 seconden

if [ -f "$logfile" ]; then
    echo "Log file $logfile already exists. Removing it."
    rm "$logfile"
fi

echo "Timestamp,Total_MB,Used_MB,Free_MB,Shared_MB,Buffers_MB,Available_MB,Swap_Total_MB,Swap_Used_MB,Swap_Free_MB" > "$logfile"

iterations=$((duration / interval))

echo "Gathering info."

for ((i=0; i<iterations; i++)); do

    if ! pgrep -x "snort" > /dev/null; then
        echo "Snort is not running. Exiting script."
        echo "Snort was not running" > "$logfile"

        cp "$logfile" /vagrant/Results/
        exit 0
    fi

    echo "snort is running. Proceeding with memory monitoring."

    timestamp=$(date '+%Y-%m-%d %H:%M:%S')

    memory_usage=$(free -m | awk 'BEGIN{ORS=","} /Mem:/{print $2 "," $3 "," $4 "," $5 "," $6 "," $7} /Swap:/{print $2 "," $3 "," $4}')

    echo "$timestamp,$memory_usage" >> "$logfile"

    echo "$timestamp"

    sleep "$interval"
done

echo "Memory monitoring completed. Results saved to $logfile"

{
    echo ""
    echo "Averages:"
    awk -F, '
        NR > 1 {
            total_mb += $2
            used_mb += $3
            free_mb += $4
            shared_mb += $5
            buffers_mb += $6
            available_mb += $7
            swap_total_mb += $8
            swap_used_mb += $9
            swap_free_mb += $10
            count++
        }
        END {
            if (count > 0) {
                printf "Average Total_MB: %.2f\n", total_mb / count
                printf "Average Used_MB: %.2f\n", used_mb / count
                printf "Average Free_MB: %.2f\n", free_mb / count
                printf "Average Shared_MB: %.2f\n", shared_mb / count
                printf "Average Buffers_MB: %.2f\n", buffers_mb / count
                printf "Average Available_MB: %.2f\n", available_mb / count
                printf "Average Swap Total_MB: %.2f\n", swap_total_mb / count
                printf "Average Swap Used_MB: %.2f\n", swap_used_mb / count
                printf "Average Swap Free_MB: %.2f\n", swap_free_mb / count
            } else {
                print "No data to process."
            }
        }
    ' "$logfile" >> "$logfile"
}  

echo "Average calculation completed and appended to $logfile"

# Nmap test
cp "$logfile" /vagrant/Results/

# SQL test
cp "$logfile" /vagrant/Results/SQL/