if [ ${TILE38_REPLICATION_ENABLED} = "true" ]; then
    FIND_MASTER_CMD="redis-cli -h "${REDIS_SENTINEL_HOST}" -p "${REDIS_SENTINEL_PORT_NUMBER}" sentinel get-master-addr-by-name "${REDIS_SENTINEL_MASTER_NAME}""
    REDIS_SENTINEL_INFO="$(${FIND_MASTER_CMD})"
    if [ $? -eq 0 ]; then
        TILE38_MASTER_HOST=$(echo "${REDIS_SENTINEL_INFO}" | head -1)
        echo "Master host: ${TILE38_MASTER_HOST}"
        TILE38_MASTER_PORT_NUMBER=$(echo "${REDIS_SENTINEL_INFO}" | head -2 | tail -1)
        echo "Master port: ${TILE38_MASTER_PORT_NUMBER}"
        echo "Starting Tile38 with slave rule ...!"
        ./tile38-server -d ./data &
        TILE38_PID=$(echo $!)
        sleep 5 # wait for starting Tile38 server
        ./tile38-cli --raw follow ${TILE38_MASTER_HOST} ${TILE38_MASTER_PORT_NUMBER}
        wait ${TILE38_PID}
    else
        echo "Sentinel error ...!"
        echo "Starting Tile38 with master rule ...!"
        ./tile38-server -d ./data
    fi
else
    echo "Starting Tile38 ...!"
    ./tile38-server -d ./data
fi
