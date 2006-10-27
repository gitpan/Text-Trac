package Text::Trac::Underline;
use strict;
use base qw(Text::Trac::InlineNode);

sub init {
    my $self = shift;
    $self->pattern(qr/__(.*?)__/xms);
    return $self;
}

sub parse {
    my ( $self, $l ) = @_;
    my $c = $self->{context};
    my $pattern = $self->pattern;
    $l =~ $pattern or return;

    $l =~ s{ $pattern }{<span class="underline">$1</span>}xmsg;

    return $l;
}

1;
