LOG="/var/log/apache2/access.log"
PAGE="${1:-page2.html}"
OUTFILE="$2"

if [ ! -r "$LOG" ]; then
  echo "Error: cannot read $LOG" >&2
  exit 1
fi

if [ -n "$OUTFILE" ]; then
  grep "GET /$PAGE " "$LOG" | cut -d' ' -f1,7 | tr -s ' ' | tr -d '/' | tee "$OUTFILE"
else
  grep "GET /$PAGE " "$LOG" | cut -d' ' -f1,7 | tr -s ' ' | tr -d '/'
fi
