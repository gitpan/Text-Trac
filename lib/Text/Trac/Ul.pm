package Text::Trac::Ul;

use strict;
use base qw(Text::Trac::BlockNode);

sub init {
    my $self = shift;
    $self->pattern(qr/(\s+) \* \s+ (.*)$/xms);
}

sub parse {
    my ( $self, $l ) = @_;
    my $c = $self->{context};
    my $pattern = $self->pattern;
    $l =~ $pattern or return $l;

    my $space = length($1);
    my $level = $c->ul->{level};
    $c->ul->{space} ||= 0;

    if ( $space > $c->ul->{space} ) {
        $l = '<ul>' . $l;
        $level++;
    }
    elsif ( $space < $c->ul->{space} ) {
        $l = '</ul>' . $l;
        $level--;
    }

    $c->ul({level => $level, space => $space });

    $l =~ s{ $pattern }{<li>$2</li>}xmsg;

    if ($c->hasnext and $c->nextline =~ /$pattern/){
        $self->parse($l);
    }
    else {
        for ( 1 .. $c->ul->{level} ){
            $l .= '</ul>';
        }
        $c->ul->{level} = 0;
    }

    # parse inline nodes
    my $parsers = $self->_get_matched_parsers('inline', $l);
    for ( @{$parsers} ){
        $l = $_->parse($l);
    }

    $c->htmllines($l);

    return;
}

1;
