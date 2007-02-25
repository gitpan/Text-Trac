package Text::Trac::Ol;

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
    my $type  = $2;

    my $space = length($1);
    my $level = $c->ol->{level} || 0;
    $c->ol->{space} ||= 0;

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

    open my $out, '>>', '/tmp/ol.txt';
    print $out $c->ol->{space} . "\n";
    close($out);

    if ( $space > $c->ol->{space} ){
       for ( 1 .. ( $space + 1 ) / 2 - $level ) {
           $l = $start_tag . $l;
           $level++;
       }
    }
    elsif ( $space < $c->ol->{space} ){
        for ( 1 .. ( $c->ol->{space} - $space ) / 2 ) {
            $l = '</ol>' . $l;
            $level--;
            $c->ol->{space} = $level;
        }
    }

    $c->ol({level => $level, space => $space });

    $l =~ s{ $pattern }{<li>$3</li>}xmsg;

    if ($c->hasnext and $c->nextline =~ $pattern){
        $self->parse($l);
    }
    else {
        for ( 1 .. $c->ol->{level} ){
            $l .= '</ol>';
        }
        $c->ol->{level} = 0;
        $c->ol->{space} = 0;
    }

    # parse inline nodes
    $l = $self->replace($l);
    $c->htmllines($l);

    return;
}

1;
