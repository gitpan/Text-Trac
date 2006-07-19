package Text::Trac::AutoLinkHttpNode;
use base qw(Text::Trac::InlineNode);
use strict;

my $url_regex = 'https?:\/\/[A-Za-z0-9~\/._\?\&=\-%#\+:\;,\@\']+[A-Za-z0-9~\/_\?\&=\-%#\+:\;,\@\']';

my $pattern1 = "($url_regex)";
my $pattern2 = "\\[ ($url_regex) \\s+ ([^\\]]+) \\]";

sub init {
    my $self = shift;
    $self->pattern(qr/ $pattern1 | $pattern2 /xms);
    return $self;
}

sub parse {
    my ( $self, $l ) = @_;
    my $c = $self->{context};
    my $pattern = $self->pattern;

    my $copy_of_l = $l;

    while ( $l =~ /$pattern/g ){
        my $match = $2 || $1;
        if ( $match =~ /\.(png|gif|jpg)$/ ){
            $copy_of_l =~ s{ $pattern2 }{<img src="$1" alt="$2" />}xmsg;
            $copy_of_l =~ s{ $pattern1 }{<img src="$1" alt="$1" />}xmsg unless $& =~ /^\[/;
        }
        else {
            $copy_of_l =~ s{ $pattern2 }{<a class="ext-link" href="$1">$2</a>}xmsg;
            $copy_of_l =~ s{ $pattern1 }{<a class="ext-link" href="$1">$1</a>}xmsg unless $& =~ /^\[/;
        }

    }

    return $copy_of_l;
}

1;
