#!/bin/sh -l
echo "-------$2------------"
echo "Hello $1"
time=$(date)
echo "::set-output name=time::$time"
