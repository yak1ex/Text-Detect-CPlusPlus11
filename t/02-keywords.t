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
	[\<<EOF, [qw(static_assert)], 'static_assert'],
static_assert(sizeof(long) >= 8, "64-bit code generation required for this library.");
EOF
	[\<<EOF, [], '! static_assert'],
int static_asserts = 0;
EOF
	[\<<EOF, [qw(decltype)], 'decltype'],
struct A { double x; };
decltype(a->x) x3;
decltype((a->x)) x4 = x3;
EOF
	[\<<EOF, [qw(nullptr)], 'nullptr'],
char* p = std::nullptr;
EOF
);

plan tests => @tests + 1;
use_ok('Text::Detect::CPlusPlus11');
my $obj = Text::Detect::CPlusPlus11->new;

foreach my $test (@tests) {
	is_deeply([sort $obj->detect($test->[0])], [sort @{$test->[1]}], $test->[2]);
}
