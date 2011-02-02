#!/usr/bin/env python

# outputs a FASTQ file but with its filename in the header (sorta)

import sys
import os

h = os.path.basename(sys.argv[1]).split('.')[0]

# Optionally add another label
if len(sys.argv) == 3:
    add = sys.argv[2]
else:
    add = ''

with open(sys.argv[1]) as handle:
    for line in handle:
        if line.startswith('>'):
            print '%s:%s' % (line.strip(), h, add)
        else:
            print line.strip()