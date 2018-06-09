#!/usr/bin/env bash
# Login to docker shell
# =====================

CURRENTDIR=$( dirname "$0")

# load env vars
export $(egrep -v '^#' ${CURRENTDIR}/../.env | xargs)

ssh -A ${1}@127.0.0.1 -p ${COMPOSE_PORT_SSH}