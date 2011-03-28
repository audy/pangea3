#!/usr/bin/env python

import sys
from collections import defaultdict

first = sys.argv[1]
second = sys.argv[2]

merged_table = defaultdict(dict)
all_headers = set()

for filename in [first, second]:
    with open(filename) as handle:
        headers = handle.next().rstrip('\n').split('\t')
        for i in headers:
            all_headers.add(i)
            
        for line in handle:
            line = line.rstrip('\n').split('\t')
            x = line[0]
            for n, c in enumerate(line[1:]):
                y = headers[n]
                merged_table[x][y] = c

sorted_headers = sorted(all_headers)

for h in sorted_headers:
    print "\t%s" % h,
print ''
 
for i in merged_table:
    print "%s\t" % i,
    for header in sorted_headers:
        if header in merged_table[i]:
            print "%s\t" % merged_table[i][header],
        else:
            print '0\t',
    print ''