package Text::Trac::Sup;

use strict;
use base qw(Text::Trac::InlineNode);

sub init {
    my $self = shift;
    $self->pattern(qr/\^ (.*?) \^/xms);
    return $self;
}

sub parse {
    my ( $self, $l ) = @_;
    my $c = $self->{context};
    my $pattern = $self->pattern;
    $l =~ $pattern or return;

    $l =~ s{ $pattern }{<sup>$1</sup>}xmsg;

    return $l;
}

1;
