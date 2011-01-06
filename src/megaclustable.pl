# !/usr/bin/perl -w
#	
# megaclustable.pl
# Written by: David Crabb
# Eric Triplett's Group
# University of Florida
# Last Modified: January 6, 2011
###########################################################################################
#
#	Parameters:
#		-m list of all megaclust output files seperated by spaces
#		-t level of taxa that megaclust was run for where 0= kingdom and 7= strain
#		-o output table name
#
###########################################################################################

use File::Basename;

if($#ARGV < 5)
{
	print "Please enter the correct parameters.\n";
	exit;
}

#organizes input
$mIn = "false";
for($a = 0; $a <= $#ARGV; $a++)
{
	if($ARGV[$a] eq "-m")
	{
		$mIn = "true";
	}
	elsif($ARGV[$a] eq "-o")
	{
		$mIn = "false";
		$a++;
		$output = $ARGV[$a];
	}
	elsif($ARGV[$a] eq "-t")
	{
		$mIN = "false";
		$a++;
		$taxLevel = $ARGV[$a];
		if($taxLevel > 7 || $taxLevel < 0)
		{
			print "You must enter a number between 0 and 7 for taxonomy level where 0 = kingdom and 6 = strain.\n";
			exit;
		}
		$taxLevel = "["."$taxLevel"."]";
	}
	elsif($mIn eq "true")
	{
		push(@megaclustFile, $ARGV[$a]);
	}
}

$numMega = scalar @megaclustFile;
@table = ();
@taxa = ();
$size = 0;

for($b = 0; $b < $numMega; $b++)
{
	unless (open(MEGA, $megaclustFile[$b]))       #tries to open file
	{
		print "Unable to open $megaclustFile[$b]\nMake sure you entered the extension when entering the file name.\n";
		exit;
	}
	@file = ();
	for($a = 0; $a < $size; $a++)
	{
		push(@file, "0");
	}
	while($line = <MEGA>)
	{
		chomp($line);
		$loc = index($line, $taxLevel);
		if($loc > -1)
		{
			$found = "false";
			$loc += 3;
			$end = index($line, ";", $loc);
			if($end == -1)
			{
				$end = index($line, ",", $loc);
			}
			$name = substr($line, $loc, $end - $loc);
			$numStart = index($line, ",", $end) + 1;
			#$numEnd = index($line, "\n", $numStart);
			$num = substr($line, $numStart, length($line) - $numStart);
			for($a = 0; $a < $size; $a++)
			{
				if($taxa[$a] eq "$name")
				{
					$found = "true";
					$file[$a]+= $num;
				}
			}
			
			if($found eq "false")
			{
				push(@taxa, $name);
				push(@file, $num);
				$size++;
			}
		}
	}
	close MEGA;
	push(@table, [@file]);
}

unshift(@table, [@taxa]);
open OUTPUT, ">$output" or die $!;
for($a = 0; $a < $numMega; $a++)
{
  $filename = basename($megaclustFile[$a]);
  $filename = substr($filename, 0, 9);
	print OUTPUT "\t$filename";
}
for($a = 0; $a < $size; $a++)
{
	print OUTPUT "\n";
	for($b = 0; $b < $numMega + 1; $b++)
	{
		if($table[$b][$a] eq "")
		{
			$table[$b][$a] = 0;
		}
		print OUTPUT "$table[$b][$a]\t";
	}
}


