use strict;
use warnings;

use Test::More;
use FindBin;
use Path::Tiny;
use File::Copy::Recursive qw( rcopy );
use Test::DZil;
use Test::Fatal;

my $dist = 'fake_dist_04';

my $source  = path("$FindBin::Bin")->parent->child('corpus')->child($dist);
my $tempdir = Path::Tiny->tempdir;

rcopy( "$source", "$tempdir" );

my $dist_ini = $tempdir->child('dist.ini');

BAIL_OUT("test setup failed to copy to tempdir") if not( -e $dist_ini and -f $dist_ini );

isnt(
  exception {
    my $builder = Builder->from_config(
      {
        dist_root => "$tempdir"
      }
    );
    $builder->build;
  },
  undef,
  'cant build dist ' . $dist
);

done_testing;

