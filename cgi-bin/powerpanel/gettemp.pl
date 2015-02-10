#!/usr/bin/perl
    use strict;



use DBI;
use DBD::mysql;
use LWP::Simple;
use Time::Local;

use CGI::Carp qw(fatalsToBrowser);

my $content;
my $rrdfile;
my $website;
my $line;
my %sensors;
my @sensors;
my $sensorvalues;
my $aktsensor;
my $aktvalue;
my %valuehash=();
my $updatecommand;
my $sql;


print "Content-type: text/html\n\n";
print '<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">', "\n";
print "<html><head><title>Templogger</title></head><body>\n";
print "<h1>Hi there!</h1>\n";
print "</body></html>\n";



$sql="SELECT sensor_id, sensor_name FROM sensoren" ;
my @sensorArray= sqlFetcharray($sql);
#print @sensorArray;




for (my $index=0 ; $index <= scalar(@sensorArray); $index=$index+2){
  $sensors{$sensorArray[$index]} = $sensorArray[$index +1];
}

my $param_string;

my $referrer = $ENV{REMOTE_ADDR};

open (MYFILE, '>referrer.txt');
 print MYFILE "$referrer\n";
 close (MYFILE);



my $method = $ENV{"REQUEST_METHOD"};
if ( $method eq "GET" ) {
    $param_string = $ENV{"QUERY_STRING"};
}
elsif ( $method eq "POST" ) {
    read STDIN, $param_string, $ENV{"CONTENT_LENGTH"};
}


my $formdata=$param_string;




@sensors=split(/[&;]/,$formdata);


 foreach $sensorvalues (@sensors){

($aktsensor,$aktvalue)=split("=",$sensorvalues);


$aktvalue=int($aktvalue/10)/10;  	#hundertstel-stellen abschneiden

if ($aktvalue != 85){

 updateDB($aktsensor,$aktvalue);
 # print $aktsensor,$aktvalue;
}
}





   exit 0;


sub updateDB(){
my $aktdatum = now("%Y-%m-%d %H:%M:%S");

my $aktsensor = $_[0];
my $aktwert = $_[1];



my $sql="select messwerte.datum,messwerte.messwert from messwerte  where messwerte.sensor = '$aktsensor' ORDER BY messwerte.datum DESC LIMIT 2";

#print $sql;
my $value;
my $counter =1;
my @valueArray= sqlFetcharray($sql);
  #print $valueArray[1];
 my $lastdate=$valueArray[0];
 my $lastvalue=$valueArray[1];
 my $previousdate=$valueArray[2];
 my $previousvalue=$valueArray[3];
 my $sql;

 #print"$aktsensor: Last=$lastvalue;Previuos=$previousvalue\n";

 if ($aktvalue != $lastvalue or $lastvalue != $previousvalue){
 $sql="INSERT INTO messwerte (datum, sensor, messwert) VALUES ('$aktdatum','$aktsensor','$aktvalue');";
sqlInsert($sql);
 #print "$aktsensor:$aktvalue neuer wert, insert\n"
#print "$sql \n";
 }
 elsif ($lastvalue == $previousvalue){
 $sql="UPDATE messwerte SET datum = '$aktdatum' WHERE messwerte.sensor ='$aktsensor' AND datum ='$lastdate'"     ;
#  open (MYFILE, '>>log.txt');
# print MYFILE " $sql\n";
# close (MYFILE);

 sqlInsert($sql)  ;

# print "$aktsensor:$aktvalue gleicher wert, update\n";
 }


}

sub sqlFetcharray{
# CONFIG VARIABLES
my $platform = "mysql";
my $database = "temperatur";
my $host = "localhost";
my $port = "3306";
my $tablename = "messwerte";
my $user = "temperatur";
my $pw = "tooltime";
my @row;
my $value;
my @valueArray;
#DATA SOURCE NAME
my $dsn = "dbi:$platform:$database:$host:$port";


# PERL DBI CONNECT
my $dbh = DBI->connect($dsn, $user, $pw);

# PREPARE THE QUERY
my $query = @_[0];
my $sth = $dbh->prepare($query);
$sth->execute or die "SQL Error: $DBI::errstr\n";

while (@row = $sth->fetchrow_array) {
    foreach $value(@row){
    push @valueArray,$value ;
    #print $value;
    }
    #push @valueArray,"\n" ;
 }

$sth->finish();

return @valueArray;

}

sub sqlInsert(){
# CONFIG VARIABLES
my $platform = "mysql";
my $database = "temperatur";
my $host = "localhost";
my $port = "3306";
my $tablename = "messwerte";
my $user = "temperatur";
my $pw = "tooltime";

#DATA SOURCE NAME
my $dsn = "dbi:$platform:$database:$host:$port";


# PERL DBI CONNECT
my $dbh = DBI->connect($dsn, $user, $pw);

# PREPARE THE QUERY
my $query = @_[0];
#print "$query \n";
my $sth = $dbh->prepare($query);
$sth->execute() ;

$sth->finish();

}

sub now {
 # Quelle http://sysadminscorner.uherbst.de/perl/date.html (ulrich herbst)
  my $FORMAT=$_[0];

  my $NOW=timelocal(localtime);
  my $y=sprintf("%02d",(localtime($NOW))[5]-100);
  my $Y=sprintf("%04d",(localtime($NOW))[5]+1900);
  my $m=sprintf("%02d",(localtime($NOW))[4]+1);
  my $d=sprintf("%02d",(localtime($NOW))[3]);
  my $H=sprintf("%02d",(localtime($NOW))[2]);
  my $M=sprintf("%02d",(localtime($NOW))[1]);
  my $S=sprintf("%02d",(localtime($NOW))[0]);

  $FORMAT =~ s/%y/$y/;
  $FORMAT =~ s/%Y/$Y/;
  $FORMAT =~ s/%m/$m/;
  $FORMAT =~ s/%d/$d/;
  $FORMAT =~ s/%H/$H/;
  $FORMAT =~ s/%M/$M/;
  $FORMAT =~ s/%S/$S/;

  return $FORMAT;
}
