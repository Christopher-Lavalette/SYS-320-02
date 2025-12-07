#!/bin/bash

url="http://10.0.17.27/IOC.html"

page=$(curl -s "$url")

# Extract lines ending in <br>
echo "$page" | sed -n 's/\(.*\)<br>/\1/p' > IOC.txt

# Remove empty lines
sed -i '/^\s*$/d' IOC.txt

echo "IOC saved to IOC.txt”
