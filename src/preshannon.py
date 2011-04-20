#!/usr/bin/env python

# Austin G. Davis-Richardson

DESCRIPTION = """"Generates files for calculating Shannon Diversity Index. 
    (Assumes that CLC reference assembly outputs results randomly)"""

import sys
import glob
import os
from random import choice

usage = '%s <reads> <filename>'

# Find barcode with least amount of PAIRS (specify this)
try:
    reads = int(sys.argv[1])*2 # "turns into pairs"
    filename = sys.argv[2]
    outfile = sys.argv[3]
except IndexError, ValueError:
    print >> sys.stderr, usage % sys.argv[0]

# Grab those reads from CLC table, make new tables.

lines = [ line.strip() for line in open(filename) ]

if len(lines) < reads:
    print >> sys.stderr, "skipping %s" % filename
    quit()    


with open(outfile, 'w') as out:
    keeps = []
    for i in range(0, reads):
        keeper = choice(lines)
        keeps.append(keeper)
        lines.remove(keeper)

    for line in keeps:
        print >> out, line.strip()

