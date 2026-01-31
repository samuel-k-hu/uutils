use 5.008003;
use strict;
use warnings;
use ExtUtils::MakeMaker;

use FindBin qw($Bin);
use File::Spec::Functions qw(catfile);

open my $manifest_fh, '<:utf8', catfile($Bin, 'MANIFEST')
	or die "Could not open MANIFEST: $!";

my @exe_files;
while( <$manifest_fh> ) {
    chomp;
    next if /\A\s*#/;
    s/\s*#.*$//;
    next unless m|\Abin/|;
    push @exe_files, $_;
}
close $manifest_fh;

my %WriteMakefileArgs = (
    NAME             => 'SKH::uutils',
    AUTHOR           => ['samuel-k-hu <zongnan.hu@gmail.com>'],

    EXE_FILES        => \@exe_files,

    VERSION_FROM     => 'lib/SKH/uutils.pm',
    ABSTRACT_FROM    => 'lib/SKH/uutils.pm',
    LICENSE          => 'artistic_2',
    MIN_PERL_VERSION => '5.008003',
    CONFIGURE_REQUIRES => {
        'ExtUtils::MakeMaker' => '0',
    },
    TEST_REQUIRES => {
        'Test::More' => '0',
    },
    PREREQ_PM => {
        #'ABC'              => '1.6',
        #'Foo::Bar::Module' => '5.0401',
    },
    dist  => { COMPRESS => 'gzip -9f', SUFFIX => 'gz', },
    clean => { FILES => 'SKH-uutils-*' },
);

# Compatibility with old versions of ExtUtils::MakeMaker
unless (eval { ExtUtils::MakeMaker->VERSION('6.64'); 1 }) {
    my $test_requires = delete $WriteMakefileArgs{TEST_REQUIRES} || {};
    @{$WriteMakefileArgs{PREREQ_PM}}{keys %$test_requires} = values %$test_requires;
}

unless (eval { ExtUtils::MakeMaker->VERSION('6.55_03'); 1 }) {
    my $build_requires = delete $WriteMakefileArgs{BUILD_REQUIRES} || {};
    @{$WriteMakefileArgs{PREREQ_PM}}{keys %$build_requires} = values %$build_requires;
}

delete $WriteMakefileArgs{CONFIGURE_REQUIRES}
    unless eval { ExtUtils::MakeMaker->VERSION('6.52'); 1 };
delete $WriteMakefileArgs{MIN_PERL_VERSION}
    unless eval { ExtUtils::MakeMaker->VERSION('6.48'); 1 };
delete $WriteMakefileArgs{LICENSE}
    unless eval { ExtUtils::MakeMaker->VERSION('6.31'); 1 };

WriteMakefile(%WriteMakefileArgs);
