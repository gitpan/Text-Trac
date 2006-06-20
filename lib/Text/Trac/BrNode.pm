package Text::Trac::BrNode;

use strict;
use base qw(Text::Trac::InlineNode);

sub init {
    my $self = shift;
    $self->pattern(qr/\[\[BR\]\]/xms);
    return $self;
}

sub parse {
    my ( $self, $l ) = @_;
    my $c = $self->{context};
    my $pattern = $self->pattern;
    $l =~ $pattern or return;

    $l =~ s{ $pattern }{<br />}xmsg;

    return $l;
}

1;
