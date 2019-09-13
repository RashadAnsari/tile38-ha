FIND_MASTER_CMD="redis-cli -h "$REDIS_SENTINEL_HOST" -p "$REDIS_SENTINEL_PORT_NUMBER" sentinel get-master-addr-by-name "$REDIS_SENTINEL_MASTER_NAME""
echo "Sentinel command: ${FIND_MASTER_CMD}"
REDIS_SENTINEL_INFO=$(${FIND_MASTER_CMD})
if [[ "$?" == "0" ]]; then
    TILE38_MASTER_HOST=${REDIS_SENTINEL_INFO[0]}
    echo "Master host: ${TILE38_MASTER_HOST}"
    TILE38_MASTER_PORT_NUMBER=${REDIS_SENTINEL_INFO[1]}
    echo "Master port: ${TILE38_MASTER_PORT_NUMBER}"
    # todo
else 
    echo "Sentinel error ...!"
    ./tile38-server -d ./data
fi