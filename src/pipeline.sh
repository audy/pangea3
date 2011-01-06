#!/bin/bash +x
# run like this
# ./pipeline.sh <directory> <database>

# CONFIGURATION (You may edit)
assemble="./src/clc/clc_ref_assemble_long"
filter="./src/clc/filter_matches"
make_tables="./src/clc/assembly_table"
count_phyl="python phylocount.py"
megaclustable="perl megaclustable.pl"

# Don't mess with anything below here, 
# unless your name is Austin David-Richardson

dir=$1 # working directory
reads=$1/reads # where the reads are at
clc_out=$1/clc_out # where CLC's output goes
tables=$1/tables # where the tables go
database=$2 # the RDP database

main () {
	# Output date!
	date
	
	# Make some directories
	mkdir -p $clc_out
	mkdir -p $tables
	
	reference_assemble
	filter
	generate_tables
	count_phylogenies
	make_megaclustables
}

# Reference Assemble:
reference_assemble () { 
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
}

filter () {
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
}

# Generate Tables
generate_tables() {
	echo "Making Tables"
	for sim in 80 90 95 99
	do
		for file in $clc_out/L_98_S_$sim/*.filtered
		do
			mkdir -p $tables/L_98_S_$sim 
			$make_tables -n -p -s $file > $tables/L_98_S_$sim/$(basename $file).table
		done
	done
}

# Count CLC Reference Assemblies Phylos.
count_phylogenies () {

	echo "Count Phylogenies"
	for sim in 80 90 95 99
	do
		for file in $tables/L_98_S_$sim/*.table
		do
			 $count_phyl $database $file
			 cat $file.paired.out $file.unpaired.out > $file.both.out
		 done
	done
}

# Make "master" tables
make_megaclustables () {

	echo "Making Master Tables!"
	$megaclustable -m $(ls -m $tables/L_98_S_99/*.both.* | tr -d ',\n') -t 6 -o $dir/species.txt
	$megaclustable -m $(ls -m $tables/L_98_S_95/*.both.* | tr -d ',\n') -t 5 -o $dir/genus.txt
	$megaclustable -m $(ls -m $tables/L_98_S_90/*.both.* | tr -d ',\n') -t 4 -o $dir/family.txt
	$megaclustable -m $(ls -m $tables/L_98_S_90/*.both.* | tr -d ',\n') -t 3 -o $dir/order.txt
	$megaclustable -m $(ls -m $tables/L_98_S_90/*.both.* | tr -d ',\n') -t 2 -o $dir/class.txt
	$megaclustable -m $(ls -m $tables/L_98_S_80/*.both.* | tr -d ',\n') -t 1 -o $dir/phylum.txt
}

main