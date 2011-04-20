#!/usr/bin/env python

import sys
from itertools import cycle
from pprint import pprint

try:
    keyword = sys.argv[1]
    pair = sys.argv[2]
    file_rdp = sys.argv[3]
    file_clc = sys.argv[4]
    file_fas = sys.argv[5]
except IndexError:
    print >> sys.stdout, \
        "Usage: %s keyword pair(0, 1) rdp clc fas" % sys.argv[0]
    quit()

# Load RDP (headers)
fasta, n = {}, 0 # Start counting at zero!
with open(file_rdp) as handle:
    for line in handle:
        if line.startswith('>'):
            if keyword.lower() in line.lower():
                # Number => Header
                fasta[n] = line[1:-1]
            n += 1 # Start counting at zero!

# Find out what to keep.
# Keep only if both pairs match the same thingie
keepers = {}
with open(file_clc) as handle:
    for line in handle:
        line = line.split()
        if line[10] is '1': # Only count paired
            fasta_number = int(line[5])
            if fasta_number in fasta:
                # Header (read) => Header (taxonomy)
                keepers[line[1]] = fasta[fasta_number]

        try: # Skip next line
            handle.next()
        except StopIteration:
            continue
                
del fasta

# Iteate through fastq file printing only reads that are to be kept.
with open(file_fas) as handle:
    n = cycle([0, 1, 2, 3])
    switch = cycle(['0', '1'])
    for line in handle:
        i = n.next()
        if i is 0:
            c = switch.next()
            keep = False
            header = line[1:-1]
            if (header in keepers) and (c in pair):
                print ">%s" % keepers[header]
                keep = True
        if (i is 1) and keep:
            print line[1:-1]
