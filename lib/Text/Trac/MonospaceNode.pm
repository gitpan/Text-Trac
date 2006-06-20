package Text::Trac::MonospaceNode;

use strict;
use base qw(Text::Trac::InlineNode);

sub init {
    my $self = shift;
    $self->pattern(qr/{{{(.*?)}}}|`(.*?)`/xms);
    return $self;
}

sub parse {
    my ( $self, $l ) = @_;
    my $c = $self->{context};
    my $pattern = $self->pattern;
    $l =~ $pattern or return;

    $l =~ s{ $pattern }{ '<tt>' . ( $1 || $2 ) . '</tt>'}xmsge;

    return $l;
}

1;
