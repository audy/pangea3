# !/usr/bin/perl -w
#	
# shannon.pl
# Written by: David Crabb
# Eric Triplett's Group
# University of Florida
# Last Modified: July 22, 2011
#######################################################
#
#	Parameters:
#		-t hybrid table input file
#		-o output name
#
#######################################################

use Getopt::Std;

my %parameters;
getopts('t:o:', \%parameters);

unless($parameters{t} && $parameters{o})
{
	print "Please enter the program with -t hybrid table input file -o output seqeunce file -n number of samples.\n";
	exit;
}

system("perl -pi -e 's/\\r\\n|\\r/\\n/g' $parameters{t}");		# Formats to UNIX newline characters
unless (open(INPUT, $parameters{t}))       						# Tries to open file
{
	print "Unable to open $parameters{t}\nMake sure you entered the extension when entering the file name.";
	exit;
}

$line = <INPUT>;
@split_Line = split(/\t/, $line);
$num_Columns = scalar @split_Line;
$num_Columns--;													# Counts the empty space to start, so one less

initialize_empty_data_space();									# Data will be stored in @data before processing
open OUT, ">$parameters{o}" or die $!;
print OUT $line;

while($line = <INPUT>)
{
	print OUT $line;											# Table will stay the same, Shannon-Weaver will be at bottom
	chomp($line);
	store_data();
}
close INPUT;
print OUT "Shannon-Weaver Diversity Index H'(loge):";
@shannon = ();													# Will contain the Shannon-Weaver Diversity Indecies
process_data();
print_shannon_weaver();
close OUT;
exit;

#######################################	  SUBROUTINES	#######################################
sub initialize_empty_data_space()
{
	for($a = 0; $a < $num_Columns; $a++)
	{
		push(@data, "");
	}
}

sub print_shannon_weaver()
{
	for($a = 0; $a < $num_Columns; $a++)
	{
		print OUT "\t$shannon[$a]";
	}
}

sub process_data()
{
	my @values = ();
	my $num_Values, $overall_Sum, $sum2;
	
	for($a = 0; $a < $num_Columns; $a++)
	{
		@values = split(/,/, $data[$a]);							# Contains each of the different abundances
		$data[$a] = "";												# Clear that entry to save space
		$num_Values = scalar @values;
		$overall_Sum = 0;
		$sum = 0;
		
		for($b = 0; $b < $num_Values; $b++)
		{
			$overall_Sum += $values[$b];							# Finds overall sum
		}
		
		for($b = 0; $b < $num_Values; $b++)
		{
			if($values[$b] != 0)
			{
				$values[$b] = $values[$b]/$overall_Sum;
				$values[$b] = $values[$b] * log($values[$b]);
				$sum += $values[$b];								# Finds Shannon-Weaver Index
			}
		}
		$sum = $sum*(-1);
		$sum = sprintf("%.2f", $sum);
		if($sum == 0)
		{
			$shannon[$a] = "N/A";
		}
		else
		{
			$shannon[$a] = "$sum";
		}
	}
}

sub store_data()
{
	my @split_Line = split(/\t/, $line);
	for($a = 0; $a < $num_Columns; $a++)
	{
		$data[$a] = $data[$a].$split_Line[$a + 1].",";				# Data stored in string separated by commas
	}
}