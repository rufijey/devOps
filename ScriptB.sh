#!/bin/bash

URL="http://127.0.0.1/compute"

send_request() {
    while true; do
        echo "Sending request to $URL at $(date)"
        curl -i -X GET $URL > /dev/null 2>&1
        sleep $((RANDOM % 6 + 5)) 
    done
}


for i in {1..5}; do
    send_request &
done


wait
