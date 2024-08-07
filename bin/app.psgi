#!/usr/bin/env perl

use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/../lib";

use Plack::Builder;
use Klortho;

builder {
  enable 'Plack::Middleware::Static',
    path => qr{/css/},
    root => 'public/';
  Klortho->to_app
};
