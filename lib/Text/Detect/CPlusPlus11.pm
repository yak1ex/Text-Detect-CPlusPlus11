package Text::Detect::CPlusPlus11;

use strict;
use warnings;

# ABSTRACT: Detect C++11 features in a source file
# VERSION

sub new
{
	my $self = shift;
	my $class = ref $self || $self;
	return bless {}, $class;
}

# TODO:
#     rvalue reference
#     uniform initialization
#     auto
#     trailing return type
#     lambda
#     in-place member initialization
#     override
#     final
#     enum class
#     alias template
#     variadic templates
#     new char types
#     raw string literal
#     user-defined literal
#     thread-local
#     alignment
my %match = (
	constexpr => qr/\bconstexpr\b/,
	decltype => qr/\bdecltype\b/,
	static_assert => qr/\bstatic_assert\b/,
	nullptr => qr/\bnullptr\b/,
	noexcept => qr/\bnoexcept\b/,
	extern_template => qr/extern\s+template/,
	initialize_list => qr/#include\s*<initializer_list>/,
	default_delete => qr/\b=\s*(?:default|delete)\b/,
	range_based_for => qr/\bfor\s*\([^;]*\)/,
	explicit_operator => qr/\bexpiicit\s+operator\b/,
);

sub detect
{
	my ($self, $target) = @_;
# TODO: Support FILEHANDLE
	my $content;
	if(ref $content eq 'SCALAR') {
		$content = $$target;
	} elsif(ref $content eq '') {
		open my $fh, '<', $target;
		{
			local $/ = undef;
			$content = <$fh>;
		}
		close $fh;
	}
	$content =~ s,//.*?\n, ,g;
	$content =~ s,/\*.*?\*/, ,g;
	my @result;
	foreach my $key (keys %match) {
		if($content =~ /$match{$key}/) {
			push @result, $key;
		}
	}
	return wantarray ? @result : \@result;
}

1;
