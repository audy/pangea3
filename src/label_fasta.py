#!/usr/bin/env python

# outputs a FASTQ file but with its filename in the header (sorta)
# Also puts paired reads together with their 5' ends touching
# This is for clustering
# Takes input from STDIN

import sys
import os
from itertools import cycle

h = os.path.basename(sys.argv[1]).split('.')[0]

# Optionally add another label
if len(sys.argv) == 2:
    add = sys.argv[1]
else:
    add = ''
    
c = cycle([0, 1])
seq = { 0: '', 1: ''}

for line in sys.stdin:
    if line.startswith('>'):
        n = c.next()
        if n == 1:
            print '%s:%s:%s' % (line.strip(), h, add)
    else:
        seq[n] += line.strip()
        if n == 1:
            print '%s%s' % (seq[1][::-1], seq[0])
            seq = { 0: '', 1: ''}
