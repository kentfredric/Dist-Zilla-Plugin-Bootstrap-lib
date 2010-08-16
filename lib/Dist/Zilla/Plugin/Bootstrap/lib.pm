use strict;
use warnings;
## no critic ( NamingConventions::Capitalization )
package Dist::Zilla::Plugin::Bootstrap::lib;
## use critic;

# ABSTRACT: A minimal boot-strapping for Dist::Zilla Plug-ins.

=head1 SYNOPSIS

    [Bootstrap::lib]

=cut

=head1 DESCRIPTION

This module does the very simple task of
injecting the distributions 'lib' directory into @INC
at the point of its inclusion, so that you can use
plug-ins you're writing for L<< C<Dist::Zilla>|Dist::Zilla >>, to release
the plug-in itself.

=cut

=head1 USE CASES

This module really is only useful in the case where you need to use something like

    dzil -Ilib

For I<every> call to L<< C<Dist::Zilla>|Dist::Zilla >>, and this is mainly a convenience.
=cut

=head1 PRECAUTIONS

=head2 DO NOT

B<DO NOT> use this library from inside a bundle. It will not likely work as expected, and you B<DO NOT> want
to bootstrap everything in all cases.

=head2 NO VERSION

At present, using this module in conjunction with a module with no explicitly defined version in the
source will result in the I<executed> instance of that plug-in I<also> having B<NO VERSION>.

This may have a workaround in the future, but no guarantees.

=head2 NOT REALLY A PLUG-IN

This is really just an inglorious hack masquerading as a plug-in. In order to be useful for I<all> plug-ins
that you may want to normally use with L<< C<Dist::Zilla>|Dist::Zilla >>, we subvert the entire plug-in
system and do all our work during C<require>.

=head2 GOOD LUCK

I wrote this plug-in, mostly because I was boiler-plating the code into every dist I had that needed it, and
it became annoying, especially having to update the code across distributions to handle
L<< C<Dist::Zilla>|Dist::Zilla >> C<API> changes.

=cut

use File::Spec;
my $lib;
BEGIN { $lib = File::Spec->catdir( File::Spec->curdir(), 'lib' ); }
use Carp;
use lib "$lib";
Carp::carp("[Bootstrap::lib] $lib added to \@INC");

=method log_debug
    1;
=cut

sub log_debug { return 1; }

=method plugin_name
    'Bootstrap::lib'
=cut

sub plugin_name { return 'Bootstrap::lib' }

=method dump_config
    sub { }
=cut

sub dump_config { return }

=method register_component
    sub { }
=cut

sub register_component { return }

1;
