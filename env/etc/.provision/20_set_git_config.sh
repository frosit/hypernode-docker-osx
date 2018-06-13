#!/usr/bin/env bash
# Set git global config

# Set git
if [ -n ${GIT_USER_NAME+x} ]; then
    echo -e "Set git user.name"
    git config --global user.name "${GIT_USER_NAME}"
fi

if [ -n ${GIT_USER_EMAIL+x} ]; then
    echo -e "Set git user.email"
    git config --global user.email "${GIT_USER_EMAIL}"
fi