package Klortho;

use strict;
use warnings;

use Dancer2;
use XML::RSS;

use Klortho::Util;

get qr[^/rss(/(\d+))?] => sub {
    content_type 'text/xml';

    my (undef, $n) = splat();
    $n //= query_parameters->get('n');
    my $advice = Klortho::Util::advice($n);

    my $rss = XML::RSS->new(version => '1.0');
    $rss->channel(
        title => 'Advice from Klortho',
        link  => 'https://klortho.perlhacks.com/rss/',
        description => 'Advice from Klortho',
    );

    ($n) = $advice =~ /(\d+)/;

    my $link = "https://klortho.perlhacks.com/?n=$n";

    $rss->add_item(
        title => $advice,
        description => $advice,
        link => $link,
    );

    return $rss->as_string;
};

get qr[^/(\d+)?] => sub {
    my ($n) = splat();
    $n //= query_parameters->get('n');
    template 'index', { advice => Klortho::Util::advice($n) };
};
