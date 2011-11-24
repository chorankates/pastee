#!/usr/bin/perl -w
#  pastee.pl -- connects to pastebin/pastie/<> and looks for interesting strings

## TODO
# need to find other sites to download from
# need to beef up the default XML matchers
# need to finish implementing the get_pastes() and loop to handle printing them

use strict;
use warnings;

use Cwd;
use Data::Dumper;
use Getopt::Long;
use LWP::UserAgent;
use XML::Simple;

## initialize
my (%flags, %matches, %matchers, %pastes, %settings, %sites);
%sites = (
    # supported site endpoints
    pastebin => 'http://www.pastebin.com',
    pastie   => 'http://www.pastie.org', 
);
%settings = (
    verbose  => 1, # 0 <= n <= 2
    parcels  => 10, # number of pastes to get in each run    
    matchers => [ glob(Cwd::getcwd . '/matches/*.xml') ] , # this will be an array
    
);
GetOptions(\%flags, "help", "verbose:i", "matchers:s");
$settings{$_} = $flags{$_} for (keys %flags);

if ($flags{matchers}) {
    $settings{matchers} = split(",", $flags{matchers});
}

%matchers = get_matchers($settings{matchers});

print Dumper(\%flags)    if $settings{verbose} ge 2;
print Dumper(\%settings) if $settings{verbose} ge 1;

## do work
for my $site (keys %sites) {
    %pastes = get_pastes($site, $settings{parcels});
    
    print Dumper(\%pastes);
}

## cleanup

exit;

## subs below

sub get_pastes {
    # get_pastes($site, $count) - calls $site and gets $count random pastes, returns hash of pastes or 0
    my ($site, $count, %hash);
    $site = shift;
    $count = shift;
    
    if ($site =~ /pastebin/i) {
        # if the implementation is > 50 lines, this needs to be abstracted into a sub
    } elsif ($site =~ /pastie/i) {
        # if this implementation is at all similar to the pastebin one, need to combine them
    } else {
        warn "WARN: unable to process site [$site]";
        return 0;
    }
    
    return (scalar keys %hash > 0) ? %hash : 0;
}

sub get_matchers {
    # get_matchers(\@array_of_filenames) - returns a hash populated with the matchers found in \@array (or 0 if error)
    my ($aref, @array, %lhash, %hash);
    
    $aref  = shift;
    @array = @{$aref};
    
    for my $element (@array) {
        
        %lhash = load_xml($element);
        
        if (scalar keys %lhash > 0) {
            # successfully loaded the XML into %lhash, now populate %hash
            
            for my $value (values %lhash) {
                $hash{$value} = $element;
            }
            
        } else {
            # unsuccessful load 
            warn "WARN:: unable to load matcher [$element]";
            next;
        }
        
    }
    
    return (scalar keys %hash > 0) ? %hash : 0;
}

sub load_xml {
    # load_xml($filename) - returns a hash populated with $filename's contents or 0 if error
    my ($doc, $filename, $worker);
    
    $filename = shift;
    
    $worker = XML::Simple->new();
    
    eval {
        $doc = $worker->XMLin($filename);
    };
    
    if ($@) {
        warn "WARN:: error loading XML [$filename]: $@";
    }
    
    return (scalar keys %{$doc}) ? %{$doc} : 0;
}
