import sys
from collections import defaultdict
from pprint import pprint
clust_file = sys.argv[1]
#fasta_file = sys.argv[2]
cutoff = int(sys.argv[2])

# Read CLUST File

counts = {}

with open(clust_file) as handle:
    for line in handle:
        if line.startswith('>'):
            cluster = int(line[1:-1].split()[1])
        else:
            header = line.split()[2].lstrip('>').rstrip('.')
            lane_barcode, read = header.split(':')
            if cluster in counts:
                if lane_barcode in counts[cluster]:
                    counts[cluster][lane_barcode] += 1
                else:
                    counts[cluster][lane_barcode] = 1
            else:
                counts[cluster] = {}
                counts[cluster][lane_barcode] = 1

# Print table headers

barcodes = sorted(max(counts.values(), key=len).keys())

print "\t",
for lane_barcode in barcodes:
    l = lane_barcode.split('.')
    run, b, n = l
    b = int(b)
    n = int(n)
    print "%s_L_%s_B_%.3i\t" % (run, n, b),
print ''

    
# Print table values

for cluster in counts:
    if sum(counts[cluster].values()) < cutoff:
        continue
    print "%s\t" % cluster,
    for lane_barcode in barcodes:
        try:
            val = counts[cluster][lane_barcode]
        except KeyError:
            val = '0'
        print "%s\t" % val,
    print ''
print ''
