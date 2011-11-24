#!/usr/bin/perl -w
#  pastee.pl -- connects to pastebin/pastie/<> and looks for interesting strings

use strict;
use warnings;

use Getopt::Long;
use XML::Simple;

## initialize
my (%flags, %s);
use constant SITES => {
    # supported site endpoints
    pastebin => 'http://www.pastebin.com',
    pastie   => 'http://www.pastie.org', 
};
%flags = (
    verbose => 1, # 0 <= n <= 2
    
);
GetOptions(\%flags, "help", "verbose:i");
$s{$_} = $flags{$_} for (keys %flags);

## do work

## cleanup

exit;

## subs below


