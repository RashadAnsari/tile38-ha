#!/bin/bash
if [ ${TILE38_REPLICATION_ENABLED} = "true" ]; then
    FIND_MASTER_CMD="redis-cli -h "${REDIS_SENTINEL_HOST}" -p "${REDIS_SENTINEL_PORT_NUMBER}" sentinel get-master-addr-by-name "${REDIS_SENTINEL_MASTER_NAME}""
    REDIS_SENTINEL_INFO="$(${FIND_MASTER_CMD})"
    if [ $? -eq 0 ]; then
        TILE38_MASTER_HOST=$(echo "${REDIS_SENTINEL_INFO}" | head -1)
        TILE38_MASTER_PORT_NUMBER=$(echo "${REDIS_SENTINEL_INFO}" | head -2 | tail -1)
        wget ${TILE38_MASTER_HOST}:${TILE38_MASTER_PORT_NUMBER}/ping
        if [ $? -eq 0 ]; then
#             mkdir -p data
#             echo "{
#                     \"follow_host\": \"${TILE38_MASTER_HOST}\",
#                     \"follow_port\": ${TILE38_MASTER_PORT_NUMBER}
#                 }" > data/config
#            ./tile38-server -d ./data
            echo "Starting Tile38 with slave role!"
            ./tile38-server -d ./data &
            TILE38_PID=$(echo $!)
            sleep 5
            ./tile38-cli --raw follow ${TILE38_MASTER_HOST} ${TILE38_MASTER_PORT_NUMBER}
            wait ${TILE38_PID}
        else
            echo "Failed to ping Tile38 master!"
            exit 1
        fi
    else
        echo "Failed to find any Tile38 master node from Sentinel!"
        echo "Starting Tile38 with master role!"
        ./tile38-server -d ./data
    fi
else
    echo "Starting Tile38!"
    ./tile38-server -d ./data
fi
