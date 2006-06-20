package Text::Trac::AutoLinkHttpNode;
use base qw(Text::Trac::InlineNode);
use strict;

my $pattern1 = '(https?:\/\/[A-Za-z0-9~\/._\?\&=\-%#\+:\;,\@\']+)';
my $pattern2 = '\[ (https?:\/\/[A-Za-z0-9~\/._\?\&=\-%#\+:\;,\@\']+) \s+ ([^\]]+) \]';

sub init {
    my $self = shift;
    $self->pattern(qr/ $pattern1 | $pattern2 /xms);
    return $self;
}

sub parse {
    my ( $self, $l ) = @_;
    my $c = $self->{context};
    my $pattern = $self->pattern;

    $l =~ $pattern or return $l;
    my $match = $2 || $1;
    if ( $match =~ /\.(png|gif|jpg)$/ ){
        $l =~ s{ $pattern2 }{<img src="$1" alt="$2" />}xmsg;
        $l =~ s{ $pattern1 }{<img src="$1" alt="$1" />}xmsg unless $& =~ /^\[/;
    }
    else {
        $l =~ s{ $pattern2 }{<a class="ext-link" href="$1">$2</a>}xmsg;
        $l =~ s{ $pattern1 }{<a class="ext-link" href="$1">$1</a>}xmsg unless $& =~ /^\[/;
    }

    return $l;
}

1;
