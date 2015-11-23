#!/usr/bin/env perl

use strict;
use warnings;

use Dancer2;
use XML::RSS;
use Klortho;

get '/' => sub {
    template 'index', { advice => Klortho::advice(params->{n}) };
};

get '/rss' => sub {
    content_type 'text/xml';
    
    my $advice = Klortho::advice(params->{n});
    
    my $rss = XML::RSS->new(version => '1.0');
    $rss->channel(
        title => 'Advice from Klortho',
        link  => 'http://dave.org.uk/klortho/rss/',
        description => 'Advice from Klortho',
    );

    my ($n) = $advice =~ /(\d+)/;

    my $link = "http://dave.org.uk/klortho/?n=$n";
    
    $rss->add_item(
        title => $advice,
        description => $advice,
        link => $link,
    );
    
    return $rss->as_string;
};

dance;
