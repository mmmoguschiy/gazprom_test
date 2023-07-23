#!/usr/bin/perl

use strict;
use warnings;

use DBI;

my $filename = "out";

my $dbh = DBI->connect("DBI:mysql:database=gazprom;host=192.168.1.10;port=3306", "gazprom", "gazprom")
  or die "ÐÐµ ÑÐ´Ð°Ð»Ð¾ÑÑ Ð¿Ð¾Ð´ÐºÐ»ÑÑÐ¸ÑÑÑÑ Ðº Ð±Ð°Ð·Ðµ Ð´Ð°Ð½Ð½ÑÑ: $DBI::errstr";

open(my $fh, "<", $filename) or die "ÐÐµ ÑÐ´Ð°Ð»Ð¾ÑÑ Ð¾ÑÐºÑÑÑÑ ÑÐ°Ð¹Ð» '$filename': $!";

while (my $line = <$fh>) {
    chomp $line;
    my @values = split(" ", $line);

    my $created = "$values[0] $values[1]";
    my $int_id = $values[2];
    my $str = join(" ", @values[3..$#values]);

    if ($values[3] =~ /^<=/) {
        my $id;
        if ($line =~ /id=(.*?)(?:\s|$)/) {
            $id = $1;
	    $dbh->do("INSERT INTO message (created, id, int_id, str) VALUES (?, ?, ?, ?)", undef, $created, $id, $int_id, $str);
        }else{
    	    my $address;
    	    $dbh->do("INSERT INTO log (created, int_id, str, address) VALUES (?, ?, ?, ?)", undef, $created, $int_id, $str, $address);
    	}
    }
    else {
        my $address;
        if ($str =~ /TO:<([^>]+)>/) {
            $address = $1;
        }
        $dbh->do("INSERT INTO log (created, int_id, str, address) VALUES (?, ?, ?, ?)", undef, $created, $int_id, $str, $address);
    }
}
print $chw;

close($fh);

$dbh->disconnect();