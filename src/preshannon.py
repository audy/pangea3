#!/usr/bin/env python

# Austin G. Davis-Richardson

DESCRIPTION = """"Generates files for calculating Shannon Diversity Index. 
    (Assumes that CLC reference assembly outputs results randomly)"""

import sys
import glob
import os

usage = '%s <reads> <filename>'

# Find barcode with least amount of reads (specify this)
try:
    reads = int(sys.argv[1]) # User specified, for now.
    filename = sys.argv[2]
except IndexError, ValueError:
    print >> sys.stderr, usage % sys.argv[0]

# Grab those reads from CLC table, make new tables.

c = 0
with open(filename) as handle:
    for line in handle: # 1 line = 1 read.
        c += 1 # start counting at 1
        if c >= reads:
            break # start a new one.
        else:
            print line.strip()

if not (c >= reads):
    print >> sys.stderr, "Error, %s < %s (%s)" % (reads, c, filename)