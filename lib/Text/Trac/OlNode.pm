package Text::Trac::OlNode;

use strict;
use base qw(Text::Trac::BlockNode);

sub init {
    my $self = shift;
    $self->pattern(qr/(\s+) ([\daiAI])\. \s+ (.*)$/xms);
    return $self;
}

sub parse {
    my ( $self, $l ) = @_;
    my $c = $self->{context};
    my $pattern = $self->pattern;
    $l =~ $pattern or return $l;
    my $ol_level = ( length($1) + 1 ) / 2;
    my $type  = $2;

    my $start_tag;
    if ($type =~ /(\d)/){
        $start_tag = qq{<ol start="$1">};
    }
    elsif ($type eq 'a'){
        $start_tag = qq{<ol class="loweralpha">};
    }
    elsif ($type eq 'A'){
        $start_tag = qq{<ol class="upperalpha">};
    }
    elsif ($type eq 'i'){
        $start_tag = qq{<ol class="lowerroman">};
    }
    elsif ($type eq 'I'){
        $start_tag = qq{<ol class="upperroman">};
    }

    if ( $ol_level > $c->current_ol_level ){
        for ( 1 .. $ol_level - $c->current_ol_level ){
            $l = $start_tag . $l;
        }
    }
    elsif ( $ol_level < $c->current_ol_level ){
        for ( 1 .. $c->current_ol_level - $ol_level ){
            $l = '</ol>' . $l;
        }
    }

    $c->current_ol_level($ol_level);

    $l =~ s{ $pattern }{<li>$3</li>}xmsg;

    if ($c->hasnext and $c->nextline =~ $pattern){
        $self->parse($l);
    }
    else {
        for ( 1 .. $c->current_ol_level($ol_level) ){
            $l .= '</ol>';
        }
        $c->current_ol_level(0);
    }

    # parse inline nodes
    my $parsers = $self->_get_matched_parsers('inline', $l);
    for ( @{$parsers} ){
        $l = $_->parse($l);
    }

    $c->htmllines($l);
}

1;
