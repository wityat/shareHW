#!/bin/bash
if ! [[ ($(date  +%d) == 13 && $(date  +%u) == 5) || ($(date  +%d) == 1 && $(date  +%m) == 1) ]]; then
	killall -TSTP smbd
	tar zcf /files/backup-$(date +%Y-%m-%d).tar.gz /files/*.html
	killall -CONT smbd
fi