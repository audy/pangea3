#!/usr/bin/env python

# Similar to clc's unassembled_reads except that it can get unassembled reads
# from a CLC output table

import sys

table = sys.argv[1]
reads = sys.argv[2]

with open(table) as handle:
    for line in handle:
        handle = line.split(-1)