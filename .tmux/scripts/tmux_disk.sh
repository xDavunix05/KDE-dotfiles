#!/usr/bin/env bash

df -P -h / | awk 'NR==2 {print $3 "/" $2}'
