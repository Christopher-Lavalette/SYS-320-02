countingCurlAccess() {
    # Check if a log file is provided
    if [ -z "$1" ]; then
        echo "Usage: countingCurlAccess <access_log_file>"
        return 1
    fi

    logfile="$1"

    echo "Counting all curl accesses by IP address:"
    echo "--------------------------------------------"

    # Find lines with curl, extract IPs, count occurrences
    grep "curl" "$logfile" | awk '{print $1}' | sort | uniq -c | sort -nr
}

countingCurlAccess /var/log/apache2/access.log
