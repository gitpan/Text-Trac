package Text::Trac::AutoLinkHttpNode;
use base qw(Text::Trac::InlineNode);
use strict;

my $url_regex = 'https?:\/\/[A-Za-z0-9~\/._\?\&=\-%#\+:\;,\@\']+[A-Za-z0-9~\/_\?\&=\-%#\+:\;,\@\']';

sub init {
    my $self = shift;
    $self->pattern(qr/ $url_regex /xms);
    return $self;
}

sub parse {
    my ( $self, $l ) = @_;

    my $pattern = $self->pattern;
    $l =~ $pattern or return $l;

    $l =~ s{(^|\s+)($url_regex)}{$1\[$2 $2\]}xmsg;

    $l =~ s{\[([^\]]+ \. (?: png | gif | jpg ) ?)\ ([^\]]+?)\] }{<img src="$1" alt="$2" />}xmsg;
    $l =~ s{\[([^\]]+?)\ ([^\]]+?)\]}{<a class="ext-link" href="$1">$2</a>}xmsg;

    return $l;
}

1;
