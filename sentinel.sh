#!/bin/sh
# Sentinel rewrites its config file at runtime, so generate a writable one.
cat > /tmp/sentinel.conf <<CONF
port 26379
sentinel resolve-hostnames yes
sentinel monitor ${REDIS_MASTER_SET:-mymaster} ${REDIS_MASTER_HOST} ${REDIS_MASTER_PORT_NUMBER} ${REDIS_SENTINEL_QUORUM:-2}
sentinel down-after-milliseconds ${REDIS_MASTER_SET:-mymaster} ${REDIS_SENTINEL_DOWN_AFTER_MILLISECONDS:-60000}
sentinel failover-timeout ${REDIS_MASTER_SET:-mymaster} ${REDIS_SENTINEL_FAILOVER_TIMEOUT:-180000}
CONF
exec redis-sentinel /tmp/sentinel.conf
