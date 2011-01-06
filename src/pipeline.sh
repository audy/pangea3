#!/bin/bash +x
# run like this
# ./pipeline.sh <directory> <database>

dir=$1 # working directory
reads=$1/reads
clc_out=$1/clc_out
tables=$1/tables

database=$2

assemble="./clc_ref_assemble_long"
filter="./filter_matches"
make_tables="./assembly_table"
count_phyl="python count_clcrefass_phylogenies.py"
megaclustable="perl mgtbl.pl"


# Make some directories


mkdir -p $clc_out
mkdir -p $tables

date

# Reference Assemble:
echo "Assembling"
for file in $reads/*.txt
do
    $assemble -o "$clc_out/$(basename $file).out" \
        -r random \
        -a global \
        -q -p fb ss 0 500 "$file" \
        -d $database \
        -l 0.5 \
        -s 0.8
done

# Filter

echo "Filtering"
for sim in 80 90 95 99
do
    for file in $clc_out/*.out
    do       
        mkdir -p $clc_out/L_98_S_$sim

        $filter -a $file \
             -l 0.98 \
             -s .$sim \
             -o $clc_out/L_98_S_$sim/$(basename $file).filtered 
    done
done

# Generate Tables

echo "Making Tables"
for sim in 80 90 95 99
do
    for file in $clc_out/L_98_S_$sim/*.filtered
    do
        mkdir -p $tables/L_98_S_$sim 
        $make_tables -n -p -s $file > $tables/L_98_S_$sim/$(basename $file).table
    done
done



# Count CLC Reference Assemblies Phylos.
echo "Count Phylogenies"
for sim in 80 90 95 99
do
    for file in $tables/L_98_S_$sim/*.table
    do
       $count_phyl $database $file
       cat $file.paired.out $file.unpaired.out > $file.both.out
done
    done



# Make "master" tables
echo "Making Master Tables!"
$megaclustable -m $(ls -m $tables/L_98_S_99/*.both.* | tr -d ',\n') -t 6 -o $dir/species.txt
$megaclustable -m $(ls -m $tables/L_98_S_95/*.both.* | tr -d ',\n') -t 5 -o $dir/genus.txt
$megaclustable -m $(ls -m $tables/L_98_S_90/*.both.* | tr -d ',\n') -t 4 -o $dir/family.txt
$megaclustable -m $(ls -m $tables/L_98_S_90/*.both.* | tr -d ',\n') -t 3 -o $dir/order.txt
$megaclustable -m $(ls -m $tables/L_98_S_90/*.both.* | tr -d ',\n') -t 2 -o $dir/class.txt
$megaclustable -m $(ls -m $tables/L_98_S_80/*.both.* | tr -d ',\n') -t 1 -o $dir/phylum.txt
