use SQLite3;

my $dbh = sqlite_open('test.db');
my $sth = $dbh.prepare('CREATE TABLE foo (item,count)');
$sth.step();
$sth.finalize();

$sth = $dbh.prepare("insert into foo values('o hai',5)");
my $result = $sth.step();
say "step: $result";
$sth.finalize();
say '';

$sth = $dbh.prepare("insert into foo values('lol',?)");
$result = $sth.bind(1,137);
say "bind: $result";
$result = $sth.step();
say "step: $result";
$sth.finalize();
say '';

## XXX bind_text doesn't work.
# $sth = $dbh.prepare("insert into foo values(?,200)");
# $result = $sth.bind(1,"lol",3,0);
# say "bind: $result";
# $result = $sth.step();
# say "step: $result";
# $sth.finalize();
# say '';

$sth = $dbh.prepare("select * from foo");
while $sth.step() == 100 {
    my $numcols = $sth.column_count();
    say "fetching a row of $numcols columns";
    for 0..^$numcols {
        my $name = $sth.column_name($_);
        # We should use column_type to find out which function to use to fetch
        my $val = $sth.column_text($_);
        say "    $name: $val";
    }
}
$sth.finalize();
say '';

$dbh.close();

say 'done';
