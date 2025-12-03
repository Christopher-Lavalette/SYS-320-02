# SYS-320-02
# Christopher Lavalette

# Accessed through webpage, webpage html file viewable in week15 directory.
URL="http://10.0.17.27/Assignment.html"

# Get ALL <td> values
ALL=$(curl -s "$URL" | grep -oP '(?<=<td>).*(?=</td>)')

# Extract TEMPERATURE (first table, values every 2 td's) 
TEMPS=$(echo "$ALL" | head -n 10 | awk 'NR % 2 == 1')

# Extract DATES (first table, values every 2 td's)
DATES=$(echo "$ALL" | head -n 10 | awk 'NR % 2 == 0')

# Extract PRESSURE (second table, values every 2 td's) 
PRESS=$(echo "$ALL" | tail -n 10 | awk 'NR % 2 == 1')

# Count rows
COUNT=$(echo "$TEMPS" | wc -l)

echo "Temperature | Pressure | Date-Time"
echo "-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-"

# Loop using line extraction
for ((i=1; i<=COUNT; i++)); do

    TEMP=$(echo "$TEMPS"  | head -n $i | tail -n 1)
    PRESSURE=$(echo "$PRESS" | head -n $i | tail -n 1)
    DATE=$(echo "$DATES" | head -n $i | tail -n 1)

    echo "$TEMP | $PRESSURE | $DATE"
done
