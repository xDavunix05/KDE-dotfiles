#! /usr/bin/env bash
uptime -p | sed 's/^up //; s/ hours\\?/h/; s/ minutes\\?/m/; s/,//g; s/\\([0-9]\\)h/0\\1h/; s/ \\([0-9]\\)m/ 0\\1m/'
