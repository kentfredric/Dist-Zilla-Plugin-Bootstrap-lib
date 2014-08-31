use strict;
use warnings;

use Test::More;
use Test::DZil qw( simple_ini );
use Dist::Zilla::Util::Test::KENTNL 1.003001 qw(dztest);
require Dist::Zilla::Plugin::Bootstrap::lib;

my $t   = dztest();
my $ini = simple_ini(
  { name => 'E' },
  [ 'Bootstrap::lib', { try_built => 1, fallback => 0, } ],    #
  ['=E'],
);
my $epm = <<'EOF';
use strict;
use warnings;
package E;

sub register_component {}

1;
EOF
$t->add_file( 'dist.ini'        => $ini );
$t->add_file( 'E-0.01/dist.ini' => $ini );
$t->add_file( 'lib/E.pm',        $epm );
$t->add_file( 'E-0.01/lib/E.pm', $epm );

$t->build_ok;

done_testing;
