package Text::Trac::BoldNode;
use strict;
use base qw(Text::Trac::InlineNode);

sub init {
    my $self = shift;
    $self->pattern(qr/'''(.*?)'''/);
    return $self;
}

sub parse {
    my ( $self, $l ) = @_;
    my $c = $self->{context};
    my $pattern = $self->pattern;
    $l =~ $pattern or return $l;

    $l =~ s{ $pattern }{<strong>$1</strong>}xmsg;

    return $l;
}

1;
