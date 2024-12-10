#!/bin/bash

# Given a log.txt generated by running benchmarks, filter out the NOT IMPELMENTED lines

OUT="missing.txt"

cat $1 | grep "NOT IMPLEMENTED" | sort | uniq >$OUT