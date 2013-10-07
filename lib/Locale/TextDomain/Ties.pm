package Locale::TextDomain::Ties;

use strict;
use warnings;

our $VERSION = '0.04';

# $Id$

1;

__END__

=pod

=head1 NAME

Locale::TextDomain::Ties - Tying all translating subs to a hash

=head1 VERSION

0.04

=head1 SYNOPSIS

Tie what you want.
Here is one example for each sub.

    require Tie::Sub;

    tie my %__x,   'Tie::Sub', sub { return __x(shift, @_) };
    tie my %__n,   'Tie::Sub', sub { return __n(shift, shift, shift) };
    tie my %__nx,  'Tie::Sub', sub { return __nx(shift, shift, shift, @_) };
    tie my %__xn,  'Tie::Sub', sub { return __xn(shift, shift, shift, @_) };

    tie my %__p,   'Tie::Sub', sub { return __p(shift, shift) };
    tie my %__px,  'Tie::Sub', sub { return __px(shift, shift, @_) };
    tie my %__np,  'Tie::Sub', sub { return __np(shift, shift, shift, shift, @_) };
    tie my %__npx, 'Tie::Sub', sub { return __npx(shift, shift, shift, shift, @_) };

    tie my %N__,   'Tie::Sub', sub { return [N__(shift)] };
    tie my %N__n,  'Tie::Sub', sub { return [N__n(shift, shift, shift)] };
    tie my %N__p,  'Tie::Sub', sub { return [N__p(shift, shift)] };
    tie my %N__np, 'Tie::Sub', sub { return [N__np(shift, shift, shift, shift)] };

The construct 'shift, @_' or 'shift, shift, @_' is necessary
because the module Locale::TextDomain uses prototypes.
A simple '@_' does not work.

    use Locale::TextDomain::Ties 1.20;

%__ is already tied and exported by Locale::Text::Domain.
It is the same like:

    tie my %__, 'Tie::Sub', sub { return __(shift) };

Further information and concrete examples are in the chapter example.

=head1 EXAMPLE

Inside of this Distribution is a directory named example.
Read and run this *.pl files.

This describes how to write and how to extract.

=head1 DESCRIPTION

Locale::TextDomain only ties a sub named &__
to a hash named %__ and a hash reference named $__ .

This module shows how to tie
all the other translating subs of Locale::TextDomain.

This is a documentation module only.
Use of this module makes no sense.

=head1 SUBROUTINES/METHODS

none

=head1 DIAGNOSTICS

none

=head1 CONFIGURATION AND ENVIRONMENT

nothing

=head1 DEPENDENCIES

none

=head1 INCOMPATIBILITIES

none

=head1 BUGS AND LIMITATIONS

not known

=head1 SEE ALSO

L<Locale::TextDomain|Locale::TextDomain> Localisation framework

L<Tie::Sub|Tie::Sub> The idea to use an arrayref as hash key too.

=head1 AUTHOR

Steffen Winkler

=head1 LICENSE AND COPYRIGHT

Copyright (c) 2009 - 2010,
Steffen Winkler
C<< <steffenw at cpan.org> >>.
All rights reserved.

This module is free software;
you can redistribute it and/or modify it
under the same terms as Perl itself.
