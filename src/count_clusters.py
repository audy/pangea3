#!/usr/bin/env python
from collections import defaultdict
import sys
cluster_file = sys.argv[1]

counts = defaultdict(int)

with open(cluster_file) as handle:
    for line in handle:
        line = line.split()
        counts[int(line[0])] += 1
        
for count in sorted(counts):
    print "cluster_%s, %s" % (count, counts[count])