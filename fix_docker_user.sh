#!/bin/bash
set -e

# This script is based on the one by Hongli Lai from https://www.joyfulbikeshedding.com/blog/2021-03-15-docker-and-the-host-filesystem-owner-matching-problem.html
# His code for the same solution is at https://github.com/FooBarWidget/matchhostfsowner

if [[ -z "$HOST_UID" ]]; then
    echo "ERROR: please set HOST_UID" >&2
    exit 1
fi

if [[ -z "$HOST_GID" ]]; then
    echo "ERROR: please set HOST_GID" >&2
    exit 1
fi

# Use this code if you want to create a new user account:
#adduser --uid "$HOST_UID" --gid "$HOST_GID" --gecos "" --disabled-password coder

# you may need this
# addgroup --gid "$HOST_GID" coder 

# -OR-
# Use this code if you want to modify an existing user account:
# groupmod --gid "$HOST_GID" coder
usermod --uid "$HOST_UID" coder

chown coder /home/coder
chown coder /home/coder/ccc

# Drop privileges and execute next container command, or 'bash' if not specified.
if [[ $# -gt 0 ]]; then
    exec sudo -H -u coder -- "$@"
else
    exec sudo -H -u coder -- bash
fi

