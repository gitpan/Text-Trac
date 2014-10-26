package Text::Trac::HeadingNode;
use strict;
use base qw(Text::Trac::BlockNode);

sub init {
    my $self = shift;
    $self->pattern(qr/^(=+) \s (.*) \s (=+)$/xms);
}

sub parse {
    my ( $self, $l ) = @_;
    my $c = $self->context;

    $l =~ $self->pattern or return;
    my $level = length($1) + $c->min_heading_level -1;

    my $id = $self->_strip( $2 );
    $l = qq(<h$level id="$id">$2</h$level>);

    my $parsers = $self->_get_matched_parsers('inline', $l);
    for ( @{$parsers} ){
        $l = $_->parse($l);
    }
    $c->htmllines($l);
}

sub _strip {
  my ( $self, $word ) = @_;
  $word =~ s/[\s\t',_\{\}\`]//g;
  return $word;
}

1;
