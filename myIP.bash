ip addr show | grep "inet " | awk '{print$2}' | cut -d/ -f1 | grep -v "127.0.0.1"

