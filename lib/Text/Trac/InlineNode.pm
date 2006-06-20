package Text::Trac::InlineNode;

use strict;

use base qw( Class::Accessor::Fast );
__PACKAGE__->mk_accessors( qw( context pattern) );

sub new {
    my ( $class, $params ) = @_;
    my $self = { %$params };
    bless $self, $class;
    $self->init;
    return $self;
}

1;
