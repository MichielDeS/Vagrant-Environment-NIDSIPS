#!/bin/bash

echo "Running Script"

# Define the service check command
check_COMMAND="sudo /opt/zeek/bin/zeekctl status"

# Define the service name
SERVICE_NAME="zeek"

# Get total RAM in MB
total_ram=$(free -m | awk '/Mem:/ {print $2}')

# Dynamic log file name
logfile="/home/vagrant/memory_usage_log_${total_ram}MB.csv"

# Delay to allow $SERVICE_NAME time to start
sleep 10

# Duration and interval settings
duration=600 # Time in Seconds
interval=30 # 30 seconds interval

# Check if the log file already exists and remove it
if [ -f "$logfile" ]; then
    echo "Log file $logfile already exists. Removing it."
    rm "$logfile"
fi

# Add CSV headers to the log file including Swap Memory
echo "Timestamp,Total_MB,Used_MB,Free_MB,Shared_MB,Buffers_MB,Available_MB,Swap_Total_MB,Swap_Used_MB,Swap_Free_MB" > "$logfile"

# Calculate the number of iterations based on the duration and interval
iterations=$((duration / interval))

echo "Gathering info."

# Loop to capture memory usage
for ((i=0; i<iterations; i++)); do
    # Check if SERVICE is running
    if ! $check_COMMAND | grep -q "running"; then
        echo "$SERVICE_NAME is not running. Exiting script."
        echo "$SERVICE_NAME was not running" > "$logfile"

        # Copy the log file to the shared folder
        cp "$logfile" /vagrant/Results/
        exit 0
    fi

    echo "$SERVICE_NAME is running. Proceeding with memory monitoring."
    # Get the current timestamp
    timestamp=$(date '+%Y-%m-%d %H:%M:%S')

    # Capture memory usage including swap using free -m and ensure all data is captured in a single line
    memory_usage=$(free -m | awk 'BEGIN{ORS=","} /Mem:/{print $2 "," $3 "," $4 "," $5 "," $6 "," $7} /Swap:/{print $2 "," $3 "," $4}')

    # Append the timestamp and memory usage to the log file
    echo "$timestamp,$memory_usage" >> "$logfile"

    echo "$timestamp"

    # Wait for the specified interval
    sleep "$interval"
done

echo "Memory monitoring completed. Results saved to $logfile"

# Calculate averages and append to the log file
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
#cp "$logfile" /vagrant/Results/

# SQL test
cp "$logfile" /vagrant/Results/SQL/