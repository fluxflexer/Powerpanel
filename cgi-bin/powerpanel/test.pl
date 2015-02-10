#!/usr/bin/perl -w

use strict;
use CGI::Carp qw(fatalsToBrowser);

my $Text = "Hallo Welt";
my $querry;
print "Content-type: text/html\n\n";
print '<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">', "\n";
print "<html><head><title>Hallo Welt</title></head><body>\n";


print "<h1>$Text</h1>\n";
print "</body></html>\n";

