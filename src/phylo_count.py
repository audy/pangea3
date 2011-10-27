#!/usr/bin/env python
# Austin G. Davis-Richardson

# CLC Ref Assembly + RDP => Description, number of reads

# How to:

# Python <fasta> <clc table>

''' 
  Print information about each match in an assembly file. The columns are:

    0 Read number
    1 Read name (enable using the `-n' option)
    2 Read length
    3 Read position for alignment start
    4 Read position for alignment end
    5 Reference sequence number
    6 Reference position for alignment start
    7 Reference position for alignment end
    8 Whether the read is reversed (0 = no, 1 = yes)
    9 Number of matches
    10 Whether the read is paired with the next one (0 = no, 1 = yes) (enable
                                                          using the `-p' option
    11 Alignment score (enable using the `-s' option)

'''
import sys
from collections import defaultdict
from glob import glob

# rdp file, prefix to tables
f_rdp, prefix = sys.argv[1:]

# counts
paired_matches = defaultdict(int)

# load RDP; we need random access!
rdp, c = {}, 0
with open(f_rdp) as handle:
    for line in handle:
        if line.startswith('>'):
            rdp[c] = line[1:-1]
            c += 1
rdp[-1] = 'UNCLASSIFIED'

def compute_lca(a, b):
    ''' compute the last common ancestor given two strings '''
    first_name = a.split(';')
    second_name = b.split(';')
    consensus = []

    for f, s in zip(first_name, second_name):
        if f == s:
            consensus.append(f)
        else:
            break
    return ';'.join(consensus)

for f_db in glob(prefix):

    print '==> %s <==' % f_db

    with open(f_db) as handle:
        for line in handle:
            line = line.split()
            next_line = handle.next().split()

            # get RDP record numbers
            a_no = int(line[5])
            b_no = int(next_line[5])

            # get names
            a_name = rdp[a_no]
            b_name = rdp[b_no]

            # get last common ancestor
            lca = compute_lca(a_name, b_name)

            paired_matches[lca] += 1

    with open('%s.paired.out' % f_db, 'w') as handle:
        for c in paired_matches:
            print >> handle, "%s, %s" % (c.replace(',', '_'), paired_matches[c])
