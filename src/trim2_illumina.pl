# !/usr/bin/perl -w
#
# Trim2_Illumina.pl
# Written by: David B. Crabb
# Eric Triplett's Group
# University of Florida
# Last Modified: November 30, 2010
###################################################
#
#	Parameters:
#		-a raw illumina input file read 1
#		-b raw illumina input file read 2
#
###################################################

$LENGTH_CUTOFF = 70;
$QUALITY_CUTOFF = 20;
$TRUNCATE = 11;

# If Length < 70; throw out.
# If throw out 1; then throw out both.
# Delete first 11 on both sides
# Number of reads in each barcode
# Number thrown out

use Getopt::Std;

# PARSE ARGUMENTS
my %parameters;
getopts( 'a:b:', \%parameters );    #Takes parameters

unless ( $parameters{a} && $parameters{b} ) {
    print "Usage: perl trim2.pl 
	-a raw illumina input file read 1
	-b raw illumina input file read 2\n";
    exit;
}

$read1       = $parameters{a};
$read2       = $parameters{b};

unless ( open( READ1, "$read1" ) ) {
    print "Unable to open $read1\n";
    exit;
}

unless ( open( READ2, "$read2" ) ) {
    print "Unable to open $read2\n";
    exit;
}

@split_out1 = split( /\./, $read1 );
@split_out2 = split( /\./, $read2 );

open SINGLE1, ">$split_out1[0]" . "_trim_single.txt" or die $!;
open SINGLE2, ">$split_out2[0]" . "_trim_single.txt" or die $!;

while ( $read1_line = <READ1> ) {
    chomp($read1_line);
    chomp( $read2_line = <READ2> );

    @line1 = split( /\t/, $read1_line );
    @line2 = split( /\t/, $read2_line );

    $line1[8] =~ s/\./N/g;
    $line2[8] =~ s/\./N/g;

    $line1[8] = trim( $line1[8], $line1[9] );
    $line2[8] = trim( $line2[8], $line2[9] );

    $line1[9] = "";
    $line2[9] = "";

    next if ( ( $line1[8] eq "0" ) && ( $line2[8] eq "0" ) );

    # Print Singletons
    if ( $line1[8] eq "0" ) {
        print SINGLE2 join( "\t", @line2 ) . "\n";
    }
    elsif ( $line2[8] eq "0" ) {
        print SINGLE1 join( "\t", @line1 ) . "\n";
    }
    # Or, print entire thing (interleaved QSEQ)
    else {
       # Print in QSEQ format, uncomment (and comment FASTQ line)
       # print join( "\t", @line1 ) . "\n" . join( "\t", @line2 ) . "\n";

       # Print in FASTQ (interleaved) format:
       # TODO shorten this!
       $header = join(':', @line1[0..7]);
       $sequence_quality = @line1[8];
       @sq = split( /\t/, $sequence_quality);
       $sequence = @sq[0];
       $quality = @sq[1];
       print "\@$header:A\n$sequence\n\+$header:A\n$quality\n";

       $header = join(':', @line2[0..7]);
       $sequence_quality = @line2[8];
       @sq = split( /\t/, $sequence_quality);
       $sequence = @sq[0];
       $quality = @sq[1];
       print "\@$header:B\n$sequence\n\+$header:B\n$quality\n";

    } 
}

close SINGLE1;
close SINGLE2;

# trim($seq, $qual);
sub trim() {
    $seq  = shift;
    $qual = shift;

    #trim off primer
    $seq  = substr( $seq,  $TRUNCATE );
    $qual = substr( $qual, $TRUNCATE );

    $max       = 0;
    $sum       = 0;
    $first     = 0;
    $start     = 0;
    $end       = 0;
    @qualities = split( //, $qual );
    $size      = scalar @qualities;

    for ( $a = 0 ; $a < $size ; $a++ ) {
        $sum += ( ord( $qualities[$a] ) - 64 - $QUALITY_CUTOFF );
        if ( $sum > $max ) {
            $max   = $sum;
            $end   = $a;
            $start = $first;
        }
        if ( $sum < 0 ) {
            $sum   = 0;
            $first = $a;
        }
    }

    $seq = substr( $seq, $start, $end - $start );
    
    return 0 if ( length($seq) < $LENGTH_CUTOFF );
    
    $seq = $seq . "\t" . substr( $qual, $start, $end - $start );
    
    return $seq;
}
