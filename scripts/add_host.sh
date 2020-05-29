#!/bin/env bash
#
#

if [[ $(grep -q $1 /etc/hosts) ]]; then
    echo -e "\nThe IP Address provided ($1) exists already in the /etc/hosts file."
    exit 1
fi

if [[ $(grep -q $2 /etc/hosts) ]]; then
    echo -e "\nThe hostname provided ($2) exists already in the /etc/hosts file."
    exit 1
fi

echo -ne "$1\t$2" >> /etc/hosts
