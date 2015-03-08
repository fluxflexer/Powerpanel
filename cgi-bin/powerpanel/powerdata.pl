#!/usr/bin/perl -w

use strict;
use DBI;
use DBD::mysql;
use LWP::Simple qw(get);
use Time::Local;
use Date::Parse;



use CGI::Carp qw(fatalsToBrowser);

use CGI qw(:standard);
my $Text = "Hallo Welt";
my $querry;
my $sql;
my $counter;
my @lines;
my $unixtime;
my $jsonvalue;



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

                }
                #push @valueArray,"\n" ;
             }

            $sth->finish();

            return @valueArray;

            };







print header('application/json');

#Possible aggregators:
#15min_day
#5min_6hour
#6hourly_month
#daily_year
#hourly_year
#monthly_year

use CGI;
my $cgi= new CGI;
my $aggregator = $cgi->param('aggregator');
my $sensor = $cgi->param('sensor');

#print "|$aggregator|\n";
#$aggregator="6hourly_month";

$sql="SELECT AVG(value), STD(value) FROM results WHERE (sensorname='". $sensor . "') AND (resultset='" . $aggregator. "')";
my @statArray= sqlFetcharray($sql);

my $avg=@statArray[0];
my $sdev=@statArray[1];

$sql="SELECT sensor_einheit FROM sensoren WHERE sensor_name='". $sensor ."';" ;
my @valueArray= sqlFetcharray($sql);
my $unit = @valueArray[0];

$sql="SELECT time, value FROM results WHERE (sensorname='". $sensor . "') AND (resultset='" . $aggregator. "') ORDER BY time ASC" ;

#print $sql;




my @valueArray= sqlFetcharray($sql);
my $akttime = time;



my $jsonstring.="{\"name\":\"$sensor\",\"date\":\"$akttime\",\"unit\":\"$unit\",\"sdev\":\"$sdev\",\"avg\":\"$avg\",\"values\": [";

for (my $index=0 ; $index <= scalar(@valueArray)-1; $index=$index+2){
 # $sensors{$sensorArray[$index]} = $sensorArray[$index +1];
 $counter+=1;

$unixtime= (str2time(@valueArray[$index])+60*60)*1000;
$jsonvalue = @valueArray[$index +1];

#print "$unixtime | $jsonvalue \n";




 $jsonstring.="[$unixtime,$jsonvalue ]";

 if ($index+2 < scalar(@valueArray)){
 $jsonstring.=",";
 };



}
  $jsonstring.="]}";
 print "$jsonstring\n" ;





   exit 0;



