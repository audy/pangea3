#!/usr/bin/env python

# Counts reads per hit in RDP database given the RDP database and the CLC
# reference assembly output!

# Usage: python count_unpaired.py <database> <clc table> > out.csv

import sys
from collections import defaultdict

rdp, c = {}, 0
with open(sys.argv[1]) as handle:
    for line in handle:
        if line.startswith('>'):
            c += 1
            rdp[c] = line[1:-1]
            
with open(sys.argv[2]) as handle: # CLC Output
    hits = defaultdict(int)
    for line in handle:
        line = line.split()
        try:
            line[1]
        except IndexError:
            print "bad line: %s" % line
            quit()
        c = int(line[5])
        if c in rdp:
            hits[rdp[c]] += 1
            
for hit in hits:
    print "%s, %s" % (hit, hits[hit])