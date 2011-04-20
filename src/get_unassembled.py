#!/usr/bin/env python

# Similar to clc's unassembled_reads except that it can get unassembled reads
# from a CLC output table

import sys
from itertools import cycle

c = cycle([1, 2, 3, 4])

table = sys.argv[1]
reads = sys.argv[2]

unassembled = set()

with open(table) as handle:
    for line in handle:
        line = line.split()
        if line[2] == '-1': # unassembled
            # we want this 
            unassembled.add(line[1]) # This takes care of pairs!
        else: # assembled
            pass
        
# Print unassembled reads in FASTA format!
# Also, we need to fix the headers        

# Print output in FASTA format!

with open(reads) as handle:
    keep = False
    for line in handle:
        n = c.next()
        if n == 1:
            keep = False
            if line[1:-1] in unassembled:
                keep = True
                print ">%s" % line[1:-1]
        elif keep and (n == 2):
            print line.strip()
