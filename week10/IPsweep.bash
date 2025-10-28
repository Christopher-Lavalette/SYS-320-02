prefix=$1

# Verify input
if [ -z "$prefix" ]; then
    echo "Usage: bash IPSweep.bash <prefix>"
    echo "Example: bash IPSweep.bash 10.0.17"
    exit 1
fi

# Verify prefix length
if [ ${#prefix} -lt 5 ]; then
    echo "Prefix length is too short"
    echo "Example: 10.0.17"
    exit 1
fi

# Main sweep loop
for i in {1..254}; do
    ip="${prefix}.${i}"
    ping -c 1 -W 1 "$ip" > /dev/null 2>&1
    if [ $? -eq 0 ]; then
        echo "$ip is up"
    fi
done

