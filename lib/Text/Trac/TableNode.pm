package Text::Trac::TableNode;

use strict;
use base qw(Text::Trac::BlockNode);

sub init {
    my $self = shift;
    $self->pattern(qr/^\|\|([^\|]*\|\|(?:[^\|]*\|\|)+)$/xms);
    return $self;
}

sub parse {
    my ( $self, $l ) = @_;
    my $c = $self->{context};
    my $pattern = $self->pattern;
    $l =~ $pattern or return $l;

    $c->htmllines('<table>');

    $c->unshiftline;
    while( $c->hasnext and ($c->nextline =~ $pattern ) ){
        my $l = $c->shiftline;
        $l =~ s{ $self->{pattern} }{$1}xmsg;
        $l = "<tr><td>" . join( "</td><td>", split(/\|\|/, $l) ) . "</td></tr>";

        # parse inline nodes
        my $inline_parsers = $self->_get_matched_parsers('inline', $l) if $l;
        for my $parser ( @{$inline_parsers} ){
            $l = $parser->parse($l);
        }

        $c->htmllines($l);
    }

    $c->htmllines('</table>');

    return;
}


1;
