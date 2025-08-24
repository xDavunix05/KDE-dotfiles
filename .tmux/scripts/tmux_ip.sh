#! /usr/bin/env bash

ip -4 addr show scope global | grep inet | awk '{print $2}' | cut -d/ -f1 | head -n1
