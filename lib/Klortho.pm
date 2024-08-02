package Klortho;

use strict;
use warnings;

use Dancer2;
use XML::RSS;

use Klortho::Util;

get '/wtf' => sub {
    template 'wtf';
};

get qr[^/rss(/(\d+))?] => sub {
    content_type 'text/xml';

    my (undef, $n) = splat();
    $n //= query_parameters->get('n');
    my $advice = Klortho::Util::advice($n);

    my $rss = XML::RSS->new(version => '1.0');
    $rss->channel(
        title => 'Advice from Klortho',
        link  => request->uri_for('/rss'),
        description => 'Advice from Klortho',
    );

    ($n) = $advice =~ /(\d+)/;

    $rss->add_item(
        title => $advice,
        description => $advice,
        link => request->uri_for('/rss', { n => $n }),
    );

    return $rss->as_string;
};

get qr[^/(\d+)?] => sub {
    my ($n) = splat();
    $n //= query_parameters->get('n');
    my $advice = Klortho::Util::advice($n);
    ($n) = $advice =~ /(\d+)/;
    template 'index', { 
      n => $n,
      advice => $advice,
    };
};
