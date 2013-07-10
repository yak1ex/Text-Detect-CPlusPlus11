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
	[\<<EOF, [qw(constexpr noexcept)], 'noexcept without args'],
static constexpr T min() noexcept { return T(); }
EOF
	[\<<EOF, [qw(noexcept)], 'noexcept with args 1'],
template<class T> void swap(T& a, T& b) noexcept(is_nothrow_move_constructible<T>::value &&
is_nothrow_move_assignable<T>::value);
EOF
	[\<<EOF, [qw(noexcept)], 'noexcept with args 2'],
template <class T, size_t N> void swap(T (&a)[N], T (&b)[N]) noexcept(noexcept(swap(*a, *b)));
EOF
	[\<<EOF, [qw(extern_template)], 'extern template'],
extern template vector<int>;
EOF
	[\<<EOF, [qw(initializer_list)], 'initializer list'],
#include <initializer_list>
EOF
	[\<<EOF, [qw(default_delete)], 'default / delete'],
struct A { A() = default; A(const A&) = delete; };
EOF
	[\<<EOF, [qw(range_based_for)], 'range-based for'],
for(auto v : c) { std::cout << v << std::endl; }
EOF
	[\<<EOF, [qw(explicit_operator)], 'explicit conversion operator'],
struct A { explicit operator int(); };
EOF
);

plan tests => @tests + 1;
use_ok('Text::Detect::CPlusPlus11');
my $obj = Text::Detect::CPlusPlus11->new;

foreach my $test (@tests) {
	is_deeply([sort $obj->detect($test->[0])], [sort @{$test->[1]}], $test->[2]);
}
