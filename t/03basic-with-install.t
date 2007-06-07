#!perl -T 

use Test::More tests => 9;

BEGIN { use_ok('Memoize::Attrs') };

my $COUNT = 0;

sub no_args :MEMOIZE( INSTALL => 'memo_no_args' ) {
    my $arg = shift;
    $COUNT++;
    11;
}

is( no_args(), 11 );
is( $COUNT, 1 );

is( no_args(), 11 );
is( $COUNT, 2 );

$COUNT = 0;

is( memo_no_args(), 11 );
is( $COUNT, 1 );

is( memo_no_args(), 11 );
is( $COUNT, 1 );


