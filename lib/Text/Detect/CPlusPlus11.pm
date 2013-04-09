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
#     range-based for loop
#     lambda
#     member initialization
#     override
#     final
#     nullptr
#     enum class
#     alias template
#     explicit conversion operator
#     variadic templates
#     new char types
#     raw string literal
#     user-defined literal
#     thread-local
#     = default / = delete
#     static_assert
#     alignment
#     noexcept
my %match = (
	constexpr => qr/\bconstexpr\b/,
	decltype => qr/\bdecltype\b/,
	extern_template => qr/extern\s+template/,
	initialize_list => qr/#include\s*<initializer_list>/,
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
