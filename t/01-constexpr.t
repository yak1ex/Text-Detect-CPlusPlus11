use Test::More tests => 2;

use_ok('Text::Detect::CPlusPlus11');
my $obj = Text::Detect::CPlusPlus11->new;
is_deeply([sort $obj->detect(\<<EOF)], [sort qw(constexpr)], 'constexpr variable');
constexpr int n = 1;
EOF

is_deeply([sort $obj->detect(\<<EOF)], [sort qw()], '! constexpr variable');
const int n = 1;
EOF

# TODO: constexpr function
