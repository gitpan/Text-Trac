package Text::Trac::UlNode;

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
    my $ul_level = ( length($1) + 1 ) / 2;

    if ( $ul_level > $c->current_ul_level ){
        for ( 1 .. $ul_level - $c->current_ul_level ){
            $l = '<ul>' . $l;
        }
    }
    elsif ( $ul_level < $c->current_ul_level ){
        for ( 1 .. $c->current_ul_level - $ul_level ){
            $l = '</ul>' . $l;
        }
    }

    $c->current_ul_level($ul_level);

    $l =~ s{ $pattern }{<li>$2</li>}xmsg;

    if ($c->hasnext and $c->nextline =~ /$pattern/){
        $self->parse($l);
    }
    else {
        for ( 1 .. $c->current_ul_level($ul_level) ){
            $l .= '</ul>';
        }
        $c->current_ul_level(0);
    }

    # parse inline nodes
    my $parsers = $self->_get_matched_parsers('inline', $l);
    for ( @{$parsers} ){
        $l = $_->parse($l);
    }

    $c->htmllines($l);
}

1;
