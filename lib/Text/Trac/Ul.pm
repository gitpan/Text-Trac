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
    my $level = $c->ul->{level} || 0;
    $c->ul->{space} ||= 0;

    if ( $space > $c->ul->{space} ) {
        for ( 1 .. ( $space + 1 ) / 2 - $level ) {
            $l = '<ul>' . $l;
            $level++;
        }
    }
    elsif ( $space < $c->ul->{space} ) {
        for ( 1 .. ( $c->ul->{space} - $space ) / 2 ) {
            $l = '</ul>' . $l;
            $level--;
        }
    }

    $c->ul({ level => $level, space => $space });

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
    $l = $self->replace($l);
    $c->htmllines($l);

    return;
}

1;
