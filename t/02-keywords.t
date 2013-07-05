use Test::More;

my @tests = (
	[\<<EOF, [qw(constexpr)], 'constexpr variable'],
constexpr int n = 1;
EOF
	[\<<EOF, [], '! constexpr variable'],
const int n = 1;
EOF
	[\<<EOF, [], '! constexpr variable'],
int constexpr_n = 1;
EOF
	[\<<EOF, [qw(constexpr)], 'constexpr function'],
constexpr int func { return 5; }
EOF
	[\<<EOF, [], '! constexpr function'],
cont int func { return 5; }
EOF
);

plan tests => @tests + 1;
use_ok('Text::Detect::CPlusPlus11');
my $obj = Text::Detect::CPlusPlus11->new;

foreach my $test (@tests) {
	is_deeply([sort $obj->detect($test->[0])], [sort @{$test->[1]}], $test->[2]);
}
