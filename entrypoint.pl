#!/usr/bin/perl

=head1 NAME

entrypoint.pl - Entry point for CPAN Testers tester Docker container

=head1 SYNOPSIS

    # Build Docker container with name "tester"
    docker build . --tag tester
    # Build Docker container with official Perl 5.26 container
    docker build . --build-arg BASE=perl:5.26 --tag tester:5.26

    # Configure `cpanm-reporter`
    # The ./config directory will store the persistent shared configuration
    docker run -it -v $(pwd)/config:/etc/cpanm-reporter tester

    # Run tests for a module
    # This uses the same ./config directory for the shared config
    # This accepts any arguments / module syntax supported by `cpanm`
    docker run -t -v $(pwd)/config:/etc/cpanm-reporter tester <module>

    # View help and usage
    docker run -t -v $(pwd)/config:/etc/cpanm-reporter tester --help

=head1 DESCRIPTION

This program is a friendly entry point for the CPAN Testers tester
Docker container. Running the Docker container without arguments will
run the L<App::cpanminus::reporter> configuration script. Running with
arguments will attempt to install the given module(s) using
L<App::cpanminus> (by passing all arguments directly to C<cpanm>,
including C<cpanm> options) and then run C<cpanm-reporter> to analyze
the installation results and send the test reports.

=head1 ARGUMENTS

=head2 <module>

A module to test. This supports any module syntax supported by
L<App::cpanminus>.

    # Run tests for the latest Mojolicious
    docker run -t -v $(pwd)/config:/etc/cpanm-reporter tester Mojolicious

    # Run tests for version 8.00 of Mojolicious
    docker run -t -v $(pwd)/config:/etc/cpanm-reporter tester Mojolicious@8.00

=head1 OPTIONS

=head2 C<-h> C<--help>

View basic help and usage.

=head1 SEE ALSO

L<http://docker.com>, L<http://cpantesters.org>

=cut

use strict;
use warnings;
use Pod::Usage qw( pod2usage );
use Getopt::Long qw( GetOptions );
GetOptions(
    'help|h' => sub { pod2usage(0) },
);
if ( !@ARGV ) {
    exec qw( cpanm-reporter --setup );
}
else {
    if ( !-e '/etc/cpanm-reporter/config.ini' ) {
        system qw( cpanm-reporter --setup );
    }
    system qw( cpanm ), @ARGV;
    system qw( cpanm-reporter );
}
