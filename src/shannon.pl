# !/usr/bin/perl -w
#
# shannon.pl
# Written by: David Crabb
# Eric Triplett's Group
# University of Florida
# Last Modified: January 13, 2011
#######################################################
#
# Parameters:
#   -t hybrid table input file
#   -o output name
#
#######################################################

use Getopt::Std;

my %parameters;
getopts('t:', \%parameters );

unless ( $parameters{t} ) {
    print STDERR
"Please enter the program with -t hybrid table input file -o output seqeunce file\n";
    exit;
}

unless ( open( INPUT, $parameters{t} ) ) {
    print STDERR "Unable to open $parameters{t}\n";
    exit;
}

$line = <INPUT>;
chomp($line);
print "SHANNON:";
if (($line =~ /\r/) && !($line =~ /\n/)) {
    @input_Lines = split( /\r/, $line );
    @samples     = split( /\t/, shift @input_Lines );
    $num         = scalar @samples;
    foreach (@samples) {
        push( @matrix, [$_] );
#        print "$_\t"; # what does this do?
    }
    print "\n";
    $count = 0;
    foreach (@input_Lines) {
        $count++;
        print "$_\n";
        chomp($_);
        @line_split = split( /\t/, $_ );
        for ( $a = 0 ; $a < $num ; $a++ ) {
            push @{ $matrix[$a] }, $line_split[$a];
        }
    }
} else {
    @samples = split( /\t/, $line );
    $num = scalar @samples;
    foreach (@samples) {
        push( @matrix, [$_] );
        print "$_\t";
    }
    print "\n";
    $count = 0;
    while ( $line = <INPUT> ) {
        $count++;

        chomp($line);
        @line_split = split( /\t/, $line );
        for ( $a = 0 ; $a < $num ; $a++ ) {
            push @{ $matrix[$a] }, $line_split[$a];
        }
    }
}
close INPUT;

push @{ $matrix[0] }, $entry;
print "SHANNON:";
for ( $a = 1 ; $a < $num ; $a++ ) {
    $sum  = 0;
    $sum2 = 0;
    for ( $b = 0 ; $b < $count ; $b++ ) {
        $sum += $matrix[$a][$b];
    }
    for ( $b = 0 ; $b < $count ; $b++ ) {
        if ( $matrix[$a][$b] != 0 ) {
            $matrix[$a][$b] = $matrix[$a][$b] / $sum;
            $matrix[$a][$b] =
              $matrix[$a][$b] * log( $matrix[$a][$b] );
            $sum2 += $matrix[$a][$b];
        }
    }
    $sum2 = $sum2 * (-1);
    $sum2 = sprintf( "%.3f", $sum2 );
    push @{ $matrix[$a] }, $sum2;
}

for ( $a = 0 ; $a < $num ; $a++ ) {
    print "$matrix[$a][$count + 1]\t";
}
print "\n";