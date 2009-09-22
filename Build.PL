use strict;
use warnings;

use Module::Build;

Module::Build->new(
    module_name       => 'Locale::TextDomain::Ties',
    license           => 'perl',
    dist_abstract     => 'Locale::TextDomain::Ties - Tying all translating subs to a hash',
    dist_author       => 'Steffen Winkler <steffenw at cpan.org>',
    dist_version_from => 'lib/Locale/TextDomain/Ties.pm',
    requires          => {
        perl => 5.006,
    },
    build_requires => {
        # Cwd                => 0, # perl dist
        'Locale::TextDomain' => '1.18',
        'Tie::Sub'           => 0,
        'Test::Simple'       => 0, # for Test::More
        'Test::NoWarnings'   => 0,
        'Test::Deep'         => 0,
        'Test::Differences'  => 0,
    },
    recommends => {
        # build
        'Test::Pod'           => '1.14',
        'Test::Pod::Coverage' => '1.04',
        'Test::More'          => 0,
    },
    create_makefile_pl   => 'traditional',
    recursive_test_files => 1,
    add_to_cleanup       => [ qw(
        META.yml *.bak *.gz Makefile.PL
    ) ],
)->create_build_script();