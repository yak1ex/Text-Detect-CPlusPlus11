use Test::More;

my @tests = (
	[\<<EOF, [], 'c comment' ],
/* constexpr */ const int n = 1;
EOF
	[\<<EOF, [qw(constexpr)], 'c comment' ],
/* constexpr */ constexpr int n = 1;
EOF
	[\<<EOF, [], 'c++ comment' ],
const int n = 1; // constexpr
EOF
	[\<<EOF, [qw(constexpr)], 'c++ comment' ],
constexpr int n = 1; // constexpr
EOF
);

plan tests => @tests + 1;
use_ok('Text::Detect::CPlusPlus11');
my $obj = Text::Detect::CPlusPlus11->new;

foreach my $test (@tests) {
	is_deeply([sort $obj->detect($test->[0])], [sort @{$test->[1]}], $test->[2]);
}
