#!/bin/bash
DEPLOY_WAIT=10
docker-compose up -d tile38-1
sleep ${DEPLOY_WAIT}
docker-compose up -d sentinel-1
sleep ${DEPLOY_WAIT}
docker-compose up -d tile38-2 tile38-3 sentinel-2 sentinel-3
sleep ${DEPLOY_WAIT}
docker-compose up -d haproxy

sleep 60

# After bellow command, you can see that tile38 master change after 1 minute
# None: You can config master change time in sentinel config
docker rm -f tile38-1
