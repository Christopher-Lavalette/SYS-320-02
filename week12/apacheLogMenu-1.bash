#!/bin/bash

# SYS-320-02
# Christopher Lavalette
# Linux Bash Apache Log Menu
# 11-10-2025

logFile="/var/log/apache2/access.log"
iocFile="ioc.txt"

# ---------- FUNCTIONS ----------

function displayAllLogs() {
    cat "$logFile"
}

function displayOnlyIPs() {
    awk '{print $1}' "$logFile" | sort | uniq -c
}

function displayOnlyPages() {
    awk '{print $7}' "$logFile" | sort | uniq -c
}

function histogram() {
    awk '{
        gsub(/\[/, "", $4);          # remove [
        split($4, t, ":");           # separate date/time
        print $1, t[1];              # print IP and date
    }' "$logFile" | sort | uniq -c
}

function frequentVisitors() {
    echo "Frequent Visitors:"
    
    # Process everything, only write final result to freq.txt
    awk '{
        gsub(/\[/, "", $4);
        split($4, t, ":");
        print $1, t[1];
    }' "$logFile" | sort | uniq -c | awk '$1 > 10' | tee freq.txt

    if [[ ! -s freq.txt ]]; then
        echo "No IPs found with more than 10 visits."
    else
        echo "Saved frequent visitor data to freq.txt"
    fi
}

function suspiciousVisitors() {
    echo "Suspicious Visitors:"
    
    if [[ ! -f "$iocFile" ]]; then
        echo "No ioc.txt found! Create one with keywords if needed: e.g., admin, login, /wp, sql, etc."
        return
    fi

    # Loads into memory, builds an array,  searches for suspicious indicators, then outputs to susp.txt (reads $iocFile then $logFile, line below is for faster functioning speed)
    matches=$(awk 'NR==FNR {ind[$0]; next} {
        for (i in ind)
            if ($0 ~ i) print $1
    }' "$iocFile" "$logFile" | sort | uniq -c)

    echo "$matches" | tee susp.txt

    if [[ -z "$matches" ]]; then
        echo "No suspicious activity found."
    else
        echo "Saved suspicious IP data to susp.txt"
    fi
}

function customDisplaySettings() {
    echo "Customize log output:"
    echo ""
    echo "Apache log format field reference:"
    echo "  1 = IP Address"
    echo "  2 = Identity (usually '-')"
    echo "  3 = Authenticated User"
    echo "  4 = Date/Time"
    echo "  5 = HTTP Method (e.g., \"GET\")"
    echo "  6 = Requested Resource Path"
    echo "  7 = Protocol (e.g., HTTP/1.1)"
    echo "  8 = Status Code (e.g., 200, 404)"
    echo "  9 = Response Size (in bytes)"
    echo ""
    read -p "Enter the field numbers to display (e.g., 1 4 6 8, (improper input results in full log output)): " fields
    echo ""

    echo "Custom View (fields: $fields)"
    echo "-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-"

    awk -v fields="$fields" '{
        n=split(fields, f)
        for (i=1; i<=n; i++) {
            printf "%s ", $f[i]
        }
        print ""
    }' "$logFile" | tail -20

    echo "---------------------------------------------"
    echo "(shows the newest 20 lines of logs)"
}

# ---------- MENU ----------
while true; do
    echo ""
    echo "Please select an option:"
    echo "[1] Display all Logs"
    echo "[2] Display only IPs"
    echo "[3] Display only Pages"
    echo "[4] Histogram"
    echo "[5] Frequent Visitors"
    echo "[6] Suspicious Visitors"
    echo "[7] Custom Display Settings"
    echo "[8] Quit"
    echo ""

    read -p "Enter your choice: " userInput
    echo ""

    case "$userInput" in
        1) echo "Displaying all logs:"; displayAllLogs ;;
        2) echo "Displaying only IPs:"; displayOnlyIPs ;;
        3) echo "Displaying only Pages:"; displayOnlyPages ;;
        4) echo "Histogram:"; histogram ;;
        5) frequentVisitors ;;
        6) suspiciousVisitors ;;
        7) customDisplaySettings ;;
        8) echo "Goodbye!"; break ;;
        *) echo "Invalid input. Please enter a number between 1 and 8." ;;
    esac
done

# Extra comment for good luck making sure this bash script runs without error!
