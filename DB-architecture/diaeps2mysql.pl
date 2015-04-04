#!/usr/bin/perl

# Program written by Doug Spencer to convert Dia EPS files ( see
# http://www.lysator.liu.se/~alla/dia/ ) to MySQL statements.
# This program is released under the GNU General Public License (GPL)

my $currentSQL = ''; # Current SQL Statement

while (<>) {
  $input = $_;
  
  $currentSQL .= "\nCREATE TABLE $1 (\n" if ($input =~ /\((\w+)\) dup sw 2/);
  $currentSQL .= ($3) ? "\t$1 $2($3)\n" : "\t$1 $2\n" 
	if ($input =~ /\(\W+(\w+):\s+(\w+)\s*\\*\(*(\d*).*=*.*\)/);
 	
}
  $currentSQL =~ s/\n\n/\n\);\n\n/g;
  $currentSQL =~ s/\n\t/$1,\n\t/g;
  $currentSQL =~ s/\(,/(/g;
  print $currentSQL; 
  print ");\n\n";
