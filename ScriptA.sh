#!/bin/bash

DOCKER_IMAGE="alekstikhonov/classaserver-multi-architecture"
CPU_AFFINITY=(0 1 2)
INSTANCE_NAMES=("serv1" "serv2" "serv3")
PORTS=(8081 8082 8083)
INTERVAL=10
LOAD_THRESHOLD_HIGH=70
LOAD_THRESHOLD_LOW=2

start_instance() {
    local name=$1
    local cpu=$2
    local port=$3
    
    echo "Starting container: $name on core $cpu, mapped to port $port..."
    docker run -d --name "$name" --rm --cpuset-cpus="$cpu" -p "$port:8081" "$DOCKER_IMAGE" > /dev/null 2>&1
    sleep 5
}

stop_instance() {
    local name=$1
    echo "Stopping container: $name..."

    docker stop "$name" > /dev/null 2>&1
    sleep 2
    if ! docker ps --filter "name=$name" --quiet | grep -q .; then
        echo "Container $name stopped successfully. Removing..."
        docker rm "$name" > /dev/null 2>&1
    else
        echo "Failed to stop container $name. Retrying..."
        docker stop "$name" > /dev/null 2>&1
        sleep 2
        docker rm -f "$name" > /dev/null 2>&1
    fi
}
remove_existing_containers() {
    for name in "${INSTANCE_NAMES[@]}"; do
        if docker ps -a --filter "name=$name" --quiet | grep -q .; then
            echo "Removing existing container: $name"
            docker rm -f "$name"
        fi
    done
}

get_cpu_usage() {
    local name=$1
    docker stats --no-stream --format "{{.CPUPerc}}" "$name" | sed 's/%//'
}

update_image() {
    echo "Checking image updates..."
    if docker pull "$DOCKER_IMAGE" | grep -q "Downloaded newer image"; then
        echo "Image updated. Restarting containers sequentially..."
        for i in "${!INSTANCE_NAMES[@]}"; do
            local instance="${INSTANCE_NAMES[i]}"
            if docker ps --filter "name=$instance" --quiet | grep -q .; then
                echo "Updating container: $instance"
                stop_instance "$instance"
                start_instance "$instance" "${CPU_AFFINITY[i]}" "${PORTS[i]}"
            fi
        done
    fi
}

manage_instances() {
    local active_instances=("${INSTANCE_NAMES[0]}")
    
    remove_existing_containers
    
    start_instance "${INSTANCE_NAMES[0]}" "${CPU_AFFINITY[0]}" "${PORT_MAPPING[0]}"

    while true; do
        for i in "${!INSTANCE_NAMES[@]}"; do
            local instance="${INSTANCE_NAMES[i]}"
            if docker ps --filter "name=$instance" --quiet | grep -q .; then
                local load
                load=$(get_cpu_usage "$instance")
                echo "$instance: CPU usage is $load%"

                if (( $(echo "$load > $LOAD_THRESHOLD_HIGH" | bc -l) )) && [[ $i -lt 2 ]]; then
                    local next_instance="${INSTANCE_NAMES[i+1]}"
                    if ! [[ " ${active_instances[*]} " =~ " $next_instance " ]]; then
                        start_instance "$next_instance" "${CPU_AFFINITY[i+1]}" "${PORTS[i+1]}"
                        active_instances+=("$next_instance")
                    fi
                fi

                if (( $(echo "$load < $LOAD_THRESHOLD_LOW" | bc -l) )) && [[ $i -gt 0 ]]; then
                    echo "$instance is idle. Shutting it down..."
                    stop_instance "$instance"
                    active_instances=("${active_instances[@]/$instance}")
                fi
            fi
        done
	
	update_image

   sleep "$INTERVAL"
   done
}

main() {
    echo "Initializing container management..."
    manage_instances
}

main
