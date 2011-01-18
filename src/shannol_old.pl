# !/usr/bin/env perl -w
#
# shannon.pl
# Written by: David Crabb
# Eric Triplett's Group
# University of Florida
# Last Modified: May 25, 2010
#######################################################
#
# Parameters:
#   -t hybrid table input file
#   -n number of samples
#   -o output name
#
#######################################################

use Getopt::Std;

my %parameters;
getopts('t:n:', \%parameters);

$usage = "shannon.pl -t <input>\n";
unless ($parameters{t}) {
  print STDERR $usage;
  exit;
}

unless (open(INPUT, $parameters{t})) {
  print STDERR "Unable to open $parameters{t}\n.";
  exit;
}

print STDERR "SDI: $parameters{t}\n";

@in = <INPUT>;
$inSize = scalar @in;

$in[0] =~ s/\n//;
@samples = split(/\t/, $in[0]);
$num = scalar @samples;
print "SHANNON:\t"; for ($b=1; $b < $num; $b++) { print "@samples[$b]\t"; } print "\nSHANNON:\t";

for ($b = 1; $b < $num; $b++) {

  @data = ();
  for ($c = 1; $c < $inSize; $c++) {
    @line = split(/\t/, $in[$c]);
    push(@data, $line[$b]);

  }
  
  $size = scalar @data;
  $sum  = 0;
  $sum2 = 0;
  for ($a = 0 ;$a < $size; $a++) {
    $sum += $data[$a];
  }
  
  for ($a = 0; $a < $size; $a++) {
    if ($data[$a] != 0) {
      $data[$a] = $data[$a] / $sum;
      $data[$a] = $data[$a] * log( $data[$a] );
      $sum2 += $data[$a];
    }
  }
  
  $sum2 = $sum2 * (-1);
  $sum2 = sprintf("%.3f", $sum2);
  print "$sum2\t"
}
print "\n";
