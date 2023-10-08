#!/bin/sh

if [ -z "${LAUNCHED_BY_SYSTEMD}" ]; then
    echo "This script is automatically executed at boot by systemd. Quiting.."
    exit 1
fi
