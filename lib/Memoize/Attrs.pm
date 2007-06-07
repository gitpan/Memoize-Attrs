
package Memoize::Attrs;

use strict;
use warnings;

our $VERSION = '0.00_03';

use Attribute::Handlers;
use Memoize;

# $qualified_name = _qualify_name($name, $package)
sub _qualify_name {
    my $name = shift;
    my $package = shift;
    return undef unless defined $name;
    if ( $name =~ /::/ ) {
        # already a fully qualified name
        return $name
    } else {
        # resolves to the given package
        return $package . '::' . $name
    }

}

#sub MEMOIZE :ATTR(CODE, CHECK) {
sub UNIVERSAL::MEMOIZE :ATTR(CODE, CHECK) {
    my ($package, $symbol, $code, $attr, $data, $phase) = @_;

    my %options =  ( 
        (ref $data) ? @$data 
                    : ( defined($data) ? ($data) : () )
    );

    # qualify the install name (eg, 'foo' to 'caller::foo')
    if ( exists $options{INSTALL} ) {
        # explicit INSTALL => name
        $options{INSTALL} = _qualify_name($options{INSTALL}, $package);
    } else {
        # No INSTALL option provided: use the original name
        $options{INSTALL} = *{$symbol}{PACKAGE} . '::' . *{$symbol}{NAME};
    }
    # XXX INSTALL => undef   makes no sense to this module !!!

    # qualify the normalizer name (if given)
    if ( exists $options{NORMALIZER} && !ref $options{NORMALIZER} ) {
            $options{NORMALIZER} = _qualify_name($options{NORMALIZER}, $package);
    }

    memoize($code, %options );

}

# XXX instead of Installing handlers into UNIVERSAL, 
#       install it into the caller of import

1;

__END__

=head1 NAME

Memoize::Attrs - Add memoization with subroutine attributes

=head1 SYNOPSIS

    use Memoize::Attrs;

    sub slow_function :MEMOIZE {
        ...
    }
    # slow_function is memoized and faster 

=head1 DESCRIPTION

Memoization is a wonderful thing when appropriate. 
And memoization is a  nice optimization trick that
may be applied after some thought and experimentation.
With the C<Memoize> module, that means to invoke C<memoize>
after declaring the subroutine in question.

But that said, memoization looks like a trait
and should be added without much fuss. That trivial
module makes is possible by annotating subroutine definitions
with an attribute C<MEMOIZE>. So that code that looked like

    use Memoize qw(memoize);

    sub slow_function { ... }

    memoize('slow_function');

turns into

    use Memoize::Attrs;

    sub slow_function :MEMOIZE { ... }

which is quite short and happens very early (namely, CHECK time).

This module is not a big deal, but it may help keep the
code clean when you have a lot of memoized functions
or when you want to add memoization without calling
much attention to it.

=head2 OPTIONS

    INSTALL => NAME

If NAME does not match /::/, this is installed in the caller package.

    NORMALIZER => CODE | NAME

If NAME does not match /::/, it is resolved in the caller package.

    SCALAR_CACHE
    LIST_CACHE

Just like the options in C<Memoize> module.

=head1 SEE ALSO

    Memoize
    Attribute::Handlers

After the release of this module to CPAN, I found

    Attribute::Memoize

There are some subtle differences between the two
modules (besides using Memoize x MEMOIZE). Namely,

    * this module resolves non-qualified subnames
      into the caller's package, while 
      Attribute::Memoize requires the use of fully
      qualified names
    * this uses attribute handlers applied at CHECK
      time while the former uses BEGIN-enabled
      handlers. 

=head1 BUGS

Documentation needs improvement. And so did tests as
well.

We actually install an attribute handler for C<MEMOIZE>
at C<UNIVERSAL> -- oh, horror! -- polluting much more than we should. Instead
the attribute handler should be installed into the caller
of C<Memoize::Attrs>' C<import> subroutine, but it looks
like the current exporter modules aren't ready to
export subroutines together with their attributes
and made their attribute handlers run. I've not digged
well enough in this issue and it may be only oversight actually.
Time will tell and fixes will come eventually.

The handling of options via the data associated to the attribute
MEMOIZE may be faulty yet. But it works

    sub scalar_function :MEMOIZE( LIST_CACHE=>'FAULT' );

for a function which should be called only in scalar context.

    sub slow_function :MEMOIZE( INSTALL => quick_function );

to install a memoized version at C<quick_function>.

Please report bugs via CPAN RT 
http://rt.cpan.org/NoAuth/Bugs.html?Dist=Memoize-Attrs.

=head1 AUTHOR

Adriano Ferreira, E<lt>ferreira@cpan.orgE<gt>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2007 by Adriano R. Ferreira

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
