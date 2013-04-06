use strict;
use warnings;
## no critic ( NamingConventions::Capitalization )
package Dist::Zilla::Plugin::Bootstrap::lib;
BEGIN {
  $Dist::Zilla::Plugin::Bootstrap::lib::AUTHORITY = 'cpan:KENTNL';
}
{
  $Dist::Zilla::Plugin::Bootstrap::lib::VERSION = '0.0102';
}
## use critic;

# ABSTRACT: A minimal boot-strapping for Dist::Zilla Plug-ins.






sub log_debug { return 1; }


sub plugin_name { return 'Bootstrap::lib' }


sub dump_config { return }


sub register_component { 
    my ( $plugin_class, $name, $payload, $section ) = @_;
    my $zilla = $section->sequence->assembler->zilla;
    my $logger = $zilla->chrome->logger->proxy({
        proxy_prefix  => '[' . $name  . '] ',
    });
    my $distname = $zilla->name;
    $logger->log([ 'online, %s v%s', $plugin_class, $plugin_class->VERSION || 0 ]);

    #require Data::Dump;
    $payload->{fallback} = 1 if not exists $payload->{fallback};
    $payload->{fallback} = undef if exists $payload->{nofallback};
    #$logger->log([ 'config = %s', Data::Dump::pp($payload)] );


    require Scalar::Util;
    $logger->log([ 'zilla isa %s', Scalar::Util::blessed($zilla) ]);
    require Cwd;
    require Path::Tiny;
    my $cwd = Path::Tiny::path(Cwd::cwd);
    $logger->log([ 'trying to bootstrap %s-*', $cwd->child($distname)->stringify ]);
    require lib;
    my ( @candidates ) = grep { $_->basename =~ /^\Q$distname\E-/ } grep { $_->is_dir } $cwd->children;

    if ( @candidates != 1  and !$payload->{fallback} ){
        $logger->log([ 'candidates for bootstrap != 1 ( %n ), and fallback disabled. not bootstrapping', scalar @candidates ])
        return;
    }
    if ( @candidates != 1  and $payload->{fallback} ){
        $logger->log([ 'candidates for bootstrap != 1 ( %n ), and fallback to boostrapping lib/', scalar @candidates ]);
        lib->import($cwd->child('lib')->stringify);
        return;
    }
    $logger->log(['bootstrapping %s', $candidates[0]->stringify ]);
    lib->import($candidates[0]->stringify);
    

    return 

}

1;

__END__

=pod

=head1 NAME

Dist::Zilla::Plugin::Bootstrap::lib - A minimal boot-strapping for Dist::Zilla Plug-ins.

=head1 VERSION

version 0.0102

=head1 SYNOPSIS

    [Bootstrap::lib]

=head1 DESCRIPTION

This module does the very simple task of
injecting the distributions 'lib' directory into @INC
at the point of its inclusion, so that you can use
plug-ins you're writing for L<< C<Dist::Zilla>|Dist::Zilla >>, to release
the plug-in itself.

=head1 METHODS

=head2 log_debug
    1;

=head2 plugin_name
    'Bootstrap::lib'

=head2 dump_config
    sub { }

=head2 register_component
    sub { }

=head1 USE CASES

This module really is only useful in the case where you need to use something like

    dzil -Ilib

For I<every> call to L<< C<Dist::Zilla>|Dist::Zilla >>, and this is mainly a convenience.

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

=head1 AUTHOR

Kent Fredric <kentnl@cpan.org>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2013 by Kent Fredric <kentnl@cpan.org>.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut
