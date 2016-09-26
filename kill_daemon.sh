#!/bin/bash 

pid=$(ps -ef | grep daemon_sample.pl | grep -v grep | awk '{print $2}')
[[ ! -z $pid ]] && kill -9 $pid
[[ ! -z $pid ]] && [[ -z $(ps -ef | grep daemon_sample.pl | grep -v grep) ]] && echo "Killed $pid"
