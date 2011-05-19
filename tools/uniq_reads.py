# Counts the number of unique reads in a fastQ file

import sys
from itertools import cycle

c = cycle([0,1,2,3])
n = c.next()
seqs = []

with open(sys.argv[1]) as handle:
  for line in handle:
    if n == 1:
      seqs.append(line.strip())
    n = c.next()

total = len(seqs)
unique = len(set(seqs))

print "%s total, %s unique (%0.5f) unique" % (total, unique, 100*unique/float(total))
