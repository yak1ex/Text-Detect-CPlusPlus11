use Test::More tests => 9;

use_ok('Text::Detect::CPlusPlus11');
my $obj = Text::Detect::CPlusPlus11->new;
is_deeply([sort $obj->detect(\<<EOF)], [sort qw(constexpr)], 'constexpr variable');
constexpr int n = 1;
EOF

is_deeply([sort $obj->detect(\<<EOF)], [sort qw()], '! constexpr variable');
const int n = 1;
EOF

is_deeply([sort $obj->detect(\<<EOF)], [sort qw()], '! constexpr variable');
/* constexpr */ const int n = 1;
EOF

is_deeply([sort $obj->detect(\<<EOF)], [sort qw()], '! constexpr variable');
const int n = 1; // constexpr
EOF

is_deeply([sort $obj->detect(\<<EOF)], [sort qw(constexpr)], 'constexpr variable');
constexpr int n = 1; // constexpr
EOF

is_deeply([sort $obj->detect(\<<EOF)], [sort qw()], '! constexpr variable');
int constexpr_n = 1; // constexpr
EOF

is_deeply([sort $obj->detect(\<<EOF)], [sort qw(constexpr)], 'constexpr function');
constexpr int func { return 5; }
EOF

is_deeply([sort $obj->detect(\<<EOF)], [sort qw()], '! constexpr function');
cont int func { return 5; }
EOF

