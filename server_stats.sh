#!/bin/bash

echo "========================================="
echo "        SERVER PERFORMANCE"
echo "========================================="


# ==================================================
# CPU USAGE
# ==================================================

echo "================= CPU Usage ===================="

CPU_IDLE=$(top -bn1 | awk -F'[, ]+' '/Cpu\(s\)/ {
    for (i=1; i<=NF; i++) {
        if ($i == "id") {
            print $(i-1)
            exit
        }
    }
}')

CPU_USAGE=$(awk -v idle="$CPU_IDLE" 'BEGIN {
    printf "%.2f", 100 - idle
}')

echo "CPU Usage: $CPU_USAGE%"


# ==================================================
# MEMORY USAGE
# ==================================================

echo "================= Memory Usage ===================="

MEM_TOTAL=$(free | awk '/Mem:/ {print $2}')
MEM_USED=$(free | awk '/Mem:/ {print $3}')
MEM_FREE=$(free | awk '/Mem:/ {print $4}')

MEM_USAGE=$(awk -v used="$MEM_USED" -v total="$MEM_TOTAL" 'BEGIN {
    printf "%.2f", (used / total) * 100
}')

echo "Memory Usage: $MEM_USAGE%"
echo "Used: $MEM_USED KB"
echo "Free: $MEM_FREE KB"


# ==================================================
# DISK USAGE
# ==================================================

echo "================= Disk Usage ===================="

DISK_TOTAL=$(df -k / | awk 'NR==2 {print $2}')
DISK_USED=$(df -k / | awk 'NR==2 {print $3}')
DISK_FREE=$(df -k / | awk 'NR==2 {print $4}')
DISK_USAGE=$(df -k / | awk 'NR==2 {print $5}')

# Remove % from disk usage
DISK_USAGE_NUMBER=${DISK_USAGE%\%}

echo "Disk Usage: $DISK_USAGE"
echo "Used: $DISK_USED KB"
echo "Free: $DISK_FREE KB"


# ==================================================
# TOP 5 PROCESSES BY CPU
# ==================================================

echo "===================================================="

echo "Top 5 Processes by CPU:"

ps aux --sort=-%cpu | head -6


# ==================================================
# TOP 5 PROCESSES BY MEMORY
# ==================================================

echo "===================================================="

echo "Top 5 Processes by Memory:"

ps aux --sort=-%mem | head -6


# ==================================================
# NETWORK STATISTICS
# ==================================================

echo "===================================================="

echo "Network Statistics:"
echo "================= Network Usage ===================="

# Get default network interface
INTERFACE=$(ip route | awk '/^default/ {print $5; exit}')

if [ -n "$INTERFACE" ]; then

    RX_BYTES=$(cat "/sys/class/net/$INTERFACE/statistics/rx_bytes")
    TX_BYTES=$(cat "/sys/class/net/$INTERFACE/statistics/tx_bytes")

    echo "Interface: $INTERFACE"
    echo "Received Bytes: $RX_BYTES"
    echo "Transmitted Bytes: $TX_BYTES"

else

    echo "Network interface not found."

fi


# ==================================================
# ALERTS
# ==================================================

echo "===================================================="

echo "Alertes :"


# CPU ALERT
if awk -v cpu="$CPU_USAGE" 'BEGIN {exit !(cpu > 80)}'; then
    echo "WARNING: CPU usage is above 80%!"
fi


# MEMORY ALERT
if awk -v mem="$MEM_USAGE" 'BEGIN {exit !(mem > 80)}'; then
    echo "WARNING: Memory usage is above 80%!"
fi


# DISK ALERT
if [ "$DISK_USAGE_NUMBER" -gt 90 ]; then

    echo "CRITICAL: Disk usage is above 90%!"

elif [ "$DISK_USAGE_NUMBER" -gt 80 ]; then

    echo "WARNING: Disk usage is above 80%!"

fi


echo "===================================================="