#!/usr/bin/perl

use strict;
use warnings;

use Socket;

my $filename = 'ips_to_scan.lst';
open(my $fh, '<:encoding(UTF-8)', $filename)
  or die "Could not open file '$filename' $!";

while (my $line = <$fh>) {
  chomp $line;
  my $name = gethostbyaddr($line, AF_INET) or print "$line\n";
  if (defined $name) {
    print "$name\n";
  }
}

