#!/usr/bin/env perl

#
#	csafe v1.0
#	Copyright Chandler Freeman, 2016
#
#	Scans for the usage of potentially dangerous functions in c/c++ code and
#   suggests replacements.
#

use strict; 
use warnings;
use File::Find;

my $version = "1.0.0";
my $directory = $ARGV[0];

my $num_args = $#ARGV + 1;
if ($num_args != 1) {
    print <<"END_HELP";
/************************************
  
                                  CSAFE v$version
              _
             | |
             | |===( )   //////
             |_|   |||  | o o|
                    ||| ( c  )                   ____
                     ||| \= /                   ||    |
                      ||||||                   ||     |
                      ||||||                ...||__/|-"
                      ||||||             __|________|__
                        |||             |______________|
                        |||             || ||      || ||
                        |||             || ||      || ||
------------------------|||-------------||-||------||-||-------
                        |__>            || ||      || ||                                        			
									
************************************/

Thank you for using csafe.

csafe is a program that scans for the usage of potentially dangerous functions 
in c/c++ code and suggests replacements.

To use it, you can either run

perl csafe.pl /name/of/c/c++/directory

or

perl csafe.pl myrepo.git

Copyright Chandler Freeman, 2016
END_HELP
exit;
}

if (substr($directory, -4) eq ".git") {
  print("HA! We can't do that whole git repo thing yet. Maybe soon though.\n");
  exit;
} else {
  print("============ Running csafe v".$version." ============\n");
  print("   -> directory: ".$directory."\n");
  print("   -> datetime: ".localtime."\n");
  print("   -> file types: .c, .cpp\n");
  print("\n");
}

# hash of unsafe functions and their suggested replacements
my %unsafeFunctions = (
    strcpy => 'strlcpy/strcpy_s',
    strncpy => 'strlcpy/strcpy_s',
    strcat => 'strlcat/strcat_s',
    strncat => 'strlcat/strcat_s',
    strtok => '',
    sprintf => 'snprintf',
    vsprintf => 'vsnprintf',
    gets => 'fgets/gets_s',
    scanf => 'sscanf_s',
    sscanf => 'sscanf_s',
    snscanf => '_snscanf_s',
    strlen => 'strnlen_s',
    memcpy => 'memcpy_s',
    makepath => '_makepath_s',
    _splitpath => '_splitpath_s'
);

## main processing done here
my @found_files = ();
my @dirs = ($directory);
find( \&searchRecursively, @dirs );        ## fullpath name in $File::Find::name

sub searchRecursively {
    next if $File::Find::name eq '.' or $File::Find::name eq '..';
    return if (substr($File::Find::name, -4) ne '.cpp' and substr($File::Find::name, -2) ne '.c');

    open my $file, '<', $File::Find::name or die "Error opening file: $!\n";
        
    while(defined(my $line = <$file>) ) {
        while (my ($key, $value) = each(%unsafeFunctions)) {

            # This regex expression attempts to ensure that the function call is actually the right function
            if($line =~ /\s$key[(]/) {
                my $outputLine = $File::Find::name;
                my $find = quotemeta $directory; # escape regex metachars if present
                $outputLine =~ s/$find//g;
                $outputLine .= ":".$.;
                $outputLine .= ": Use of potentially dangerous function ".$key; 

                if ($value ne "") {
                  $outputLine .= ": Consider replacing with ".$value;
                }
                
                push @found_files, $outputLine;      
                last;            
            } 
        }      
    }
    close ($file);    
}

## display files - could be sorted if needed, etc
foreach my $file(@found_files) {
    print $file, "\n";
}
print "============ END REPORT csafe v1.0.0 ============\n";
