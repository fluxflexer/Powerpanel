#!/usr/bin/perl -w
 use DBI;

 my $platform = "mysql";
             my $database = "temperatur";
             my $host = "localhost";
             my $port = "3306";
             my $tablename = "messwerte";
             my $user = "temperatur";
             my $pw = "tooltime";

my $dsn = "dbi:$platform:$database:$host:$port";
 my $dbh = DBI->connect($dsn, $user, $pw) or die "Connection Error: $DBI::errstr\n";
 $sql = "SELECT time, value FROM results WHERE (sensorname= 'stromzaehler') AND (`resultset`='hourly_year') ORDER BY time ASC";
 $sth = $dbh->prepare($sql);
 $sth->execute
 or die "SQL Error: $DBI::errstr\n";
 while (@row = $sth->fetchrow_array) {
 print "@row\n";
 }

