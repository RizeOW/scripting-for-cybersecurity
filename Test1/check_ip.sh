#!/bin/bash

if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <ip_address>" >&2
    exit 1
fi

IP="$1"

if [[ ! "$IP" =~ ^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
    echo "Error: '$IP' does not look like an IPv4 address" >&2
    exit 1
fi

AUTH_LOG="exam-data/case/logs/auth.log"
IOC_FILE="exam-data/intel/iocs.txt"
FIREWALL_LOG="exam-data/case/logs/firewall.log"
LOG_DIR="exam-data/case/logs"

FAILED=$(grep -wF "$IP" "$AUTH_LOG" | grep -c "Failed password")
ACCEPTED=$(grep -wF "$IP" "$AUTH_LOG" | grep -c "Accepted password")

echo "IP: $IP"
echo "Failed password: $FAILED"
echo "Accepted password: $ACCEPTED"

if [ "$FAILED" -eq 0 ]; then
    RISK="NONE"
elif [ "$FAILED" -le 4 ]; then
    RISK="LOW"
elif [ "$FAILED" -le 9 ]; then
    RISK="MEDIUM"
else
    RISK="HIGH"
fi

echo "Risk: $RISK"

if grep -qxF "$IP" "$IOC_FILE"; then
    echo "IOC: yes"
else
    echo "IOC: no"
fi

FIREWALL=$(grep -wF "$IP" "$FIREWALL_LOG")

if [ -n "$FIREWALL" ]; then
    echo "$FIREWALL"
else
    echo "Firewall: no entries"
fi

if [ "$FAILED" -gt 0 ] && [ "$ACCEPTED" -gt 0 ]; then
    echo "WARNING: successful login after failed attempts"
fi

if grep -R -qwF "$IP" "$LOG_DIR"; then
    exit 0
else
    exit 3
fi
