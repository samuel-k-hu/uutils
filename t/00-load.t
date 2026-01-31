#!perl
use 5.008003;
use strict;
use warnings;
use Test::More;

plan tests => 1;

BEGIN {
    use_ok( 'SKH::uutils' ) || print "Bail out!\n";
}

diag( "Testing SKH::uutils $SKH::uutils::VERSION, Perl $], $^X" );
