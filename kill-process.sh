#!/usr/bin/env bash
echo "killing the process"
kill $( ps -ef | grep mitm |  grep -v grep | head -n 10 | awk '{print $2}')
