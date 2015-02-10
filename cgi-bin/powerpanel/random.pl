#!/usr/bin/perl -w

use strict;
use DBI;
use DBD::mysql;
use LWP::Simple;
use Time::Local;
use CGI qw(:standard);


use CGI::Carp qw(fatalsToBrowser);

use CGI qw(:standard);

print header('application/json');

my $index;
my $jsonstring;
my $datalength;

$datalength=10;

$jsonstring.="{\"name\":\"powercount\",\"data\":[";

for ($index=0; $index < $datalength; $index=$index+1){
my $x= timelocal(localtime)*1000;
my $y = int(rand(50)+1);
$jsonstring.="[$x, $y]";


if ($index < $datalength-1){
$jsonstring.=",";
};
sleep(1);

}

  $jsonstring.="]}";
 print "$jsonstring\n" ;
   exit 0;
