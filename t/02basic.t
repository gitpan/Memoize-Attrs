#!perl -T 

use Test::More tests => 5;

BEGIN { use_ok('Memoize::Attrs') };

my $COUNT = 0;

sub no_args :MEMOIZE {
    my $arg = shift;
    $COUNT++;
    $arg;
}

is( no_args(1), 1 );
is( $COUNT, 1 );

is( no_args(1), 1 );
is( $COUNT, 1 );




