#!/usr/bin/perl
use strict;
use warnings;
use CGI;
use DBI;

my $cgi = CGI->new;

my $recipient = $cgi->param('recipient');

my $dbh = DBI->connect("DBI:mysql:database=gazprom;host=localhost", "gazprom", "gazprom")
    or die "��ибка подкл��ени� к базе данн��: $DBI::errstr";

print $cgi->header;

print <<HTML;
<html>
<head>
<title>log find</title>
</head>
<body>
<h1>log find</h1>

<form method="POST" action="$ENV{SCRIPT_NAME}">
  <label for="recipient">recipient address:</label>
  <input type="text" id="recipient" name="recipient" size="50" value="$recipient">
  <input type="submit" value="find">
</form>
HTML

if ($ cgi->request_method() eq 'POST') {
    my $query = "SELECT created, str FROM log WHERE address LIKE ?";
    my $sth = $dbh->prepare($query);
    $sth->execute('%' . $recipient . '%');

    my $count = 0;
    print "<h2>Find results:</h2>";

    while (my ($timestamp, $log_message) = $sth->fetchrow_array) {
        print "<p>$timestamp $log_message</p>";
        $count++;
        last if $count >= 100;
    }

    if ($count > 100) {
        print "<p>find more 100 records.</p>";
    }
}

$dbh->disconnect();

print <<HTML;
</body>
</html>
HTML
