pageCount() {
    # Check if a log file is provided, continues if true
    if [ -z "$1" ]; then
        echo "Usage: pageCount <access_log_file>"
        return 1
    fi

    logfile="$1"

    # Extract page names from log, count occurrences, and sort by frequency, similar to the webscraping CHamplain Courses  powershell assignment
    awk '{print $7}' "$logfile" | sort | uniq -c | sort -nr
}
# Runs function upon start by inputting 'sudo bash getlogrecord.bash"
pageCount /var/log/apache2/access.log
