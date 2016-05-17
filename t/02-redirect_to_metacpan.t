#!perl -T
use strict;
use warnings;

use Test::More tests => 2;
use Plack::Builder;
use Plack::Test;
use HTTP::Request::Common;

use Plack::Middleware::Pod;

my $app = sub { return [ 404, [], [ "Nothing to see here"] ] };

$app = Plack::Middleware::Pod->wrap($app,
      path => qr{^/pod/},
      root => './lib/',
      redirect_to_metacpan => 1,
);

my $test = Plack::Test->create($app);
my $res = $test->request(GET "/pod/LWP/UserAgent.pm");
is($res->code, 302, "Redirecting ...")
    or diag $res->content;
is($res->header('Location'), 'http://metacpan.org/pod/LWP::UserAgent', "... to metacpan");
