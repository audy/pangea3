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
    run, barcode, lane = lane_barcode.split('.')
    lane = int(lane)
    barcode = int(barcode)
    print "%s_L_%s_B_%.3i\t" % (run, lane, barcode),
print ''

# sort clusters by sum of reads
# edit: not really
sorted_clusters = counts.keys()

# Print table values
for cluster in sorted_clusters:

    if sum(counts[cluster].values()) < cutoff:
        continue
    print "%s\t" % cluster,
    for lane_barcode in barcodes:
        print "%s\t" % counts[cluster].get(lane_barcode, 0),
    print ''
print ''
