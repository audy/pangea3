#!/usr/bin/env python
from collections import defaultdict
import sys

cluster_file, minimum = sys.argv[1], int(sys.argv[2])

counts = defaultdict(int)

with open(cluster_file) as handle:
    for line in handle:
        line = line.split()
        counts[int(line[0])] += 1
        
for count in sorted(counts):
    if counts[count] >= minimum:
        print "cluster_%s, %s" % (count, counts[count])