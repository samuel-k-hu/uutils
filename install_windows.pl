#! perl

use strict;

use FindBin;
use File::Spec::Functions qw(catfile);
use File::Path qw(make_path);
use File::Copy::Recursive qw(dircopy);

my $bin_dir = catfile( $FindBin::Bin , 'bin' );
my $home;
my $install_base;

if ( $^O eq 'MSWin32' ) {
    $home = $ENV{USERPROFILE};
}
else {
    $home = $ENV{HOME};
}
$install_base = catfile( $home, 'uutils' );

make_path($install_base) unless -d $install_base;

opendir my $dh, $bin_dir or die "Cannot open $bin_dir: $!";

while (my $entry = readdir $dh) {
  next if $entry eq '.' or $entry eq '..';
  my $path = catfile( $bin_dir, $entry );
  system "pl2bat -u $path";
  print "$path\n";
}

dircopy($bin_dir, $install_base)
  or die "Failed to copy $bin_dir to $install_base: $!";

close($dh);
