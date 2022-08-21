#! /bin/bash

# Usage: battery-logger.sh
#
# Goal: Do a snapshot of battery characteristics.
#       Can be used to track battery health.

BATTERY_DIR="${HOME}/battery"
BATTERY_LOG="${BATTERY_DIR}/$(date '+%F:%T').log"

mkdir -p "${BATTERY_DIR}"
grep . /sys/class/power_supply/BAT0/* 2>/dev/null > "${BATTERY_LOG}"
